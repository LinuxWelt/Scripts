#!/bin/bash
# Script: gnomeidle.sh
# Author: LinuxWelt; author: David Wolski <pcwelt@gmail.com>;
# Beschreibung: Dieses Script dient zur Prozesssteuerung in einem Terminal-Fenster unter Gnome mit Wayland.
# Ein angegebener Befehl, Shell-Programm oder Script wird nur ausgeführt, wenn Gnome ohne Benutzereingaben
# im Leerlauf ist. Während Benutzeraktivität wird der Prozess pausiert.

# Quit, wenn kein Parameter angegeben

if [ $# -eq 0 ]; then
    >&2 echo "Kein Befehl oder Programm angegeben. Quit."
    exit 1
fi

( kill -STOP $BASHPID ; exec "$@" ) & TASKPID=$!
while $(kill -0 $TASKPID 2>/dev/null); do
# Diese Abfrage ermittelt, wie lange die Gnome-Shell unter Wayland (Compositor Mutter) schon inaktiv ist, in Millisekunden
get_idle_time=`dbus-send --print-reply --dest=org.gnome.Mutter.IdleMonitor /org/gnome/Mutter/IdleMonitor/Core org.gnome.Mutter.IdleMonitor.GetIdletime`
idle_time=$(echo $get_idle_time | awk '{print $NF}')
if [[ $idle_time -ge 2000 ]]; then
# Prozess fortsetzen
kill -CONT $TASKPID 2>/dev/null
else
# Prozess pausieren
kill -STOP $TASKPID 2>/dev/null & IDLEPID=$!
fi
done

printf "\nFertig!\n"
