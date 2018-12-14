
class tomcat {
  include archive

  file { '/opt/bin':
    ensure => 'directory',
    mode   => '1777',
    owner  => 'wassim',
    group  => 'wassim',
  }

  exec { 'downloads JRE':
    command => 'wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jre-8u191-linux-x64.tar.gz',
    path    => ['/usr/bin'],
    cwd     => '/tmp',
    user    => 'wassim',
    group   => 'wassim',
    }

  archive { 'extract jre':
   path => '/tmp/jre-8u191-linux-x64.tar.gz',
    ensure       => present,
    extract      => true,
    extract_path => '/opt/bin',
    source       => '/tmp/jre-8u191-linux-x64.tar.gz',
    cleanup      => true,
    creates      => '/opt/bin/jre1.8.0_191'
  }
  


  exec { 'export path':
    environment => ['JAVA_HOME=/opt/bin/jre1.8.0_191'],
    path        => 'PATH=$JAVA_HOME/bin:$PATH',
  }

  archive { 'extract apache tomcat':
    path         => '/tmp/apache-tomcat-9.0.12.tar.gz',
    ensure       => present,
    extract      => true,
    extract_path => '/opt/bin',
    source       => 'http://mirror.ibcp.fr/pub/apache/tomcat/tomcat-9/v9.0.12/bin/apache-tomcat-9.0.12.tar.gz',
    cleanup      => true,
    creates      => '/opt/bin/apache-tomcat-9.0.12'
  }
  include tomcat::config

}

class tomcat::config {
  file { 'configure Tomcat server.xml':
    path    => '/opt/bin/apache-tomcat-9.0.12/conf/server.xml',
    owner   => 'wassim',
    group   => 'wassim',
    mode    => '0775',
    content => template('/home/wassim/Documents/workspace_puppet/puppet-tomcat-demo/modules/tomcat/templates/server.xml.erb'),
  }

  file { 'configure Tomcat tomcat-users.xml':
    path    => '/opt/bin/apache-tomcat-9.0.12/conf/tomcat-users.xml',
    owner   => 'wassim',
    group   => 'wassim',
    mode    => '0775',
    content => template('/home/wassim/Documents/workspace_puppet/puppet-tomcat-demo/modules/tomcat/templates/tomcat-users.xml.erb'),
  }

  file { 'configure setenv.sh':
    path    => '/opt/bin/apache-tomcat-9.0.12/bin/setenv.sh',
    owner   => 'wassim',
    group   => 'wassim',
    mode    => '0755',
    content => template('/home/wassim/Documents/workspace_puppet/puppet-tomcat-demo/modules/tomcat/templates/setenv.sh.erb'),
  }

  exec { 'downloads apps':
    command => 'wget http://localhost:8081/repository/webapps/com/webapps/sample/1.0/sample-1.0.war',
    path    => ['/usr/bin'],
    cwd     => '/opt/bin/apache-tomcat-9.0.12/webapps/',
    user    => 'wassim',
    group   => 'wassim',
  }

}

define tomcat::deployment ($path) {
  include tomcat
  #  notice("Establishing http://$hostname:${tomcat::tomcat_port}/$name/")
  #
  #  file { "/var/lib/tomcat6/webapps/${name}.war":
  #    owner => 'root',
  #    source => $path,
  #  }
}

