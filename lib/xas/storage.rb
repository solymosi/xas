module XAS
	class Storage
		attr_reader :backend, :config
		
		def initialize(backend, config = nil)
			@backend, @config = backend, config
		end
	end
end