module XAS
	class ModuleManager
		attr_reader :modules
		
		def initialize
			@modules = {}
		end
		
		def load(name)
			@modules[name] = Modules.const_get(name.to_s.camelcase)
			@modules[name].initialize! Environment.config.get(name)
		end
		
		def loaded?(name)
			!@modules[name].nil?
		end
	end
	
	module Modules
	end
end