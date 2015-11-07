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

To see all available commands, use `dotter help`. Not all commands are currently implemented.
This project tries to follow [Semantic Versioning](http://semver.org/) but no guarantees are made in this regard.
## TODO
1. Refactor and clean up the code.
2. Implement all unimplemented commands.
3. Implement error handling
4. Add any useful suggested features.
5. Port to Crystal so it can be a single executable.
