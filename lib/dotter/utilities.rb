 module Dotter
	 module Utilities
		@@dotfiles_path = Pathname(File.expand_path('~/dotfiles')) 
		def dotfiles_path
			@@dotfiles_path
		end
		def go_to_dotfiles()
			Dir.chdir(@@dotfiles_path)
		end
		def package_path(package)
			@@dotfiles_path + package
		end
		@@dotter_path = @@dotfiles_path + 'dotter'
		def dotter_path
			@@dotter_path
		end
		def repo_path(package)
			@@dotter_path + '.dotter/gitrepos/' + package 
		end
		def index_path(package)
			@@dotter_path + '.dotter/indexes/' + package
		end
	 end
end
