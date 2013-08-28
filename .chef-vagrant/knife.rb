log_level :debug
log_location STDOUT
node_name "admin"
cache_type "BasicFile"
cache_options( :path => "./.chef-vagrant/checksums" )
cookbook_path "/vagrant/cookbooks"
client_key "/etc/chef-server/admin.pem"
validation_key "/vagrant/chef-validator.pem"
