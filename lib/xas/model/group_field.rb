module XAS
	module Model
		class GroupField < Field
			attr_reader :model
			
			def initialize(*args)
				super
				model = Class.new
				model.send :include, Model
				model.class_eval &options[:definition]
				@model = model
			end
			
			def merge_definition(&block)
				raise "Definition block required." unless block_given?
				@model.class_eval(&block)
			end
			
			def type
				raise "Field collections have no type."
			end
			
			def method_missing(method, *args, &block)
				model.respond_to?(method) ? model.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || model.respond_to?(method)
			end
			
			def create_value
				GroupValue.new self
			end
		end
	end
end