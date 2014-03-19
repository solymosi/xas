module XAS::Modules::MongoBackend
	class RegistryStorage < XAS::RegistryStorage
		scope :sorted do
			sort :date => 1, :_id => 1
		end
		
		scope :between do |first, last|
			first.nil? && last.nil? ? self : where(:date => {}.merge(first ? { :$gte => first } : {}).merge(last ? { :$lt => last } : {}))
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
					:date => event.value(:date).get,
					:created_at => event.value(:created_at).get,
					:values => event.to_hash.except(:references, :date, :created_at),
					:references => event.references.to_hash
				}
			end
			
			def hydrate_event(data)
				data.deep_symbolize_keys!
				event = data[:type].constantize.new data[:_id]
				event.load data[:values]
				event.value(:date).set data[:date]
				event.value(:created_at).set data[:created_at]
				data[:references].each do |name, id|
					event.references.value(name).set XAS::Placeholder.new(event.class.references[name][:type], id)
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