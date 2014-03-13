module XAS
	module Eventful
		def self.included(base)
			base.send :include, Methods
			base.send :extend, Methods
		end
		
		module Methods
			def hooks
				own = @hooks || {}
				respond_to?(:superclass) && superclass.include?(Eventful) ? superclass.hooks.merge(own) : own
			end
			
			def trigger(event, *args)
				event = parse_event_argument [event].flatten
				Eventful.trigger :event, self, event, args unless self == Eventful
				event.map.with_index { |e, i| event[0..i] }.unshift([]).reverse.map { |i| hooks[i] }.flatten.compact.each do |e|
					e.call(event, *args)
				end unless hooks.nil?
			end
			
			def on(*event, &block)
				event = parse_event_argument event
				Eventful.trigger :hook, self, event unless self == Eventful
				@hooks ||= {}
				@hooks[event] ||= []
				@hooks[event] << block
			end
			
			def on_any(&block)
				on nil, &block
			end
			
			protected
				def parse_event_argument(event)
					event = [] if event.size == 1 && event.first.nil?
					event = event.first.split(".").map(&:to_sym) if event.size == 1 && event.first.is_a?(String)
					event = event.first if event.size == 1 && event.first.is_a?(Array)
					raise "Event identifier segments must be symbols." if event.any? { |i| !i.is_a?(Symbol) }
					raise "Event identifier segments cannot contain periods." if event.any? { |i| i.to_s.include?(".") }
					event
				end
		end
		
		extend Methods
	end
end