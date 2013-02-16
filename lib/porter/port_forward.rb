module Porter
  class PortForward

    attr_reader :local_port, :remote_host, :remote_port

    def initialize(local_port, remote_host, remote_port)
      @local_port = local_port
      @remote_host = remote_host
      @remote_port = remote_port
    end

    def self.build(line)
      self.new *line.split(" ")
    end

    def enable(iptables)
      rules = [
        "-A PREROUTING -t nat -i eth1 -p tcp --dport #{@local_port} -j DNAT --to #{@remote_host}:#{@remote_port}",
        "-A PREROUTING -t nat -i eth1 -p udp --dport #{@local_port} -j DNAT --to #{@remote_host}:#{@remote_port}",
        "-A INPUT -p tcp -m state --state NEW --dport #{@local_port} -i eth1 -j ACCEPT"
      ]

      rules.each do |rule|
        iptables.run rule
      end
    end

    def disable

    end

    def self.all
      
      port_forwards = Array.new

      File.read(Porter.store).each_line do |line|
        port_forwards << self.build line
      end

      port_forwards
    end

  end
end