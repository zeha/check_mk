class check_mk::agent (
  Array[String] $host_tags    = [],
  Array[String] $ip_whitelist = [],
  Integer       $port         = 6556,
  String        $server_dir   = '/usr/bin',
  Boolean       $use_cache    = false,
  String        $user         = 'root',
  String        $configdir    = $::check_mk::agent::params::configdir,
  String        $plugindir    = $::check_mk::agent::params::plugindir,
  String        $mrpe_cfg     = $::check_mk::agent::params::mrpe_cfg,
) inherits check_mk::agent::params {
  class { 'check_mk::agent::install':
  }
  class { 'check_mk::agent::config':
    ip_whitelist => $ip_whitelist,
    port         => $port,
    server_dir   => $server_dir,
    use_cache    => $use_cache,
    user         => $user,
    require      => Class['check_mk::agent::install'],
  }
}
