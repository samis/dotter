require 'dotter/backend'
module Dotter
  class StowBackend < Backend
    @@dotfiles_path = Pathname(File.expand_path('~/dotfiles'))
    @@dotter_path = @@dotfiles_path + 'dotter'
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
  end
end
