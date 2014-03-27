require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/usr/local/bin'
  end
end

describe "Node" do

  describe command('node -v') do
    it { should return_stdout 'v0.10.26' }
  end

end