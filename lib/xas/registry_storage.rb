module XAS
	class RegistryStorage < Storage
		include Queriable
		
		def save(obj)
			raise "Only events and placeholders can be saved." unless ([Event, Placeholder] & obj.class.ancestors).any?
			save_event(obj) if obj.is_a?(Event)
			save_placeholder(obj) if obj.is_a?(Placeholder)
			obj
		end
	end
end