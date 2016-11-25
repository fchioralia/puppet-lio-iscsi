define lio-iscsi::targetcli::createtpg(
    $tpg         = undef,
    $target_name = undef,
    $tpg_luns    = undef,
    $tpg_acls    = undef,
    $tpg_portals = ["0.0.0.0:3260"],
)
{

  validate_string($tpg)
  validate_string($target_name)
  validate_array($tpg_luns)
  validate_array($tpg_portals)
  validate_array($tpg_acls)

include ::lio-iscsi

  exec { "createtpg_$target_name_$title":
    command     => "targetcli iscsi/${target_name} create ${tpg}",
    unless      => "targetcli iscsi/${target_name}/${tpg}",
    path        => $path,
    notify      => Exec['save'],
    require     => Package['targetcli'],
  }->

  #alocate luns
  lio-iscsi::targetcli::tpg::luns{ $tpg_luns:
    target_name   => $target_name,
    tpg           => $tpg,
  }

  #alocate portals
  lio-iscsi::targetcli::tpg::portals{ $tpg_portals:
    target_name   => $target_name,
    tpg           => $tpg,
  }

  #alocate acls
  lio-iscsi::targetcli::tpg::acls{ $tpg_acls:
    target_name   => $target_name,
    tpg           => $tpg,
  }

}
