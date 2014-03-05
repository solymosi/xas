module XAS
	module Modules
		module Core
			extend self
			
			attr_reader :config, :registry, :item_cache
			
			def initialize!(config = nil)
				@config = config || Configuration.new
				set_config_defaults
				
				Environment.events.on :environment, :ready do
					@registry = Registry.new(Environment.storage.get(config.get(:registry, :storage)))
					@item_cache = Items::Cache.new(Environment.storage.get(config.get(:item_cache, :storage)))
				end
			end
			
			protected
				def set_config_defaults
					@config.instance_eval do
						group :registry do
							default :storage, :default
							default :collection, "registry"
						end
						
						group :item_cache do
							default :storage, :default
							default :collection, "item_cache"
						end
					end
				end
		end
	end
end