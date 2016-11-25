#
# == Define: lio-iscsi::targetcli::createfileio
#
# 'lio-iscsi::targetcli::createbackstore': configure a lio iscsi backstores/fileio.
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
#    lio-iscsi::targetcli::createfileio{"name":
#        name => "backstore_name",
#        size => "1G",
#        file_or_dev => "/home/test.img"
#     }
#
# === Parameters
#
# [*name*] The name for the new backstore.
# Should be a string that uniqe identify the backstore.
#
# [*file_or_dev*] The type of the backstore. Can be file or dev.
# Could be for example: file: "/home/test.img" or dev: "/dev/sdb".
#
# [*size*] The size for the backstore:
# Could be an integer or a human readable size (1Tb).
#
# [*sparse*] Specify if the backstore is thin provisioned.
# Default: true
#
# [*write_back*] Specify if write back is activated.
# Default: true
#
# [*type*] Should be fileio, block, pscsi, ramdisk.
# Required.
#

define lio-iscsi::targetcli::createbackstore(
    $name = undef,
    $file_or_dev = undef,
    $write_back = true,
    $size = undef,
    $readonly = false,
    $nullio = false,
    $sparse = true,
    $type = undef,
)
{
  validate_string($name)
  if $type !~ /^(fileio|block|pscsi|ramdisk)$/
  {  fail("This type not supported! Only fileio, block, pscsi or ramdisk")  }

  include ::lio-iscsi
  case $type
  {
    "fileio": {

      validate_bool($write_back)
      validate_bool($sparse)
      if !is_integer($size) and $size !~ /^\d+(B|k|K|kBOA|KB|m|M|mB|MB|g|G|gB|GB|t|T|tB|TB)$/
      {  fail("size error
      SIZE SYNTAX
      ===========
      - If size is an int, it represents a number of bytes.
      - If size is a string, the following units can be used:
      - B or no unit present for bytes
      - k, K, kB, KB for kB (kilobytes)
      - m, M, mB, MB for MB (megabytes)
      - g, G, gB, GB for GB (gigabytes)
      - t, T, tB, TB for TB (terabytes)
      ")
      }

          exec { "createfileio_$name":
            command     => "targetcli backstores/fileio/ create name=$name file_or_dev=$file_or_dev sparse=$sparse write_back=$write_back size=$size",
            unless      => "targetcli backstores/fileio/$name",
            path        => $path,
            notify      => Exec['save'],
            require     => Package['targetcli'],
          }
     }
    "block": {

      validate_string($file_or_dev)
      validate_bool($readonly)
          exec { "createblock_$name":
            command     => "targetcli backstores/block/ create name=$name dev=$file_or_dev readonly=$readonly",
            unless      => "targetcli backstores/block/$name",
            path        => $path,
            notify      => Exec['save'],
            require     => Package['targetcli'],
          }
     }
    "pscsi": {

      validate_string($file_or_dev)
          exec { "createpscsi_$name":
            command     => "targetcli backstores/pscsi/ create name=$name dev=$file_or_dev",
            unless      => "targetcli backstores/pscsi/$name",
            path        => $path,
            notify      => Exec['save'],
            require     => Package['targetcli'],
          }
     }
    "ramdisk": {

      validate_bool($nullio)
      if !is_integer($size) and $size !~ /^\d+(B|k|K|kBOA|KB|m|M|mB|MB|g|G|gB|GB|t|T|tB|TB)$/
      {  fail("size error
      SIZE SYNTAX
      ===========
      - If size is an int, it represents a number of bytes.
      - If size is a string, the following units can be used:
      - B or no unit present for bytes
      - k, K, kB, KB for kB (kilobytes)
      - m, M, mB, MB for MB (megabytes)
      - g, G, gB, GB for GB (gigabytes)
      - t, T, tB, TB for TB (terabytes)
      ")
      }
          exec { "createramdisk_$name":
            command     => "targetcli backstores/ramdisk/ create name=$name nullio=$nullio size=$size",
            unless      => "targetcli backstores/ramdisk/$name",
            path        => $path,
            notify      => Exec['save'],
            require     => Package['targetcli'],
          }
     }
  }

}
