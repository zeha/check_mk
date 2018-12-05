# Need to require => Class['::check_mk::agent']
define check_mk::mrpe (
  String $command
) {
  concat::fragment { "check_mk_mrpe_cfg_${name}":
    target  => $::check_mk::agent::mrpe_cfg,
    content => "${name}\t${command}\n",
    order   => '01',
  }
}
