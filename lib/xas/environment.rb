module XAS
	module Environment
		extend self
		
		attr_reader :config
		attr_reader :events
		attr_reader :modules
		attr_reader :storage
		
		def add_config(path)
			@config ||= Configuration.new
			config.load(path)
		end
		
		def start!
			@events = EventManager.new
			@modules = ModuleManager.new
			@storage = StorageManager.new
		
			events.trigger [:environment, :start]
			
			config.get(:modules).each do |item|
				modules.load item
			end
			
			events.trigger [:environment, :modules_loaded]
			
			config.get(:storage).keys.each do |item|
				storage.register item, config.get(:storage, item)
			end
			
			events.trigger [:environment, :ready]
		end
	end
end