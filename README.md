# puppet-webdriver-wharf
Puppet module for [webdriver-wharf](https://github.com/seandst/webdriver-wharf)

## Support
Currently only supports RHEL/CentOS 7+

## Parameters

Parameter | Default
- | -
docker_image | 'cfmeqe/sel_ff_chrome'
listen_port | 4899
listen_address | 0.0.0.0
pool_size | 4
max_checkout_time | 3600
log_level | 'info'
start_timeout| 60
