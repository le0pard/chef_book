template "#{node['ohai']['plugin_path']}/system_node_js.rb" do
  source "plugins/system_node_js.rb.erb"
  owner "root"
  group "root"
  mode 00755
  variables(
    :node_js_bin => "#{node['my_cool_app']['nodejs']['dir']}/bin/node"
  )
end

include_recipe "ohai"