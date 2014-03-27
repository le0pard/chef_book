actions :create, :delete
default_action :create

attribute :host, :kind_of => String, :name_attribute => true, :required => true
attribute :key, :kind_of => String
attribute :port, :kind_of => Fixnum, :default => 22
attribute :known_hosts_file, :kind_of => String, :default => '/etc/ssh/ssh_known_hosts'

# Needed for Chef versions < 0.10.10
def initialize(*args)
  super
  @action = :create
end