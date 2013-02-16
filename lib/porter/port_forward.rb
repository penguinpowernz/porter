module Porter
  class PortForward

    def initialize(local_port, remote_host, remote_port)
      @local_port = local_port
      @remote_host = remote_host
      @remote_port = remote_port
    end

    def self.build(line)
      self.new *line.split(" ")
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

    def enable

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