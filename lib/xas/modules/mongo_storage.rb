require "mongo"

module XAS
	module Modules
		module MongoStorage
			extend self
			
			def initialize!(config = nil)
			end
			
			def get_storage(config)
				Storage.new(config)
			end
		end
	end
end