# encoding: UTF-8
=begin

BETTERCAP

Author : Simone 'evilsocket' Margaritelli
Email  : evilsocket@gmail.com
Blog   : http://www.evilsocket.net/

This project is released under the GPL 3 license.

=end

module BetterCap
module Firewalls
# IPFW Firewall class.
class IPFW < Base
  # If +enabled+ is true will enable packet forwarding, otherwise it will
  # disable it.
  def enable_forwarding(enabled)
    Shell.execute("sysctl -w net.inet.ip.forwarding=#{enabled ? 1 : 0}")
  end

  # If +enabled+ is true will enable packet icmp_echo_ignore_broadcasts, otherwise it will
  # disable it.
  def enable_icmp_bcast(enabled)
    Shell.execute("sysctl -w net.inet.icmp.bmcastecho=#{enabled ? 1 : 0}")
  end

  # Return true if packet forwarding is currently enabled, otherwise false.
  def forwarding_enabled?
    Shell.execute('sysctl net.inet.ip.forwarding').strip.split(' ')[1] == '1'
  end

  # This method is ignored on FreeBSD.
  def enable_send_redirects(enabled); end

  # If +enabled+ is true, the IPFW firewall will be enabled, otherwise it will
  # be disabled.
  #def enable(enabled)
  #  begin
  #    Shell.execute("ipfw #{enabled ? 'enable' : 'disable'} firewall >/dev/null 2>&1")
  #  rescue; end
  #end

  # Apply the +r+ BetterCap::Firewalls::Redirection port redirection object.
  def add_port_redirection( r )
    # load the rule
    Shell.execute("ipfw add 13 fwd #{r.dst_address},#{r.dst_port} #{r.protocol} from any to #{r.src_address.nil? ? 'any' : r.src_address} #{r.src_port} via #{r.interface} >/dev/null 2>&1")
    # enable ipfw
    #enable true
  end

  # Remove the +r+ BetterCap::Firewalls::Redirection port redirection object.
  def del_port_redirection( r )
    # FIXME: The rule number (13) should not be hardcoded (there may be other
    # rules with this number that we don't want to delete.
    Shell.execute("ipfw -q delete 13")

    # disable ipfw
    #enable false
  end
end
end
end
