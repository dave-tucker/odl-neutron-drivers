#
# Copyright (C) 2013 Red Hat, Inc.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
#
# @author: Dave Tucker <djt@redhat.com>

from neutron.openstack.common import log as logging
from neutron.services.loadbalancer.drivers import lbaas_base

from odldrivers.common import client as odl_client
from odldrivers.common import config  # noqa

LOG = logging.getLogger(__name__)


class OpenDaylightLbaasDriver(lbaas_base.LoadBalancerAbstractDriver):

    """OpenDaylight LBaaS Driver"""

    def __init__(self, plugin):
        LOG.debug(_("Initializing OpenDaylight LBaaS driver"))
        self.plugin = plugin
        self.client = odl_client.OpenDaylightRestClient(
            cfg.CONF.odl_rest.url,
            cfg.CONF.odl_rest.username,
            cfg.CONF.odl_rest.password,
            cfg.CONF.odl_rest.timeout,
            cfg.CONF.odl_rest.session_timeout
        )

    def create_vip(self, context, vip):
        """Create a vip on the OpenDaylight Controller."""
        pass

    def update_vip(self, context, old_vip, vip):
        """Update a vip on the OpenDaylight Controller."""
        pass

    def delete_vip(self, context, vip):
        """Delete a vip on the OpenDaylight Controller."""
        pass

    def create_pool(self, context, pool):
        """Create a pool on the OpenDaylight Controller."""
        pass

    def update_pool(self, context, old_pool, pool):
        """Update a pool on the OpenDaylight Controller."""
        pass

    def delete_pool(self, context, pool):
        """Delete a pool on the OpenDaylight Controller."""
        pass

    def create_member(self, context, member):
        """Create a pool member on the OpenDaylight Controller."""
        pass

    def update_member(self, context, old_member, member):
        """Update a pool member on the OpenDaylight Controller."""
        pass

    def delete_member(self, context, member):
        """Delete a pool member on the OpenDaylight Controller."""
        pass

    def create_pool_health_monitor(self, context, health_monitor, pool_id):
        """Create a pool health monitor on the OpenDaylight Controller."""
        pass

    def update_pool_health_monitor(self, context, old_health_monitor,
                                   health_monitor, pool_id):
        """Update a pool health monitor on the OpenDaylight Controller."""
        pass

    def delete_pool_health_monitor(self, context, health_monitor, pool_id):
        """Delete a pool health monitor on the OpenDaylight Controller."""
        pass

    def stats(self, context, pool_id):
        """Retrieve pool statistics from the OpenDaylight Controller"""
        pass


