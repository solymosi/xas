module XAS::Modules::MongoStorage
	class Placeholder < XAS::Modules::Core::Items::Placeholder
		attr_reader :id
		
		def initialize(type, id = nil)
			@id = id || BSON::ObjectId.new
			super(type)
		end
		
		def ==(other)
			self.id == other.id && self.type == other.type
		end
	end
end