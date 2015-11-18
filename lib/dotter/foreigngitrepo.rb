require 'git'
require 'dotter/utilities'
module Dotter
  class ForeignGitRepo < GitRepo
    def initialize(package, init = false, source_repository = '')
      @package = package
      @project_path = package_path(package)
      @origin = source_repository
      unless init
        open
      else
        self.init(source_repository)
      end
    end

    def init(source_url)
      @repo = Git.clone(source_url, @project_path.to_s)
    end

    def open
      @repo = Git.open(@project_path)
      @log = @repo.log
    end

    def update
      @repo.pull
    end
  end
end
