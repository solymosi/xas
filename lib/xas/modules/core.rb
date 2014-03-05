module XAS
	module Modules
		module Core
			extend self
			
			attr_reader :config, :registry, :item_cache
			
			def initialize!(config = nil)
				@config = config || Configuration.new
				set_config_defaults
				
				Environment.events.on :environment, :ready do
					@registry = Registry.new(get_storage(:registry))
					@item_cache = Items::Cache.new(get_storage(:item_cache))
				end
			end
			
			protected
				def set_config_defaults
					@config.instance_eval do
						group :registry do
							set :backend, :default
							set :storage, :registry_storage
							set :collection, "registry"
						end
						
						group :item_cache do
							set :backend, :default
							set :storage, :item_cache_storage
							set :collection, "item_cache"
						end
					end
				end
				
				def get_storage(type)
					Environment.backend.get(config.get(type, :backend)).get_storage(config.get(type, :storage), config.get(type))
				end
		end
	end
end