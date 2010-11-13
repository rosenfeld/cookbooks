maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs openssh"
version           "0.8.0"

recipe "openssh", "Installs openssh"

%w{ redhat centos fedora ubuntu debian arch}.each do |os|
  supports os
end

%w{ iptables }.each do |cb|
  depends cb
end

attribute "openssh/enable_iptables",
  :display_name => "Specifies whether iptables rules are enabled",
  :description => %{Specifies whether iptables rules are enabled. The argument must be “yes” or “no”.},
  :default => "no"

attribute "openssh/port",
  :display_name => "Specifies the port number that sshd listens on",
  :description => "Specifies the port number that sshd listens on. Multiple options of this type are permitted.",
  :type => "array",
  :default => [ "22" ]

attribute "openssh/listen_address",
  :display_name => "Specifies the local addresses sshd should listen on",
  :description => <<-DESC
    Specifies the local addresses sshd should listen on.
    The following forms may be used:

        ListenAddress host|IPv4_addr|IPv6_addr
        ListenAddress host|IPv4_addr:port
        ListenAddress [host|IPv6_addr]:port

    If port is not specified, sshd will listen on the address and all prior 
    Port options specified.  The default is to listen on all local addresses.
    Multiple ListenAddress options are permitted. Additionally, any Port 
    options must precede this option for non-port qualified addresses.
  DESC
  ,
  :type => "array",
  :default => [ "0.0.0.0" ]

attribute "openssh/permit_root_login",
  :display_name => "Specifies whether root can log in using ssh",
  :description => %{Specifies whether root can log in using ssh. The argument must be “yes”, “without-password”, “forced-commands-only”, or “no”.},
  :default => "yes"

attribute "openssh/x11_forwarding",
  :display_name => "Specifies whether X11 forwarding is permitted",
  :description => %{Specifies whether X11 forwarding is permitted. The argument must be “yes” or “no”.},
  :default => "no"

