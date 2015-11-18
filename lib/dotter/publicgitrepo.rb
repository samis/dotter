require 'git'
require 'dotter/utilities'
require 'dotter/gitrepo'
module Dotter
  class PublicGitRepo
    include Utilities
    def initialize(init = false)
      @project_path = package_path('public')
      unless init
        open
      else
        self.init
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
      other_package = Package.new(package)
      packagerepo = other_package.repo
      package_repo = packagerepo.repo
      @repo.add_remote(package.to_s, package_repo)
      subtree_output = `git subtree add --prefix #{package.to_s} #{package.to_s} master`
      conf = Configuration.new
      conf.publish(package)
      subtree_output
    end

    def remove_package(package)
      Dir.chdir(@project_path)
      # This was broken with ruby-git. Someone else should check.
      `git remote remove #{package}`
      FileUtils.remove_dir(package)
      @repo.commit_all('Removed package #{package}')
      conf = Configuration.new
      conf.unpublish(package)
    end
    attr_reader :repo
  end
end
