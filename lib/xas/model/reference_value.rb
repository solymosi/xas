module XAS
	module Model
		class ReferenceValue < Value
			def initialize(*args)
				super
			end
			
			def get
				self
			end
			
			def build
				@data = Placeholder.new(field.type)
			end
			
			def fetch(cache, date)
				cache.get self, date
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || @data.respond_to?(method)
			end
			
			def to_hash
				@data.to_hash unless @data.nil?
			end
			
			def to_data
				@data
			end
			
			protected
				def parse(value)
					return nil if value.nil?
					value = value.data if value.is_a?(ReferenceValue)
					value = value.placeholder if value.is_a?(Item)
					raise "Placeholder required." unless value.is_a?(Placeholder)
					raise "Invalid reference type." unless value.type == field.type
					value
				end
		end
	end
end