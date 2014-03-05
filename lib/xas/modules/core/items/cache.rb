module XAS::Modules::Core
	module Items
		class Cache
			attr_reader :storage
			
			def initialize(storage)
				@storage = storage
			end
		end
	end
end