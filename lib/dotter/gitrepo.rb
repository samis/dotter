require 'git'
module Dotter
  require 'dotter/utilities'
  class GitRepo
    include Utilities
    def initialize(package, init = false, bare = false)
      @package = package
      @project_path = package_path(package)
      @metadata_path = repo_path(package)
      @metadata_indexes_path = index_path(package)
      unless init
        open
      else
        self.init(bare)
      end
    end

    def open
      @repo = Git.open(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s)
      @log = @repo.log
    end

    def init(bare = false)
      unless bare
        @repo = Git.init(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s)
      else
        @repo = Git.init(@project_path.to_s, repository: @metadata_path.to_s, index: @metadata_indexes_path.to_s, bare: true)
      end
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
