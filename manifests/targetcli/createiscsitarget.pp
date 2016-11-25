#
# == Define: lio-iscsi::targetcli::createiscsitarget
#
# 'lio-iscsi::targetcli::createiscsitarget': Creates a new target. 
# The wwn format depends on the transport(s)
# supported by the fabric module. If the wwn is ommited, then a
# target will be created using either a randomly generated WWN of the
# proper type, or the first unused WWN in the list of possible WWNs if
# one is available. If WWNs are constrained to a list (i.e. for hardware
# targets addresses) and all WWNs are in use, the target creation will
# fail. Use the info command to get more information abour WWN type
# and possible values.
#
# This class follows the recommendations of the "Puppet Labs Style Guide":
# http://docs.puppetlabs.com/guides/style_guide.html . If you want to
# contribute, please check your code with puppet-lint.
#
# === Authors
#
# Copyright (c) Florin Chioralia	
#
# License: Apache 2.0
# Contact: fchioralia@gmail.com
#
# === Examples
#
#    lio-iscsi::targetcli::createiscsitarget{"name":
#        $target_name = undef,
#    }
#
# === Parameters
#
# [*target_name*] The name for the new backstore.
# Should be a string that uniqe identify the backstore.
#
# [*tpg*] Creates a new Target Portal Group within the target. The
# tag must be a positive integer value, optionally prefaced
# by 'tpg'. If omitted, the next available Target Portal Group
# Tag (TPGT) will be used. Must be array. Default: ["tpg1"]
#
# [*size*] The size for the backstore:
# Could be an integer or a human readable size (1Tb).
#
# [*sparse*] Specify if the backstore is thin provisioned.
# Default: true
#
# [*write_back*] Specify if write back is activated.
# Default: true


define lio-iscsi::targetcli::createiscsitarget(
    $target_name = undef,
    $tpg         = 'tpg1',
    $tpg_luns    = undef,
    $tpg_portals = undef,
    $tpg_acls    = undef,
)
{

  validate_string($tpg)
  validate_array($tpg_luns)
  validate_array($tpg_acls)
  validate_string($target_name)
  if $target_name !~ /^iqn\.([1][9][0-9]{2}|[2][0-9]{3})-([0][1-9]|[1][0-2])\.([a-z]+)\.([a-z]+)\:(\w+)$/ and $target_name !~ /^naa\.[a-f0-9]{16}$/ and $target_name !~ /^eui\.[a-f0-9]{16}$/
  {  fail(" WWN not valid as: iqn (iqn.2016-11.net.domain:t1), naa (naa.50014057f822d991), eui (eui.50014057f822d991)") }

include ::lio-iscsi

  exec { "createiscsitarget_$name":
    command     => "targetcli iscsi/ create $target_name",
    unless      => "targetcli iscsi/${target_name}",
    path        => $path,
    notify      => Exec['save'],
    require     => Package['targetcli'],
  }->
  lio-iscsi::targetcli::createtpg{"${target_name}_${tpg}":
    tpg                        => $tpg,
    target_name                => $target_name,
    tpg_luns                   => $tpg_luns,
    tpg_portals                => $tpg_portals,
    tpg_acls                   => $tpg_acls,
  }

}
