require 'spec_helper'

describe 'my_cool_app::tests' do
  let(:platfom) { 'ubuntu' }
  let(:platfom_version) { '12.04' }
  let(:chef_run) { ChefSpec::Runner.new(platform: platfom, version: platfom_version).converge(described_recipe) }

  it "install haproxy package" do
    expect(chef_run).to install_package('haproxy')
  end

  it 'enable haproxy service' do
    expect(chef_run).to enable_service('haproxy')
  end

  it 'create config /etc/haproxy/haproxy.cfg with empty backends' do
    expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(/backend bk_http\nbackend bk_https\n/)
  end

  context 'with env, role and one node' do
    let(:node_env) { 'test' }
    let(:chef_run) do
      ChefSpec::Runner.new(platform: platfom, version: platfom_version) do |node|
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

    it 'create config /etc/haproxy/haproxy.cfg with first-node backend' do
      config_output = <<EOF
global
  log 127.0.0.1   local0
  log 127.0.0.1   local1 notice
  maxconn 5000
  user haproxy
  group haproxy

defaults
  log     global
  mode    http
  retries 3
  timeout client 60000
  timeout server 50000
  timeout connect 25000
  balance roundrobin

frontend ft_http
  bind *:80
  mode tcp
  default_backend bk_http
frontend ft_https
  bind *:443
  mode tcp
  default_backend bk_https
backend bk_http
  mode http
  server test.org 127.0.0.1:80 weight 1 maxconn 1024 check
  option httpchk GET /
backend bk_https
  mode tcp
  server test.org 127.0.0.1:443 weight 1 maxconn 1024 check
  option httpchk GET /
EOF
      expect(chef_run).to render_file('/etc/haproxy/haproxy.cfg').with_content(config_output)
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