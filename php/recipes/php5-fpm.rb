#
# Author::  Fletcher Nichol (<fnichol@nichol.ca>)
# Based on php5-cgi
# Cookbook Name:: php
# Recipe:: php5-fpm
#
# Copyright 2010, Fletcher Nichol
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

MODULES = %w{apt curl fileinfo fpdf gd ldap memcache mysql pgsql sqlite3}

case node[:platform]
  when "centos", "redhat", "fedora", "suse", "debian"
    #placeholder modify when available
  when "ubuntu"
    if node.platform_version.to_f >= 10.10
      directory "/var/www" do
        recursive true
      end

      package "php5-fpm" do
        action :upgrade
      end
    end
end

node[:php][:modules].each do |mod|
  include_recipe "php::module_#{mod}" if MODULES.include?(mod)
end
