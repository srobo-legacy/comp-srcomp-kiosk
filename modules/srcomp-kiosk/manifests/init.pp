class srcomp-kiosk {

  $kioskdir = '/opt/srcomp-kiosk'

  package { ["iceweasel"
            ,"unclutter"
            ,"python3-yaml"
            ,"x11-xserver-utils"
            ]:
    ensure => installed,
  }

  file { '/etc/srcomp-kiosk':
    ensure => directory,
  }

  $url = hiera('url')

  file { '/etc/srcomp-kiosk/config.yaml':
    ensure  => file,
    content => "url: '${url}'",
  }

  file { '/home/pi/.config/autostart':
    ensure  => directory,
    owner   => 'pi',
  }

  file { '/home/pi/.config/autostart/kiosk.desktop':
    ensure  => file,
    owner   => 'pi',
    content => template('srcomp-kiosk/kiosk.desktop.erb'),
  }

  file { '/usr/local/bin/srcomp-kiosk':
    ensure  => file,
    content => template('srcomp-kiosk/srcomp-kiosk.erb'),
    mode    => '0755',
  }

  file { '/opt/srcomp-kiosk':
    ensure  => directory,
    owner   => 'pi',
  }

  file { '/opt/srcomp-kiosk/kiosk.py':
    ensure  => file,
    source  => 'puppet:///modules/srcomp-kiosk/kiosk.py',
    mode    => '0755',
    owner   => 'pi',
  }

  file { '/opt/srcomp-kiosk/firefox-profile':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/srcomp-kiosk/firefox-profile',
    mode    => '0755',
    owner   => 'pi',
  }
}
