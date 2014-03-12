module XAS
	module Queriable
		extend ActiveSupport::Concern
		
		def query
			Query.new self
		end
		
		module ClassMethods
			def scopes
				own = @scopes || {}
				superclass.respond_to?(:scopes) ? superclass.scopes.merge(own) : own
			end
			
			def scope(name, &block)
				@scopes ||= {}
				raise "Scope name must be a symbol." unless name.is_a?(Symbol)
				raise "Scope '#{name.to_s}' already defined." unless scopes[name].nil?
				@scopes[name] = block
			end
		end
		
		class Query
			attr_reader :storage, :conditions, :sorts, :limits, :skips
			delegate :to_a, :each, :count, :to => :execute
			
			def initialize(storage)
				@storage = storage
				@conditions = {}
				@sort = {}
				self
			end
			
			def execute
				storage.find conditions, sorts, limits, skips
			end
			
			def where(condition)
				conditions.deep_merge! condition
				self
			end
			
			def sort(param)
				sort.merge! param
				self
			end
			
			def limit(count)
				@limit = count
				self
			end
			
			def skip(count)
				@skip = count
				self
			end
			
			def unscoped
				conditions.clear
				sort.clear
				@limit = nil
				@skip = nil
				self
			end
			
			def method_missing(method, *args, &block)
				return instance_exec(*args, &storage.class.scopes[method]) unless storage.class.scopes[method].nil?
				super
			end
			
			def respond_to?(method)
				super || !storage.class.scopes[method].nil?
			end
		end
	end
end