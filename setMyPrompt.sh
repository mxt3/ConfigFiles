#!/bin/bash
# Sets PS1 to an informative
# source this in .bashrc

# --------------------
#  Options
# --------------------

# set options to empty string or comment to disable

PS1_ENABLE_SHH_CHECK=1	# Different color for machine if on ssh connection
PS1_ENABLE_LONG_DIR=1	# Print full dir name in first block
PS1_ENABLE_ERROR_CODE=1 # Show error code on command line if any
PS1_ENABLE_BG_BLOCK=1	# block for viewing jobs, tmux, screen sessions ...	
PS1_ENABLE_GIT_BLOCK=1	# git branch info using __git_ps1
PS1_ENABLE_TERM_TITLE=1	# Enable Display of current dir and jobs in title
PS1_ENABLE_PATH_ABBRV=1 # Enable abbreviating the working directory if it 
						# does not fit on the current line

# Abbreviate dir names longer than this:
PATH_ABBR_THRSHLD=4
# Indicator that the path has been abbreviated
# (avoid confusion if abbreviated dir has same name as existing one) 
PATH_ABBR_IND='~'
# If working dir path becomes longer than ($COLUMNS - $PATH_ABBR_MARGIN),
# then abbreviate
# TODO: better to just construct the string, and then check and redo?
PATH_ABBR_MARGIN=45

# Separator
SEP='-'

# Type of braces 
BR_O='['
BR_C=']'

# shell prompt sign
PS1_SIGN='$'

# --------------------
#  Color Definitions
# --------------------
# wrapping escape characters in  \[ \] helps bash ignoring them when counting
# the length of the prompt
# escape sequences itself start with \e, the escape character, and the code is
# encapsulated between [ and m, e.g \e[1m for bright text
DEFAULT='\[\e[0m\]'				# Remove all formatting
DEFAULT_COL='\[\e[22;21;39m\]'	# reset bright or dim, set default color
BLACK='\[\e[30m\]'
RED='\[\e[31m\]'
GREEN='\[\e[32m\]'
YELLOW='\[\e[33m\]'
BLUE='\[\e[34m\]'
MAGENTA='\[\e[35m\]'
CYAN='\[\e[36m\]'
LIGHTGRAY='\[\e[37m\]' # Often default
DARKGRAY='\[\e[90m\]'
LIGHTRED='\[\e[91m\]'
LIGHTGREEN='\[\e[92m\]'
LIGHTYELLOW='\[\e[93m\]'
LIGHTBLUE='\[\e[94m\]'
LIGHTMAGENTA='\[\e[95m\]'
LIGHTCYAN='\[\e[96m\]'
WHITE='\[\e[97m\]'

# --------------------------------------------------
#  Git PS1 options, see git-prompt.sh for details
# --------------------------------------------------

# __git_ps1 function always shows branch name if in git dir
export GIT_PS1_SHOWDIRTYSTATE=true		# show * and + next to branch name for
										# respectively unstaged and staged files
export GIT_PS1_SHOWSTASHSTATE=true		# show $ to indicate stashed stuff
export GIT_PS1_SHOWUNTRACKEDFILES=true	# show % for untracked files
export GIT_PS1_SHOWUPSTREAM=true		# show < > or <> to indicate relation:
										# local [sign] upstream
export GIT_PS1_SHOWCOLORHINTS=true		# hints about dirty state in color!

# --------------------
#  Code
# --------------------

