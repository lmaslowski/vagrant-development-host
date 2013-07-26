# Basic Puppet vim  manifest

class vim {

  Package { ensure => "installed" }

  package { 'git': }
  
  file { "/home/vagrant/.gitignore":
    source => 'puppet:///modules/git/gitignore',
  }

  file { "/home/vagrant/.gitconfig":
    source => 'puppet:///modules/git/gitconfig',
  }
}
