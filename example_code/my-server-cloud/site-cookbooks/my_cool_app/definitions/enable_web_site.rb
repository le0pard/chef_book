define :enable_web_site, :enable => true, :template => "site.conf.erb" do
  if params[:enable]
    # create nginx config from temlate nginx.conf.erb
    nginx_config = "#{node['nginx']['dir']}/sites-available/#{params[:name]}.conf"
    template nginx_config do
      source params[:template]
      mode "0644"
    end
    # activate conf in nginx
    nginx_site "#{params[:name]}.conf"
  else
    # deactivateconf in nginx
    nginx_site "#{params[:name]}.conf" do
      enable    false
    end
  end
end