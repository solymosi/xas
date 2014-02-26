module XAS
	class ModuleManager
		attr_reader :modules
		
		def initialize
			@modules = {}
		end
		
		def load(name)
			require_relative "modules/#{name.to_s.underscore}/#{name.to_s.underscore}"
			Modules.const_get(name.to_s.camelcase).initialize!
		end
	end
	
	module Modules
	end
end