require 'dotter/utilities'
require 'parseconfig'
module Dotter
	class Configuration
		attr_reader :config_file
		attr_accessor :config
		def initialize(config_file=Utilities.package_path('dotter') + '.dotter/Dotfile')
			@config_file = config_file
			@config = ParseConfig.new(@config_file.to_s)
		end
		def package_config(package)
			@config[package]
		end
	end
end
