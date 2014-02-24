require 'spec_helper'

describe 'my_cool_app::node' do
  let(:platfom) { 'ubuntu' }
  let(:platfom_version) { '12.04' }
  let(:chef_run) { ChefSpec::Runner.new(platform: platfom, version: platfom_version).converge(described_recipe) }
  let(:nodejs_version) { '0.10.26' }
  let(:nodejs_tar) { "node-v#{nodejs_version}.tar.gz" }

  it "install libssl-dev package" do
    expect(chef_run).to install_package('libssl-dev')
  end

  context 'rhel or fedora' do
    let(:platfom) { 'redhat' }
    let(:platfom_version) { '6.5' }

    it "install openssl-devel package" do
      expect(chef_run).to install_package('openssl-devel')
    end
  end

  it 'download node if missing' do
    expect(chef_run).to create_remote_file_if_missing("/usr/local/src/#{nodejs_tar}")
  end

  it 'unpack node' do
    expect(chef_run).to run_execute("tar --no-same-owner -zxf #{nodejs_tar}")
  end

  it 'install node' do
    expect(chef_run).to run_execute('make install').with(cwd: "/usr/local/src/node-v#{nodejs_version}")
  end
end