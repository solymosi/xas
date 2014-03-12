module XAS::Modules::MongoBackend
	class RegistryStorage < XAS::RegistryStorage
		def initialize(backend, config)
			super
			set_config_defaults
		end
		
		def event_collection
			backend.database[config.get(:event_collection)]
		end
		
		def placeholder_collection
			backend.database[config.get(:placeholder_collection)]
		end
		
		def find(conditions = {}, sort = {}, limit = nil, skip = nil)
			cursor = event_collection.find(conditions).sort(sort)
			cursor = cursor.limit(limit) unless limit.nil?
			cursor = cursor.skip(skip) unless skip.nil?
			cursor
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :event_collection, "events"
					default :placeholder_collection, "placeholders"
				end
			end
			
			def save_event(obj)
				event_collection.insert build_event_data(obj)
			end
			
			def save_placeholder(obj)
				placeholder_collection.insert build_placeholder_data(obj)
			end
			
			def build_event_data(event)
				{
					:_id => event.id,
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
			
			def hydrate_event(data)
				event = data["type"].constantize.new(data["id"]).symbolize_keys
				data[:fields].each do |name, value|
					event.set name, value
				end
				data[:references].each do |name, id|
					event.references[name] = Placeholder.new event.class.references[name][:type], id
				end
				data
			end
			
			def build_placeholder_data(ph)
				{
					:_id => ph.id,
					:type => ph.class.name
				}
			end
	end
end