module XAS
	class ItemCache
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
	end
end