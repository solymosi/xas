module XAS
	module Model
		class CollectionValue
			include Model
			
			def initialize(*args, &block)
				super(*args, &nil)
				@data = field.model.new
			end
			
			def set(value)
				@data = parse(value)
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			protected
				def parse(value)
					raise "Collection value is not an instance of the collection field model." unless value.nil? || value.is_a?(field.model)
					value
				end
		end
	end
end