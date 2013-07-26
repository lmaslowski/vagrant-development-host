# Basic Puppet vim  manifest

class vim {

  Package { ensure => "installed" }

  package { 'vim': }
  
  file { "/home/vagrant/.vimrc":
    source => 'puppet:///modules/vim/vimrc',
  }

}
