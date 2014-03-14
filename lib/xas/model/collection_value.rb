module XAS
	module Model
		class CollectionValue < Value
			include Model
			
			def initialize(*args)
				super
				@data = field.model.new
			end
			
			def set(value)
				@data = parse(value)
			end
			
			def to_hash
				@data.to_hash
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			protected
				def parse(value)
					return field.model.from_hash(value) if value.is_a?(Hash)
					raise "Collection value is not an instance of the collection field model." unless value.nil? || value.is_a?(field.model)
					value
				end
		end
	end
end