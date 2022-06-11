#/bin/bash
# 
# Script: laufwerke.sh 
# Beschreibung: Dieses Python3-Script listet angeschlossene Laufwere mit ihrer eigenen SATA-Geschwindigkeit
# und der Geschwindkeit des SATA-Ports auf. Das Script hilft dabei, bei mehreren Laufwerken in einem Rechner
# diese Laufwerke optimale auf die verfügbaren SATA-Ports zu verteilen.
# Autor: David Wolski, LinuxWelt (pcwelt@gmail.com).

# preflight checks: is ' strings' available?

if ! [ -x "$(command -v strings)" ]; then
  echo "Entschuldigung: Befehl 'strings' ist nicht verfügbar. Bitte installieren Sie das Paket 'binutils'." >&2
  exit 1
fi

# Create table header

printf "\nModell\t\t\t\tSATA-Link\t\t\t     SATA-Speed\n"
printf '%s\n' '-------------------------------------------------------------------------------'

# Fill table by looping through ATA-links in /sys/class/ata_link/:
for i in `grep -l Gbps /sys/class/ata_link/*/sata_spd`; do
    device="${i%/*}"/device/dev*/ata_device/dev*/id
    idbytes="$(cat $device)"
    #Modell-Bezeichnung decodieren und ausgeben:
    printf "$idbytes"| perl -nE 's/([0-9a-f]{2})/print chr hex $1/gie' | echo `strings` | cut -d ' ' -f 2-6 | cut -c -28 | tr -d "\n"
    #SATA-Link-Nummer ausgeben:
    printf "\t${i%/*}\t     "
    speed=$(printf `cat $i`)
    #SATA Link-Speed ausgeben: 
    printf "$speed Gbit/s\n"
done
    printf "\n"
