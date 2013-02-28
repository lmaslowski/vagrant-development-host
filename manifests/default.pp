# Basic Puppet Apache manifest

class lamp {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update'
  }

  Package { ensure => "installed" }

  package { "apache2": }
  package { "apache2.2-common": } 
  package { "mysql-server": }
  package { "php5-mysql": } 
  package { "php5-xdebug": }
  package { "php5-intl": }

  service { "apache2":
    ensure => running,
    enable => true,
    require => Package["apache2"],
  }

  service { "mysql":
    ensure => "running",
    enable => "true",
    require => Package["mysql-server"],
  }

}

class php54 {
    package { 
	"php5": ensure => installed,
    }
}

class git {
    package {
        "git": ensure => installed,
    }
}

class xdebug::debian {

   include xdebug::params
    
    package { "xdebug":
        name   => $xdebug::params::pkg,
        ensure => installed,
        require => Class['php54'],
    }

}

include lamp
include php54
include git
