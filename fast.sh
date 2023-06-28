#!/usr/bin/env bash
# script LinuxWelt; author: David Wolski <pcwelt@gmail.com>;

cat <<HEREDOC

Dieses Script dient dazu, einen Geschwindigkeitstest der Internetverbindung
mit den Servern von fast.com (Netflix) als Gegenstelle durchzuführen. Dabei
werden rund 1,22 GB Daten übertragen (Download) bevor das Script beendet wird.

Voraussetzungen: Das Script setzt die Tools "pv", "curl" und "mkfifo" voraus,
die sich in den Paketquellen nahezu aller Linux-Distributionen finden.

HEREDOC

# preflight checks: is ' strings' available?

if ! [ -x "$(command -v pv)" ]; then
  echo "Entschuldigung: Programm 'pv' ist nicht verfügbar. Bitte installieren Sie das Paket 'pv'." >&2
  exit 1
fi

if ! [ -x "$(command -v mkfifo)" ]; then
  echo "Entschuldigung: Programm 'mkfifo' ist nicht verfügbar. Bitte installieren Sie das Paket 'coreutils'." >&2
  exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
  echo "Entschuldigung: Programm 'curl' ist nicht verfügbar. Bitte installieren Sie das Paket 'curl'." >&2
  exit 1
fi

printf "Starte Verbindungstest...\n"

mkfifo /tmp/fast.com.test.fifo;token=$(curl -s https://fast.com/app-ed402d.js|egrep -om1 'token:"[^"]+'|cut -f2 -d'"'); curl -s "https://api.fast.com/netflix/speedtest?https=true&token=$token" |egrep -o 'https[^"]+'|while read url; do first=${url/speedtest/speedtest\/range\/0-2048}; next=${url/speedtest/speedtest\/range\/0-26214400};(curl -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com' "$first" > /tmp/fast.com.test.fifo; for i in {1..10}; do curl -s -H 'Referer: https://fast.com/' -H 'Origin: https://fast.com'  "$next">>/tmp/fast.com.test.fifo; done)& done & pv /tmp/fast.com.test.fifo > /dev/null; rm /tmp/fast.com.test.fifo
