#
# Cookbook Name:: openssh
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

packages = case node[:platform]
  when "centos","redhat","fedora"
    %w{openssh-clients openssh}
  when "arch"
    %w{openssh}
  else
    %w{openssh-client openssh-server}
  end
  
packages.each do |pkg|
  package pkg
end

service "ssh" do
  case node[:platform]
  when "centos","redhat","fedora","arch"
    service_name "sshd"
  else
    service_name "ssh"
  end
  supports value_for_platform(
    "debian" => { "default" => [ :restart, :reload, :status ] },
    "ubuntu" => {
      "8.04" => [ :restart, :reload ],
      "default" => [ :restart, :reload, :status ]
    },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "arch" => { "default" => [ :restart ] },
    "default" => { "default" => [:restart, :reload ] }
  )
  action [ :enable, :start ]
end

case node[:platform]
when "ubuntu"

  if node.platform_version.to_f >= 10.10
    template "/etc/ssh/sshd_config" do
      source "sshd_config.erb"
      owner "root"
      group "root"
      mode "0644"
      notifies :restart, "service[ssh]", :immediately
    end
  end
end

case node[:platform]
when "redhat","centos","debian","ubuntu"
  iptables_rule "port_ssh" do
    if node[:openssh][:enable_iptables] == "yes"
      enable true
    else
      enable false
    end
  end
end

