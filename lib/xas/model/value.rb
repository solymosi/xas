module XAS
	module Model
		class Value
			include Validation::Value
			
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
			
			def to_hash
				get.respond_to?(:to_hash) ? get.to_hash : get
			end
			
			def to_data
				get.respond_to?(:to_data) ? get.to_data : get
			end
			
			def nil?
				@data.nil?
			end
			
			def blank?
				@data.blank?
			end
			
			protected
				def parse(value)
					raise "Value must be #{field.type.to_s}." unless value.nil? || field.type.nil? || value.is_a?(field.type)
					value
				end
		end
	end
end