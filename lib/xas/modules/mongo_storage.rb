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
				end
			end
		end
	end
end