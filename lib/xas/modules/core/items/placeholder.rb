module XAS::Modules::Core
	module Items
		class Placeholder
			attr_reader :type
			
			def initialize(type)
				@type = type
			end
			
			def ==(other)
				self.equal? other
			end
		end
	end
end