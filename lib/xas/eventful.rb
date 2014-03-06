module XAS
	module Eventful
		extend ActiveSupport::Concern
		
		def _event
			self.class._event
		end
		
		module ClassMethods
			def _event
				Environment.events
			end
		end
	end
end