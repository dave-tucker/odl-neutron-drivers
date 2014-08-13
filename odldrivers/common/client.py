# Copyright (c) 2014 Red Hat Inc.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
# @author: Dave Tucker, Red Hat Inc.

import requests

from neutron.openstack.common import jsonutils
from neutron.openstack.common import log

from odldrivers.common import auth

LOG = log.getLogger(__name__)


class OpenDaylightRestClient(object):

    def __init__(self, url, username, password, timeout, session_timeout):
        self.url = url
        self.timeout = timeout
        self.auth = auth.JsessionId(url, username, password, session_timeout)

    def sendjson(self, method, urlpath, obj, ignorecodes=[]):
        """Send json to the OpenDaylight controller."""

        headers = {'Content-Type': 'application/json'}
        data = jsonutils.dumps(obj, indent=2) if obj else None
        url = '/'.join([self.url, urlpath])
        LOG.debug(_('ODL-----> sending URL (%s) <-----ODL') % url)
        LOG.debug(_('ODL-----> sending JSON (%s) <-----ODL') % data)
        r = requests.request(method, url=url,
                             headers=headers, data=data,
                             auth=self.auth, timeout=self.timeout)

        # ignorecodes contains a list of HTTP error codes to ignore.
        LOG.debug(_('ODL-----> status code (%i) <------ODL)' % r.status_code)
        if r.status_code in ignorecodes:
            return
        r.raise_for_status()
