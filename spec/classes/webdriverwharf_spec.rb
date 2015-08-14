require 'spec_helper'

describe 'webdriverwharf', :type => :module do
  sysconfig_file = '/etc/sysconfig/webdriver-wharf'
  defaults = {
    'docker_image'         => 'cfmeqe/sel_ff_chrome',
    'pool_size'            => 4,
    'max_checkout_time'    => 3600,
    'image_pull_interval'  => 3600,
    'rebalance_interval'   => 21600,
    'log_level'            => 'info',
    'listen_host'          => '0.0.0.0',
    'listen_port'          => 4899,
    'start_timeout'        => 60,
    'db_url'               => nil,
  }

  describe 'on RHEL' do
    let(:facts) do
      { :osfamily => 'RedHat',
        :operatingsystemmajrelease => '7' }
    end

    describe 'with default parameters' do
      let(:params) {{ }}
      it { should compile }
      defaults.each do |key, value|
        regex = Regexp.new(".*=#{value}\n.*")
        it { should contain_file(sysconfig_file).with_content(regex) }
      end
    end
  end

  describe 'on non-RHEL' do
    let(:facts) do
      { :osfamily => 'Ubuntu' }
    end
    it { should_not compile }
  end
end
