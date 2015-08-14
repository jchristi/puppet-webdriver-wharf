# = Class: webdriverwharf
#
#   * installs webdriver-wharf
#
# == Requires:
#
#   * stdlib
#
class webdriverwharf(
  $docker_image         = 'cfmeqe/sel_ff_chrome',
  $pool_size            = 4,
  $max_checkout_time    = 3600,
  $image_pull_interval  = 3600,
  $rebalance_interval   = 21600,
  $log_level            = 'info',
  $listen_host          = '0.0.0.0',
  $listen_port          = 4899,
  $start_timeout        = 60,
  $db_url               = undef,
){

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '7') < 0 {
        fail("${module_name} requires ${$::osfamily} 7 or higher")
      }
    }
    default: {
      fail("${::osfamily} is not supported")
    }
  }

  # RPM is not as recent as pip
  package { 'docker-py':
    ensure => absent,
  }

  # See https://bugzilla.redhat.com/show_bug.cgi?id=1207839
  package { 'device-mapper-libs':
    ensure => latest,
    before => Package['docker'],
  }

  ensure_packages(['git', 'python-pip', 'docker', 'docker-logrotate'])

  exec { 'pip install git+https://github.com/seandst/webdriver-wharf.git':
    path    => '/usr/bin:/bin:/sbin',
    require => [
      Package['docker-py'],
      Package['python-pip'],
      Package['git'],
    ],
    before  => Service['webdriver-wharf'],
    unless  => 'test -d /usr/lib/python2.7/site-packages/webdriver_wharf',
  }

  File { before => Service['webdriver-wharf'], }

  file { '/etc/sysconfig/webdriver-wharf':
    content => template('webdriverwharf/sysconfig.erb'),
  }

  file { '/lib/systemd/system/webdriver-wharf.service':
    content => template('webdriverwharf/webdriver-wharf.service.erb'),
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker'],
  }

  service { 'webdriver-wharf':
    ensure  => running,
    enable  => true,
    require => Service['docker'],
  }
}
