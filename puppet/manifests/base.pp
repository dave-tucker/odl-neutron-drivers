$deps = [
    'bc',
    'bridge-utils',
    'build-essential',
    'conntrack',
    'curl',
    'debhelper',
    'dkms',
    'dnsmasq-base',
    'dnsmasq-utils',
    'ebtables',
    'euca2ools',
    'fakeroot',
    'gawk',
    'gcc',
    'genisoimage',
    'git',
    'graphviz',
    'iptables',
    'iputils-arping',
    'iputils-ping',
    'kpartx',
    'libffi-dev',
    'libjs-jquery-tablesorter',
    'libkrb5-dev',
    'libldap2-dev',
    'libmysqlclient-dev',
    'libpq-dev',
    'libsasl2-dev',
    'libssl-dev',
    'libvirt-bin',
    'libxml2-dev',
    'libxslt1-dev',
    'libyaml-dev',
    'linux-headers-generic',
    'lsof',
    'mysql-server',
    'openssh-server',
    'openssl',
    'parted',
    'pm-utils',
    'psmisc',
    'pylint',
    'python-all',
    'python-boto',
    'python-cheetah',
    'python-cmd2',
    'python-dev',
    'python-eventlet',
    'python-feedparser',
    'python-greenlet',
    'python-iso8601',
    'python-kombu',
    'python-libvirt',
    'python-libxml2',
    'python-lockfile',
    'python-lxml',
    'python-m2crypto',
    'python-migrate',
    'python-mock',
    'python-mox',
    'python-mysql.connector',
    'python-mysqldb',
    'python-numpy',
    'python-paste',
    'python-pastedeploy',
    'python-pastescript',
    'python-pip',
    'python-pysqlite2',
    'python-pyudev',
    'python-qpid',
    'python-qt4',
    'python-routes',
    'python-setuptools',
    'python-sqlalchemy',
    'python-suds',
    'python-tempita',
    'python-twisted-conch',
    'python-twisted-web',
    'python-unittest2',
    'python-virtualenv',
    'python-webob',
    'python-wsgiref',
    'python-xattr',
    'python-zopeinterface',
    'python2.7',
    'qemu',
    'qemu-kvm',
    'rabbitmq-server',
    'radvd',
    'screen',
    'socat',
    'sqlite3',
    'sudo',
    'tar',
    'tcpdump',
    'unzip',
    'vlan',
    'wget',
    'xauth',
    'zlib1g-dev'
]

$hosts = hiera('hosts')

$ovs_version = '2.3.0'

file { '/etc/hosts':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('/vagrant/puppet/templates/hosts.erb')
}

package { $deps:
    ensure   => installed,
}

exec {"openvswitch-${ovs_version}.tar.gz":
    command => "wget http://openvswitch.org/releases/openvswitch-${ovs_version}.tar.gz",
    cwd     => '/home/vagrant',
    path    => $::path,
    user    => 'vagrant'
}

exec { 'Extract Open vSwitch':
    command => "tar -xvf openvswitch-${ovs_version}.tar.gz",
    cwd     => '/home/vagrant',
    user    => 'vagrant',
    path    => $::path,
    timeout => 0,
    require => Exec["openvswitch-${ovs_version}.tar.gz"]
}

exec { 'Compile Open vSwitch':
    command => 'fakeroot debian/rules binary',
    cwd     => "/home/vagrant/openvswitch-${ovs_version}",
    user    => 'root',
    path    => $::path,
    timeout => 0,
    require => [Exec['Extract Open vSwitch'], Package[$deps]]
}

package { 'openvswitch-common':
    ensure   => installed,
    provider => dpkg,
    source   => "/home/vagrant/openvswitch-common_${ovs_version}-1_amd64.deb",
    require  => Exec['Compile Open vSwitch']
}

package { 'openvswitch-switch':
    ensure   => installed,
    provider => dpkg,
    source   => "/home/vagrant/openvswitch-switch_${ovs_version}-1_amd64.deb",
    require  => Package['openvswitch-common']
}

package { 'openvswitch-datapath-dkms':
    ensure   => installed,
    provider => dpkg,
    source   => "/home/vagrant/openvswitch-datapath-dkms_${ovs_version}-1_all.deb",
    require  => Package['openvswitch-switch']
}

package { 'openvswitch-pki':
    ensure   => installed,
    provider => dpkg,
    source   => "/home/vagrant/openvswitch-pki_${ovs_version}-1_all.deb",
    require  => Package['openvswitch-datapath-dkms']
}
