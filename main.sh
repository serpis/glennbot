#!/bin/bash

# Usage:
#    sh main.sh <nick> <channel> <maxsleep> <ordvitspath>

NICK=$1
TARGET_CHANNEL=$2
MAX_SLEEP=$3
ORDVITS_PATH=$4

RAND_SEC=$(shuf -i 1-$MAX_SLEEP -n 1)
echo sleeping $RAND_SEC
sleep $RAND_SEC


ORDVITS=$(shuf -n 1 $ORDVITS_PATH)


in_fifo=$(mktemp -u)
out_fifo=$(mktemp -u)

mkfifo $in_fifo
mkfifo $out_fifo

echo $in_fifo $out_fifo

nc port80.se.quakenet.org 6667 < $in_fifo > $out_fifo &

# open in fifo as FD 3
exec 3> $in_fifo

FIRST=1

while read LINE; do
	LINE=$(echo $LINE | dos2unix)
	COMMAND=$(echo $LINE | cut -d " " -f 1)
	ARGS=$(echo $LINE | cut -d " " -f 2-)

	if [ "$FIRST" -eq 1 ]; then
		echo -n "NICK $NICK\r\n" >&3
		echo -n "USER glenn * * :Glenn\r\n" >&3
		FIRST=0
	fi
	
	if [ "$COMMAND" = "PING" ]; then
		echo -n "PONG $ARGS\r\n" >&3
	fi

	if [ "$ARGS" = "MODE Glennbot +i" ]; then
		echo "Connected! Sending joke and quitting."
		echo -n "JOIN $TARGET_CHANNEL\r\n" >&3
		echo -n "PRIVMSG $TARGET_CHANNEL :$ORDVITS\r\n" >&3
		echo -n "QUIT :Ha dé gött /Glenn\r\n" >&3
		break
	fi
done < $out_fifo

# close FD
exec 3>&-

# remove named pipes
rm $in_fifo $out_fifo


