require "mongo"

module XAS
	module Modules
		module MongoStorage
			extend self
			
			attr_reader :client
			attr_reader :database
			
			def initialize!
				Environment.events.on :environment, :ready do
					@client = Mongo::MongoClient.new
					@database = @client.db "xas"
					
					if Environment.modules.loaded? :core
						
					end
				end
			end
			
			class Persistence
				def initialize(obj)
					@object = obj
				end
				
				def get_data
					@object
				end
			end
		end
	end
end