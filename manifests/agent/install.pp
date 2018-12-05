class check_mk::agent::install (
  String $configdir = $::check_mk::agent::configdir,
  String $plugindir = $::check_mk::agent::plugindir
) {
  if ($::kernel == 'Linux') {
    include ::xinetd

    package { 'check-mk-agent':
      ensure  => present,
      require => Package['xinetd'],
    }
    package { 'check-mk-agent-logwatch':
      ensure  => present,
      require => Package['check-mk-agent'],
    }

    file { '/etc/check_mk':
      ensure => directory,
      mode   => '0755',
    }
  }
  if ($::kernel == 'Windows') {
    $filename = 'check-mk-agent-1.5.0p7-c14156cc71493a1b.msi'
    $path = "C:\\Install\\${filename}"
    file { $path:
      ensure => present,
      source => "puppet:///modules/check_mk/${filename}",
    }
    exec { "c:/windows/system32/msiexec.exe /qn /norestart /i ${path}":
      refreshonly => true,
    }
  }
}
