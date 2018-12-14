class read_data {
  $my_hiera_data = hiera('my_configuration')
  notify { "$my_hiera_data": }
}

include ::read_data
