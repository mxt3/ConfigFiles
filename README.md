Configuration Repo Vim and dotfiles
====================================
This repo contains my preferred configuration files for several unix tools. A
script in the root of this repo creates symlinks to the config files here from the
home directory. Run the correct script (platform dependent) after cloning the
directory to your preferred location.

Structure
----------
The dotfiles that have to be copied to the home directory are free files
in this repo starting with an underscore _ instead of a dot. When creating
symlinks, the underscore are automatically replaced by dots.

### Vim
The .vim\ configuration folder is stored under the folder _vim\

Linux Install
-------------
Run the script setupSymLinks.sh from the root directory of this repo. It asks for
permission before overwriting existing files.

Windows Install
-------------
Run the script setupSumLinks.ps1 from the root directory of this repo. It asks for 
permission before overwriting existing files. Administrator privileges are
usually necessary to make symlinks (except if Developer Mode is enabled in
Windows 10 Creators Update and later, with the right options).

Todo
------
* Support for ~\Config\ new style of configuration files.
* ...
