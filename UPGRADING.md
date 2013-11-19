4.1.2 -> 4.2.x
================

CentOS notes
------------

* Previously, the package bsd-mailx is installed.  We've switched to
  the default heirloom mailx.  bsd-mailx will need to be removed prior
  to running chef-client on all nodes.
