#
# Cookbook Name:: graylog2
# Recipe:: web_interface
#
# Copyright 2010, Medidata Solutions Inc.
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

# Install required APT packages
include_recipe "build-essential"
include_recipe "postfix"

# Install gem dependencies
gem_package "bundler"
gem_package "rake"

# Create the release directory
directory "#{node["graylog2"]["basedir"]}/rel" do
  mode 0755
  recursive true
end

# Download the desired version of Graylog2 web interface from GitHub
remote_file "download_web_interface" do
  path "#{node["graylog2"]["basedir"]}/rel/graylog2-web-interface-#{node["graylog2"]["web_interface"]["version"]}.tar.gz"
  source node["graylog2"]["web_interface"]["source"]
  owner "root"
  group "root"
  action :create_if_missing
end

# Unpack the desired version of Graylog2 web interface
execute "tar zxf graylog2-web-interface-#{node["graylog2"]["web_interface"]["version"]}.tar.gz" do
  cwd "#{node["graylog2"]["basedir"]}/rel"
  creates "#{node["graylog2"]["basedir"]}/rel/graylog2-web-interface-#{node["graylog2"]["web_interface"]["version"]}/build_date"
  user "root"
  group "root"
end

# Link to the desired Graylog2 web interface version
link "#{node["graylog2"]["basedir"]}/web" do
  to "#{node["graylog2"]["basedir"]}/rel/graylog2-web-interface-#{node["graylog2"]["web_interface"]["version"]}"
end

# Perform bundle install on the newly-installed Graylog2 web interface version
execute "bundle install" do
  cwd "#{node["graylog2"]["basedir"]}/web"
  action :nothing
  subscribes :run, resources(:link => "#{node["graylog2"]["basedir"]}/web"), :immediately
end

# Create mongoid.yml
template "#{node["graylog2"]["basedir"]}/web/config/mongoid.yml" do
  mode 0644
end

# Create general.yml
template "#{node["graylog2"]["basedir"]}/web/config/general.yml" do
  owner "nobody"
  group "nogroup"
  mode 0644
end

# Chown the Graylog2 directory to nobody/nogroup to allow web servers to serve it
directory "#{node['graylog2']['basedir']}/rel/graylog2-web-interface-#{node['graylog2']['web_interface']['version']}" do
  owner "nobody"
  group "nogroup"
  recursive true
  action :nothing
  notifies :run, resources(:execute => "bundle install"), :immediately
end
