if Chef::Config.solo
  default[:users][:sysadmins] = Array.new
end
