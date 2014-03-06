module XAS
	module Environment
		extend self
		
		attr_reader :events
		attr_reader :modules, :backends
		attr_reader :registry, :item_cache
		
		def config
			@config ||= Configuration.new
		end
		
		def start!
			@events = EventService.new
			set_config_defaults
		
			events.trigger "environment.start"
			
			load_modules
			register_backends
			initialize_registry
			initialize_item_cache
			
			events.trigger "environment.ready"
		end
		
		protected
			def set_config_defaults
				config.instance_eval do
					default :modules, []
					
					group :registry do
						default :backend, :default
					end
					
					group :item_cache do
						default :backend, :default
					end
				end
			end
			
			def load_modules
				@modules = ModuleManager.new
				config.get(:modules).each do |item|
					modules.load item
				end
				events.trigger "environment.modules.loaded"
			end
			
			def register_backends
				@backends = BackendManager.new
				config.get(:backend).keys.each do |item|
					backends.register item, config.get(:backend, item)
				end
				events.trigger "environment.backends.registered"
			end
			
			def initialize_registry
				storage = backends.get(config.get(:registry, :backend)).get_storage(:registry, config.get(:registry))
				@registry = Registry.new(storage)
				events.trigger "environment.registry.initialized"
			end
			
			def initialize_item_cache
				storage = backends.get(config.get(:registry, :backend)).get_storage(:item_cache, config.get(:item_cache))
				@item_cache = ItemCache.new(storage)
				events.trigger "environment.item_cache.initialized"
			end
	end
end