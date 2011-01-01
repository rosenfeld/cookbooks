#
# Cookbook Name:: ubuntu
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

include_recipe "apt"

template "/etc/apt/sources.list" do
  mode 0644
  notifies :run, resources(:execute => "apt-get update"), :immediately
  source "sources.list.erb"
  variables(
    :code_name    => node[:lsb][:codename],
    :main         => node[:ubuntu][:sources][:main],
    :main_src     => node[:ubuntu][:sources][:main_src],
    :updates      => node[:ubuntu][:sources][:updates],
    :updates_src  => node[:ubuntu][:sources][:updates_src],
    :security     => node[:ubuntu][:sources][:security],
    :security_src => node[:ubuntu][:sources][:security_src]
  )
end
