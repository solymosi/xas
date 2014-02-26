module XAS
	module Modules
		module Core
			extend self
			
			def initialize!
				
			end
			
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
				
				class Field
					attr_reader :type, :options
					
					def initialize(type, options = {})
						@type = type
						@options = options
					end
					
					def set(obj, value)
						raise "Value must be of type #{@type.to_s}." unless value.is_a?(@type)
						value
					end
				end
				
				module Validations
					extend ActiveSupport::Concern
					
					included do
						@@validations = {}
					end
					
					def initialize(*args)
						@errors = {}
						super
					end
				end
			end
			
			class Asset
				include Model
				include Validations
				
				field :type, String
				field :name, String
				field :value, Integer
			end
		end
	end
end