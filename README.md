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

Besides directly symlinking, the tool can also 'mirror' a directory structure
by prefixing directories with '%'. This is also removed, just like the _ 
However, no period is used for the equivalent directory in the home directory.
This is used for mirorring a directory structure, whithout tracking every file
in the directory. You can selectevely make the directories.

'%' prefixes work in recursively. Inside mirrored folders, no prefix _ is
necessary for symlinking files. All child files and folders, except those prefixed by
%, are symlinked.


Checking for updates
--------------------
To update your settings with the git repo version, do as follows. 
Go to the ConfigFiles directories directory, and do git fetch or git pull
(the latter if you want to immeadiately merge new remote settings)

You can crontab this to make notifications or so. Or modify you bashrc.

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
