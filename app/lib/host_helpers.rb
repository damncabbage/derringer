module HostHelpers

  def self.my_first_non_loopback_ipv4
    addr = Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}
    addr.ip_address if addr
  end

  def self.hostname
    `hostname`.strip
  end

  def self.id
    ip   = my_first_non_loopback_ipv4
    host = hostname
    id = "#{host}"
    id << " (#{ip})" unless ip.blank?
    id
  end

end
