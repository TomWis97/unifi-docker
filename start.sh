#!/usr/bin/env bash
# Function to be called when SIGINT is received
stop_all () {
        checking=false
        echo "Stopping container..."
        /etc/init.d/unifi stop
        # Stop for the mongodb init script is broken. Pkilling as alternative.
        #/etc/init.d/mongodb stop
        pkill -SIGINT mongod
        mongopkill=$?
        if [ $mongopkill -eq 1 ]
        then
                echo "No mongod process running" >&2
        elif [ $mongopkill -eq 3 ]
        then
                echo "Fatal error when pkilling mongod" >&2
        fi
        checkrunning
        status=$?
        echo -n "Waiting for processes to be stopped"
        while [ $status -ne 3 ]
        do
                checkrunning
                status=$?
                echo -n '.'
        done
        echo 
        echo "Stopped all processes"
}

rec_sigint () {
        echo "SIGINT received. Stopping..."
        stop_all
        exit 0
}

checkrunning () {
        # Function for checking if unifi and mongodb are running.
        # Return codes: 0=all running, 1=unifi dead, 2=mongodb dead, 3=both dead

        /etc/init.d/unifi status > /dev/null
        unifistatus=$?
        /etc/init.d/mongodb status > /dev/null
        mongodbstatus=$?

        # (Obviously, I'm pretty new to bash scripting)
        if [[ $unifistatus -eq 0 && $mongodbstatus -eq 0 ]]
        then
                # Everything is running.
                return 0
        elif [[ $unifistatus -ne 0 && $mongodbstatus -eq 0 ]]
        then
                # Unifi is stopped
                return 1
        elif [[ $unifistatus -eq 0 && $mongodbstatus -ne 0 ]]
        then
                # Mongodb is stopped
                return 2
        elif [[ $unifistatus -ne 0 && $mongodbstatus -ne 0 ]]
        then
                # Mongodb and Unifi are stopped
                return 3
        fi
}

# Catch SIGINT (CTRL-C)
trap rec_sigint INT

# Start mongodb and unifi software
/etc/init.d/unifi start
/etc/init.d/mongodb start

checking=true

while [ checking ]
do
        checkrunning
        status=$?
        case $status in
                0)
                        echo "$0: Both are running"
                        ;;
                1)
                        echo "Unify stopped unexpectedly" >&2
                        stop_all
                        exit 1
                        ;;
                2)
                        echo "Mongodb stopped unexpectedly" >&2
                        stop_all
                        exit 2
                        ;;
                3)
                        echo "Mongodb and unifi are stopped unexpectedly" >&2
                        exit 3

        esac
        sleep 10
done

echo "Done!"
