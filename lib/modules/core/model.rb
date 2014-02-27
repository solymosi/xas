require_relative "model/field"
require_relative "model/validations"

module XAS::Modules::Core
	module Model
		extend ActiveSupport::Concern
		
		included do
			self.init
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
			raise "Value must be of type #{self.class.fields[name].type.to_s}." unless value.is_a?(self.class.fields[name].type)
			@fields[name] = self.class.fields[name].set(self, value)
		end
		
		module ClassMethods
			def init
				@@fields = {}
			end
			
			def field(name, type, options = {})
				@@fields[name.to_sym] = Field.new(type, options)
			end
			
			def fields
				@@fields
			end
		end
	end
end