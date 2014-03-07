module XAS
	module Model
		module Validation
			class ModelValidator < Validator
				def validate(model)
					raise "Use a subclass of ModelValidator for validation."
				end
			end
		end
	end
end