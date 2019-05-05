Configuration Repo Vim and dotfiles
====================================
This repo contains my preferred configuration files for several unix tools. A
script in the root of this repo creates symlinks to the config files here from the
home directory. Run the correct script (platform dependant) after cloning the
directory to your prefered location.

Structure
----------
The dotfiles that have to be coppied to the home directory are free files
in this repo starting with an underscore _ instead of a dot. When creating
symlinks, the underscore are automatically replaced by dots.

### Vim
The .vim\ configuration folder is stored under the folder _vim\

Linux Install
-------------
Run the scrip setupSymLinks.sh from the root directory of this repo. It asks for
permission before overwitting existing files.

Windows Install
-------------
TODO: make script
Bla bla script

Todo
------
* Support for ~\Config\ new style of configuration files.
* ...
