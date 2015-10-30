require 'git'
require 'dotter/utilities'
require 'dotter/gitrepo'
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
		def add_package(package)
			Dir.chdir(@project_path)
			packagerepo = GitRepo.new(package)
			package_repo = packagerepo.repo
			@repo.add_remote(package.to_s, package_repo)
			subtree_output = `git subtree add --prefix #{package.to_s} #{package.to_s} master`
			subtree_output
		end
		attr_reader :repo
	end
end
