require 'pathname'
module Dotter
  module Utilities
    @@dotfiles_path = Pathname(File.expand_path('~/dotfiles'))
    def dotfiles_path
      @@dotfiles_path
    end

    def go_to_dotfiles
      Dir.chdir(@@dotfiles_path)
    end

    def package_path(package)
      @@dotfiles_path + package
    end
    @@dotter_path = @@dotfiles_path + 'dotter'
    @@public_repo_path = @@dotfiles_path + 'public'
    def dotter_path
      @@dotter_path
    end

    def repo_path(package)
      @backend.repository_path(package)
    end

    def index_path(package)
      @backend.index_path(package)
    end

    def all_package_names
      directory = Pathname.new(@@dotfiles_path)
      directories = directory.children.select(&:directory?)
      package_names = []
      directories.each do |directory|
        package_names.push(directory.basename)
      end
      package_names
    end
   end
end
