# puppet-lio-iscsi
targetcli from puppet

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations](#limitations)
4. [Contribute](#contribute)

## Overview

A module that help configure target iscsi lio service. 
Intended to deploy easy a iscsi server on RedHat Family OSs.
You can:
    * add new iscsi backstores
    * configure iscsi target names with acls, luns and portals.

Puppet dependencies (Puppet modules):
    stdlib

## Usage

First add a backstore (block, fileio, pscsi, ramdisk).

fileio example:
```
     lio-iscsi::targetcli::createbackstore{"iscsi-5g":
             name        => "iscsi-5g",
             type        => "fileio"
             size        => "5G",
             file_or_dev => "/home/5g.img"
             write_back  => "true",
             sparse      => "true",
     }
```
block example:
```
     lio-iscsi::targetcli::createbackstore{"iscsi-block":
             name        => "iscsi-block",
             type        => "block"
             file_or_dev => "/dev/sdb1",
             readonly    => "false",
     }
```
pscsi example:
```
     lio-iscsi::targetcli::createbackstore{"iscsi-pscsi":
             name        => "iscsi-pscsi",
             type        => "pscsi"
             file_or_dev => "/dev/disk/by-path/pci-0000\:00\:01.1-ata-2.1"
     }
```
ramdisk example:
```
     lio-iscsi::targetcli::createbackstore{"iscsi-ram":
             name        => "iscsi-ram",
             type        => "ramdisk"
             size        => "5G",
             nullio      => "false",
     }
```

Then create the target
```
     lio-iscsi::targetcli::createiscsitarget{"testiscsi":
            target_name => "iqn.2016-11.net.example:target1",
            tpg         => "tpg1",
            tpg_luns    => ["fileio/iscsi-5g"],
            tpg_acls    => ["iqn.2016-11.net.example:xen1","iqn.2016-11.net.example:xen2"],
            tpg_portals => ["0.0.0.0:3260"]
    }
```

## Limitations

Tested only on RedHad 7.2

## Contribute

I encourage you to contribute. Send me your pull requests on Github!