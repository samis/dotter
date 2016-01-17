require 'git'
module Dotter
  require 'dotter/utilities'
  class GitRepo
    include Utilities
    def initialize(package, init = false)
      @package = package
      @project_path = package_path(package)
      @metadata_path = repo_path(package)
      @metadata_indexes_path = index_path(package)
      @backend = Configuration.new.backend
    end

    def open
      @repo = @backend.get_package_repository(@package)
      @log = @repo.log
    end

    def init(bare = false)
      @repo = @backend.create_package_repository(@package)
    end
    attr_reader :repo
    attr_reader :project_path
    attr_reader :package
    attr_reader :metadata_path
    attr_reader :metadata_indexes_path
    attr_reader :log
    def add(file)
      @repo.add(file)
    end

    def reset
      @repo.reset
    end

    def commit_all(commit_message)
      @repo.commit_all(commit_message)
    end

    def commit(commit_message)
      @repo.commit(commit_message)
    end
  end
end
