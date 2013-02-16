require 'yaml'

module Porter

  class << self
    def store
      "/var/cache/porter/store.txt"
    end
    
    def config_file
      "/etc/porter/config.yaml"
    end
    
    # Todo: refactor all the shit under this line
    
    def config
      YAML::load_file(Porter.config_file ) if c.nil?
    end
    
    def config=(c)
      File.open(Porter.config_file, "w") {|f| f.write c.to_yaml}
    end
    
    def interfaces(type=nil, new_value=nil)
      
      raise ArgumentError if type != "green" or type != "red"
      
      if !new_value.nil?
        c = Porter.config
        c["porter"][:interfaces][type.to_sym] = new_value
        Porter.config = c
      end
      
      if type.nil?
        ifs << *Porter.config["porter"][:interfaces][:green].split(",")
        ifs << Porter.config["porter"][:interfaces][:red]
        return ifs
      end
      
      Porter.config["porter"][:interfaces][type.to_sym]
    end
  end

end
