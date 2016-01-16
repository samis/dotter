require 'dotter/backend'
module Dotter
  class StowBackend < Backend
    def stow(package)
      `stow -v #{package}`
    end
    def unstow(package)
      `stow -Dv #{package}`
    end
  end
end
