# find all files and folders starting with _ 
getFiles () {
	local pattern='_(.*)'
	local cnt=0
	result=''
	for f in * ; do
		if [[ $f =~ $pattern ]] ; then
			let cnt=cnt+1
			local name="${BASH_REMATCH[1]}"
			result="$result $name"
		fi
	done
	echo "Found $cnt config files or directories in repo"
}

# make symlinks for all found files
makeLinks () {
	#expects as arguments the differen files/folders to make a symlink for
	echo "This utility will symlink files and folders staring with _ in this folder to home"
	#echo "The underscore will be replaced by ."
	echo "Proceed? (y/n)"
	read resp
	if [[ $resp =~ ^[Yy](es)*$ ]] ; then
		for it in $@ ; do
			local target="$(pwd)/_$it" 
			local link="$HOME/.$it"

			#file check
			if [ -f $link -o -d $link ] ; then
				echo "The file $link already exists, overwrite? (y/n)"
				read resp
				if [[ ! $resp =~ ^[Yy](es)*$ ]] ; then
					continue
				fi
			fi	
			
			echo "Making link $link ..."
			ln -sf -T $target $link 
		done
	else
		echo "Canceled by user..."
	fi
}

#Vundle is a submodule
git submodule init
git submodule update

# geFiles stores the results in $result variable
getFiles
pwd
makeLinks $result
