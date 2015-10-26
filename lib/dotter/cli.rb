require 'thor'
require 'dotter/utilities'
require 'dotter/gitrepo'
require 'dotter/version'
require 'dotter/configuration'
require 'pathname'
module Dotter
class CLI < Thor
	include Utilities
	desc "version", "Print the dotter version"
	def version
		puts "This is dotter #{Dotter::VERSION}"
	end
	desc "init", "Initialise the directory structure for ~/dotfiles"
	def init
		puts "Initialising ~/dotfiles"
		puts "Creating the dotfiles directory."
		FileUtils.mkpath(dotfiles_path)
		go_to_dotfiles
		puts "Creating the directory for the combined public dotfiles."
		FileUtils.mkpath('public')
		puts "Creating an initial package for dotter."
		FileUtils.mkpath('dotter/.dotter/gitrepos')
		FileUtils.mkpath('dotter/.dotter/indexes/')
	end
	desc "list", "List all packages present in ~/dotfiles"
	def list
		puts "List of packages in ~/dotfiles"
		directory_name = dotfiles_path
		directory = Pathname.new(directory_name)
		directories = directory.children.select { |c| c.directory? }
		package_names = []
		directories.each do |directory| 
			package_names.push(directory.basename)
		end
		package_names.each do |package| 
			puts package
		end
	end
	desc "stow PACKAGE", "Stow the given package name."
	def stow(package)
		config = Configuration.new
		package_config = config.package_config(package)
		if package_config['state'] == 'stowed'
			error "Package #{package} is already stowed."
			exit(1)
		end
		puts "Stowing package #{package}"
		go_to_dotfiles
		puts `stow -v #{package}`
		config.set_state(package, 'stowed')
	end
	desc "unstow PACKAGE", "Unstow the given package name."
	def unstow(package)
		puts "Unstowing package #{package}"
		go_to_dotfiles
		puts `stow -Dv #{package}`
		config = Configuration.new
		config.set_state(package, 'unstowed')
	end
	desc "track PACKAGE", "Begin tracking the given package with Git"
	def track(package)
		puts "Initialising Git repository for package #{package}"
		repo = GitRepo.new(package,true)
		puts "Repository for package #{package} initialised. Git's metadata is stored in #{repo.metadata_path.to_s}"
		config = Configuration.new
		config.track(package)
	end
	desc "publish PACKAGE", "Make a package available in your public dotfiles repository"
	def publish(package)
		puts "Making package #{package} public"
	end
	desc "unpublish PACKAGE", "Make a package private after publishing it."
	def unpublish(package)
		puts "Making package #{package} private again"
	end
	method_option :commit_message, :required => true, :aliases => "-m"
	method_option :all, :type => :boolean, :aliases => "-a"
	desc "commit PACKAGE", "Commit your changes to a Git-tracked package."
	def commit(package)
		puts "Committing the changes to package #{package} with commit message #{options.commit_message}."
		commit_message = options.commit_message
		repo = GitRepo.new(package)
		if options.all
			repo.commit_all(commit_message)
		else
			repo.commit(commit_message)
		end
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
	desc "status PACKAGE", "Obtain the repository status of a Git-tracked package."
	def status(package)
		metadata_path = repo_path(package)
		metadata_indexes_path = index_path(package)
		# Punt because it does this better than ruby-git.
		system({"GIT_DIR" => metadata_path.to_s, "GIT_INDEX_FILE" => metadata_indexes_path.to_s}, "git status")
	end
	desc "add PACKAGE FILE", "Add a file from a package to the next commit of that package."
	def add(package,file)
		puts "Marking #{file} to be committed for package #{package}"
		repo = GitRepo.new(package)
		repo.add(file)
    end
	desc "reset PACKAGE", "Reset what will be commmitted in the next commit to the given package."
	def reset(package)
		puts "Resetting what will be committed to package #{package}"
		repo = GitRepo.new(package)
		repo.reset()
	end
	desc "log PACKAGE", "View the commit log of a package."
	def log(package)
		puts "Obtaining the log of package #{package}"
		repo = GitRepo.new(package)
		repo.log.each do |commit|
			puts "[#{commit.date}] #{commit.message} (#{commit.author.name})"
		end
	end
end
end
