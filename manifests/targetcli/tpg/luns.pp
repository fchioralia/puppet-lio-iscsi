define lio-iscsi::targetcli::tpg::luns(
    $tpg         = undef,
    $target_name = undef,
)
{
  include ::lio-iscsi
  exec { "createtpg_${target_name}_${tpg}_${title}":
    command     => "targetcli iscsi/${target_name}/${tpg}/luns create /backstores/${title}",
    unless      => "targetcli iscsi/${target_name}/${tpg}/luns ls|grep ${title}",
    path        => $path,
    notify      => Exec['save'],
    require     => Package['targetcli'],
  }
}
