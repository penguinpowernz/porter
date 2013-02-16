require 'porter/port_forward'
require 'porter/ip_tables'

module Porter
  class << self
  	def enable(local_port, remote_host, remote_port)
      Porter::PortForward.new(
      	local_port, 
      	remote_host, 
      	remote_port
      ).enable Porter::IpTables
  	end

  	def disable(local_port)

  	end

  	def list
	  puts "Local Port\tRemote Host\tRemote Port"
	  Porter::PortForward.all.each do |pf|
	  	puts "#{pf.local_port}\t#{pf.remote_host}\t#{remote_port}"
	  end
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