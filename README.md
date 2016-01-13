# Dotter, a dotfiles manager using stow & git

[![Dependency Status](http://img.shields.io/gemnasium/samis/dotter.svg)](https://gemnasium.com/samis/dotter)
[![Code Climate](http://img.shields.io/codeclimate/github/samis/dotter.svg)](https://codeclimate.com/github/samis/dotter)
[![Gem Version](http://img.shields.io/gem/v/dotter_dotfiles.svg)](https://rubygems.org/gems/dotter_dotfiles)
![](http://ruby-gem-downloads-badge.herokuapp.com/dotter_dotfiles)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://samis.mit-license.org)
[![Badges](http://img.shields.io/:badges-5/5-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)


As the title explained, dotter is a tool to manage your dotfiles. It is written in ruby and uses the tools stow and git in order to manage your dotfiles effectively.
It wraps around both tools in order to achieve easy and effective management of dotfiles. Stow handles the symlinking of them while Git tracks the history.
It is very new, unfinished software that likely has multiple bugs. However, due to the specific tools used there is not too much risk with using it.

Due to the name 'dotter' already being used, the gem is available under the name 'dotter_dotfiles'. Install it with `gem install dotter_dotfiles`

To see all available commands, use `dotter help` or look at the list of commands below. All commands are implemented, but the clone command is dumb due to the difficulties
involved in reconstructing the entire structure and state ` ~/dotfiles` from a single, flat git repository.

I have been using this tool for a while now, and it has worked really well. However, there were a few issues which bugged me enough to think on them more.
This first issue is that stow has an automatic 'ignore list' that ignores certain directories like `.git`. 
This is unexpected and I made one of the design choices (stuffing the git metadata into `~/.dotter/gitrepos/<PACKAGE>` was it.) based around the fact that this did not happen.
The design decision above has caused multiple other issues such as limited git functionality and a really difficult-to-write accurate clone command.
There are other ways to manage dotfiles, but in the interests of not fixing stuff that isn't broken, I plan to seperate the stow/git specific code out and add in another method, likely based on [this](https://github.com/NorfairKing/super-user-spark) repository.

Commands:
```
  dotter add PACKAGE FILE                                    # Add a file from a package to the next commit of that package.
  dotter clone REPO_URL                                      # Clones the dotfiles / packages of the specified repository into ~/dotfiles. Will overwrite any existing data.
  dotter commit PACKAGE -m, --commit-message=COMMIT_MESSAGE  # Commit your changes to a Git-tracked package.
  dotter help [COMMAND]                                      # Describe available commands or one specific command
  dotter import PATH PACKAGE                                 # Imports a file or directory into the specified package
  dotter import_repo REPO_URL PACKAGE                        # Clones the specified git repository as the contents of the specified Package.
  dotter init                                                # Initialise the directory structure for ~/dotfiles
  dotter list                                                # List all packages present in ~/dotfiles
  dotter log PACKAGE                                         # View the commit log of a package.
  dotter publish PACKAGE                                     # Make a package available in your public dotfiles repository
  dotter reset PACKAGE                                       # Reset what will be commmitted in the next commit to the given package.
  dotter status PACKAGE                                      # Obtain the repository status of a Git-tracked package.
  dotter stow PACKAGE                                        # Stow the given package name.
  dotter track PACKAGE                                       # Begin tracking the given package with Git
  dotter unpublish PACKAGE                                   # Make a package private after publishing it.
  dotter unstow PACKAGE                                      # Unstow the given package name.
  dotter update PACKAGE                                      # Updates the specified package
  dotter update_all                                          # Updates all stowed packages.
  dotter version                                             # Print the dotter version
  dotter update_public                                       # Updates the contents of the public git repository and then pushes it
```
This project tries to follow [Semantic Versioning](http://semver.org/) but no guarantees are made in this regard.
## TODO
1. Refactor and clean up the code.
2. ~~Implement all unimplemented commands.~~
3. Make the `clone` command smarter
4. Implement error handling
5. Add any useful suggested features.
6. Port to Crystal so it can be a single executable.
