module XAS
	module Modules
		module Console
			extend self
			
			def initialize!
				raise "Module already initialized." if @initialized
				
				Environment.events.on :environment, :ready do
					Pry.pager = nil
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