module XAS
	class Item
		include Model
		
		attr_reader :id, :placeholder
		
		field :from, Time
		validate :from, :presence
		
		field :to, Time
		
		def initialize(placeholder = nil, id = nil)
			@id, @placeholder = id, placeholder
		end
		
		def saved?
			@id != nil
		end
		
		def ==(other)
			saved? ? self.id == other.id : self.equal?(other)
		end
		
		protected
			def set_id(id)
				@id = id
			end
	end
end