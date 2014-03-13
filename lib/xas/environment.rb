module XAS
	module Environment
		extend self
		include Eventful
		
		attr_reader :modules, :backends
		attr_reader :registry, :item_cache
		
		def config
			@config ||= Configuration.new
		end
		
		def start!
			set_config_defaults
		
			Eventful.on :event do |e, subject, event|
				puts "Event triggered on #{subject.inspect}: #{event.map(&:to_s).join "."}"
			end
			
			trigger :start
			
			load_modules
			register_backends
			initialize_registry
			initialize_item_cache
			
			trigger :ready
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
				trigger "modules.loaded"
			end
			
			def register_backends
				@backends = BackendManager.new
				config.get(:backend).keys.each do |item|
					backends.register item, config.get(:backend, item)
				end
				trigger "backends.registered"
			end
			
			def initialize_registry
				storage = backends.get(config.get(:registry, :backend)).get_storage(:registry, config.get(:registry))
				@registry = Registry.new(storage)
				trigger "registry.initialized"
			end
			
			def initialize_item_cache
				storage = backends.get(config.get(:registry, :backend)).get_storage(:item_cache, config.get(:item_cache))
				@item_cache = ItemCache.new(storage, registry)
				trigger "item_cache.initialized"
			end
	end
end