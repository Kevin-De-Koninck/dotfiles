# Use gnome-shell desktop manager
sudo yum install gnome-tweak-tool gnome-shell-extension-workspace-indicator -y

# .vnc/xstartup:
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
gnome-session

# Start it
vncserver -kill :1
vncserver -geometry 1920x1100 -depth 24

# open gui, go to tweaks, extensions -> workspace indicator

# use Xfce desktop manager
sudo yum groupinstall "Server with GUI" -y
sudo yum groupinstall -y "Xfce"

# .vnc/xstartup:

#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
xfce4-session

# start it
vncserver -kill :1
vncserver -geometry 1920x1100 -depth 24
