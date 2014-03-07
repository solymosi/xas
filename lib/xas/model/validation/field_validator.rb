module XAS
	module Model
		module Validation
			class FieldValidator < Validator
				def validate(model, field, value)
					raise "Use a subclass of FieldValidator for validation."
				end
			end
		end
	end
end