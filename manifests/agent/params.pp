class check_mk::agent::params {
  if ($::kernel == 'Linux') {
    $configdir = '/etc/check_mk'
    $plugindir = '/usr/lib/check_mk_agent/local'
    $mrpe_cfg  = "${configdir}/mrpe.cfg"
  }
  if ($::kernel == 'Windows') {
    $installpath = 'C:/Program Files (x86)/Check_MK/'
    $configdir = $installpath
    $plugindir = "${installpath}/plugins/"
    $mrpe_cfg  = "${configdir}/mrpe.cfg"
  }
}
