#
# Cookbook Name:: graylog2
# Recipe:: nginx
#
# Copyright 2011, dkd Internet Service GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install Graylog2 web interface
include_recipe "graylog2::web_interface"

# Install Nginx using the OpsCode community cookbook
include_recipe "nginx"

# Install apache mod-passenger (NOTE: This should be added to base apache2 cookbook, but keeping it
#    here allows the use of the 'vanilla' Opscode apache2 cookbook which doesn't have a mod_passenger.rb
#    recipe. This should be compatible with the above, since the Opscode cookbook uses apt to install
#    apache.
#package "libapache2-mod-passenger"

# Create an Apache vhost for the Graylog2 web interface
template "nginx-vhost-conf" do
  path "/etc/nginx/sites-available/graylog2"
  source "graylog2.apache2.erb"
  mode 0644
end

# Remove the default vhost
#apache_site "000-default" do
#  enable false
#end

# Enable the Graylog2 web interface vhost
#apache_site "graylog2"
