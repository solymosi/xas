module XAS
	module Model
		module Validation
			extend ActiveSupport::Concern
			
			def errors
				@errors || {}
			end
			
			def valid?
				
			end
			
			module ClassMethods
				def validate(field, validator, options = {})
					raise "Field does not exist." if fields[field].nil?
					@validations ||= {}
					@validations[field] ||= []
					@validations[field] << const_get(validator.to_s.camelcase).new(options)
				end
			end
		end
	end
end