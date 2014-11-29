#
# Cookbook Name:: kibana
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ark "kibana" do
  url 'https://download.elasticsearch.org/kibana/kibana/kibana-3.1.1.tar.gz'
  path '/var/www/html'
  creates 'kibana'
  action :put
end

template "/etc/nginx/conf.d/virtual.conf" do
  source "virtual.conf.erb"
  mode '0644'
  owner 'root'
  group 'root'
  variables({
    :server_name => "localhost",
    :access_log => "/var/log/nginx/kibana.access.log",
    :proxy_pass => "http://127.0.0.1:9200"
  })
end

template "/var/www/html/kibana/config.js" do
  source "config.js.erb"
  variables({
    :elasticsearch => "\"http://\"+window.location.hostname+\":8888\"",
    :default_route => "/dashboard/file/default.json",
    :kibana_index => "kibana-int"
  })
end