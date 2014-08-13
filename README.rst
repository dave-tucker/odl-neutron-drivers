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

    #Enable ODL L3, Firewall, Loadbalancer
    Q_SERVICE_PLUGIN_CLASSES=odl_router,firewall,lbaas

    [[post-config|/etc/neutron/plugins/ml2/ml2_conf.ini]]
    [agent]
    minimize_polling=True

    # Note this was formerly "ml2_odl"
    [odl_rest]
    url=http://192.168.50.1:8080/controller/nb/v2/neutron
    username=admin
    password=admin

    # For FWaaS
    [[post-config]|/etc/neutron/fwaas_driver.ini]
    [fwaas]
    driver = odldrivers.fwaas.driver.OpenDaylightFwaasDriver
    enabled = True

    # For LBaaS
    [[post-config]|/etc/neutron/lbaas_agent.ini]
    [DEFAULT]
    device_driver = odldrivers.lbaas.driver.OpenDaylightLbaasDriver

3) Start devstack::

    cd devstack
    ./stack.sh
