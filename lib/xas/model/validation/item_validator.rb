module XAS
	module Model
		module Validation
			class ItemValidator < Validator
				def validator
					options[:validator]
				end
				
				def validate(value, collection)
					errors = {}
					field = Model::Field.new(:type => value.field.type)
					field.validators << validator
					value.pairs.each do |k, v|
						item = field.create_value
						item.set(v)
						item.valid?
						errors[k] = item.errors if item.errors.any?
					end
					value.errors.deep_merge! :_items => errors if errors.any?
				end
			end
		end
	end
end