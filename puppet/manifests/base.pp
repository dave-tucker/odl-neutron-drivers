$deps = [
    'autoconf',
    'automake',
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
    'libssl-dev',
    'libtool',
    'libyaml-dev',
    'lsof',
    'lvm2',
    'open-iscsi',
    'openssh-server',
    'openssl',
    'parted',
    'pm-utils',
    'psmisc',
    'pylint',
    'python-all',
    'python-boto',
    'python-cheetah',
    'python-dev',
    'python-eventlet',
    'python-feedparser',
    'python-greenlet',
    'python-iso8601',
    'python-kombu',
    'python-libxml2',
    'python-lockfile',
    'python-lxml',
    'python-m2crypto',
    'python-migrate',
    'python-mox',
    'python-mysql.connector',
    'python-mysqldb',
    'python-numpy',
    'python-paste',
    'python-pastedeploy',
    'python-pyudev',
    'python-qt4',
    'python-routes',
    'python-setuptools',
    'python-sqlalchemy',
    'python-suds',
    'python-tempita',
    'python-twisted-conch',
    'python-unittest2',
    'python-virtualenv',
    'python-xattr',
    'python-zopeinterface',
    'python2.7',
    'screen',
    'sg3-utils',
    'socat',
    'sqlite3',
    'sudo',
    'sysfsutils',
    'tar',
    'tcpdump',
    'unzip',
    'vlan',
    'wget'
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

exec {"Download Open vSwitch":
    command => "wget http://openvswitch.org/releases/openvswitch-${ovs_version}.tar.gz",
    cwd     => "/home/vagrant",
    creates => "/home/vagrant/openvswitch-${ovs_version}.tar.gz",
    path    => $::path,
    user    => 'vagrant'
}

exec { 'Extract Open vSwitch':
    command => "tar -xvf openvswitch-${ovs_version}.tar.gz",
    cwd     => '/home/vagrant',
    creates => "/home/vagrant/openvswitch-${ovs_version}",
    user    => 'vagrant',
    path    => $::path,
    timeout => 0,
    require => Exec['Download Open vSwitch']
}

exec { 'Compile Open vSwitch':
    command => 'fakeroot debian/rules binary',
    cwd     => "/home/vagrant/openvswitch-${ovs_version}",
    creates => "/home/vagrant/openvswitch-common_${ovs_version}-1_amd64.deb",
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
