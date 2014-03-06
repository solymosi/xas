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
			
			def set(value)
				raise "Value must be #{type.to_s}." unless type.nil? || value.is_a?(type)
				value
			end
		end
	end
end