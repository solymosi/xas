module XAS
	module Model
		class ArrayValue < Value
			def initialize(*args)
				super
				@data = []
			end
			
			def get
				self
			end
			
			def set(value)
				@data = parse_array(value)
			end
			
			def push(value)
				@data.push parse(value)
			end
			
			alias_method :<<, :push
			
			def concat(array)
				@data.concat parse_array(array)
			end
			
			def to_hash
				get.map { |i| i.respond_to?(:to_hash) ? i.to_hash : i }
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			protected
				def parse_array(value)
					raise "Value must be enumerable." unless value.nil? || value.is_a?(Enumerable)
					value.map { |i| parse(i) }
				end
		end
	end
end