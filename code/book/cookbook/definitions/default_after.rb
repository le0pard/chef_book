# enable website
enable_web_site node['my_cool_app']['name'] do
  template "nginx.conf.erb"
end