module XAS
	module Environment
		extend self
		
		attr_reader :events
		attr_reader :modules
		
		def initialize!
			@events = EventManager.new
			@modules = ModuleManager.new
			
			modules.load :core
			modules.load :console
			modules.load :mongo_storage
			
			events.trigger [:environment, :ready]
		end
	end
end