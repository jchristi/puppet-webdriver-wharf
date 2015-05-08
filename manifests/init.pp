# = Class: webdriverwharf
#
#   * installs webdriver-wharf
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

  # TODO: error if osver < RHEL7

  package { ['git', 'python-pip', 'docker', 'docker-logrotate']:
    ensure => installed,
  }

  Exec {
    path    => '/usr/bin:/bin:/sbin',
    require => [ Package['python-pip'], Package['git'], ],
    before  => Service['webdriver-wharf'],
  }

  exec { 'pip install docker-py': } #>=1.2
  exec { 'pip install git+https://github.com/seandst/webdriver-wharf.git': }

  File { before => Service['webdriver-wharf'], }

  file { '/etc/sysconfig/webdriver-wharf':
    content => template('webdriverwharf/sysconfig.erb'),
  }

  file { '/lib/systemd/system/webdriver-wharf.service':
    content => template('webdriverwharf/webdriver-wharf.service.erb'),
  }

  service { 'docker':
    enabled => true,
    ensure  => running,
    require => Package['docker'],
  }

  service { 'webdriver-wharf':
    enabled => true,
    ensure => running,
  }
}
