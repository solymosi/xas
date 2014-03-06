module XAS::Modules::Core
	class Registry
		attr_reader :storage
		
		def initialize(storage)
			@storage = storage
		end
		
		def save(obj)
			raise "#{obj.class.name} already saved." if obj.saved?
			if obj.is_a?(Events::Event)
				obj.references.each do |name, placeholder|
					save(placeholder) unless placeholder.saved?
				end
			end
			obj.send :set_id, new_id
			storage.save obj
		end
		
		def get_affected_events(event)
			
		end
		
		def new_id
			storage.new_id
		end
	end
end