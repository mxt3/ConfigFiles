#!/bin/bash
# setupSymLinks.sh
# Setup sym links to dotfiles and configuration directories living in this git repo

# Two kind of files: distinction made on starting charcterc
# * starting with the LNK_FILE_PREFIX_CHR = '_' : These are to be symlinked in the home directory with
#   same relative path to home as the relative path to the ConfigFile path.
# * starting with the MIRROR_DIR_PREFIX_CHR = "%" : These mirror a directory with these same relative path
#	to $HOME as compared to the ConfigFiles direcotroy (same name in $HOME, #   but prefixed with this char).
#
# In the root of ConfigFiles, the LNK_FILE_PREFIX_CHR is necessary for file to be picked up by the script.
# However, in subdirectories, the necessity of this character depends on the IS_SUBDIR_LNK_CHAR -flag.

# determines if the files in subdirectories need the LNK_FILE_PREFIX_CHR prefixed to be linked to the home directory.
readonly IS_SUBDIR_LNK_CHAR=false

# Patterns
# important: the ^ to mark begin of basepath
patternLnkFiles="^_(.+)" 
patternNotMirrorDir="^([^%/].+)"
patternMirrorDir="^%(.+)"

# global array to keep track of mirror directories
mirrorDirStack=()


# find all files and folders starting with _ 
# result is stored in $result global
getFiles () {
	local pattern='_(.*)'
	getFilesPattern "$pattern" "./"
}

# get files matching pattern in requested directory (non-recursive)
# arg1: the posix regex pattern
# arg2: the directory 
# retult: the global $result variable contains list with files
getFilesPattern () {
	local pattern=$1
	local path="$2"
	local cnt=0
	result=''
	# echo $path
	# echo $pattern

	# exit on empty dir
	if [[ -z "$(ls $2 )" ]]; then
		return 0
	fi

	local path_glob="$path/*"
	for f in $path_glob ; do
		f=$(basename $f)
		# echo "Current file to check: $f"
		if [[ $f =~ $pattern ]] ; then
			let cnt=cnt+1
			local name="${BASH_REMATCH[1]}"
			result="$result $name"
		fi
	done
	echo "Found $cnt config files or directories in current dir"
	# echo $result
}

# get user acknowledgement
# returns result by use of reStella Kyriakides turn statement: check $? to continue (0=Yes)
# ARG1 : (optional) question to be asked
getUserAck () {
	if [ $# -lt 1 ] ; then
		local msg="Proceed?"
	else
		local msg="$1"
	fi

	echo "$msg (y/n)"
	read resp
	if [[ $resp =~ ^[Yy](es)?$ ]] ; then
		return 0
	fi
	return 1
}

# make symlinks for a list of files
# Arg1 : bool. If true, use dot prefix for link, and _ prefix for target name 
# Folowing ARGS: as arguments the different files/folders to make a symlink for
makeLinks () {
	local isPrefixedLink=$1
	shift

	if [[ ${#mirrorDirStack[@]}  -gt 0  ]] ; then 
		local targetPath="$(pwd)$(printf "/%%%s" ${mirrorDirStack[@]})"
		local linkPath="$HOME$(printf "/%s" ${mirrorDirStack[@]})"
	else
		local targetPath="$(pwd)"
		local linkPath="$HOME"
	fi

	for it in $@ ; do

		# do we need prefixes?
		if [[ "$isPrefixedLink" = true ]]; then
			local target="$targetPath/_$it" 
			local link="$linkPath/.$it"
		else
			local target="$targetPath/$it" 
			local link="$linkPath/$it"
		fi

		#file check
		if [ -f $link -o -d $link ] ; then
			getUserAck "The file $link already exists, overwrite?"
			if [[ $? != 0 ]] ; then
				# skip this file, go to next
				continue
			fi
		fi	
		
		echo "Making link $link ..."
		echo "Target: $target"
		ln -sf -T $target $link 
	done
}

# recursvie function to make configuration links
# ARG1 : the current source directory
# ARG2 : Link only files starting with 'make-link' pattern
linkConfigDir() {
	local currDir=$1
	local inRootDir=$2

	echo "Recursive call in dir $currDir"

	# Find files for linking
	if [[ "$2" = true ]]; then
		# if yes: get list of _ files
		getFilesPattern "$patternLnkFiles" "$currDir"
		local lnkFiles=$result	
	else
		# if no: get list of all files not starting with %
		getFilesPattern "$patternNotMirrorDir" "$currDir"
		local lnkFiles=$result	
	fi


	#link the lnkFiles
	makeLinks "$2" "$lnkFiles"

	#recursive on the MirrorDirs
	echo "Looking for mirror dirs"

	# make a list of directories for which this func has to be called recursively.
	getFilesPattern "$patternMirrorDir" "$currDir"
	local mirrorDirs=""
	# filter only directories
	for f in $result; do
		# note the %-sign: the pattern matching does NOT return this, but orginal dir has this
		local checkDir="$currDir/%$f" 
		if [[ -d $checkDir ]]; then
			mirrorDirs+=" $f"
		fi
	done

	for dr in $mirrorDirs ; do
		mirrorDirStack+=( $dr )
		# check if target dir exists, and make it if necessary
		local targetDir=$(printf "/%s" ${mirrorDirStack[@]} )
		mkdir -p "$HOME$targetDir"

		linkConfigDir "$currDir/%$dr" false
		# unset 'mirrorDirStack[-1]'
		unset 'mirrorDirStack[${#mirrorDirStack[@]}-1]'
	done
	echo "Exiting $currDir"
}


#Vundle is a submodule
# git submodule init
# git submodule update

# geFiles stores the results in $result variable
echo "This utility will symlink files and folders from the ConfigFiles repo to \$HOME"
getUserAck
if [ $? = 0 ]; then
	linkConfigDir "./" true	
fi
