module XAS
	module Model
		module Validation
			class Validator
				attr_reader :options
				
				def initialize(options = {})
					@options = options
				end
				
				def validate(*args)
					raise "Base validator cannot be used for validation."
				end
			end
		end
	end
end