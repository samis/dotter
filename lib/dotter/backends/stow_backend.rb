require 'dotter/backend'
module Dotter
  class StowBackend < Backend
    include Utilities
    def stow(package)
      `stow -v #{package}`
    end
    def unstow(package)
      `stow -Dv #{package}`
    end
    def update(package)
      `stow -Rv #{package}`
    end
    def repository_path(package)
      @@dotter_path + '.dotter/gitrepos/' + package
    end
    def index_path(package)
      @@dotter_path + '.dotter/indexes/' + package
    end
    def get_package_repository(package)
      @project_path = package_path(package)
      @metadata_path = repo_path(package)
      @metadata_indexes_path = index_path(package)
      repo = Git.open(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s)
    end
    def create_package_repository(package, bare=false)
      @project_path = package_path(package)
      @metadata_path = repo_path(package)
      @metadata_indexes_path = index_path(package)
      unless bare
        @repo = Git.init(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s)
      else
        @repo = Git.init(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s, bare: true)
      end
  end
end
