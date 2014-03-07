module XAS
	class Event
		include Model
		
		field :date, Time
		field :created_at, Time
		
		attr_reader :id, :references
		
		def initialize(id = nil)
			@id = id
			@references = {}
			set :created_at, Time.now
		end
		
		def saved?
			@id != nil
		end
		
		def set(*args)
			raise "Event already saved and can no longer be changed." if saved?
			super
		end
		
		def load(*args)
			raise "Event already saved and can no longer be changed." if saved?
			super
		end
		
		def create(name)
			filter_action :create, name
			set_reference name, Placeholder.new(self.class.references[name][:type])
		end
		
		def assign(name, ref)
			raise "Reference must already be saved." unless ref.saved?
			set_reference name, ref
		end
		
		def valid?
			super do
				self.class.references.each do |name, params|
					add_model_error :error => :missing_reference, :reference => name if params[:required] && @references[name].nil?
				end
				yield if block_given?
			end
		end
		
		protected
			def filter_action(action, reference, field = nil)
				a = self.class.actions[reference]
				raise "Reference does not exist." if a.nil?
				raise "Action '#{action}' not valid for '#{reference}'#{field.nil? ? "" : " field '#{field}'"}" unless a[:action] == action && ([nil, :all].include?(a[:fields]) || a[:fields].include?(field))
			end
			
			def set_id(id)
				@id = id
			end
			
			def set_reference(name, ref)
				raise "Reference does not exist." unless self.class.references.include?(name)
				raise "Reference must be a placeholder." unless ref.is_a?(Placeholder)
				@references[name] = ref
			end
		
		class << self
			def references
				own = @references || {}
				superclass.is_a?(Event) ? superclass.references.merge(own) : own
			end
			
			def reference(name, type, options = {})
				@references ||= {}
				raise "Reference already defined." if references.include?(name)
				raise "Reference type must be a subclass of Item." unless type.ancestors.include?(Item)
				@references[name] = options.merge(:type => type).reverse_merge(:required => true)
			end
			
			# Dependencies
			
			def dependencies
				own = @dependencies || {}
				superclass.is_a?(Event) ? superclass.dependencies.merge(own) : own
			end
			
			def depends_on(name, fields)
				@dependencies ||= {}
				raise "Reference does not exist." unless references.include?(name)
				raise "Invalid field definition." unless fields.is_a?(Array) || [:exists, :all].include?(fields)
				@dependencies[name] = dependencies[name].nil? ? fields : merge_fields(dependencies[name], fields)
			end
			
			def requires(name)
				depends_on name, :exists
			end
			
			def uses(name, *fields)
				depends_on name, (fields.flatten.any? ? fields.flatten : :all)
			end
			
			# Actions
			
			def actions
				own = @actions || {}
				superclass.is_a?(Event) ? superclass.actions.merge(own) : own
			end
			
			def performs(action, name, fields = nil)
				@actions ||= {}
				raise "Reference does not exist." unless references.include?(name)
				raise "Unexpected field definition." unless action == :change || fields.nil?
				raise "Invalid field definition." unless fields.is_a?(Array) || [nil, :all].include?(fields)
				raise "Incompatible action already defined." if !actions[name].nil? && actions[name][:action] != action
				@actions[name] = { :action => action, :fields => (actions[name].nil? ? fields : merge_fields(actions[name][:fields], fields)) }
			end
			
			def creates(name)
				performs :create, name
			end
			
			def changes(name, *fields)
				performs :change, name, (fields.flatten.any? ? fields.flatten : :all)
			end
			
			def removes(name)
				performs :remove, name
			end
			
			protected
				def merge_fields(prev, current)
					return :all if prev == :all || current == :all
					return :exists if prev == :exists && current == :exists
					p, c = (prev == :exists ? [] : prev), (current == :exists ? [] : current)
					(p + c).uniq
				end
		end
	end
end