module XAS
	module Model
		module Validation
			class PresenceValidator < Validator
				def validate(value)
					value.add_error :blank if value.get.blank?
				end
			end
		end
	end
end