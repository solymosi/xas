module XAS
	module Model
		module Validation
			class PresenceValidator < Validator
				def validate(field, value)
					field.add_error :blank if value.blank?
				end
			end
		end
	end
end