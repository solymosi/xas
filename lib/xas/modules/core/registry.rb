module XAS::Modules::Core
	class Registry
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
		
		def add(event)
			
		end
		
		def new_id
			storage.new_id
		end
	end
end