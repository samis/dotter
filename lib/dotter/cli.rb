require 'thor'
module Dotter
class CLI < Thor
	desc "version", "Print the dotter version"
	def version
		require 'dotter/version'
		puts "This is dotter #{Dotter::VERSION}"
	end
	desc "init", "Initialise the directory structure for ~/dotfiles"
	def init
		puts "Initialising ~/dotfiles"
	end
	desc "list", "List all packages present in ~/dotfiles"
	def list
		puts "List of packages in ~/dotfiles"
		directory_name = File.expand_path('~/dotfiles')
		require 'pathname'
		directory = Pathname.new(directory_name)
		directories = directory.children.select { |c| c.directory? }
		package_names = []
		directories.each {|directory| package_names.push(directory.basename)}
		package_names.each {|package| puts package}
	end
	desc "stow PACKAGE", "Stow the given package name."
	def stow(package)
		puts "Stowing package #{package}"
		dotfiles_path = File.expand_path('~/dotfiles')
		Dir.chdir(dotfiles_path)
		puts `stow -v #{package}`
	end
	desc "unstow PACKAGE", "Unstow the given package name."
	def unstow(package)
		puts "Unstowing package #{package}"
		dotfiles_path = File.expand_path('~/dotfiles')
		Dir.chdir(dotfiles_path)
		puts `stow -Dv #{package}`
	end
	desc "track PACKAGE", "Begin tracking the given package with Git"
	def track(package)
		puts "Initialising Git repository for package #{package}"
	end
	desc "publish PACKAGE", "Make a package available in your public dotfiles repository"
	def publish(package)
		puts "Making package #{package} public"
	end
	desc "unpublish PACKAGE", "Make a package private after publishing it."
	def unpublish(package)
		puts "Making package #{package} private again"
	end
	desc "log PACKAGE", "Obtain the VCS log of a Git-tracked package."
	def log(package)
		puts "Obtaining git log for package #{package}"
	end
	desc "commit PACKAGE", "Commit your changes to a Git-tracked package."
	def commit(package)
		puts "Committing the changes to package #{package}"
	end
	desc "update PACKAGE", "Updates the specified package"
	def update(package)
		puts "Updating the contents / symlinks for package #{package}"
	end
	desc "update_all", "Updates all stowed packages."
	def update_all()
		puts "Updating all stowed packages"
	end
	desc "import PATH PACKAGE", "Imports a file or directory into the specified package"
	def import(path, package)
		puts "Importing #{path} into package {package}"
	end
	desc "import_repo REPO_URL PACKAGE", "Clones the specified git repository as the contents of the specified Package."
	def import_repo(repo_url, package)
		puts "Cloning repository #{repo_url} into package #{package}"
	end
	desc "clone REPO_URL", "Clones the dotfiles / packages of the specified repository into ~/dotfiles. Will overwrite any existing data."
	def clone(repo_url)
		puts "Cloning repository #{repo_url} directly into ~/dotfiles"
	end

end
end
