module XAS::Modules::Core
	module Model
		module Validations
			extend ActiveSupport::Concern
			
			included do
				@@validations = {}
			end
			
			def initialize(*args)
				@errors = {}
				super
			end
		end
	end
end