name             'my_cool_app'
maintainer       'Alexey Vasiliev'
maintainer_email 'leopard_ne@inbox.ru'
license          'MIT'
description      'Installs/Configures my_cool_app'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe 'my_cool_app',   'Configure my cool app'

depends 'nginx',           '~> 2.2.0'
depends 'build-essential'
depends 'ohai'
depends 'hostsfile'

%w{ fedora redhat centos ubuntu debian }.each do |os|
  supports os
end