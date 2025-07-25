#!/bin/bash

export SUBJECT="Dl01 vpn"
export MAILRCV="claytonzane@gmail.com"
export MSG="Dl01 vpn is down, restart the script!"
counterfile="check_vpn.cnt"

pid="$(ssh -i ~/.ssh/vpnchk vpnchk@dl01.steininho.com "pgrep vpn")"

# check that pid is a valid integer, otherwise set to 1
if ! [[ "$pid" =~ ^[0-9]+$ ]]; then
  pid=1
fi

# pid will be above 1000 if the process is running on dl01
if (( $pid < 1000 )); then
  echo "VPN-script is not running."
  # If the counterfile doesn't exist, then create counterfile and add 1, then send mailalert.
  if ! [ -f check_vpn.cnt ]; then
    echo "$MSG" | mail -v -s "$SUBJECT" $MAILRCV >/dev/null 2>&1
    echo 1 > $counterfile
    echo "Alertmail sent. Counterfile created."
  else
    # If the counterfile does exist, read the current counter and add 1.
    # If the counter is above 47 (after 24 hour downtime, with script run every 30 mins), reset the counterfile and send mailalert.
    counter=$(<check_vpn.cnt)
    if (( counter > 47 )); then
      export MSG="Dl01 vpn is still down, restart the script!"
      echo "$MSG" | mail -v -s "$SUBJECT" $MAILRCV >/dev/null 2>&1
      echo 1 > $counterfile
      echo "VPN has been down for 24 hours, resetting counter and sending alertmail."
    else
      counter=$((counter+1))
      echo $counter > $counterfile
      echo "Current counter: $counter".
    fi
   fi
else
  # Delete counter-file if it exists, else do nothing.
  if [ -f $counterfile ]; then
    echo "VPN-script is running again. Deleting counterfile."
    rm $counterfile
  else
    echo "VPN-script is running."
  fi
fi