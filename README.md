macOS Minecraft Monitoring Script
=================================
##### Created August 15th 2020 by Tony Field tony@tonyfield.ca
##### Version 1.0

Minecraft does not play well with Apple's Screen Time.  This makes it extremely difficult to enforce screen time usage.

This script monitors Minecraft usage each day and will automatically shut down the game when usage exceeds a specific time limit.

Users are warned to save their work and exit the game several times once the time remaining falls below one minute.

The default time limit is 45 minutes, but this can be changed at installation.

Usage statistics are tallied for the whole day, no matter how many times Minecraft is restarted.

The script utilizes CPU time, not "real time".  Thus if the game is currently sitting idle or doing very little, it will measure less than one minute of usage compared to the actual time. Similarly, when the game is hard at work and utilizing more than 100% of a single CPU core, usage time will increment faster than real time.  Expectations of the user should be set accordingly, and based on usage patterns, limits may need to be refined.  In practice, it seems to be pretty close and within about 50%. YMMV.

### Supported macOS versions

The script has been verified to work on macOS 10.15.5 (catalina)

### Installation
Download a release and then run install.sh.
~~~
sh ./install.sh
~~~
or
~~~
sh ./install.sh <number of minutes allowed>
~~~

### Uninstallation

Download a release and run remove.sh

~~~
sh ./remove.sh
~~~

### Source Code
https://github.com/tfield/minemon
