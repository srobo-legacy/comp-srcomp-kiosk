class srcomp-kiosk {

  $opt_kioskdir = '/opt/srcomp-kiosk'
  $etc_kioskdir = '/etc/srcomp-kiosk'
  $kiosk_log    = '/var/log/srcomp-kiosk.log'
  $user         = 'pi'
  $user_home    = "/home/${user}"
  $user_config  = "${user_home}/.config"
  $user_ssh     = "${user_home}/.ssh"
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

  # Config
  file { $etc_kioskdir:
    ensure => directory,
  }

  file { "${etc_kioskdir}/config.yaml":
    ensure  => file,
    content => "url: '${url}'",
    require => File[$etc_kioskdir],
  }

  # User config
  file { $user_home:
    ensure  => directory,
  }

  # Easy logins
  file { $user_ssh:
    ensure  => directory,
    mode    => '0700',
  }

  file { "${user_ssh}/authorized_keys":
    ensure  => file,
    mode    => '0600',
    # TODO: Put in hiera?
    source  => 'puppet:///modules/srcomp-kiosk/pi-authorized_keys',
    require => File[$user_ssh],
  }

  # Autostart
  file { $user_config:
    ensure  => directory,
    require => File[$user_home],
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

  file { $kiosk_log:
    ensure  => file,
  }

  $kiosk_runner = '/usr/local/bin/srcomp-kiosk'
  $kiosk_script = "${opt_kioskdir}/kiosk.py"
  file { $kiosk_runner:
    ensure  => link,
    target  => $kiosk_script,
    mode    => '0755',
    require => [File[$kiosk_script],
                File[$kiosk_log],
                File["${etc_kioskdir}/config.yaml"],
                File["${opt_kioskdir}/firefox-profile"]],
  }

  file { $opt_kioskdir:
    ensure  => directory,
  }

  file { $kiosk_script:
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

  exec { 'Start kiosk':
    environment => ["DISPLAY=:0.0"],
    command     => "${kiosk_runner} &",
    user        => $user,
    group       => $user,
    unless      => "/bin/ps aux | /bin/grep -v grep | /bin/grep 'python3 ${kiosk_script}'",
    require     => File[$kiosk_runner],
  }
}
