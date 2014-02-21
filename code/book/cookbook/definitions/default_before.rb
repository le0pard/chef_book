# create nginx config from temlate nginx.conf.erb
nginx_config = "#{node['nginx']['dir']}/sites-available/#{node['my_cool_app']['name']}.conf"
template nginx_config do
  source "nginx.conf.erb"
  mode "0644"
end

# activate conf in nginx
nginx_site "#{node['my_cool_app']['name']}.conf"