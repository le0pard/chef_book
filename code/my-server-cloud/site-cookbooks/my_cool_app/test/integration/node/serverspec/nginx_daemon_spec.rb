require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Nginx Daemon" do

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "has a running service of nginx" do
    expect(service("nginx")).to be_running
  end

end