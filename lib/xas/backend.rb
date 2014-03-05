module XAS
	class Backend
		attr_reader :config
		
		def initialize(config)
			@config = config
		end
		
		def connect
			raise "Backend base class does not support connect."
		end
		
		def get_storage(name, config = nil)
			raise "Backend base class has no Storage classes."
		end
		
		def uuid
			SecureRandom.uuid
		end
	end
end