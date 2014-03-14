module XAS
	module Model
		class Field
			attr_reader :options
			
			def initialize(options = {})
				@options = options
			end
			
			def type
				@options[:type]
			end
			
			def create_value
				Value.new self
			end
		end
	end
end