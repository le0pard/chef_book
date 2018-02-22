require 'chef/resource'

class Chef
  class Resource
    class MyCoolAppKnownHost < Chef::Resource

      def initialize(name, run_context=nil)
        super
        # Bind ourselves to the name with an underscore
        @resource_name = :my_cool_app_known_host
        # We need to tie to our provider
        @provider = Chef::Provider::MyCoolAppKnownHost
        # Default Action Goes here
        @action = :create
        @allowed_actions = [:create, :delete]

        # Now we need to set up any resource defaults
        @port = 22
        @known_hosts_file = '/etc/ssh/ssh_known_hosts'
        @host = name  # This is equivalent to setting :name_attribute => true
      end

      # Define the attributes we set defaults for
      def key(arg=nil)
        set_or_return(:key, arg, :kind_of => String)
      end

      def host(arg=nil)
        set_or_return(:host, arg, :kind_of => String)
      end

      def port(arg=nil)
        set_or_return(:port, arg, :kind_of => Integer)
      end

      def known_hosts_file(arg=nil)
        set_or_return(:known_hosts_file, arg, :kind_of => String)
      end

    end
  end
end