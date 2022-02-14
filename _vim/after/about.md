# About the after/ folder

Vim plugins here are intended to be run after the ones in the folder
one hierarchy higher. They do not completely override a previous
plugin, but rather add a specific configuration, change a few options
etc.

The plugin/ and ftplugin/ folders in .vim/ folder, however, are
integral part of the vim  search path. These folders normally
precede the builtin path of $VIMRUNTIME, and therefore override the
default behavior, as these plugins are found first. (Good plugins stop
the search when found).

After this process, vim will still load the plugins in the after/
folder.

References:
* <https://vi.stackexchange.com/questions/12731/when-to-use-the-after-directory>
