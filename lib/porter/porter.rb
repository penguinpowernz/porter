require 'porter/port_forward'
require 'porter/ip_tables'

module Porter
  class << self
  
    def prepare(red, green)
      
      # Turn on forwarding in the kernel
      system "/sbin/sysctl net.ipv4.ip_forward=1"
      
      # Allow forwarding over the given interfaces
      [red]+green.split(",").each do |if|
        if File.exist? "/proc/sys/net/ipv4/conf/#{if}/forwarding"
          system "echo 1 > /proc/sys/net/ipv4/conf/#{if}/forwarding"
        end
      end
      
      # TODO: Save settings to config file
      Porter.interfaces("red", red)
      Porter.interfaces("green", green)
    end
    
    def add(red_port, green_host, green_port)
      Porter::PortForward.new(
        red_port, 
        green_host, 
        green_port
      ).enable( Porter::IpTables )
    end
    
    def delete(red_port)
      Porter::PortForward.find( red_port ).disable( Porter::IpTables )
    end
    
    def print_forwards
      puts "Red Port\tGreen Host\tGreen Port"
      Porter::PortForward.all.each do |pf|
        puts "#{pf.red_port}\t#{pf.green_host}\t#{pf.green_port}"
      end
    end
    
    def print_interfaces
      puts "Red interface: #{Porter.interfaces('red')}"
      puts "Green interface: #{Porter.interfaces('green')}"
    end
    
    def disable_all
      Porter::PortForward.all.each do |pf|
        pf.disable Porter::IpTables
      end
    end
    
    def enable_all
      Porter::PortForward.all.each do |pf|
        pf.enable Porter::IpTables
      end
    end
  end
end
