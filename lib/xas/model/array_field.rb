module XAS
	module Model
		class ArrayField < Field
			def initialize(*args)
				super
			end
			
			def create_value
				ArrayValue.new self
			end
		end
	end
end