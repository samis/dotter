require 'thor'
require 'dotter/utilities'
require 'dotter/gitrepo'
require 'dotter/version'
require 'dotter/configuration'
require 'dotter/package'
require 'dotter/publicgitrepo'
require 'dotter/foreigngitrepo'
require 'pathname'
require 'git'
module Dotter
  class CLI < Thor
    include Utilities
    def initialize(*args)
      super
      @backend = Configuration.new.backend
    end
    desc 'version', 'Print the dotter version'
    def version
      puts "This is dotter #{Dotter::VERSION}"
    end
    desc 'init', 'Initialise the directory structure for ~/dotfiles'
    def init
      puts 'Initialising ~/dotfiles'
      puts 'Creating the dotfiles directory.'
      FileUtils.mkpath(dotfiles_path)
      go_to_dotfiles
      puts 'Creating the directory for the combined public dotfiles.'
      FileUtils.mkpath('public')
      puts 'Creating an initial package for dotter.'
      FileUtils.mkpath('dotter/.dotter/gitrepos')
      FileUtils.mkpath('dotter/.dotter/indexes/')
      # If we don't do this now, we'll get a nasty exception if we ever access the configuration.
      FileUtils.touch('dotter/.dotter/Dotfile')
    end
    desc 'list', 'List all packages present in ~/dotfiles'
    def list
      puts 'List of packages in ~/dotfiles'
      all_package_names.each do |package|
        puts package
      end
    end
    desc 'stow PACKAGE', 'Stow the given package name.'
    def stow(package)
      package = Package.new(package, @backend)
      puts "Stowing package #{package}"
      begin
        puts package.stow
      rescue PackageAlreadyStowedError
        error "Package #{package} is already stowed."
        exit(1)
      end
    end
    desc 'unstow PACKAGE', 'Unstow the given package name.'
    def unstow(package)
      package = Package.new(package)
      puts "Unstowing package #{package}"
      begin
        puts package.unstow
      rescue PackageNotStowedError
        error "Package #{package} is not stowed."
        exit(1)
      end
    end
    desc 'track PACKAGE', 'Begin tracking the given package with Git'
    def track(package)
      puts "Initialising Git repository for package #{package}"
      package = Package.new(package)
      package.track
      puts "Repository for package #{package} initialised. Git's metadata is stored in #{package.repo.metadata_path}"
      puts 'Creating an initial snapshot to serve as a starting point.'
      repo = package.repo
      repo.add('.')
      repo.commit_all("Initial snapshot of the package's contents")
      puts 'Initial snapshot created.'
    end
    desc 'publish PACKAGE', 'Make a package available in your public dotfiles repository'
    def publish(package)
      puts "Making package #{package} public"
      public_repo = PublicGitRepo.new
      puts public_repo.add_package(package)
    end
    desc 'unpublish PACKAGE', 'Make a package private after publishing it.'
    def unpublish(package)
      puts "Making package #{package} private again"
      public_repo = PublicGitRepo.new
      public_repo.remove_package(package)
    end
    method_option :commit_message, required: true, aliases: '-m'
    method_option :all, type: :boolean, aliases: '-a'
    desc 'commit PACKAGE', 'Commit your changes to a Git-tracked package.'
    def commit(package)
      package = Package.new(package)
      if package.untracked?
        error "Package #{package} is not tracked by Git."
        exit 1
      end
      puts "Committing the changes to package #{package} with commit message #{options.commit_message}."
      commit_message = options.commit_message
      repo = package.repo
      if options.all
        repo.commit_all(commit_message)
      else
        repo.commit(commit_message)
      end
    end
    desc 'update PACKAGE', 'Updates the specified package. For packages imported from external repositories, also updates the repository.'
    def update(package)
      puts "Updating the contents / symlinks for package #{package}"
      package = Package.new(package)
      if package.unstowed?
        error "Package #{package} is not stowed and therefore cannot be updated."
        exit 1
      end
      package.update
    end
    desc 'update_all', 'Updates all stowed packages.'
    def update_all
      puts 'Updating all stowed packages'
      all_packages = []
      all_package_names.each do |package|
        all_packages.push(Package.new(package.to_s))
      end
      stowed_packages = all_packages.select(&:stowed?)
      stowed_packages.each do |package|
        puts "Updating #{package}"
        package.update
      end
    end
    desc 'update_public', 'Updates the contents of the public git repository and then pushes it'
    def update_public
      puts "Updating the public repository."
      public_repo = PublicGitRepo.new
      puts public_repo.update
      public_repo.push
    end
    desc 'import PATH PACKAGE', 'Imports a file or directory into the specified package'
    def import(path, package)
      puts "Importing #{path} into package #{package}"
      filepath = Pathname.new(File.expand_path(path))
      packagepath = package_path(package)
      FileUtils.mkpath(packagepath.to_s) unless Dir.exist?(packagepath.to_s)
      homepath = Pathname.new(File.expand_path('~'))
      relative_filepath = filepath.relative_path_from(homepath)
      complete_path = packagepath + relative_filepath
      FileUtils.copy(File.expand_path(path), complete_path.to_s)
      puts 'File imported successfully. Update the package to make the symlink.'
    end
    desc 'import_repo REPO_URL PACKAGE', 'Clones the specified git repository as the contents of the specified Package.'
    desc 'clone REPO_URL', 'Clones the dotfiles / packages of the specified repository into ~/dotfiles. Will overwrite any existing data.'
    def clone(repo_url)
      puts "Cloning repository #{repo_url} directly into ~/dotfiles"
      repo = Git.clone(repo_url, @@dotfiles_path.to_s)
      puts "Due to implementation difficulties, all the the commit history and state information will be lost."
      go_to_dotfiles
      `rm -rf .git`
      `rm -rf dotter/*`
      `touch dotter/Dotfile`
    end
    desc 'status PACKAGE', 'Obtain the repository status of a Git-tracked package.'
    def status(package)
      package = Package.new(package)
      if package.untracked?
        error "Package #{package} is not tracked by Git."
        exit 1
      end
      metadata_path = repo_path(package.to_s)
      metadata_indexes_path = index_path(package.to_s)
      # Punt because it does this better than ruby-git.
      system({ 'GIT_DIR' => metadata_path.to_s, 'GIT_INDEX_FILE' => metadata_indexes_path.to_s }, 'git status')
    end
    desc 'add PACKAGE FILE', 'Add a file from a package to the next commit of that package.'
    def add(package, file)
      package = Package.new(package)
      puts "Marking #{file} to be committed for package #{package}"
      begin
        repo = package.repo
        repo.add(file)
      rescue PackageNotTrackedError
        error "Package #{package} is not tracked by Git."
        exit(1)
      end
    end
    desc 'reset PACKAGE', 'Reset what will be commmitted in the next commit to the given package.'
    def reset(package)
      package = Package.new(package)
      puts "Resetting what will be committed to package #{package}"
      begin
        repo = package.repo
        repo.reset
      rescue PackageNotTrackedError
        error "Package #{package} is not tracked by Git."
        exit(1)
      end
    end
    desc 'log PACKAGE', 'View the commit log of a package.'
    def log(package)
      package = Package.new(package)
      puts "Obtaining the log of package #{package}"
      begin
        repo = package.repo
        repo.log.each do |commit|
          puts "[#{commit.date}] #{commit.message} (#{commit.author.name})"
        end
      rescue PackageNotTrackedError
        error "Package #{package} is not tracked by Git."
        exit(1)
      end
    end
  end
end