# function for detecting jobs
# takes two variables arguments and sets these
# first becomes the count of background jobs
# second becomes the name if only one job is running
function detect_jobs()
{
	local __resultvar1=$1
	local __resultvar2=$2

	local BG_RUNNING_COUNT=$(jobs -r | wc -l)	# r restricts to running jobs, see help jobs

	# if only one task, also set the name
	if [[ $BG_RUNNING_COUNT == 1 ]]; then
		# the 4th word of the jobs -r output contains the name of the command
		# running in the background
		local JOBS_WORD_ARR=($(jobs -r))

		local INDEX_COMM_NAME=2
		if [[ $LANG =~ nl ]] ; then
			INDEX_COMM_NAME=3
		fi
		local BG_JOB_NAME=${JOBS_WORD_ARR[${INDEX_COMM_NAME}]}
	else
		local BG_JOB_NAME=''
	fi
	
	# set the arguments to return results
	eval $__resultvar1="'$BG_RUNNING_COUNT'"
	eval $__resultvar2="'$BG_JOB_NAME'"
}

# function for detecting screen/tmux sessions
# takes two arguments and sets these as variables
# fist is count of tmux detached sessions
# second is count of screen detached sessions
function detect_term_mux()
{
	local __resultvar1=$1
	local __resultvar2=$2

	# detect presence of tmux/screen
	# hash is bash built-in, check hash table with commands on path
	# when not found -> errors
	local haveTMUX=1
	local haveSCREEN=1
	# remember: zero value value is true in shell terms....
	hash tmux 2>/dev/null || haveTMUX=0
	hash screen 2>/dev/null || haveSCREEN=0
	
	if [[ $haveTMUX -eq 1 ]]; then
		# grep -c: counts matching line; -v: invert, so ignore lines containing
		# attack
		local CNT_TMUX=$(tmux ls 2> /dev/null | grep -i -c -v attach)	
	else
		local CNT_TMUX=0
	fi

	if [[ $haveSCREEN -eq 1 ]]; then
		local CNT_SCREEN=$(screen -ls 2> /dev/null | grep -c -i detach)
	else
		local CNT_SCREEN=0
	fi

	# set the arguments to return results
	eval $__resultvar1="'$CNT_TMUX'"
	eval $__resultvar2="'$CNT_SCREEN'"
}

# return 1 or nothing to stdout
function is_ssh_session()
{
	if [[ $SSH_CLIENT ]]; then
		echo 1
	fi
}

# Prompt block generator functions
# ----------------------------------------

# to generate the background block
# separators not included, delimiters are
function gen_str_bg_block()
{
	detect_jobs PS1_CNT_JOB PS1_JOB_NAME
	detect_term_mux PS1_CNT_TMUX PS1_CNT_SCREEN
	local BG_STR="${BR_O}"
	local ADD_SPACE=''

	# return immediately if block is empty
	if ! ([[ $PS1_CNT_SCREEN -gt 0 ]] || [[ $PS1_CNT_TMUX -gt 0 ]] ||\
		[[ $PS1_CNT_JOB -gt 0 ]]); then
		return
	fi

	BG_STR+=$MAGENTA

	if [[ $PS1_CNT_JOB -gt 0 ]]; then
		BG_STR+="j:${PS1_CNT_JOB}"
		ADD_SPACE=1
	fi

	if [[ $PS1_CNT_SCREEN -gt 0 ]]; then
		if [[ $ADD_SPACE ]]; then
			BG_STR+=' '
		fi
			BG_STR+="s:${PS1_CNT_SCREEN}"
			ADD_SPACE=1
	fi

	if [[ $PS1_CNT_TMUX -gt 0 ]]; then
		if [[ $ADD_SPACE ]]; then
			BG_STR+=' '
		fi
		BG_STR+="t:${PS1_CNT_TMUX}"
		ADD_SPACE=1
	fi

	BG_STR+=$DEFAULT
	BG_STR+="$BR_C"

	echo -n "$BG_STR"
}

