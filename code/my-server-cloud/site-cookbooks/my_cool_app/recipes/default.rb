#
# Cookbook Name:: my_cool_app
# Recipe:: default
#
# Copyright (C) 2014 Alexey Vasiliev
#
# MIT
#

%w(git ntp).each do |pack|
  package pack
end