module XAS
	module Model
		extend ActiveSupport::Concern
		include Validation
		
		def values
			@values || {}
		end
		
		def value(name)
			@values ||= {}
			@values[name] ||= self.class.fields[name].create_value unless self.class.fields[name].nil?
			values[name]
		end
		
		def to_hash
			Hash[values.map { |n, v| [n, v.to_hash] }]
		end
		
		def to_data
			Hash[values.map { |n, v| [n, v.to_data] }]
		end
		
		def load(values)
			raise "Hash required." unless values.is_a?(Hash)
			clear
			values.deep_symbolize_keys.each do |name, data|
				next unless self.class.has_field?(name)
				val = value(name)
				data = Placeholder.new(val.field.type, data) if !data.nil? && val.is_a?(ReferenceValue)
				data = val.field.from_hash(data) if val.field.respond_to?(:from_hash)
				val.set(data)
			end
			self
		end
		
		def clear
			@values = {}
		end
		
		def method_missing(method, *args, &block)
			name = method.to_s.ends_with?("=") ? method.to_s[0...-1].to_sym : method
			unless self.class.fields[name].nil?
				return value(name).set(*args) if method.to_s.ends_with?("=")
				return value(name).get(*args)
			end
			super
		end
		
		def respond_to?(method)
			name = method.to_s.ends_with?("=") ? method.to_s[0...-1].to_sym : method
			super || !self.class.fields[name].nil?
		end
		
		module ClassMethods
			def fields
				own = @fields || {}
				superclass.include?(Model) ? superclass.fields.merge(own) : own
			end
			
			def has_field?(name)
				fields.include?(name.to_sym)
			end
			
			def field(name, klass, options = {})
				raise "Field '#{name.to_s}' already defined." if has_field?(name)
				@fields ||= {}
				@fields[name.to_sym] = klass.ancestors.include?(Field) ? klass.new(options) : Field.new(options.reverse_merge(:type => klass))
			end
			
			def field_array(name, klass, options = {})
				field name, ArrayField, options.reverse_merge(:type => klass)
			end
			
			def field_hash(name, klass, options = {})
				field name, HashField, options.reverse_merge(:type => klass)
			end
			
			def field_group(name, options = {}, &block)
				block = Proc.new {} unless block_given?
				return fields[name.to_sym].merge_definition(&block) if has_field?(name) && fields[name.to_sym].is_a?(GroupField)
				field name, GroupField, options.merge(:definition => block)
			end
			
			def field_group_array(name, options = {}, &block)
				field = fields[name.to_sym]
				block = Proc.new {} unless block_given?
				return field.options[:group].merge_definition(&block) if has_field?(name) && field.is_a?(ArrayField) && field.options[:group].is_a?(GroupField)
				group = GroupField.new(:definition => block)
				field_array name, group.model, options.merge(:group => group)
			end
			
			def field_group_hash(name, options = {}, &block)
				field = fields[name.to_sym]
				block = Proc.new {} unless block_given?
				return field.options[:group].merge_definition(&block) if has_field?(name) && field.is_a?(HashField) && field.options[:group].is_a?(GroupField)
				group = GroupField.new(:definition => block)
				field_hash name, group.model, options.merge(:group => group)
			end
		
			def reference(name, klass, options = {})
				field name, ReferenceField, options.reverse_merge(:type => klass)
			end
			
			def from_hash(values)
				self.new.load(values)
			end
		end
	end
end