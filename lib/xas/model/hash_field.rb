module XAS
	module Model
		class HashField < Field
			def initialize(*args)
				super
			end
			
			def create_value
				HashValue.new self
			end
		end
	end
end