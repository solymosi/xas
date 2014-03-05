module XAS
	class BackendManager
		attr_reader :storages
		
		def initialize
			@storages = {}
		end
		
		def register(name, config)
			raise "Backend module not specified." if config.nil? || config.get(:module).nil?
			raise "Backend already registered." unless storages[name].nil?
			@storages[name] = Modules.const_get(config.get(:module).to_s.camelcase).get_backend(config)
		end
		
		def get(name)
			raise "Backend '#{name.to_s}' not registered." if storages[name].nil?
			storages[name].connect unless storages[name].connected?
			storages[name]
		end
		
		def [](name)
			get(name)
		end
	end
end