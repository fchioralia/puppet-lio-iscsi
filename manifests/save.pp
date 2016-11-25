class lio-iscsi::save
{

include lio-iscsi

  exec { "save":
    command     => "targetctl save",
    path        => $path,
    refreshonly => true,
    require     => Package['targetcli'],
  }

}
