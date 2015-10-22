 module Dotter
	 class Utilities
		def Utilities.go_to_dotfiles()
			dotfiles_path = File.expand_path('~/dotfiles')
			Dir.chdir(dotfiles_path)
		end
	end
end
