module XAS
	class Registry
		include Eventful
		
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
		
		def save(event)
			raise "Event object required." unless event.is_a?(Event)
			raise "Event already saved." if event.saved?
			raise "Event has the following errors: #{event.errors.inspect}" unless event.valid?
			save_references event.to_data
			save_object event
			trigger :save, event
		end
		
		def events
			query
		end
		
		def get_affected_events(event)
			
		end
		
		def new_id
			storage.new_id
		end
		
		def method_missing(method, *args, &block)
			return storage.send method, *args, &block if storage.respond_to?(method)
			super
		end
		
		def respond_to?(method)
			super || storage.respond_to?(method)
		end
		
		protected
			def save_object(obj)
				obj.send :set_id, new_id
				storage.save obj
			end
			
			def save_references(obj)
				if obj.is_a?(Placeholder)
					save_object(obj) unless obj.saved?
				elsif obj.is_a?(Array)
					obj.map { |i| save_references(i) }
				elsif obj.is_a?(Hash)
					obj.map { |k, v| save_references(v) }
				end
			end
	end
end