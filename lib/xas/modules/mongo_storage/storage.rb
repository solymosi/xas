module XAS::Modules::MongoStorage
	class Storage < XAS::Storage
		attr_reader :client
		attr_reader :database
		
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