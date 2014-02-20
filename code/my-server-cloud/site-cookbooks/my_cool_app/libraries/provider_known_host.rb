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
        @current_resource.port(new_resource.port)
        @current_resource.known_hosts_file(new_resource.known_hosts_file)
        # Although you can reference @new_resource throughout the provider it is best to
        # only make modifications to the current version
        @current_resource.host(new_resource.host)
        @current_resource
      end

      def action_create
        Chef::Log.debug("#{@new_resource}: Create #{new_resource.host}")
      end

      def action_delete
        Chef::Log.debug("#{@new_resource}: Delete #{new_resource.host}")
      end

    end
  end
end