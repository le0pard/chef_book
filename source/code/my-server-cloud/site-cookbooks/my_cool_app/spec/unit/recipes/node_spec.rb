require 'spec_helper'

describe 'my_cool_app::node' do
  let(:platform) { 'ubuntu' }
  let(:platform_version) { '12.04' }
  let(:chef_run) { ChefSpec::Runner.new(platform: platform, version: platform_version).converge(described_recipe) }
  let(:nodejs_version) { '0.10.26' }
  let(:nodejs_tar) { "node-v#{nodejs_version}.tar.gz" }

  it "install libssl-dev package" do
    expect(chef_run).to install_package('libssl-dev')
  end

  context 'rhel or fedora' do
    let(:platform) { 'redhat' }
    let(:platform_version) { '6.5' }

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

  context 'node versions' do
    let(:system_node_version) { nil }
    let(:chef_run) do
      ChefSpec::Runner.new(platform: platform, version: platform_version) do |node|
        node.automatic['system_node_js'] = { 'version' => system_node_version } if system_node_version
      end.converge(described_recipe)
    end

    it 'install node if version not specified' do
      expect(chef_run).to run_execute('make install').with(cwd: "/usr/local/src/node-v#{nodejs_version}")
    end

    context 'installed different version' do
      let(:system_node_version) { '0.8.0' }

      it 'install node if version is not the same' do
        expect(chef_run).to run_execute('make install').with(cwd: "/usr/local/src/node-v#{nodejs_version}")
      end
    end

    context 'installed same version' do
      let(:system_node_version) { nodejs_version }

      it 'do not install node' do
        expect(chef_run).not_to run_execute('make install').with(cwd: "/usr/local/src/node-v#{nodejs_version}")
      end
    end
  end

end