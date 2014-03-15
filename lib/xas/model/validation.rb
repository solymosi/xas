module XAS
	module Model
		module Validation
			extend ActiveSupport::Concern
			
			module Field
				def validators
					@validators || []
				end
				
				def validate(*args, &block)
					options = args.extract_options!
					args << BlockValidator.new(options, &block) if block_given?
					raise "Validator or block required." if args.size != 1
					validator = block_given? ? args.first : Validation.const_get("#{args.first.to_s}_validator".camelcase).new(options)
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
					errors.clear
					binding.pry
					field.validators.each do |validator|
						validator.validate self, get
					end
					errors.none?
				end
			end
			
			def errors
				@errors ||= {}
				hash = @errors.any? ? { :_model => @errors } : {}
				self.class.fields.each do |name, field|
					hash[name] = value(name).errors if value(name).errors.any?
				end
				hash
			end
			
			def add_error(error, params = {})
				raise "Error must be a symbol." unless error.is_a?(Symbol)
				@errors ||= {}
				@errors[error] = params
			end
			
			def valid?
				@errors = {}
				self.class.validators.each do |validator|
					validator.validate self, nil
				end
				self.class.fields.each do |name, field|
					value(name).valid?
				end
				errors.none?
			end
			
			module ClassMethods
				def validate(*args, &block)
					options = args.extract_options!
					args << BlockValidator.new(options, &block) if block_given?
					raise "Invalid parameters." unless (1..2).include?(args.size)
					validator, field = args.last, (args.size > 1 ? args.first : nil)
					puts ({:field => field, :validator => validator, :block => block, :options => options}).inspect
					unless field.nil?
						raise "Field '#{field.to_s}' does not exist." if fields[field].nil?
						return block_given? ? fields[field].validate(&block) : fields[field].validate(validator)
					end
					validator = Validation.const_get("#{validator.to_s}_validator".camelcase).new(options) unless validator.is_a?(BlockValidator)
					raise "Invalid validator." unless validator.is_a?(Validator)
					@validators ||= []
					@validators << validator
				end
				
				def validators
					own = @validators || []
					superclass.respond_to?(:validators) ? superclass.validators + own : own
				end
			end
		end
	end
end