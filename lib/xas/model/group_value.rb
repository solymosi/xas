module XAS
	module Model
		class GroupValue < Value
			def initialize(*args)
				super
				@data = field.model.new
			end
			
			def get
				self
			end
			
			def set(value)
				@data = parse(value)
			end
			
			def to_hash
				@data.to_hash
			end
			
			def to_data
				@data.to_data
			end
			
			def valid?
				@data.valid?
			end
			
			def errors
				@data.errors
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || @data.respond_to?(method)
			end
			
			protected
				def parse(value)
					raise "Collection value is not an instance of the collection field model." unless value.nil? || value.is_a?(field.model)
					value
				end
		end
	end
end