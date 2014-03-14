module XAS
	module Model
		extend ActiveSupport::Concern
		include Validation
		
		def values
			@values || {}
		end
		
		def value(name)
			@values ||= {}
			@values[name] ||= self.class.fields[name].create_value
			values[name]
		end
		
		def load(values)
			raise "Hash required." unless values.is_a?(Hash)
			values.each do |name, val|
				value(name).set val
			end
			values
		end
		
		def method_missing(method, *args, &block)
			name = method.to_s.ends_with?("=") ? method.to_s[0...-1].to_sym : method
			unless self.class.fields[name].nil?
				return value(name).set(*args) if method.to_s.ends_with?("=")
				return value(name).get(*args)
			end
			super
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