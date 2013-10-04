# Basic Puppet PHP manifest

class php {

  Package { ensure => "installed" }

  package { 'php-apc': }
  package { "php5-cli": }
  package { "php5-curl": }
  package { 'php5-fpm': }
  package { "php5-gd": }
  package { 'php5-imagick': }
  package { "php5-intl": }
  package { 'php5-mcrypt': }
  package { 'php5-memcached': }
  package { 'php5-mongo': }
  package { "php5-mysql": } 
  package { 'php5-sqlite': }
  package { "php5-xdebug": }
  package { "php5-memcache": }

  service { 'php5-fpm':
    ensure     => running,
    enable     => true,
    require => Package['php5-fpm'],
  }  

  file { "/etc/php5/fpm/php.ini":
    source => 'puppet:///modules/php/php.ini',
  }

  file { "/etc/php5/fpm/pool.d/www.conf":
    source => 'puppet:///modules/php/www.conf',
    require => Service['php5-fpm']
  }

  exec { 'reload_php5-fpm':
    command     => '/usr/sbin/service php5-fpm reload',
    require => Service['php5-fpm']
  }
  
  Package <| |> -> File["/etc/php5/fpm/php.ini"] -> Exec['reload_php5-fpm']
}
