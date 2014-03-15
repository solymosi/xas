module XAS
	module Model
		module Validation
			extend ActiveSupport::Concern
			
			module Field
				def validators
					own = @validators || []
					superclass.respond_to?(:validators) ? superclass.validators.merge(own) : own
				end
				
				def validate(*args, &block)
					options = args.extract_options!
					raise "Invalid parameters." if args.size > 1
					raise "Validator or block required." unless args.any? || block_given?
					validator, validate_each = args.first, options.delete(:each)
					validator = Validation.const_get("#{validator.to_s}_validator".camelcase).new(options, &block) unless validator.nil?
					validator = BlockValidator.new(options, &block) if block_given?
					@validators ||= []
					@validators << validator
				end
			end
			
			module Value
				def errors
					@errors || {}
				end
				
				def add_error(error, params = {})
					raise "Error must be a symbol." unless error.is_a?(Symbol)
					@errors ||= {}
					@errors[error] = params
				end
				
				def valid?
					@errors.clear
					field.validators.each do |validator|
						validator.validate self, get
					end
					errors.none?
				end
			end
			
			def model_errors
				@errors || {}
			end
			
			def add_model_error(error, params = {})
				raise "Error must be a symbol." unless error.is_a?(Symbol)
				@errors ||= {}
				@errors[error] = params
			end
			
			def errors
				hash = { :_model => model_errors }
				hash.merge self.class.fields.keys.inject(Hash.new) { |result, current| result.merge value(current).errors }
			end
			
			def add_error(field, *args, &block)
				raise "Error must be a symbol." unless error.is_a?(Symbol)
				raise "Field '#{field.to_s}' does not exist." if !field.nil? && self.class.fields[field].nil?
				value(field).add_error(*args, &block)
			end
			
			def valid?
				@errors.clear
				validators.each do |validator|
					validator.validate self
				end
				self.class.fields.each do |name, field|
					value(name).valid?
				end
				errors.none?
			end
			
			module ClassMethods
				def validate(*args, block)
					options = args.extract_options!
					raise "Invalid parameters." if args.size > 2
					raise "Validator or block required." unless args.last || block_given?
					validator, field = args.last, (args.size > 1 ? args.first : nil)
				end
			
				def validate(*args, &block)
					options = args.extract_options!
					args << BlockValidator.new(options, &block) if block_given?
					raise "Invalid parameters." unless (1..2).include?(args.size)
					validator, field = args.last, (args.many? ? args.first : nil)
					raise "Field does not exist." if !field.nil? && fields[field].nil?
					validator = Validation.const_get("#{validator.to_s}_validator".camelcase).new(options) unless validator.is_a?(BlockValidator)
					unless validator.is_a?(BlockValidator)
						raise "Field validator required." if !field.nil? && !validator.is_a?(FieldValidator)
						raise "Model validator required." if field.nil? && !validator.is_a?(ModelValidator)
					end
					@validators ||= {}
					@validators[field] ||= []
					@validators[field] << validator
				end
				
				def validators
					own = @validators || {}
					superclass.respond_to?(:validators) ? superclass.validators.merge(own) : own
				end
				
				def model_validators
					
				end
			end
		end
	end
end