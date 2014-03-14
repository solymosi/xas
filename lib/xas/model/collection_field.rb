module XAS
	module Model
		class CollectionField < Field
			attr_reader :model
			
			def initialize(*args)
				super
				model = Class.new
				model.send :include, Model
				model.class_eval &options[:block]
				@model = model
			end
			
			def type
				raise "Field collections have no type."
			end
			
			def method_missing(method, *args, &block)
				model.respond_to?(method) ? model.send(method, *args, &block) : super
			end
			
			def create_value
				CollectionValue.new self
			end
		end
	end
end