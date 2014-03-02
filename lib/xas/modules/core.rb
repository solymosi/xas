module XAS
	module Modules
		module Core
			extend self
			
			attr_reader :events, :item_cache
			
			def initialize!
				@events = Events::Registry.new
				@item_cache = Items::Cache.new
			end
		end
	end
end