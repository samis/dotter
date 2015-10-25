module Dotter
	require 'dotter/utilities'
	class GitRepo
		def initialize(package,init=false)
			@package = package
			@project_path = Utilities.package_path(package)
			@metadata_path = Utilities.repo_path(package)
			@metadata_indexes_path = Utilities.index_path(package)
			unless init
				self.open()
			else
				self.init()
			end
		end
		def open()
			require 'git'
			@repo = Git.open(@project_path.to_s,  { :repository => @metadata_path.to_s, :index => @metadata_indexes_path.to_s})
		end
		def init()
			require 'git'
			@repo = Git.init(@project_path.to_s,  { :repository => @metadata_path.to_s, :index => @metadata_indexes_path.to_s})
		end
		attr_reader :repo
		attr_reader :project_path
		attr_reader :package
		attr_reader :metadata_path
		attr_reader :metadata_indexes_path
		def add(file)
			@repo.add(file)
		end
		def reset()
			@repo.reset()
		end
	end
end
