module XAS::Modules::MongoBackend
	class RegistryStorage < XAS::Storage
		def initialize(backend, config)
			super
			set_config_defaults
		end
		
		def new_id
			backend.uuid
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :collection, "registry"
				end
			end
	end
end