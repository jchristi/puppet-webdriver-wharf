# puppet-webdriver-wharf

[![Build Status](https://travis-ci.org/jchristi/puppet-webdriver-wharf.svg)](https://travis-ci.org/jchristi/puppet-webdriver-wharf)

Puppet module for [webdriver-wharf](https://github.com/seandst/webdriver-wharf)

## Support
Currently only supports RHEL/CentOS 7+

## Parameters

Parameter | Default
--- | ---
docker_image | 'cfmeqe/sel_ff_chrome'
pool_size | 4
max_checkout_time | 3600
image_pull_interval | 3600
rebalance_interval | 21600
log_level | 'info'
listen_host | 0.0.0.0
listen_port | 4899
start_timeout| 60
db_url | undef
