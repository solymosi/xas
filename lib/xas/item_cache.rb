module XAS
	class ItemCache
		include Eventful
		
		attr_reader :storage, :registry, :meta
		
		def initialize(storage, registry)
			@storage = storage
			@registry = registry
			@meta = storage.find_meta.reverse_merge :valid_to => nil
			
			registry.on :save do |e, event|
				set_valid_to [valid_to, event.value(:date).get].min unless valid_to.nil?
			end
			
			storage.on :build_required do |e, date|
				build(date)
			end
		end
		
		def save(item)
			raise "Item object required." unless item.is_a?(Item)
			raise "Item already saved." if item.saved?
			raise "From date not set." if item.value(:from).nil?
			raise "No placeholder set for item." if item.placeholder.nil?
			raise "Unsaved placeholder is assigned to item." unless item.placeholder.saved?
			raise "Item has the following errors: #{item.errors.inspect}" unless item.valid?
			
			date = item.value(:from).get
			prev = at(date, false).ref(item.placeholder).first
			raise "Cannot resurrect deleted item." if prev.nil? && before(date).ref(item.placeholder).any?
			unless prev.nil?
				prev.value(:to).set date
				storage.save prev
			end
			
			storage.remove after(date).ref(item.placeholder)
			
			item.send :set_id, new_id
			item.value(:from).set date
			item.value(:to).set nil
			storage.save item
		end
		
		def items
			query
		end
		
		def build(date)
			raise "A build is already running." if building?
			return if valid_on?(date)
			begin
				@building = true
				trigger "build.started", date
				context = Build.new self, registry.sorted.between(valid_to, date)
				context.each do |date, event, action|
					raise "Invalid event or action order." if !valid_to.nil? && valid_to > date
					if action.nil?
						trigger :build_event, event
						event.apply context
					else
						trigger :build_action, event, action
						event.instance_exec date, context, &action
					end
					set_valid_to date
				end
			ensure
				@building = false
				trigger "build.finished", date
			end
		end
		
		def rebuild(date)
			clear
			build(date)
		end
		
		def clear
			storage.remove items
			set_valid_to nil
		end
		
		def create(placeholder, date)
			raise "Date required." unless date.is_a?(Time)
			raise "Placeholder required." unless placeholder.is_a?(Placeholder)
			raise "Cannot create item for an unsaved placeholder." unless placeholder.saved?
			raise "Item already exists or existed." if at(date, false).ref(placeholder).any? || before(date).ref(placeholder).any?
			item = placeholder.type.new(placeholder)
			item.value(:from).set date
			item
		end
		
		def get(placeholder, date)
			raise "Date required." unless date.is_a?(Time)
			raise "Placeholder required." unless placeholder.is_a?(Placeholder)
			raise "Cannot retrieve item for an unsaved placeholder." unless placeholder.saved?
			item = at(date, false).ref(placeholder).first
			raise "Item does not exist on the provided date." if item.nil?
			item.send :set_id, nil
			item.value(:from).set date
			item.value(:to).set nil
			item
		end
		
		def building?
			@building || false
		end
		
		def valid_to
			meta[:valid_to]
		end
		
		def valid_on?(date)
			!valid_to.nil? && valid_to >= date
		end
		
		def set_valid_to(date)
			return unless date != valid_to
			meta[:valid_to] = date
			save_meta
			trigger :set_valid_to, date
		end
		
		def save_meta
			storage.save_meta @meta
		end
		
		def method_missing(method, *args, &block)
			storage.respond_to?(method) ? storage.send(method, *args, &block) : super
		end
		
		def respond_to?(method)
			super || storage.respond_to?(method)
		end
		
		class Build
			attr_reader :cache, :query, :actions, :current_date, :current_event
			
			def initialize(cache, query)
				@cache, @query = cache, query
				@actions = {}
			end
			
			def each
				raise "This context is already being enumerated." unless current_date.nil?
				e = Enumerator.new do |y|
					event, cursor = nil, query.execute
					while true
						act_date = actions.keys.sort.first
						action = act_date.nil? || actions[act_date].nil? ? nil : actions[act_date].first
						event = cursor.next rescue nil if event.nil?
						break if event.nil? && action.nil?
						if !event.nil? && (action.nil? || event.value(:date).get <= act_date)
							args = [event.value(:date).get, event, nil]
							event = nil
						elsif !action.nil? && (event.nil? || event.value(:date).get > act_date)
							args = [act_date, action[:event], action[:action]]
							actions[act_date].delete action
							actions.delete(act_date) if actions[act_date].empty?
						else
							raise "Invalid state."
						end
						@current_date, @current_event = args[0], args[1]
						yield *args
					end
				end
				return e unless block_given?
				e.each do |event, action|
					yield event, action
				end
			ensure
				@current_date = nil
			end
			
			def at(date, &block)
				return cache.at(date) unless block_given?
				raise "Time required." unless date.is_a?(Time)
				raise "The date of the deferred action must not precede the current build time." unless current_date.nil? || current_date <= date
				actions[date] ||= []
				actions[date] << { :event => current_event, :action => block }
			end
			
			def method_missing(method, *args, &block)
				cache.respond_to?(method) ? cache.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || cache.respond_to?(method)
			end
		end
	end
end