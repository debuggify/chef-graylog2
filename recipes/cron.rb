#
# Cookbook Name:: graylog2
# Recipe:: web_interface
#
# Copyright 2011, dkd Internet Service GmbH
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

include_recipe "graylog2::web_interface"

# Stream message rake tasks
cron "Graylog2 send stream alarms" do
  minute node["graylog2"]["stream_alarms_cron_minute"]
  action node["graylog2"]["send_stream_alarms"] ? :create : :delete
  command "cd #{node["graylog2"]["basedir"]}/web && RAILS_ENV=production bundle exec rake streamalarms:send"
end

cron "Graylog2 send stream subscriptions" do
  minute node["graylog2"]["stream_subscriptions_cron_minute"]
  action node["graylog2"]["send_stream_subscriptions"] ? :create : :delete
  command "cd #{node["graylog2"]["basedir"]}/web && RAILS_ENV=production bundle exec rake subscriptions:send"
end