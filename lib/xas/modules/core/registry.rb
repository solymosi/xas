module XAS::Modules::Core
	class Registry
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
		
		def add(event)
			
		end
		
		def uuid
			storage.uuid
		end
	end
end