#!/bin/bash

##https://dbwebb.se/kunskap/create-bash-script-with-options-commands-and-arguments
# options are start, stop, restart
VERSION="1.0.2b"
SCRIPT=$( basename "$0" )
cd /usr/games/minecraft/
#
# function that displays the help page
#
usage()
{
        local txt=(
        "Utility $SCRIPT for starting a mineos server"
        "Usage: $SCRIPT [start][stop][restart]"
        "Command:"
        "start		starts server"
        "stop		stops server"
        "restart	restarts a running server"
        
        "Options:"
        "--version -v  prints the current version "
        "--help -h 	prints this  page "
        )
        printf "%s\n" "${txt[@]}"

}
#
# function that displays the error message if the command fails
#
badUsage() 
{
local message="$1"
local text="use option -h or --help to display help page"

$message && printf "$message\n"
printf "%n" "${txt[@]}"
}

#
# function that displays the current version
#
version() 
{
	local txt="$SCRIPT version $VERSION"
	
	printf "%s\n" "${txt[@]}"

}

while (( $# ))
do 
	case "$1" in

		--help | -h)
			usage
			exit 0
		;;

		--version | -v)
			version
			exit 0
	esac
done

while (( $# ))
do
	case "$1" in
	
	*)
		badUsage "Option/command not recognized."
		exit 1
	;;

	esac
done

badUsage
exit 1

done

while (( $# ))
do
	case "$1" in
		
		start		\
		| stop		\
		| restart	\
			command=$1
			shift
			app-$command $*
			exit 0
		;;

	esac
done

function app-start
{
	node mineos_console.js -s $2 start
	exit 0
}

function app-stop
{
	node mineos_console.js -s $2 stop
	exit 0
}

function app-restart
{
	node mineos_console.js -s $2 restart
	exit 0
}

end

---EOF---

