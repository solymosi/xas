module XAS
	module Model
		class HashField < Field
			def initialize(*args)
				super
			end
			
			def from_hash(value)
				type.respond_to?(:from_hash) ? Hash[value.map { |k, v| [k, type.from_hash(v)] }] : value
			end
			
			def create_value
				HashValue.new self
			end
		end
	end
end