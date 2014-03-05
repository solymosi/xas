require "mongo"

module XAS
	module Modules
		module MongoBackend
			extend self
			
			def initialize!(config = nil)
			end
			
			def get_backend(config)
				Backend.new(config)
			end
		end
	end
end