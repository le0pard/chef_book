require 'minitest/spec'

describe_recipe 'my_cool_app::default' do

  it "install ntp package" do
    package('ntp').must_be_installed
  end

  it "install git package" do
    if "ubuntu" == node['platform'] && node['platform_version'].to_f <= 10.04
      pack = "git-core"
    else
      pack = "git"
    end
    package(pack).must_be_installed
  end

  it "nginx must running" do
    service("nginx").must_be_running
  end

end