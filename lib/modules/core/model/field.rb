module XAS::Modules::Core
	module Model
		class Field
			attr_reader :type, :options
			
			def initialize(type, options = {})
				@type = type
				@options = options
			end
		end
	end
end