include_recipe "build-essential"

include_recipe "my_cool_app::ohai_plugin"
Chef::Log.info "Installed Node version: #{node['system_node_js']['version']}" if node['system_node_js']

case node['platform_family']
  when 'rhel','fedora'
    package "openssl-devel"
  when 'debian'
    package "libssl-dev"
end

nodejs_tar = "node-v#{node['my_cool_app']['nodejs']['version']}.tar.gz"
nodejs_tar_path = nodejs_tar
if node['my_cool_app']['nodejs']['version'].split('.')[1].to_i >= 5
  nodejs_tar_path = "v#{node['my_cool_app']['nodejs']['version']}/#{nodejs_tar_path}"
end
# Let the user override the source url in the attributes
nodejs_src_url = "#{node['my_cool_app']['nodejs']['src_url']}/#{nodejs_tar_path}"

remote_file "/usr/local/src/#{nodejs_tar}" do
  source nodejs_src_url
  checksum node['my_cool_app']['nodejs']['checksum']
  mode 0644
  action :create_if_missing
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{nodejs_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/node-v#{node['my_cool_app']['nodejs']['version']}"
end

bash "compile node.js" do
  cwd "/usr/local/src/node-v#{node['my_cool_app']['nodejs']['version']}"
  code <<-EOH
    PATH="/usr/local/bin:$PATH"
    ./configure --prefix=#{node['my_cool_app']['nodejs']['dir']} && \
    make
  EOH
  creates "/usr/local/src/node-v#{node['my_cool_app']['nodejs']['version']}/node"
end

execute "nodejs make install" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "make install"
  cwd "/usr/local/src/node-v#{node['my_cool_app']['nodejs']['version']}"
  not_if {node['system_node_js'] && node['system_node_js']['version'] == node['my_cool_app']['nodejs']['version'] }
end