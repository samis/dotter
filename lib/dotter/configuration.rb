require 'dotter/utilities'
require 'dotter/backends/stow_backend'
require 'inifile'
module Dotter
  class Configuration
    include Utilities
    attr_reader :config_file
    attr_accessor :config
    def initialize(config_file = package_path('dotter') + '.dotter/Dotfile')
      @config_file = config_file
      @config = IniFile.load(config_file)
    end

    def package_config(package)
      @config[package]
    end

    def save
      @config.write
    end

    def set_state(package, state)
      package_conf = package_config(package)
      package_conf['state'] = state
      save
    end

    def track(package)
      package_conf = package_config(package)
      package_conf['tracked'] = true
      save
    end

    def publish(package)
      package_conf = package_config(package)
      package_conf['public'] = true
      save
    end

    def unpublish(package)
      package_conf = package_config(package)
      package_conf['public'] = false
      save
    end

    def set_type(package, type)
      package_conf = package_config(package)
      package_conf['type'] = type
      save
    end
    def set_url(package,url)
      package_conf = package_config(package)
      package_conf['url'] = url
      save
    end
    def get_backend()
      Dotter::StowBackend.new
    end
  end
end
