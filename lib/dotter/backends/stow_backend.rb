require 'dotter/backend'
module Dotter
  class StowBackend < Backend
    def stow(package)
      `stow -v #{package}`
    end
  end
end
