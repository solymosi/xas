module XAS
	class EventService
		attr_reader :subscriptions
		
		def initialize
			@subscriptions = Hash.new
		end
		
		def trigger(event, *args)
			event = parse_event_argument([event].flatten)
			event.map.with_index { |e, i| event[0..i] }.unshift([]).reverse.map { |i| @subscriptions[i] }.flatten.compact.each do |e|
				e.call(event, *args)
			end
		end
		
		def on(*event, &block)
			event = parse_event_argument(event)
			@subscriptions[event] = [] if @subscriptions[event].nil?
			@subscriptions[event] << block
			@subscriptions[event]
		end
		
		def on_any(&block)
			on(nil, &block)
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
end