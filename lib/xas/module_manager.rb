module XAS
	class ModuleManager
		attr_reader :modules
		
		def initialize
			@modules = {}
		end
		
		def load(name)
			raise "Module #{name} is already loaded." if loaded?(name)
			@modules[name] = Modules.const_get(name.to_s.camelcase)
			@modules[name].initialize! Environment.config.get(name)
		end
		
		def loaded?(name)
			!@modules[name].nil?
		end
		
		def get(name)
			raise "Module '#{name}' is not loaded." unless loaded?(name)
			@modules[name]
		end
	end
	
	module Modules
	end
end