# return string that puts "bash - (job_info)" in the title
# When one job, put name, otherwise put job count
# Let this string be appended to PS1
function gen_title_str()
{
	local TITLE_STR="\[\e]0;\W/"	
	detect_jobs PS1_CNT_JOB PS1_JOB_NAME
	if [[ $PS1_CNT_JOB -gt 0 ]]; then
		if [[ $PS1_CNT_JOB -gt 1 ]]; then
			TITLE_STR+=" - jobs: ${PS1_CNT_JOB}"
		else
			TITLE_STR+=" - ${PS1_JOB_NAME}"
		fi

		# end title string with necessary escape characters: bell + closing
		# don't count
	fi

	TITLE_STR+="\a\]"
	echo -n "$TITLE_STR"
}

# Shows error code and changes the prompt sign color when exit code != 0
# Takes one argument, the error code
function gen_error_ind_prompt_sign()
{
	local RESULT=$1
	local PROMPT="  ${PS1_SIGN} "
	if [[ $RESULT -ne 0 ]] ; then
		PROMPT="${DARKGRAY}(${RESULT}) ${RED}\$ ${DEFAULT}"
	fi
	echo -n "$PROMPT"
}


# Applying it
# ----------------------------------------

# the function to be called every time before the prompt is drawn
function my_prompt_command_func()
{
	# inform of error code on prompt line
	# hast to come first, as we need to get that error code
	local PS1_POSTFIX_GIT="\n$(gen_error_ind_prompt_sign $?)"
	if [[ -z $PS1_ENABLE_ERROR_CODE ]] ; then
		local PS1_POSTFIX_GIT="\n  ${PS1_SIGN} "
	fi

	local PS1_STATIC_BLOCK="\n${BR_O}${GREEN}\\u@"
	
	# SSH colorized machine name
	if [[ -n $PS1_ENABLE_SHH_CHECK ]] && [[ $(is_ssh_session) -eq 1 ]] ; then
		PS1_STATIC_BLOCK+="${CYAN}\\h"
	else
		PS1_STATIC_BLOCK+="\\h"
	fi

	# Add working directory
	PS1_STATIC_BLOCK+=" ${YELLOW}"
	if [[ -n $PS1_ENABLE_LONG_DIR ]] ; then
		local max_length=$(expr $COLUMNS - $PATH_ABBR_MARGIN)
		if [[ -n $PS1_ENABLE_PATH_ABBRV && (( $(expr length "$(dirs -0)") -gt $max_length )) ]]; then
			# abbreviated path
			PS1_STATIC_BLOCK+="$(dirs -0| sed -r "s|/([^/]{$PATH_ABBR_THRSHLD})[^/]+|/\1${PATH_ABBR_IND}|g")"
		else
			# full path
			PS1_STATIC_BLOCK+="\\w"
		fi
	else
			# only current dir
			PS1_STATIC_BLOCK+="\\W"
	fi
	PS1_STATIC_BLOCK+="${DEFAULT}${BR_C}"
	local PS1_PREFIX_GIT=$PS1_STATIC_BLOCK

	# second block with background task information
	local PS1_BG_BLOCK=''
	if [[ -n $PS1_ENABLE_BG_BLOCK ]] ; then
		PS1_BG_BLOCK="$(gen_str_bg_block)"
	fi
	if ! [[ -z $PS1_BG_BLOCK ]]; then
		PS1_PREFIX_GIT+="${SEP}${PS1_BG_BLOCK}"
	fi

	local PS1_GIT_BR_FORMAT="${SEP}${BR_O}%s${BR_C}"

	# Add title format string
	if [[ -n $PS1_ENABLE_TERM_TITLE ]] ; then
		PS1_PREFIX_GIT="$(gen_title_str)${PS1_PREFIX_GIT}"
	fi

	if [[ -n $PS1_ENABLE_GIT_BLOCK ]] ; then
		__git_ps1 "${PS1_PREFIX_GIT}" "${PS1_POSTFIX_GIT}"\
			 "${PS1_GIT_BR_FORMAT}"
	else
		PS1="${PS1_PREFIX_GIT}${PS1_POSTFIX_GIT}"
	fi
}

# __git_ps1 will set PS1
export PROMPT_COMMAND=my_prompt_command_func

