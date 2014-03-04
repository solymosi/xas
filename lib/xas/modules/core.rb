module XAS
	module Modules
		module Core
			extend self
			
			attr_reader :registry, :item_cache
			
			def initialize!
				Environment.events.on :environment, :ready do
					@registry = Registry.new(XAS::Modules::MongoStorage::EventStorage.new)
					@item_cache = Items::Cache.new
				end
			end
		end
	end
end