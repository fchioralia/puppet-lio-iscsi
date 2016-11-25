# == Class: lio-iscsi
#
# Full description of class lio-iscsi here.
#
# === Parameters
#
# Document parameters here.
#
# === Examples
#
#  class { 'iscsi':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <fchioralia@gmail.com>
#
class lio-iscsi{

     service { 'target':
        ensure => running,
        enable => true,
     }->

     package { 'targetcli':
        ensure => present,
     }

     $targetcli="/usr/bin/targetcli"
     $path = "/bin:/sbin:/usr/bin:/usr/sbin"

include lio-iscsi::save

}

