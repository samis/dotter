require 'dotter/utilities'
require 'dotter/configuration'
require 'dotter/gitrepo'
require 'dotter/errors'
module Dotter
  class Package
    include Utilities
    def initialize(name, backend=Configuration.new.backend)
      @name = name
      @backend = backend
      @config = Configuration.new
      @our_config = @config.package_config(@name)
      if self.tracked?
        @repo = GitRepo.new(name)
      end
    end

    def stow
      go_to_dotfiles
      if self.stowed?
        raise PackageAlreadyStowedError
      end
      returned_output = @backend.stow(@name)
      @config.set_state(@name, 'stowed')
      returned_output
    end

    def unstow
      go_to_dotfiles
      if self.unstowed?
        raise PackageNotStowedError
      end
      returned_output = @backend.unstow(@name)
      @config.set_state(@name, 'unstowed')
      returned_output
    end

    def track
      @repo = GitRepo.new(@name, true)
      @config.track(@name)
    end

    def update
      go_to_dotfiles
      returned_output = @backend.update(@name)
    end

    def stowed?
      @our_config['state'] == 'stowed'
    end

    def unstowed?
      !self.stowed?
    end

    def tracked?
      @our_config['tracked']
    end

    def untracked?
      !self.tracked?
    end

    def to_s
      @name
    end

    def public?
      @our_config['public'] == true
    end

    def private?
      !self.public?
    end
    def repo
      unless self.untracked?
        raise PackageNotTrackedError
      end
      @repo
    end
    attr_reader :name
    attr_accessor :config
  end
end
