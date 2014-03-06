module XAS::Modules::MongoBackend
	class RegistryStorage < Storage
		def initialize(backend, config)
			super
			set_config_defaults
		end
		
		def collection
			backend.database[config.get(:collection)]
		end
		
		def save(obj)
			raise "Only Event and Placeholder objects can be saved." unless ([XAS::Event, XAS::Placeholder] & obj.class.ancestors).any?
			collection.insert build_data(obj)
		end
		
		def new_id
			backend.uuid
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :collection, "registry"
				end
			end
			
			def build_data(obj)
				return build_event_data(obj) if obj.is_a?(XAS::Event)
				return build_placeholder_data(obj) if obj.is_a?(XAS::Placeholder)
			end
			
			def build_event_data(event)
				{
					:_id => event.id,
					:kind => "event",
					:type => event.class.name,
					:date => event.get(:date),
					:created_at => event.get(:created_at),
					:fields => event.fields.except(:date, :created_at),
					:references => Hash[event.references.map do |a|
						raise "Reference '#{a[0]}' must be saved first." unless a[1].nil? || !a[1].id.nil?
						[a[0], a[1].nil? ? nil : a[1].id]
					end]
				}
			end
			
			def build_placeholder_data(ph)
				{
					:_id => ph.id,
					:kind => "placeholder",
					:type => ph.class.name
				}
			end
	end
end