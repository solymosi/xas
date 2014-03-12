module XAS
	class Storage
		attr_reader :backend, :config
		
		def initialize(backend, config = nil)
			@backend, @config = backend, config
		end
		
		def save(*args)
			raise "Save is not supported in base storage."
		end
		
		def find(*args)
			raise "Find is not supported in base storage."
		end
		
		def new_id
			SecureRandom.uuid
		end
	end
end