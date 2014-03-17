require 'minitest/spec'

describe_recipe 'my_cool_app::default' do

  %w(git ntp).each do |pack|
    it "install #{pack}" do
      package(pack).must_be_installed
    end
  end

  it "nginx must running" do
    service("nginx").must_be_running
  end

end