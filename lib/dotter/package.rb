require 'dotter/utilities'
require 'dotter/configuration'
module Dotter
	class Package
		include Utilities
		def initialise(name)
			@name = name
		end
		def stow()
			go_to_dotfiles
			puts `stow -v #{@name}`
			configuration = Configuration.new
			configuration.set_state(@name, 'stowed')
		end
		attr_reader :name
		attr_accessor :config
end
