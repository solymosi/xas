module XAS::Modules::Core
	module Events
		class Event
			include Model
			
			field :date, DateTime
			field :created_at, DateTime
			
			class << self
				def references
					own = @references || {}
					superclass.is_a?(Event) ? superclass.references.merge(own) : own
				end
				
				def reference(name, type)
					@references ||= {}
					raise "Reference already defined." if references.include?(name)
					raise "Reference type must be a subclass of Item." unless type.ancestors.include?(Items::Item)
					@references[name] = type
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
				
				private
					def merge_fields(prev, current)
						return :all if prev == :all || current == :all
						return :exists if prev == :exists && current == :exists
						p, c = (prev == :exists ? [] : prev), (current == :exists ? [] : current)
						(p + c).uniq
					end
			end
		end
	end
end