#!/bin/sh
echo Minecraft Monitor Installer
echo ===========================

if [ -f ~/Library/LaunchAgents/ca.tonyfield.minecraftmonitor.agent.plist ]; then
  echo "Unloading old agent"
  launchctl unload ~/Library/LaunchAgents/ca.tonyfield.minecraftmonitor.agent.plist
  echo "Removing old agent"
  rm ~/Library/LaunchAgents/ca.tonyfield.minecraftmonitor.agent.plist
else
  echo "Agent not present - no need to unload or uninstall"
fi
if [ -f ~/.minemon/minemon.sh ]; then
  echo "Removing script"
  rm ~/.minemon/minemon.sh
else
  echo "Script not present - no need to uninstall"
fi

if [ -d ~/.minemon ]; then
  echo "Removing installation directory"
  rm -rf ~/.minemon
else
  echo "Installation directory not present - no need to uninstall"
fi

echo "Uninstallation Complete\n"