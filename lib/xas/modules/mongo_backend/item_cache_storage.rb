module XAS::Modules::MongoBackend
	class ItemCacheStorage < XAS::Storage
		def initialize(backend, config)
			super
			set_config_defaults
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :collection, "item_cache"
				end
			end
	end
end