module XAS
	class Configuration
		def initialize(&block)
			@config = Hash.new
			instance_eval &block if block_given?
		end
		
		def load(path)
			instance_eval File.read(path), path
		end
		
		def has?(*names)
			!get(*names).nil?
		end
		
		def get(*names)
			raise "Name must be specified." unless names.any?
			@config[names.first].is_a?(self.class) && names.length > 1 ? @config[names.first].get(*(names.drop(1))) : @config[names.first]
		end
		
		def set(name, value)
			raise "Configuration name must be a symbol." unless name.is_a?(Symbol)
			@config[name] = value
		end
		
		def default(name, value)
			set(name, value) unless has?(name)
		end
		
		def group(name, &block)
			raise "Block required." unless block_given?
			@config[name] ||= self.class.new(&block)
			@config[name].instance_eval &block
		end
		
		def replace(name, &block)
			@config[name] = nil
			group(name, &block)
		end
		
		def keys
			@config.keys
		end
		
		def to_hash
			Hash[@config.map { |i| i.is_a?(self.class) ? i.to_hash : i }]
		end
	end
end