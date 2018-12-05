define check_mk::plugin (
  $ensure='',
  $source=undef,
) {
  file { "${::check_mk::agent::plugindir}/${name}":
    ensure  => $ensure,
    mode    => '0755',
    source  => $source,
    require => Class['::check_mk::agent'],
  }
}
