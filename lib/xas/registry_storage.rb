module XAS
	class RegistryStorage < Storage
		include Queriable
		
		def save(obj)
			raise "Only events and placeholders can be saved." unless ([Event, Placeholder] & obj.class.ancestors).any?
			save_event(obj) if obj.is_a?(Event)
			save_placeholder(obj) if obj.is_a?(Placeholder)
			obj
		end
		
		def new_id
			backend.uuid
		end
		
		def method_missing(method, *args, &block)
			return query.send method, *args, &block if query.respond_to? method
			super
		end
		
		def respond_to?(method)
			super || query.respond_to?(method)
		end
	end
end