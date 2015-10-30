require 'git'
require 'dotter/utilities'
module Dotter
	class PublicGitRepo
		include Utilities
		def initialize(init=false)
			@project_path = package_path('public')
			unless init
				self.open()
			else
				self.init()
			end
		end
		def open
			@repo = Git.open(@project_path.to_s)
		end
		def init
			@repo = Git.init(@project_path.to_s)
		end
	end
end
