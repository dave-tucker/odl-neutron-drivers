vcsrepo {'/home/vagrant/devstack':
    ensure   => present,
    provider => git,
    user     => 'vagrant',
    source   => 'https://github.com/openstack-dev/devstack.git',
    before   => File['/home/vagrant/devstack/local.conf']
}

$hosts = hiera('hosts')

file { '/home/vagrant/devstack/local.conf':
    ensure  => present,
    owner   => 'vagrant',
    group   => 'vagrant',
    content => template('/vagrant/puppet/templates/compute.local.conf.erb')
}

exec { 'Install Drivers':
    command => 'pip install -r requirements.txt && python setup.py install',
    cwd     => '/vagrant',
    path    => $::path,
    user    => 'root'
}
