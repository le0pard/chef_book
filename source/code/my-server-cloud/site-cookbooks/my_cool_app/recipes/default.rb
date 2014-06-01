#
# Cookbook Name:: my_cool_app
# Recipe:: default
#
# Copyright (C) 2014 Alexey Vasiliev
#
# MIT
#

case node['platform_family']
when "debian"
  # update apt
  execute "apt-get-update" do
    command "apt-get update"
    action :run
    ignore_failure true
    # tip: to suppress this running every time, just use the apt cookbook
    not_if do
      ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
      ::File.mtime('/var/lib/apt/periodic/update-success-stamp') > Time.now - 86400*2
    end
  end
when "rhel", "fedora"
  # skip
else
  Chef::Application.fatal! "Doesn't support this platform: #{node['platform_family']}"
end

# install needed package
packages = %w(ntp)

if "ubuntu" == node['platform'] && node['platform_version'].to_f <= 10.04
  packages << "git-core"
else
  packages << "git"
end

packages.each do |pack|
  package pack
end

# create directory for web app
directory node['my_cool_app']['web_dir'] do
  owner node['my_cool_app']['user']
  mode "0755"
  recursive true
end

# upload index.html file to web app directory as index.html
cookbook_file "#{node['my_cool_app']['web_dir']}/index.html" do
  owner node['my_cool_app']['user']
  source "index.html"
  mode 0755
end

# set host to local file
hostsfile_entry '127.0.0.1' do
  hostname  node['my_cool_app']['web_host']
  unique    true
end

# nginx recipe
include_recipe 'nginx'

# enable website
enable_web_site node['my_cool_app']['name'] do
  template "nginx.conf.erb"
end

# known hosts for github.com
my_cool_app_know_host 'github.com'

#my_cool_app_know_host 'github.com' do
#  action :delete
#end

my_cool_app_known_host 'bitbucket.org'

# comment for test kitchen
#include_recipe 'my_cool_app::node'