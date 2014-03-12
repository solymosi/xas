module XAS
	module Queriable
		extend ActiveSupport::Concern
		
		def query
			Query.new self
		end
		
		def method_missing(method, *args, &block)
			respond_to?(method) ? query.send(method, *args, &block) : super
		end
		
		def respond_to?(method)
			super || query.respond_to?(method)
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
			
			def initialize(storage)
				@storage = storage
				@conditions = {}
				@sorts = {}
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
				sorts.merge! param
				self
			end
			
			def limit(count)
				@limits = count
				self
			end
			
			def skip(count)
				@skips = count
				self
			end
			
			def unscoped
				conditions.clear
				sorts.clear
				@limits = nil
				@skips = nil
				self
			end
			
			def method_missing(method, *args, &block)
				return instance_exec(*args, &storage.class.scopes[method]) unless storage.class.scopes[method].nil?
				respond_to?(method) ? execute.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || !storage.class.scopes[method].nil? || Enumerable.instance_methods.include?(method)
			end
		end
	end
end