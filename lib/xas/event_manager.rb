module XAS
	class EventManager
		attr_reader :subscriptions
		
		def initialize
			@subscriptions = Hash.new
		end
		
		def trigger(event, args = nil)
			event = [event].flatten
			@subscriptions[event].each do |e|
				e.call(event, args)
			end
		end
		
		def on(*event, &block)
			event = [event].flatten
			@subscriptions[event] = [] if @subscriptions[event].nil?
			@subscriptions[event] << block
			@subscriptions[event]
		end
	end
end