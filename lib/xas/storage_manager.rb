module XAS
	class StorageManager
		attr_reader :storages
		
		def initialize
			@storages = {}
		end
		
		def register(name, config)
			raise "Storage module not specified." if config.nil? || config.get(:module).nil?
			raise "Storage already registered." unless storages[name].nil?
			@storages[name] = Modules.const_get(config.get(:module).to_s.camelcase).get_storage(config)
		end
		
		def get(name)
			raise "Storage '#{name.to_s}' not registered." if storages[name].nil?
			storages[name].connect unless storages[name].connected?
			storages[name]
		end
		
		def [](name)
			get(name)
		end
	end
end