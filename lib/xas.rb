require "active_support/core_ext"
require "active_support/concern"
require "active_support/dependencies"

require "pry"
require "hashr"

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

module XAS
	def self.config(path)
		Environment.config.load(path)
	end
	
	def self.start!
		Environment.start!
	end
end