# glennbot

Glennbot performs these actions in order:
1. Picks a random number between 1 and N
2. Sleep that number of seconds
3. Connects to an IRC server
4. Joins a channel
5. Tells a joke
6. Quits



# Example
As an example, see the follow line. It is suitable to add to crontab. It will tell a joke to the specified channel once a day between 8:00 and 16:00. That should be sufficient for most uses.

0 8 * * * sh /path/to/glennbot/main.sh Glenn "#gbg4ever" 28800 /path/to/glennbot/ordvitsar.txt

