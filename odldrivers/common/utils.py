# Copyright (C) 2013 Red Hat, Inc.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License v1.0 which accompanies this distribution,
# and is available at http://www.eclipse.org/legal/epl-v10.html
#
# @author: Dave Tucker <djt@redhat.com>


def try_del(d, keys):
    """Ignore key errors when deleting from a dictionary."""
    for key in keys:
        try:
            del d[key]
        except KeyError:
            pass
