action :create do
  key = (new_resource.key || `ssh-keyscan -H -p #{new_resource.port} #{new_resource.host} 2>&1`)
  comment = key.split("\n").first || ""

  Chef::Application.fatal! "Could not resolve #{new_resource.host}" if key =~ /getaddrinfo/

  # Ensure that the file exists and has minimal content (required by Chef::Util::FileEdit)
  file new_resource.known_hosts_file do
    action        :create
    backup        false
    content       '# This file must contain at least one line. This is that line.'
    only_if do
      !::File.exists?(new_resource.known_hosts_file) || ::File.new(new_resource.known_hosts_file).readlines.length == 0
    end
  end

  # Use a Ruby block to edit the file
  ruby_block "add #{new_resource.host} to #{new_resource.known_hosts_file}" do
    block do
      file = ::Chef::Util::FileEdit.new(new_resource.known_hosts_file)
      file.insert_line_if_no_match(/#{Regexp.escape(comment)}|#{Regexp.escape(key)}/, key)
      file.write_file
    end
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  key = (new_resource.key || `ssh-keyscan -H -p #{new_resource.port} #{new_resource.host} 2>&1`)
  comment = key.split("\n").first || ""

  Chef::Application.fatal! "Could not resolve #{new_resource.host}" if key =~ /getaddrinfo/

  # Ensure that the file exists and has minimal content (required by Chef::Util::FileEdit)
  file new_resource.known_hosts_file do
    action        :create
    backup        false
    content       '# This file must contain at least one line. This is that line.'
    only_if do
      !::File.exists?(new_resource.known_hosts_file) || ::File.new(new_resource.known_hosts_file).readlines.length == 0
    end
  end

  # Use a Ruby block to edit the file
  ruby_block "del #{new_resource.host} from #{new_resource.known_hosts_file}" do
    block do
      file = ::Chef::Util::FileEdit.new(new_resource.known_hosts_file)
      file.search_file_delete_line(/#{Regexp.escape(comment)}|#{Regexp.escape(key)}/, key)
      file.write_file
    end
    only_if do
      ::File.exists?(new_resource.known_hosts_file)
    end
  end
  new_resource.updated_by_last_action(true)
end