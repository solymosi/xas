module XAS
	module Model
		class HashValue < Value
			include Validation::Value::Collection
			
			def initialize(*args)
				super
				@data = {}
			end
			
			def get
				self
			end
			
			def set(value)
				@data = parse_hash(value)
			end
			
			def build(key, *args)
				item = field.type.new(*args)
				store(key, item)
				item
			end
			
			def store(key, value)
				@data.store parse_key(key), parse(value)
			end
			
			alias_method :[]=, :store
			
			def merge!(hash, &block)
				@data.merge! parse_hash(hash), &block
			end
			
			def to_hash
				Hash[get.map { |k, i| [k, i.respond_to?(:to_hash) ? i.to_hash : i] }]
			end
			
			def to_data
				Hash[get.map { |k, i| [k, i.respond_to?(:to_data) ? i.to_data : i] }]
			end
			
			def pairs
				each_pair
			end
			
			def method_missing(method, *args, &block)
				@data.respond_to?(method) ? @data.send(method, *args, &block) : super
			end
			
			def respond_to?(method)
				super || @data.respond_to?(method)
			end
			
			protected
				def parse_key(key)
					raise "Key must be a symbol." unless key.is_a?(Symbol)
					key
				end
				
				def parse_hash(value)
					raise "Value must be a hash." unless value.nil? || value.is_a?(Hash)
					Hash[value.map { |k, i| [parse_key(k), parse(i)] }]
				end
		end
	end
end