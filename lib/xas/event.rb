module XAS
	class Event
		include Model
		
		field :date, Time
		validate :date, :presence
		
		field :created_at, Time
		validate :created_at, :presence
		
		attr_reader :id
		
		def initialize(id = nil)
			@id = id
			value(:created_at).set Time.now
		end
		
		def apply(*args)
			raise "Base event cannot be applied on an item cache."
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