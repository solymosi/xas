module XAS
	module Model
		class ArrayField < Field
			def initialize(*args)
				super
			end
			
			def from_hash(value)
				type.respond_to?(:from_hash) ? value.map { |i| type.from_hash(i) } : value
			end
			
			def create_value
				ArrayValue.new self
			end
		end
	end
end