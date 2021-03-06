require "pry"

module XAS
	module Modules
		module Console
			extend self
			include Eventful
			
			def initialize!(config = nil)
				raise "Module already initialized." if @initialized
				
				Environment.on "frontend.start" do
					Pry.pager = nil
					
					Backend.send :define_method, :pretty_print do |q|
						q.text "#<#{self.class.name} #{self.config.to_hash.inspect}>"
					end
					
					XAS.binding.pry
				end
				
				@initialized = true
			end
		end
	end
	
	def self.binding
		super
	end
	
	def self.test
		Modules::Console::Test.run!
	end
	
	def self.core
		Modules::Core
	end
	
	def self.env
		Environment
	end
	
	def self.reg
		Environment.registry
	end
	
	def self.cache
		Environment.item_cache
	end
end