require 'spec_helper'

describe 'my_cool_app::haproxy' do
  let(:platform) { 'ubuntu' }
  let(:platform_version) { '12.04' }
  let(:chef_run) { ChefSpec::Runner.new(platform: platform, version: platform_version).converge(described_recipe) }

  it "install haproxy package" do
    expect(chef_run).to install_package('haproxy')
  end

  it 'enable haproxy service' do
    expect(chef_run).to enable_service('haproxy')
  end

  it 'create config /etc/haproxy/haproxy.cfg with empty backends' do
    expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote("backend bk_http\nbackend bk_https\n")}/)
  end

  context 'with env, role and one node' do
    let(:node_env) { 'test' }
    let(:chef_run) do
      ChefSpec::Runner.new(platform: platform, version: platform_version) do |node|
        # Create a new environment (you could also use a different :let block or :before block)
        env = Chef::Environment.new
        env.name node_env

        # Stub the node to return this environment
        node.stub(:chef_environment).and_return(env.name)

        # Stub any calls to Environment.load to return this environment
        Chef::Environment.stub(:load).and_return(env)
      end.converge(described_recipe)
    end

    before do
      ChefSpec::Server.create_environment(node_env, { description: 'Test env' })
      ChefSpec::Server.create_role('web', { default_attributes: {} })
      ChefSpec::Server.create_node('first-node', {
        run_list: ['role[web]'],
        chef_environment: node_env,
        normal: { fqdn: '127.0.0.1', hostname: 'test.org', ipaddress: '127.0.0.1' }
      })
    end

    it 'create config /etc/haproxy/haproxy.cfg with first-node on 80 port' do
      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test.org 127.0.0.1:80 weight 1 maxconn 1024 check')}/)
    end

    it 'create config /etc/haproxy/haproxy.cfg with first-node on 443 port' do
      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test.org 127.0.0.1:443 weight 1 maxconn 1024 check')}/)
    end

    context 'with two nodes' do
      before do
        ChefSpec::Server.create_node('second-node', {
          run_list: ['role[web]'],
          chef_environment: node_env,
          normal: { fqdn: '192.168.1.2', hostname: 'test2.org', ipaddress: '192.168.1.2' }
        })
      end

      it 'create config /etc/haproxy/haproxy.cfg with first-node on 80 port' do
        expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test.org 127.0.0.1:80 weight 1 maxconn 1024 check')}/)
      end

      it 'create config /etc/haproxy/haproxy.cfg with first-node on 443 port' do
        expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test.org 127.0.0.1:443 weight 1 maxconn 1024 check')}/)
      end

      it 'create config /etc/haproxy/haproxy.cfg with second-node on 80 port' do
        expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test2.org 192.168.1.2:80 weight 1 maxconn 1024 check')}/)
      end

      it 'create config /etc/haproxy/haproxy.cfg with second-node on 443 port' do
        expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/#{Regexp.quote('server test2.org 192.168.1.2:443 weight 1 maxconn 1024 check')}/)
      end

    end
  end

end