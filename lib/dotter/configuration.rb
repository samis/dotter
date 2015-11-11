require 'dotter/utilities'
require 'inifile'
module Dotter
	class Configuration
		include Utilities
		attr_reader :config_file
		attr_accessor :config
		def initialize(config_file=package_path('dotter') + '.dotter/Dotfile')
			@config_file = config_file
			@config = IniFile.load(config_file)
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
		def publish(package)
			package_conf = self.package_config(package)
			package_conf['public'] = true
			self.save()
		end
		def unpublish(package)
			package_conf = self.package_config(package)
			package_conf['public'] = false
			self.save()
		end
		def set_type(package, type)
			package_conf = self.package_config(package)
			package_conf['type'] = 'git_repo'
			self.save()
		end
	end
end
