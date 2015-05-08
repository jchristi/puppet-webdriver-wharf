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

  ensure_packages(['git', 'python-pip', 'docker', 'docker-logrotate'])

  Exec {
    path    => '/usr/bin:/bin:/sbin',
    require => [
      Package['docker-py'],
      Package['python-pip'],
      Package['git'],
    ],
    before  => Service['webdriver-wharf'],
  }

  #exec { 'pip install docker-py>=1.2': }
  exec { 'pip install git+https://github.com/seandst/webdriver-wharf.git': }

  File { before => Service['webdriver-wharf'], }

  file { '/etc/sysconfig/webdriver-wharf':
    content => template('webdriverwharf/sysconfig.erb'),
  }

  file { '/lib/systemd/system/webdriver-wharf.service':
    content => template('webdriverwharf/webdriver-wharf.service.erb'),
  }

  service { 'docker':
    ensure  => running,
    enabled => true,
    require => Package['docker'],
  }

  service { 'webdriver-wharf':
    ensure  => running,
    enabled => true,
    require => Service['docker'],
  }
}
