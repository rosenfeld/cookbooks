#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

if platform?("redhat","centos","debian","ubuntu")
  include_recipe "iptables"
end

users = nil

if Chef::Config.solo
  if node[:samba]["shares"].nil?
    shares = { "shares" => Hash.new }
  else
    shares = node[:samba]
  end
else
  shares = data_bag_item("samba", "shares")
end

shares["shares"].each do |k,v|
  if v.has_key?("path")
    directory v["path"] do
      recursive true
    end
  end
end

unless node["samba"]["passdb_backend"] =~ /^ldapsam/
  unless Chef::Config.solo
    users = search("users", "*:*")
  end
end

package value_for_platform(
  ["ubuntu", "debian", "arch"] => { "default" => "samba" },
  ["redhat", "centos", "fedora"] => { "default" => "samba3x" },
  "default" => "samba"
)

svcs = value_for_platform(
  ["ubuntu", "debian"] => { "default" => ["smbd", "nmdb"] },
  ["redhat", "centos", "fedora"] => { "default" => ["smb", "nmb"] },
  "arch" => { "default" => [ "samba" ] },
  "default" => ["smbd", "nmdb"]
)

svcs.each do |s|
  service s do
    pattern "smbd|nmbd" if node["platform"] =~ /^arch$/

    if (platform?("ubuntu") && node.platform_version.to_f >= 10.10)
      provider Chef::Provider::Service::Upstart
      supports :status => true, :restart => true, :reload => true
      action :nothing
    else
      action [:enable, :start]
    end
  end
end

template node["samba"]["config"] do
  source "smb.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :shares => shares["shares"]
  notifies :restart, resources(:service => svcs)
end

if users
  users.each do |u|
    samba_user u["id"] do
      password u["smbpasswd"]
      action [:create, :enable]
    end
  end
end

if platform?("redhat","centos","debian","ubuntu")
  iptables_rule "port_samba" do
    if node[:samba][:iptables_allow] == "disable"
      enable false
    else
      enable true
    end
  end
end
