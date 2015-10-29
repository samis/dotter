require 'dotter/utilities'
require 'dotter/configuration'
require 'dotter/gitrepo'
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
			returned_output =  `stow -v #{@name}`
			@config.set_state(@name, 'stowed')
			returned_output
		end
		def unstow()
			go_to_dotfiles
			returned_output =  `stow -Dv #{@name}`
			@config.set_state(@name, 'unstowed')
			returned_output
		end
		def track()
			@repo = GitRepo.new(@name,true)
			@config.track(@name)
		end
		def stowed?()
			@our_config['state'] == 'stowed'
		end
		def unstowed?()
			!self.stowed?
		end
		attr_reader :name
		attr_accessor :config
		attr_reader :repo
	end
end
