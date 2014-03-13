module XAS::Modules::MongoBackend
	class RegistryStorage < XAS::RegistryStorage
		scope :sorted do
			sort :date => 1, :_id => 1
		end
		
		scope :between do |first, last|
			where :date => {}.merge(first ? { :$gte => first } : {}).merge(last ? { :$lt => last } : {})
		end
		
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
		
		def find(query)
			cursor = event_collection.find(query.conditions).sort(query.sorts)
			cursor = cursor.limit(query.limits) unless query.limits.nil?
			cursor = cursor.skip(query.skips) unless query.skips.nil?
			Enumerator.new do |y|
				cursor.each do |e|
					y.yield hydrate_event(e)
				end
			end
		end
		
		def new_id
			backend.uuid
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
				data.deep_symbolize_keys!
				event = data[:type].constantize.new data[:_id]
				event.set :date, data[:date]
				event.set :created_at, data[:created_at]
				data[:fields].each do |name, value|
					event.set name, value
				end
				data[:references].each do |name, id|
					event.references[name] = XAS::Placeholder.new event.class.references[name][:type], id
				end
				event
			end
			
			def build_placeholder_data(ph)
				{
					:_id => ph.id,
					:type => ph.type.name
				}
			end
			
			def hydrate_placeholder(data)
				data.deep_symbolize_keys!
				XAS::Placeholder.new data[:type].constantize, data[:_id]
			end
	end
end