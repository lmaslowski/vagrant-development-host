exec { 'apt-get update':
  command => '/usr/bin/apt-get update'
}

Package { ensure => "installed" }

package { "varnish": }
package { "git": }
package { "sqlite": }
package { 'memcached': }
package { 'curl': }
package { 'mc': }
package { 'htop': }
package { 'screen': }
package { 'rabbitmq-server': }
file { "/home/capifony":
    ensure => "directory",
    owner  => "vagrant",
    group  => "vagrant",
}
  
nginx::vhost { 'local.sparwelt.de':
    framework => 'symfony2'
}

file {  "/etc/nginx/sites-enabled/default":
  ensure => absent,
  notify  => Exec['reload_nginx'],
} 

nginx::vhost { 'local.example.com':
    framework => 'symfony2',
}

nginx::vhost { 'local.example2.com':
    framework => 'symfony2'
}

nginx::vhost { 'local.example3.com':
    framework => 'zf2'
}

#nginx::vhost { 'local.remind-about.com':
#    framework => 'zf2'
#}

include vim
include mysql
include php
include locale
include nginx
include mongodb
include redis-server
include acl
include elasticsearch 
include update-sun-jre

#TODO: configure nagios
# apt-get install nagios3 nginx fcgiwrap

exec {
  'reload_nginx':
  command     => '/usr/sbin/service nginx reload',
  refreshonly => true,
  require => Service['nginx']
}

Exec["apt-get update"] -> Package <| |>

group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }
file { '/etc/motd':
   content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet.\n"
}

