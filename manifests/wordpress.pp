class profile::wordpress (
  $site_name               = $::fqdn,
  $wordpress_port          = '80',
  $wordpress_user_password = 'wordpress',
  $wordpress_user_name     = 'wordpress',
  $wordpress_group_name    = 'wordpress',
  $wordpress_user_home     = '/var/www/wordpress',
  $mysql_root_password     = 'password',
  $wordpress_db_host       = 'wordpress',
  $wordpress_db_name       = 'wordpress',
  $wordpress_db_user       = 'wordpress',
  $wordpress_db_password   = 'wordpress',
) {
  ## Create user
  group { 'wordpress':
    ensure => present,
    name   => $wordpress_group_name,
  }

  user { 'wordpress':
    ensure   => present,
    name     => $wordpress_user_name,
    gid      => $wordpress_group_name,
    password => $wordpress_user_password,
    home     => $wordpress_user_home,
  }

  ## Configure mysql
  class { 'mysql::server':
    root_password => $wordpress_root_password,
  }

  class { 'mysql::bindings':
    php_enable => true,
  }

  ## Configure apache
  ## NOTE: If you create a profile for Apache, please include it
  ##       here instead of directly including the apache classes.
  include apache
  include apache::mod::php
  apache::vhost { $::fqdn:
    port    => $wordpress_port,
    docroot => $wordpress_user_home,
  }

  ## Configure wordpress
  class { '::wordpress':
    install_dir => $wordpress_user_home,
    db_name     => $wordpress_db_name,
    db_host     => $wordpress_db_host,
    db_user     => $wordpress_db_user,
    db_password => $wordpress_db_password,
  }
}
