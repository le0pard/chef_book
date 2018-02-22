current_dir = File.dirname(__FILE__)

log_level                :info
log_location             STDOUT
node_name                'leo'
client_key               "#{current_dir}/leo.pem"
syntax_check_cache_path  "#{current_dir}/syntax_check_cache"
validation_client_name   "chef-validator"
validation_key           "#{current_dir}/chef-validator.pem"
chef_server_url          "https://10.33.33.33"
cookbook_path            ["#{current_dir}/../cookbooks", "#{current_dir}/../site-cookbooks"]
node_path                 "#{current_dir}/../nodes"
role_path                 "#{current_dir}/../roles"
data_bag_path             "#{current_dir}/../data_bags"
environment_path          "#{current_dir}/../environments"
#encrypted_data_bag_secret "data_bag_key"

knife[:berkshelf_path] = "cookbooks"