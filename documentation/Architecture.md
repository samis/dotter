# Dotter Architecture
Seeing as it is planned for dotter to support multiple ways of organising and managing dotfiles, it is important that these ways are seperate and structured in order to keep the code readable, modular and maintainable.
Therefore, this planned version will have 3 'layers' in order to achieve this.

## Layer 1: CLI Interface
This is the highest-level layer and the only one that the user directly interacts with. It is responsible for presenting the set of commands with which the user performs actions and translating any given actions into calls to the next layer below.
It is also responsible for initialising the configuration and backend(s). The final responsibility is handling any errors that may bubble up from lower layers.

## Layer 2: API
This is the middle layer of the program. It provides a set of classes/objects that manipulate the collection of dotfiles in a backend-agnotic way. 
The main responsibility of this layer is taking 1 or more actions from the CLI layer and then perform some sanity checking before instructing the configured backend to actually perform the action. 
It is also responsible from taking any resulting errors from the backend and transforming them into equivalent errors to be propagated back up to the CLI layer. 

## Layer 3: Backend
The most low-level layer is the backend layer. This is responsible for implementing each action for a specific tool / method. Where a one-to-one mapping does not exist between the action to execute and actions provided by the tool then the action may be emulated.
Should a tool simply not have a corresponding action and emulating / creating one is too difficult, then it could simply fail with an error when called. Minimal processing of command output is done, and the same goes for errors. Examples of backends would be the current combination of stow with git, or super-user-spark with git. 
