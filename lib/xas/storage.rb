module XAS
	class Storage
		attr_reader :config
		
		def initialize(config)
			@config = config
		end
		
		def connect
			raise "Storage base class does not support connect."
		end
		
		def uuid
			SecureRandom.uuid
		end
	end
end