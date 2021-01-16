#!/bin/bash
VERSION="1.0a"
SCRIPT=$( basename $0 )
#mkdir /var/log/mosdaemon
LOG="/var/log/mosdaemon$DATE"
DATE="["$(date -u)"]"
touch $LOG
#
# This software is distrobuted under the GNU General Public License version 3.0 which is available at http://www.gnu.org/licenses/gpl-3.0.html
# 
usage()
{

    local txt=( 
        "Usage:"
        "Utility $SCRIPT (daemon) to automatically start a mineos server in case of a crash"
        "Usage: $SCRIPT <option> servername"
        "Options:"
        "-h --help      shows this page "
        "-q --quit      exits the daemon, note this will not kill the server"
        "-s --start     starts the daemon for chosen server"
        "-v --version   shows the current script version"
        "-g --get-state gets the state of the currently running instance"
        "-l --log-out   sets a custom log output file (this is mostly used if command is run as root and perms go shit)"
        "--forcequit   stops the current session (includes the server)"
    )
        printf "%s\n" "${txt[@]}"
    

}
# This function is the main part of the script as it checks if server is up and else starts it

screen_state() {

    if ! screen -list | grep -q $2; then
        sleep 1s
    else
        echo $DATE"server appears to be offline, attempting startup" >> $LOG
        cd /usr/games/minecraft/
        node mineos_console.js -s $2 start
        if $? == 1 
        then
            echo "$DATE server started successfully, continuing..." >> $LOG
        else 
            echo "$DATE server will not start successfully, exiting..." >> $LOG
            exit 0
        fi
    fi
}

#
# function that displays the error message if the command fails
#
badUsage() 
{
local message="$1"
local txt="use option -h or --help to display help page"

$message && printf "$message\n"
echo "${txt[@]}"
}

#
# function that displays the current version
#
version() 
{
	local txt="$SCRIPT version $VERSION"
	
	printf "%s\n" "${txt[@]}"

}

forcequit() {

    echo "$DATE forcequit command executed, stopping server..." >> $LOG
    cd /usr/games/minecraft/
    node mineos_console.js -s $2 stop
    if $? == 1 
    then 
        exit 0
    else 
        echo "$DATE forcequit has failed, check server log." >> $LOG
    fi

}

get_state() {

    if ! screen -list | grep -q $2; 
    then
        echo "$DATE server is up." 
    else
        echo "$DATE server is down."
    fi
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
        ;;
        --start | -s)
            screen_state
            exit 0
        ;;

        --quit | -q)
            echo "$DATE script soft-killed through --quit parameter" >> $LOG
            exit 1
        ;;

        --get-state | -g)
            echo "$DATE get-state parameter executed, output state" >> $LOG
            get_state
            exit 0
        ;;

        --forcequit)
            forcequit
        ;;

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
---EOF---



        