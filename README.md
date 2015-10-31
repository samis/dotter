# Dotter, a dotfiles manager using stow & git

As the title explained, dotter is a tool to manage your dotfiles. It is written in ruby and uses the tools stow and git in order to manage your dotfiles effectively.
It wraps around both tools in order to achieve easy and effective management of dotfiles. Stow handles the symlinking of them while Git tracks the history.
It is very new, unfinished software that likely has multiple bugs. However, due to the specific tools used there is not too much risk with using it.

Due to the name 'dotter' already being used, the gem is available under the name 'dotter_dotfiles'. Install it with `gem install dotter_dotfiles`

To see all available commands, use `dotter help`. Not all commands are currently implemented.

## TODO
1. Refactor and clean up the code.
2. Implement all unimplemented commands.
3. Implement error handling
4. Add any useful suggested features.
5. Port to Crystal so it can be a single executable.
