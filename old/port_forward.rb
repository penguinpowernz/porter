#!/usr/bin/ruby

def usage
  <<-eou
Usage: port-forward <port> <remote host> <remote port>
       port-forward <action> [options]
  eou
end

case
when Integer.is_numeric? ARGV[1] || ARGV[1].include? ":"
  port, remote_host, remote_port = *ARGV

  pf = PortForward.new( local_port, remote_host, remote_port, 1 )
  PortForwarder.forward pf
when String.is_string? ARGV[1]
  action, options = *ARGV
else
  raise ArgumentError
end

case action
when "list"

when ""
end

class IpTables
  const IPTABLES = "/sbin/iptables"

  def add_rule(args)
    system "#{IPTABLES} #{args}"
  end

  def list
    `#{IPTABLES} -L --numeric-ports`
  end

end

class PortForwarder < IpTables

  def self.forward(port_forwards)
    PortForwarder.new.forward port_forwards
  end

  def forward(port_forwards)
    port_forwards = make_array port_forwards

    port_forwards.each do |pf|
      next unless pf.enabled?

      rules = generate_rules pf

      rules.each do |rule|
        add_rule( rule )
      end
    end
  end

  def unforward(port_forwards)

  end

  def generate_rules(pf)
    [
      "-A PREROUTING -t nat -i eth1 -p tcp --dport #{pf.local_port} -j DNAT --to #{pf.remote_host}:#{pf.remote_port}",
      "-A PREROUTING -t nat -i eth1 -p udp --dport #{pf.local_port} -j DNAT --to #{pf.remote_host}:#{pf.remote_port}",
      "-A INPUT -p tcp -m state --state NEW --dport #{pf.local_port} -i eth1 -j ACCEPT"
    ]
  end

  def make_array(object)

    queue = Array.new
    
    case object.class.name 
    when "PortForward"
      queue << object
    when "Array"
      queue = queue + object
    else
      raise StandardError, "Incorrect argument type"
    end

    queue
  end

end

class PortForward

  def initialize(local_port, remote_host, remote_port, enabled)
    @local_port => local_port
    @remote_host => remote_host
    @remote_port => remote_port
    @enabled => enabled
  end

  def self.build(line)
    self.new *line.split(" ")
  end

  def enabled?
    @enabled == 1
  end

  def remote_host
    @remote_host
  end

  def remote_port
    @remote_port
  end

  def local_port
    @local_port
  end

  def self.all
    
    port_forwards = Array.new

    File.read("db.txt").each_line do |line|
      port_forwards << self.build line
    end

    port_forwards
  end

end