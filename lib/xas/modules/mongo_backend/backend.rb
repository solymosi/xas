module XAS::Modules::MongoBackend
	class Backend < XAS::Backend
		attr_reader :client, :database
		
		def initialize(config)
			super
			set_config_defaults
		end
		
		def connect
			@client = Mongo::MongoClient.new config.get(:address)
			@database = @client[config.get(:database)]
		end
		
		def connected?
			!@client.nil?
		end
		
		def get_storage(name, config = nil)
			raise "Storage '#{name.to_s}' is not supported." unless self.respond_to?("get_#{name.to_s}")
			self.send "get_#{name.to_s}", config
		end
		
		def get_registry_storage(config)
			@registry_storage ||= RegistryStorage.new(self, config)
		end
		
		def get_item_cache_storage(config)
			@item_cache_storage ||= ItemCacheStorage.new(self, config)
		end
		
		def uuid
			BSON::ObjectId.new
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :address, nil
					default :database, "xas"
				end
			end
	end
end