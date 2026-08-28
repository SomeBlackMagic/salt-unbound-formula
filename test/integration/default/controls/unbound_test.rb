# frozen_string_literal: true

# Detect OS family to set expected paths
os_family = os.family

config_file =
  if %w[debian ubuntu].include?(os_family)
    '/etc/unbound/unbound.conf'
  elsif os_family == 'redhat'
    '/etc/unbound/unbound.conf'
  elsif os_family == 'freebsd'
    '/usr/local/etc/unbound/unbound.conf'
  else
    '/etc/unbound/unbound.conf'
  end

cache_file =
  if os_family == 'freebsd'
    '/usr/local/etc/unbound/named.cache'
  else
    '/etc/unbound/named.cache'
  end

config_group = os_family == 'suse' ? 'unbound' : 'root'

control 'unbound-package' do
  impact 1.0
  title 'Unbound package is installed'

  describe package('unbound') do
    it { should be_installed }
  end
end

control 'unbound-service' do
  impact 1.0
  title 'Unbound service is running and enabled'

  describe service('unbound') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'unbound-config' do
  impact 1.0
  title 'Unbound configuration file is present'

  describe file(config_file) do
    it { should exist }
    it { should be_file }
    its('owner') { should eq 'root' }
    its('group') { should eq config_group }
    its('mode') { should cmp '0440' }
  end
end

control 'unbound-cache' do
  impact 0.5
  title 'DNS root hints cache file is present'

  describe file(cache_file) do
    it { should exist }
    it { should be_file }
  end
end

control 'unbound-config-content' do
  impact 1.0
  title 'Unbound config contains required sections'

  describe file(config_file) do
    its('content') { should match(/^server:/) }
    its('content') { should match(/auto-trust-anchor-file/) }
  end
end
