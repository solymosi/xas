module XAS::Modules::Core
	module Model
		extend ActiveSupport::Concern
		
		included do
			@fields = {}
		end
	
		def initialize(*args)
			@fields = {}
			super
		end
		
		def get(name)
			@fields[name]
		end
		
		def set(name, value)
			raise "Field does not exist." if self.class.fields[name].nil?
			@fields[name] = value.nil? ? nil : self.class.fields[name].set(value)
		end
		
		module ClassMethods
			def field(name, klass, options = {})
				@fields[name.to_sym] = klass.ancestors.include?(Field) ? klass.new(options) : Field.new(options.reverse_merge(:type => klass))
			end
			
			def fields
				@fields
			end
		end
	end
end