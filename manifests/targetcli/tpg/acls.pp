define lio-iscsi::targetcli::tpg::acls(
    $tpg         = undef,
    $target_name = undef,
)
{
  include ::lio-iscsi
  if $title !~ /^iqn\.([1][9][0-9]{2}|[2][0-9]{3})-([0][1-9]|[1][0-2])\.([a-z]+)\.([a-z]+)\:(\w+)$/ and $title !~ /^naa\.[a-f0-9]{16}$/ and $title !~  /^eui\.[a-f0-9]{16}$/
  {  fail(" WWN not valid as: iqn (iqn.2016-11.net.domain:t1), naa (naa.50014057f822d991), eui (eui.50014057f822d991)") }

  exec { "createtpg_${target_name}_${tpg}_${title}":
    command     => "targetcli iscsi/${target_name}/${tpg}/acls create ${title}",
    unless      => "targetcli iscsi/${target_name}/${tpg}/acls ls|grep ${title}",
    path        => $path,
    notify      => Exec['save'],
    require     => Package['targetcli'],
  }
}
