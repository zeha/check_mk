class check_mk::agent::config (
  Array[String] $ip_whitelist,
  Integer       $port,
  String        $server_dir,
  Boolean       $use_cache,
  String        $user,
  String        $configdir = $::check_mk::agent::configdir,
  String        $plugindir = $::check_mk::agent::plugindir,
  String        $mrpe_cfg  = $::check_mk::agent::mrpe_cfg,
) {

  if $ip_whitelist != [] {
    $only_from = join($ip_whitelist, ' ')
  } else {
    $only_from = undef
  }

  if ($::kernel == 'Linux') {
    if $use_cache {
      $server = "${server_dir}/check_mk_caching_agent"
    } else {
      $server = "${server_dir}/check_mk_agent"
    }

    file { '/etc/xinetd.d/check_mk_agent':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => template('check_mk/agent/check_mk.erb'),
      require => Package['check-mk-agent'],
    }
    file {
      [
        '/etc/xinetd.d/check-mk-agent',
        '/etc/xinetd.d/check-mk-agent.rpmsave',
        '/etc/xinetd.d/check_mk',
        '/etc/xinetd.d/check_mk.dpkg-dist',
        '/etc/xinetd.d/check_mk.rpmsave',
      ]:
      ensure => absent,
    }

    # some of our plugins use this.
    file { '/var/cache/check_mk':
      ensure => directory,
      mode   => '0755',
    }

    file { '/usr/lib/check_mk_agent/plugins/apt':
      ensure => absent,
    }
    check_mk::plugin { 'apt':
      ensure => present,
      source => 'puppet:///modules/check_mk/plugins.linux/apt',
    }
    package { 'python-apt':
      ensure => installed,
    }

    file { '/etc/check_mk/logwatch.d':
      ensure  => directory,
      purge   => true,
      recurse => true,
    }
    file { "${configdir}/logwatch.cfg":
      ensure  => present,
      mode    => '0755',
      source  => 'puppet:///modules/check_mk/plugins.linux/logwatch.cfg',
      require => Class['::check_mk::agent'],
    }

    file { $plugindir:
      ensure  => directory,
      recurse => true,
      purge   => true,
    }
    file { "${plugindir}/mk_logins":
      ensure  => present,
      mode    => '0755',
      source  => 'puppet:///modules/check_mk/plugins.linux/mk_logins',
      require => Class['::check_mk::agent'],
    }
    file { "${plugindir}/exim4_mailq":
      ensure  => present,
      mode    => '0755',
      source  => 'puppet:///modules/check_mk/plugins.linux/exim4_mailq',
      require => Class['::check_mk::agent'],
    }

    concat { $mrpe_cfg:
      ensure => 'present',
      mode   => '0600',
    }
  }

  if ($::kernel == 'Windows') {
    file { "${configdir}/check_mk.ini":
      source => 'puppet:///modules/check_mk/check_mk.ini',
    }
    ~> service { 'Check_MK_Agent':
      ensure => running,
    }
    file { $plugindir:
      ensure => directory,
    }

    file { "${plugindir}/msexch_dag.ps1":
      ensure => present,
      source => 'puppet:///modules/check_mk/plugins.windows/msexch_dag.ps1',
    }
    file { "${plugindir}/msexch_database.ps1":
      ensure => absent,
      source => 'puppet:///modules/check_mk/plugins.windows/msexch_database.ps1',
    }
    file { "${plugindir}/windows_updates.vbs":
      ensure => absent,
      source => 'puppet:///modules/check_mk/plugins.windows/windows_updates.vbs',
    }
    file { "${plugindir}/windows_updates.ps1":
      ensure => absent,
    }
    file { "${plugindir}/windows_time.bat":
      ensure => present,
      source => 'puppet:///modules/check_mk/plugins.windows/windows_time.bat',
    }
  }
}
