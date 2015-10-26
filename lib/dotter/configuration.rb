require 'dotter/utilities'
require 'inifile'
module Dotter
	class Configuration
		include Utilities
		attr_reader :config_file
		attr_accessor :config
		def initialize(config_file=package_path('dotter') + '.dotter/Dotfile')
			@config_file = config_file
			@config = IniFile.load(@config_file.to_s)
		end
		def package_config(package)
			@config[package]
		end
		def save()
			@config.write()
		end
		def set_state(package, state)
			package_conf = self.package_config(package)
			package_conf['state'] = state
			self.save()
		end
		def track(package)
			package_conf = self.package_config(package)
			package_conf['tracked'] = true
			self.save()
		end
	end
end
