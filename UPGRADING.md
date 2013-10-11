4.1.2 -> 4.2.x
================

Global changes
---------------

* SNMP has been removed from scope.  The snmp packages and configs can
  be safely removed.

CentOS notes
------------

* Previously, the package bsd-mailx is installed.  We've switched to
  the default heirloom mailx.  bsd-mailx will need to be removed prior
  to running chef-client on all nodes.
