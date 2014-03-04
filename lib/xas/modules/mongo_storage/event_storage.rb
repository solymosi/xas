module XAS::Modules::MongoStorage
	class EventStorage
		def save(event)
			raise "Event required." unless event.is_a?(XAS::Modules::Core::Events::Event)
			
		end
	end
end