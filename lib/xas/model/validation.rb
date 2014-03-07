module XAS
	module Model
		module Validation
			extend ActiveSupport::Concern
			
			def errors
				@errors || {}
			end
			
			def add_error(field, error, options = {})
				raise "Error must be a symbol or a hash." unless error.is_a?(Symbol) || error.is_a?(Hash)
				raise "Field does not exist." if !field.nil? && self.class.fields[field].nil?
				error = options.merge(:error => error) if error.is_a?(Symbol)
				raise "Error code must be specified." if error[:error].nil?
				@errors ||= {}
				@errors[field] ||= []
				@errors[field] << error
			end
			
			def add_model_error(error, options = {})
				add_error nil, error, options
			end
			
			def valid?
				errors.clear
				self.class.validations.each do |field, validators|
					validators.each do |validator|
						validator.validate self, field, get(field) unless field.nil?
						validator.validate self if field.nil?
					end unless validators.nil?
				end
				yield if block_given?
				!errors.any?
			end
			
			module ClassMethods
				def validate(*args, &block)
					options = args.extract_options!
					raise "Invalid parameters." unless (1..2).include?(args.size)
					validator, field = args.last, (args.many? ? args.first : nil)
					raise "Field does not exist." if !field.nil? && fields[field].nil?
					validator = Validation.const_get("#{validator.to_s}_validator".camelcase).new(options)
					raise "Field validator required." unless field.nil? || validator.is_a?(FieldValidator)
					raise "Model validator required." unless !field.nil? || validator.is_a?(ModelValidator)
					@validations ||= {}
					@validations[field] ||= []
					@validations[field] << validator
				end
				
				def validations
					@validations || {}
				end
			end
		end
	end
end