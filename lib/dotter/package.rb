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
			puts `stow -v #{@name}`
			@config.set_state(@name, 'stowed')
		end
		def unstow()
			go_to_dotfiles
			puts `stow -Dv #{@name}`
			@config.set_state(@name, 'unstowed')
		end
		def track()
			puts "Initialising Git repository for package #{package}"
			@repo = GitRepo.new(@name,true)
			puts "Repository for package #{@name} initialised. Git's metadata is stored in #{@repo.metadata_path.to_s}"
			@config.track(@name)
		end
		attr_reader :name
		attr_accessor :config
		attr_reader :repo
	end
end
