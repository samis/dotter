 module Dotter
	 class Utilities
		@@dotfiles_path = Pathname(File.expand_path('~/dotfiles')) 
		 def Utilities.go_to_dotfiles()
			Dir.chdir(@@dotfiles_path)
		end
		def Utilities.package_path(package)
			@@dotfiles_path + package
		end
		@@dotter_path = Utilities.package_path('dotter')
		def Utilities.repo_path(package)
			@@dotter_path + '.dotter/gitrepos/' + package 
		end
		def Utilities.index_path(package)
			@@dotter_path + '.dotter/indexes/' + package
		end
	 end
end
