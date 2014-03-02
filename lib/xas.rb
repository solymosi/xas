require "active_support/core_ext"
require "active_support/concern"
require "active_support/dependencies"

require "pry"

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)
#$LOAD_PATH.unshift File.dirname(__FILE__)

module XAS
	def self.start!
		Environment.initialize!
	end
end