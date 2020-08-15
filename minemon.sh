#!/bin/bash
# Minecraft Monitoring Script
# ===========================
# Created August 15th 2020 by Tony Field
# Version 1.0
#
# This script automatically kills minecraft if it has used more than a specified amount of CPU time.  The player
# is warned several times when one minute is remaining, so that they can save their work.  The app terminates (kills)
# Minecraft if it is not gracefully shut down first.
#

export minecraftTimeLimit=$1
if [ -z $minecraftTimeLimit ]
then
  minecraftTimeLimit=30
fi

initDataFolder() {
  export dataFolder="`dirname \"$0\"`"/data/$(date +%Y-%m-%d)
  mkdir -p ${dataFolder}
}

checkMinecraftMinutes() {
  initDataFolder
  currentMinecraftPidMinutes

  totalMins=0
  arr=($dataFolder/*)

  for((i=0; i < ${#arr[@]}; i++)); do
    if [ -f ${arr[$i]} ]; then
      thisFileMin=$(<${arr[$i]})
      totalMins=$(($totalMins+$thisFileMin))
    fi
  done
  export minecraftMinutes=$totalMins

  JPID=$(jps -l | grep net.minecraft.client.main.Main | cut -d " " -f 1)
  if [ -z "$JPID" ]; then
    echo "`date` Minecraft has been running for $minecraftMinutes minutes today. Time limit is $minecraftTimeLimit minutes. It is not currently running." > /dev/null
  else
    echo "`date` Minecraft has been running for $minecraftMinutes minutes today. Time limit is $minecraftTimeLimit minutes."
  fi
}

currentMinecraftPidMinutes() {
  JPID=$(jps -l | grep net.minecraft.client.main.Main | cut -d " " -f 1)
  if [ -z "$JPID" ]; then
    export currentProcessMinecraftMinutes=0
  else
    MCTIME=$(ps -p $JPID -o time=)
    MCTIME=$(echo $MCTIME | sed -e 's/^[[:space:]]*//')
    IFS=: read -r minute second <<<"$MCTIME"
    echo $minute > $dataFolder/$JPID
    export currentProcessMinecraftMinutes=$minute
  fi
}

checkMinecraftRunning() {
  JPID=$(jps -l | grep net.minecraft.client.main.Main | cut -d " " -f 1)
  if [ -z "$JPID" ]; then
    export minecraftRunning=false
  else
    export minecraftRunning=true
  fi
}

killMinecraft() {
  JPID=$(jps -l | grep net.minecraft.client.main.Main | cut -d " " -f 1)
  if [ -z "$JPID" ]; then
    echo "`date` No need to kill Minecraft - it is not running"
  else
    echo "`date` Killing Minecraft"
    kill $JPID
    osascript -e "display alert \"Minecraft Terminated\" message \"Minecraft was forced to shut down because it was running longer than the allowed limit of $minecraftTimeLimit minutes.\""
  fi
}

ensureMinecraftNotRunningTooLong() {
  checkMinecraftMinutes

  if [ $minecraftMinutes -gt $minecraftTimeLimit ]; then
    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      shutdownWarning 60 15
    fi

    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      shutdownWarning 45 15
    fi

    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      shutdownWarning 30 10
    fi

    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      shutdownWarning 20 10
    fi

    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      shutdownWarning 10 10
    fi

    checkMinecraftRunning
    if [ $minecraftRunning = true ]; then
      killMinecraft
    fi
  fi
}

shutdownWarning() {
  osascript -e "display notification \"$minecraftTimeLimit minute time limit exceeded. Save your work now. Forced shutdown in $1 seconds.\" with title \"Minecraft Time Limit\" sound name \"Submarine\""
  echo "`date` $1 second warning..."
  sleep $2
}



ensureMinecraftNotRunningTooLong
