module XAS
	module Model
		class ReferenceField < Field
			def initialize(*args)
				super
				raise "Reference type must be a subclass of Item." unless type.ancestors.include?(Item)
			end
			
			def self_validating?
				false
			end
			
			def create_value
				ReferenceValue.new self
			end
		end
	end
end