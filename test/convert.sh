#!/bin/bash

# strict mode
set -u

# unmatching globs expand to the empty string
shopt -s nullglob

function run {
    if [ "$JUSTPRINT" = "0" ]; then
	$*
    else
	echo $*
    fi
}

function debug {
    [ "$DEBUG" != "0" ] && echo ". $@" >&2
}

function info {
    echo "$@" >&2
}

function warning {
    echo "WARNING: $@" >&2
}

function error {
    echo "ERROR: $@" >&2
}

function backup-file {
    local dfile=${1%.*}.backup.${1##*.}
    if [ -e $dfile ]; then
	warning "Backup file '$dfile' already exists.  Skipping."
    else
	cp $1 $dfile
    fi
    echo $dfile
}

function convert-tex {
    local sfile=$1
    local dfile=$2
    if [ "$JUSTPRINT" = "1" ]; then
	echo "Converting tex file $sfile to $dfile"
    else
	sed \
	    -e 's/\.gpi\.eps/.eps/' \
	    -e 's/\.gz\.eps/.eps/' \
	    $sfile > $dfile
    fi
}

function convert-graphics {
    for g in *.eps.gpi; do
	newg=${g//.eps.gpi/.gpi}
	info "Copying $g to $newg"
	run "${MV} $g $newg"
    done
}

function get-graphics {
# We'll handle the .fig.gpi case separately, if ever.  I was only using it in
# one place, and it never really worked very well, so I doubt anyone else is
# using it.
    echo *.{eps.gpi,eps.gz}
}

#------------------------------------------------------------------------------
# Main code
#------------------------------------------------------------------------------

# Get command-line parameters
declare -a workdirs

# Move command (for moving graphics files)
MV=mv
DEBUG=0
JUSTPRINT=0

for parm in "$@"; do
    arg=${parm#*=}
    case $parm in
	--justprint)
	    JUSTPRINT=1
	;;

	--debug=*)
	    if (( arg > 0 )); then
		DEBUG=1
	    fi
	    if (( arg > 1 )); then
		set -x
	    fi
	;;

	--mv=*)
	    cmdloc=`which $arg`
	    if [ "$cmdloc" != "" -a -e "$cmdloc" ]; then
		MV=$arg
	    else
		warning "Ignoring invalid move command '$arg'"
	    fi
	;;

	*)  
	    if [ -d $parm ]; then
		workdirs[${#workdirs}]=$parm
	    else
		warning "Ignoring non-directory '$parm'"
	    fi
	;;
    esac
done

if [ ${#workdirs} = '0' ]; then
    error "No directories specified.  Exiting"
    exit -1
fi

for workdir in ${workdirs[@]}; do
    debug "Changing to directory '$workdir'"
    pushd $workdir >/dev/null
    graphics=`get-graphics`
    debug "Found the following graphics files in '$workdir'"
    for g in $graphics; do
	debug $g;
    done

    if [ "$graphics" != "" ]; then
	    convert-graphics
    else
	warning "No graphics to convert in '$workdir'"
    fi
    info "Converting .tex files"
    for texfile in *.tex; do
	if [ "$texfile" = "${texfile/.backup//}" ]; then
	    debug "Converting '$texfile'"
	    backupfile=`backup-file $texfile`
	    convert-tex $backupfile $texfile "$graphics"
	else
	    debug "Ignoring backup '$texfile'"
	fi
    done
    popd >/dev/null
done

