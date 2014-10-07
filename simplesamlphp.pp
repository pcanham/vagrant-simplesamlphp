node default {
  include '::ntp'
  include '::epel'

  class { 'timezone':
    timezone => 'UTC',
  }

  @package {'php-xml':
    ensure => installed,
  }
  @package {'php-mcrypt':
    ensure => installed,
  }
  @package {'php-mysql':
    ensure => installed,
  }
  @package {'php-ldap':
    ensure => installed,
  }

  realize Package[  'php-xml',
                    'php-mcrypt',
                    'php-mysql',
                    'php-ldap'
                  ]


  class { '::mysql::server':
    root_password    => 'strongpassword',
    override_options => { 'mysqld' => { 'max_connections' => '128',
                                        'bind-address' => '0.0.0.0'
                                      }
                        }
  }

  mysql::db { 'simplesaml':
    user     => 'userdb',
    password => 'secretpassword',
    host     => 'localhost',
    grant    => [ 'ALL' ],
  }

  class { 'apache':
    default_vhost => false,
  }
  class { 'apache::mod::php': }
  class { 'apache::mod::ssl': }

  apache::vhost { 'idp-saml.sandbox.internal':
    servername    => '*',
    port          => '80',
    docroot       => '/var/www/simplesamlphp/www',
    aliases => [
      { alias      => '/simplesaml',
        path       => '/var/www/simplesamlphp/www',
      },
    ],
  }

  apache::vhost { 'sp-saml.sandbox.internal':
    servername    => '*',
    port          => '80',
    docroot       => '/var/www/simplesamlphp/www',
    aliases => [
      { alias      => '/simplesaml',
        path       => '/var/www/simplesamlphp/www',
      },
    ],
  }

  $version = "1.13.0"

  staging::deploy { "simplesamlphp-${version}.tar.gz":
    source => "https://simplesamlphp.org/res/downloads/simplesamlphp-${version}.tar.gz",
    target => '/var/www',
  }

  file { '/var/www/simplesamlphp':
   ensure => 'link',
   target => "/var/www/simplesamlphp-${version}",
   require => Staging::Deploy["simplesamlphp-${version}.tar.gz"],
  }
}

