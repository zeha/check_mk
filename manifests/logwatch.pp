define check_mk::logwatch (
  $logfile      = undef,
  $patterns     = [],
) {
  file { "/etc/check_mk/logwatch.d/${name}.cfg":
    content => inline_template("<%=[@logfile].flatten.join(' ')%>\n <%=@patterns.join(\"\n \")%>\n"),
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
  }
}
