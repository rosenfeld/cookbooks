#
# Cookbook Name:: ubuntu
# Attribute File:: default
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
default[:ubuntu][:sources][:main]         = "http://us.archive.ubuntu.com/ubuntu"
default[:ubuntu][:sources][:main_src]     = ubuntu[:sources][:main]

default[:ubuntu][:sources][:updates]      = ubuntu[:sources][:main]
default[:ubuntu][:sources][:updates_src]  = ubuntu[:sources][:main]

default[:ubuntu][:sources][:security]     = "http://security.ubuntu.com/ubuntu"
default[:ubuntu][:sources][:security_src] = ubuntu[:sources][:security]