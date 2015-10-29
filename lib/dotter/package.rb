require 'dotter/utilities'
require 'dotter/configuration'
module Dotter
	class Package
		include Utilities
		def initialize(name)
			@name = name
			@config = Configuration.new
			@our_config = @config.package_config(@name)
		end
		def stow()
			go_to_dotfiles
			puts `stow -v #{@name}`
			@config.set_state(@name, 'stowed')
		end
		def unstow()
			go_to_dotfiles
			puts `stow -Dv #{@name}`
			@config.set_state(@name, 'unstowed')
		end
		attr_reader :name
		attr_accessor :config
	end
end
