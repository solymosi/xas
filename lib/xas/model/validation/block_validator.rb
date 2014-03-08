module XAS
	module Model
		module Validation
			class BlockValidator < Validator
				attr_reader :block
				
				def initialize(options = {}, &block)
					super options, &nil
					@block = block
				end
				
				def validate(*args)
					block.call *args
				end
			end
		end
	end
end