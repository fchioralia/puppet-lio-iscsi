define lio-iscsi::targetcli::tpg::portals(
    $tpg         = undef,
    $target_name = undef,
)
{
  include ::lio-iscsi

  $portal_parts     = split($title, ':')
  $portal_ip        = "${portal_parts[0]}"
  $portal_port      = "${portal_parts[1]}"
          
          
  exec { "createtpg_${target_name}_${tpg}_${title}":
    command     => "targetcli iscsi/${target_name}/${tpg}/portals create ${portal_ip} ${portal_port}",
    unless      => "targetcli iscsi/${target_name}/${tpg}/portals ls|grep ${title}",
    path        => $path,
    notify      => Exec['save'],
    require     => Package['targetcli'],
  }
}
