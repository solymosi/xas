module XAS
	module Modules
		module Core
			extend self
			
			attr_reader :registry, :item_cache
			
			def initialize!
				@registry = Registry.new
				@item_cache = Items::Cache.new
			end
		end
	end
end