#!/bin/bash

if [[ -z "$DESTINATIONS" ]]; then
    echo "DESTINATIONS is required in the format of either <destip>:<destport>:<localport> or <destip>:<destport> (localport will default to destport for the 2nd format)"
    exit 1
fi

echo "# This file is auto-generated $0 upon container run based on environment variable DESTINATIONS" > /etc/rinetd.conf

if [[ -n "$LOGFILE" ]]; then
    echo "logfile $LOGFILE" >> /etc/rinetd.conf
    if [[ -n "$LOGCOMMON" ]]; then
        echo "logcommon" >> /etc/rinetd.conf
    fi
fi

ISVALID=0
readarray -d ' ' -t DESTINATIONS_ARR <<<"$DESTINATIONS"
for DEST in "${DESTINATIONS_ARR[@]}"
do
    readarray -d ':' -t DESTARR <<<"$DEST"
    if [[ ${#DESTARR[@]} -lt 2 ]]; then
        echo "Ignoring destination $DEST as it is in invalid format. Must be either <destip>:<destport>:<localport> or <destip>:<destport>"
    else
    	DSTIP=$(echo ${DESTARR[0]} | tr -d '[:space:]')
    	DSTPORT=$(echo ${DESTARR[1]} | tr -d '[:space:]')
        if [[ ${#DESTARR[@]} -gt 2 ]]; then
            LOCPORT=$(echo ${DESTARR[2]} | tr -d '[:space:]')
        else
            LOCPORT=$DSTPORT
        fi
        echo "0.0.0.0 $LOCPORT $DSTIP $DSTPORT" >> /etc/rinetd.conf
	ISVALID=1
    fi 
done

if [[ $ISVALID -eq 0 ]]; then
    echo "Error! No valid destination found in DESTINATIONS variable."
    exit 1
fi

/usr/sbin/rinetd -f -c /etc/rinetd.conf
