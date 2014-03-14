module XAS
	module Model
		class ArrayField < Field
			def create_value
				ArrayValue.new self
			end
		end
	end
end