odl-neutron-drivers
===================

This repository hosts the OpenDaylight project's OpenStack Neutron drivers.

Usage
-----

To use these drivers with Devstack....

1) Check out the repo and install the drivers::

    git clone https://github.com/dave-tucker/odl-neutron-drivers.git
    cd odl-neutron-drivers.git
    sudo python setup.py install

2) Edit your local.conf::

    Q_PLUGIN=ml2
    # Use "odl" instead of "opendaylight" to pick up the new driver
    Q_ML2_PLUGIN_MECHANISM_DRIVERS=odl,logger
    ODL_MGR_IP=192.168.50.1
    ENABLE_TENANT_TUNNELS=True
    Q_ML2_TENANT_NETWORK_TYPE=vxlan

    [[post-config|/etc/neutron/plugins/ml2/ml2_conf.ini]]
    [agent]
    minimize_polling=True

    # Note this was formerly "ml2_odl"
    [odl_rest]
    url=http://192.168.50.1:8080/controller/nb/v2/neutron
    username=admin
    password=admin

    # For L3
    [[post-config]|/etc/neutron/neutron.conf]
    [DEFAULT]
    service_plugins = odldrivers.l3.l3_odl.OpenDaylightL3ServicePlugin

3) Start devstack::

    cd devstack
    ./stack.sh
