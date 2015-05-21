# = Class: webdriverwharf
#
#   * installs webdriver-wharf
#
# == Requires:
#
#   * stdlib
#
class webdriverwharf(
  $docker_image       = undef,
  $listen_port        = undef,
  $listen_address     = undef,
  $pool_size          = undef,
  $max_checkout_time  = undef,
  $log_level          = undef,
  $db_url             = undef,
  $start_timeout      = undef,
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
