require 'porter/port_forward'

module Porter
  class << self
  	def enable(local_port, remote_host, remote_port)

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

  	end

  	def enable_all
  		
  	end
  end
end