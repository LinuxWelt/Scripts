#!/usr/bin/env python3
#
# Script: laufwerke.py 
# Beschreibung: Dieses Python3-Script listet angeschlossene Laufwerke mit ihrer eigenen SATA-Geschwindigkeit
# und der Geschwindigkeit des SATA-Ports auf. Das Script hilft dabei, bei mehreren Laufwerken in einem Rechner
# diese Laufwerke optimale auf die verfügbaren SATA-Ports zu verteilen.
# Autor: David Wolski, LinuxWelt (pcwelt@gmail.com).

import os
import re
import textwrap
import subprocess
import shutil
import json
from glob import glob

callsubprocesssmartctl = 1

#convert bytes to K, M, G, T
def convert_bytes(bytes):
    bytes=float(bytes)
    if bytes>=1099511627776:B=bytes/1099511627776;convert_bytes='%.1fT'%B
    elif bytes>=1073741824:C=bytes/1073741824;convert_bytes='%.1fG'%C
    elif bytes>=1048576:D=bytes/1048576;convert_bytes='%.1fM'%D
    elif bytes>=1024:E=bytes/1024;convert_bytes='%.1fK'%E
    else:convert_bytes='%.1fb'%bytes
    return convert_bytes

#check for sudo or root
if not os.environ.get("SUDO_UID") and os.geteuid() != 0:
    print("Dieses Script verlangt zum Aufruf von \"smartctl\" nach root- oder sudo-Privilegien. Bitte erneut mit sudo starten.")
    callsubprocesssmartctl = 0
#check for smartctl
if shutil.which("smartctl") is None:
    print("Das Programm \"smartctl\" aus dem Paket \"smartmontools\" ist nicht vorhanden.\nBitte das Paket installieren und das Script erneut aufrufen.")
    callsubprocesssmartctl = 0

if callsubprocesssmartctl == 0:
    print("Es werden folgend unvollständige Informationen ohne 'smartctl' angezeigt.")

#print table:
print ("\n{:<13} {:<8} {:<21} {:<10} {:<9} {:<6}".format('SATA-','','','SATA', 'Speed', 'Port'))
print ("{:<13} {:<8} {:<21} {:<10} {:<9} {:<6}".format('Laufwerk','Grösse','Modell','Version', 'Laufwerk', 'Speed'))
print ("-------------------------------------------------------------------------------")

for path in glob('/sys/block/*'):
    #bestimmte Laufwerke, Ramdisks und Loopback-Devices ignorieren. big if-loop!
    if not any(map(path.__contains__, ["/loop", "/zram", "/dm-", "/md", "/mmc", "/nvme"])):
        name = '/dev/'+re.sub('/sys/block/', '', path)
        #internal or external drive?
        with open(path+'/removable') as f:
            if f.read(1) == '1':
                internal = str('Nein')
            else:
                internal = str('Ja')
        #calculate size
        platz=convert_bytes(512 * int(open(path+'/size','r').read()))

        #model
        try:
            bezeichnung=str.strip(open(path+'/device/model','r').read())
        except:
            bezeichnung="Unbekannt"       
        #collect SATA info from smartstl (JSON output)
        speed = "N/A"
        port = "N/A"  
        sataversion = "N/A"
        if callsubprocesssmartctl == 1:
            try:
                output = subprocess.check_output(["smartctl", "-a", name, "--json"])
                smartctldata = json.loads(output)
                try:
                    sataversion = smartctldata['sata_version']["string"]
                except KeyError:
                    sataversion = "N/A"
                try:
                    speed = re.sub(' ', '', smartctldata['interface_speed']["current"]["string"])
                except KeyError:
                    speed = "N/A"
                try:
                    port = re.sub(' ', '', smartctldata['interface_speed']["max"]["string"])
                except KeyError:
                    port = "N/A"    
            except subprocess.CalledProcessError as e:
                output = e.output
        #create table
        print("{:<13} {:<8} {:<21} {:<10} {:<9} {:<7}".format(name, platz, textwrap.shorten(bezeichnung, width=21, placeholder='...'), sataversion, speed, port))
print("\n")




