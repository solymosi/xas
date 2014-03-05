module XAS::Modules::Core
	module Items
		class Placeholder
			attr_reader :registry, :id, :type
			
			def initialize(registry, type, id = nil)
				@registry = registry
				raise "Type must be a subclass of Item." unless type.ancestors.include?(Item)
				@type = type
				@id = id || registry.uuid
			end
			
			def ==(other)
				self.id == other.id && self.type == other.type
			end
			
			alias_method :eql?, :==
		end
	end
end