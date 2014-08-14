#
# Copyright (C) 2013 Red Hat, Inc.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
#
# @author: Dave Tucker <djt@redhat.com>

from oslo.config import cfg

from neutron.openstack.common import log as logging
from neutron.services.firewall.drivers import fwaas_base

from odldrivers.common import client as odl_client
from odldrivers.common import config  # noqa

LOG = logging.getLogger(__name__)


class OpenDaylightFwaasDriver(fwaas_base.FwaasDriverBase):

    """OpenDaylight FWaaS Driver"""

    def __init__(self):
        LOG.debug(_("Initializing OpenDaylight FWaaS driver"))
        self.client = odl_client.OpenDaylightRestClient(
            cfg.CONF.odl_rest.url,
            cfg.CONF.odl_rest.username,
            cfg.CONF.odl_rest.password,
            cfg.CONF.odl_rest.timeout,
            cfg.CONF.odl_rest.session_timeout
        )

    def create_firewall(self, apply_list, firewall):
        """Create the Firewall with default (drop all) policy.
        The default policy will be applied on all the interfaces of
        trusted zone.
        """
        pass

    def delete_firewall(self, apply_list, firewall):
        """Delete firewall.
        Removes all policies created by this instance and frees up
        all the resources.
        """
        pass

    def update_firewall(self, apply_list, firewall):
        """Apply the policy on all trusted interfaces.
        Remove previous policy and apply the new policy on all trusted
        interfaces.
        """
        pass

    def apply_default_policy(self, apply_list, firewall):
        """Apply the default policy on all trusted interfaces.
        Remove current policy and apply the default policy on all trusted
        interfaces.
        """
        pass
