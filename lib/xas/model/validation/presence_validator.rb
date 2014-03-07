module XAS
	module Model
		module Validation
			class PresenceValidator < FieldValidator
				def validate(model, field, value)
					model.add_error field, :blank if value.blank?
				end
			end
		end
	end
end