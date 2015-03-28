package { "iceweasel":
  ensure => installed,
}

package { "unclutter":
  ensure => installed,
}

file { "/etc/srcomp-kiosk/config.yaml"
  ensure => file,
  content => "url: '${hiera('url')}'",
}

file { "/home/pi/.config/autostart/kiosk.desktop"
  ensure => link,
  target => /home/pi/srcomp-kiosk/kiosk.desktop,
  owner => "pi"
}
