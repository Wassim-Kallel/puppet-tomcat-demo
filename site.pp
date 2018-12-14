node default {
  $tomcat_port = '8080'
  $tomcat_password='passw0rd$'
  $minheap_size ='128M'
  $maxheap_size='512M'
 
   tomcat::deployment { "SimpleServlet":
      path => '/home/wassim/Documents/workspace_puppet/puppet-tomcat-demo/java_src/SimpleServlet.war'
   }

   # repeat as desired for different servlets ...

}
