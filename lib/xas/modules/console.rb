module XAS
	module Modules
		module Console
			extend self
			
			def initialize!(config = nil)
				raise "Module already initialized." if @initialized
				
				Environment.events.on :environment, :ready do
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
end