require 'chef/provider'

class Chef
  class Provider
    class MyCoolAppKnownHost < Chef::Provider

      # We MUST override this method in our custom provider
      def load_current_resource
        # Here we keep the existing version of the resource
        # if none exists we create a new one from the resource we defined earlier
        @current_resource ||= Chef::Resource::MyCoolAppKnownHost.new(new_resource.name)

        # New resource represents the chef DSL block that is being run (from a recipe for example)
        @current_resource.key(new_resource.key)
        @current_resource.port(new_resource.port)
        @current_resource.known_hosts_file(new_resource.known_hosts_file)
        # Although you can reference @new_resource throughout the provider it is best to
        # only make modifications to the current version
        @current_resource.host(new_resource.host)
        @current_resource
      end

      def action_create
        Chef::Log.debug("#{@new_resource}: Create #{new_resource.host}")

        key, comment = insure_for_file(new_resource)
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

      def action_delete
        Chef::Log.debug("#{@new_resource}: Delete #{new_resource.host}")

        key, comment = insure_for_file(new_resource)
        # Use a Ruby block to edit the file
        ruby_block "del #{new_resource.host} from #{new_resource.known_hosts_file}" do
          block do
            file = ::Chef::Util::FileEdit.new(new_resource.known_hosts_file)
            file.search_file_delete_line(/#{Regexp.escape(comment)}|#{Regexp.escape(key)}/)
            file.write_file
          end
        end
        new_resource.updated_by_last_action(true)
      end

      private

      def insure_for_file(new_resource)
        cmd = Mixlib::ShellOut.new("ssh-keyscan -H -p #{new_resource.port} #{new_resource.host} 2>&1")
        key = (new_resource.key || cmd.run_command.stdout)
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
        [key, comment]
      end

    end
  end
end