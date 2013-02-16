require 'porter/port_forward'
require 'porter/ip_tables'

module Porter
  class << self
  
    def prepare(red, green)
    
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
    
    def list
      puts "Red Port\tGreen Host\tGreen Port"
      Porter::PortForward.all.each do |pf|
        puts "#{pf.red_port}\t#{pf.green_host}\t#{pf.green_port}"
      end
    end
    
    def interfaces
    
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
