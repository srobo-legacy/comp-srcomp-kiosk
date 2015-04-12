class srcomp-kiosk {

  $opt_kioskdir = '/opt/srcomp-kiosk'
  $etc_kioskdir = '/etc/srcomp-kiosk'
  $user         = 'pi'
  $user_config  = "/home/${user}/.config"
  $url          = hiera('url')

  package { ["iceweasel"
            ,"unclutter"
            ,"python3-yaml"
            ,"x11-xserver-utils"
            ]:
    ensure => installed,
  }

  File {
    owner   => $user,
    group   => $user,
  }

  file { $etc_kioskdir:
    ensure => directory,
  }

  file { "${etc_kioskdir}/config.yaml":
    ensure  => file,
    content => "url: '${url}'",
    require => File[$etc_kioskdir],
  }

  file { $user_config:
    ensure  => directory,
  }

  $autostart_dir = "${user_config}/autostart"
  file { $autostart_dir:
    ensure  => directory,
    require => File[$user_config],
  }

  file { "${autostart_dir}/kiosk.desktop":
    ensure  => file,
    content => template('srcomp-kiosk/kiosk.desktop.erb'),
    require => File[$autostart_dir],
  }

  file { '/usr/local/bin/srcomp-kiosk':
    ensure  => file,
    content => template('srcomp-kiosk/srcomp-kiosk.erb'),
    mode    => '0755',
  }

  file { $opt_kioskdir:
    ensure  => directory,
  }

  file { "${opt_kioskdir}/kiosk.py":
    ensure  => file,
    source  => 'puppet:///modules/srcomp-kiosk/kiosk.py',
    mode    => '0755',
    require => File[$opt_kioskdir],
  }

  file { "${opt_kioskdir}/firefox-profile":
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/srcomp-kiosk/firefox-profile',
    mode    => '0755',
    require => File[$opt_kioskdir],
  }
}
