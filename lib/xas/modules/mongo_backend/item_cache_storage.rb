module XAS::Modules::MongoBackend
	class ItemCacheStorage < XAS::ItemCacheStorage
		META_ID = :_meta
		
		scope :at do |date, build = true|
			param(:build, build ? date : nil).where :from => { :$lte => date }, :$or => [ { :to => nil }, { :to => { :$gt => date } } ]
		end
		
		scope :before do |date|
			where :to => { :$lte => date }
		end
		
		scope :after do |date|
			where :from => { :$gt => date }
		end
		
		scope :ref do |placeholder|
			raise "Cannot query on unsaved placeholder." unless placeholder.saved?
			where :_ref => placeholder.id
		end
		
		def initialize(backend, config)
			super
			set_config_defaults
		end
		
		def collection
			backend.database[config.get(:collection)]
		end
		
		def find(query)
			trigger :find_query, query.params, query
			trigger :build_required, query.params[:build], query unless query.params[:build].nil?
			cursor = collection.find(query.conditions).sort(query.sorts)
			cursor = cursor.limit(query.limits) unless query.limits.nil?
			cursor = cursor.skip(query.skips) unless query.skips.nil?
			Enumerator.new do |y|
				cursor.each do |i|
					y.yield hydrate_item(i) unless i["_id"] == META_ID
				end
			end
		end
		
		def remove(query)
			trigger :remove_query, query.params, query
			collection.remove query.conditions
		end
		
		def find_meta
			meta = collection.find(:_id => META_ID).first || {}
			meta.deep_symbolize_keys.except(:_id)
		end
		
		def save_meta(data)
			collection.update({ '_id' => META_ID }, data.merge('_id' => META_ID), { :upsert => true })
		end
		
		def new_id
			backend.uuid
		end
		
		protected
			def set_config_defaults
				@config.instance_eval do
					default :collection, "item_cache"
				end
			end
			
			def save_item(obj)
				collection.update({ :_id => obj.id }, build_item_data(obj), { :upsert => true })
			end
			
			def build_item_data(item)
				{
					:_id => item.id,
					:_ref => item.placeholder.id,
					:type => item.class.name,
					:from => item.value(:from).get,
					:to => item.value(:to).get,
					:values => item.to_hash.except(:from, :to)
				}
			end
			
			def hydrate_item(data)
				data.deep_symbolize_keys!
				item = data[:type].constantize.new XAS::Placeholder.new(data[:type].constantize, data[:_ref]), data[:_id]
				item.value(:from).set data[:from]
				item.value(:to).set data[:to]
				item.load data[:values]
				item
			end
	end
end