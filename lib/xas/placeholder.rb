module XAS
	class Placeholder
		attr_reader :id, :type
		
		def initialize(type, id = nil)
			raise "Type must be a subclass of Item." unless type.ancestors.include?(Item)
			@type, @id = type, id
		end
		
		def saved?
			@id != nil
		end
		
		def ==(other)
			saved? ? self.id == other.id : self.equal?(other)
		end
		
		alias_method :eql?, :==
		
		def to_hash
			id
		end
		
		protected
			def set_id(id)
				@id = id
			end
	end
end