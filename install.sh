#!/bin/sh
sh ./remove.sh

installdir=$HOME/.minemon
echo "Installing script into $installdir"
mkdir -p $installdir
cp minemon.sh $installdir/minemon.sh
chmod +x $installdir/minemon.sh
mkdir -p $installdir/log
mkdir -p $installdir/data

# Tech note:
# For now, install as a launch agent
# In the future we might want to change this to a daemon, but that would require elevated access, and time tracking per user.
# We'll see if bypassing it becomes a problem.

echo "Installing agent into $HOME/Library/LaunchAgents"
cp ca.tonyfield.minecraftmonitor.agent.plist $HOME/Library/LaunchAgents
plistfile=$HOME/Library/LaunchAgents/ca.tonyfield.minecraftmonitor.agent.plist
ESCAPED_REPLACE=$(printf '%s\n' "$installdir" | sed -e 's/[\/&]/\\&/g')
sed -i.bak "s/__INSTALLDIR__/$ESCAPED_REPLACE/g" $plistfile >> $plistfile

if [ "$1" -eq "$1" ] 2>/dev/null
then
  echo "Time limit set to $1 minutes"
  sed -i.bak "s/__TIMELIMIT__/$1/g" $plistfile >> $plistfile
else
  echo "Time limit set to 45 minutes. To set a different time, run install.sh with followed by the number of minutes: $ install.sh 45"
  sed -i.bak "s/__TIMELIMIT__/45/g" $plistfile >> $plistfile
fi

echo "Cleaning up"
rm ${plistfile}.bak

echo "Loading agent"
launchctl load $plistfile
#echo "Starting agent"
#launchctl start ca.tonyfield.minecraftmonitor.agent
echo "Checking agent (status 0 is good)"
launchctl list | grep 'PID\|ca.tonyfield.minecraftmonitor.agent'
echo "Installation complete\n"