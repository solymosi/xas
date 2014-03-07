module XAS
	class Registry
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
		
		def save(event)
			raise "Event object required." unless event.is_a?(Event)
			raise "Event already saved." if event.saved?
			raise "Event has the following errors: #{event.errors.inspect}" unless event.valid?
			event.references.each do |name, placeholder|
				save_object(placeholder) unless placeholder.saved?
			end
			save_object event
		end
		
		def get_affected_events(event)
			
		end
		
		def new_id
			storage.new_id
		end
		
		protected
			def save_object(obj)
				obj.send :set_id, new_id
				storage.save obj
			end
	end
end