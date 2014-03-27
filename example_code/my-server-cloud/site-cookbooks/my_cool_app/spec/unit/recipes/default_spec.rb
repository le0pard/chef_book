require 'spec_helper'

describe 'my_cool_app::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  %w(git ntp).each do |pack|
    it "install #{pack} package" do
      expect(chef_run).to install_package(pack)
    end
  end

  it 'create direcory for web app' do
    expect(chef_run).to create_directory('/var/www/my_cool_app').with(
      user:   'vagrant',
      mode:  "0755"
    )
  end

  it 'include nginx recipe' do
    expect(chef_run).to include_recipe('nginx')
  end

  it 'create web app nginx config' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/my_cool_app.conf')
  end

  it 'enable nginx service' do
    expect(chef_run).to enable_service('nginx')
  end

  # comment for test-kitchen
  #it 'include node recipe' do
  #  expect(chef_run).to include_recipe('my_cool_app::node')
  #end

end