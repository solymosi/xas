module XAS
	module Model
		class ArrayValue < Value
			include Validation::Value::Collection
			
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
			
			def build(*args)
				item = field.type.new(*args)
				push item
				item
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
			
			def pairs
				Enumerator.new do |y|
					each_with_index.each { |v, k| y.yield [k, v] }
				end
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || @data.respond_to?(method)
			end
			
			protected
				def parse_array(value)
					raise "Value must be enumerable." unless value.nil? || value.is_a?(Enumerable)
					value.map { |i| parse(i) }
				end
		end
	end
end