module XAS
	module Model
		class CollectionField < Field
			attr_reader :model
			
			def initialize(*args)
				super
				@model = Class.new options[:block]
			end
			
			def type
				raise "Field collections have no type."
			end
			
			def create_value
				CollectionValue.new self
			end
		end
	end
end