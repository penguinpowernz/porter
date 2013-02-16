module Porter
  class PortNotForwardedError < StandardError; end
  class PortForward

    def initialize(red_port, green_host, green_port)
      @red_port = red_port
      @green_host = green_host
      @green_port = green_port.sub("u","") # remove u just incase
    end

    def rules
      @protocol = @red_port.start_with?("u") ? "udp" : "tcp"
      red_port = @red_port.sub("u","")

      [
        "PREROUTING -t nat -i #{Porter.interfaces(:red)} -p #{@protocol} --dport #{red_port} -j DNAT --to #{@green_host}:#{@green_port}",
        "INPUT -p #{@protocol} -m state --state NEW --dport #{red_port} -i #{Porter.interfaces(:red)} -j ACCEPT",
        "FORWARD -p tcp -d #{@green_host} --dport #{@green_port} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT",
        "POSTROUTING -p #{@protocol} -m #{@protocol} -s #{@green_host} --sport #{@green_port} -o #{Porter.interfaces(:red)} -j SNAT",
        "OUTPUT -p #{@protocol} -s #{@green_host} --sport #{@green_port} -o #{Porter.interfaces(:red)} -j ACCEPT"
      ]
    end

    def enable(iptables)
      rules.each {|rule| iptables.add rule }
      
      # add this forward to the store
      File.open(Porter.store, "a") {|f|
        f.puts [@red_port, @green_host, @green_port].join(" ")
      }
    end

    def disable(iptables)
      rules.each {|rule| iptables.delete rule }
      
      # Remove the line for this red_port and save the file
      store = File.read(Porter.store).lines.reject{ |line| 
        line.start_with?(@red_port)
      }.join '\n'
      File.open(Porter.store, "w") {|f| f.puts store }
    end

    def self.build(line)
      self.new *line.split(" ")
    end

    def self.find(red_port)
      line = `grep -P "^#{red_port}" #{Porter.store}`.chomp
      raise PortNotForwardedError if $?.exitstatus != 0
      self.build line
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
