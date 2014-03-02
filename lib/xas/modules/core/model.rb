module XAS::Modules::Core
	module Model
		extend ActiveSupport::Concern
	
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
			def fields
				own = @fields || {}
				superclass.include?(Model) ? superclass.fields.merge(own) : own
			end
			
			def field(name, klass, options = {})
				raise "Field already defined." if fields.include?(name.to_sym)
				@fields ||= {}
				@fields[name.to_sym] = klass.ancestors.include?(Field) ? klass.new(options) : Field.new(options.reverse_merge(:type => klass))
			end
		end
	end
end