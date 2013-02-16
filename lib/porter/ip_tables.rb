module Porter
  class IpTablesRuleError < StandardError; end
  class IpTables
    def run(rule)
      output = `/sbin/iptables #{rule}`
      raise IpTablesRuleError, output if $?.exitstatus != 0
    end
    
    def delete(rule)
      run("-D #{rule}")
    end
    
    def add(rule)
      run("-A #{rule}")
    end
  end
end
