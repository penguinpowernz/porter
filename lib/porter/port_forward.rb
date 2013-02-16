module Porter
  class PortForward

    def initialize(red_port, green_host, green_port)
      @red_port = red_port
      @green_host = green_host
      @green_port = green_port.sub("u","") # remove u just incase
    end

    def rules
      @protocol = @red_port.start_with?("u") ? "udp" : "tcp"
      @red_port.sub!("u","")

      [
        "PREROUTING -t nat -i #{Porter.interfaces(:red)} -p #{@protocol} --dport #{@red_port} -j DNAT --to #{@green_host}:#{@green_port}",
        "INPUT -p #{@protocol} -m state --state NEW --dport #{@red_port} -i #{Porter.interfaces(:red)} -j ACCEPT",
        "FORWARD -p tcp -d #{@green_host} --dport #{@green_port} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT",
        "POSTROUTING -p #{@protocol} -m #{@protocol} -s #{@green_host} --sport #{@green_port} -o #{Porter.interfaces(:red)} -j SNAT",
        "OUTPUT -p #{protocol} -s #{@green_host} --sport #{@green_port} -o #{Porter.interfaces(:red)} -j ACCEPT"
      ]
    end

    def enable(iptables)
      rules.each {|rule| iptables.add rule }
    end

    def disable(iptables)
      rules.each {|rule| iptables.delete rule }
    end

    def self.build(line)
      self.new *line.split(" ")
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
