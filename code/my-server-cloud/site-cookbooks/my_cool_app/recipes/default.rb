#
# Cookbook Name:: my_cool_app
# Recipe:: default
#
# Copyright (C) 2014 Alexey Vasiliev
#
# MIT
#

# install needed package
%w(git ntp).each do |pack|
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

include_recipe 'my_cool_app::node'