module XAS
	module Model
		class Value
			attr_reader :field, :data
			
			def initialize(field)
				@field = field
			end
			
			def get
				@data
			end
			
			def set(value)
				@data = parse(value)
			end
			
			def nil?
				get.nil?
			end
			
			protected
				def parse(value)
					raise "Value must be #{field.type.to_s}." unless value.nil? || field.type.nil? || value.is_a?(field.type)
					value
				end
		end
	end
end