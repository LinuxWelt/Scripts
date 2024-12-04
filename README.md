# Scripts
Scripts aus der LinuxWelt-Redaktion

## :page_with_curl: [tar2zip.py](https://github.com/LinuxWelt/Scripts/blob/main/tar2zip.py) [Download](https://github.com/051782fa-e72b-40f4-b910-d0e9c302acff)
Eine Reihe gepackter Archivdateien liegen in den Formen "tar", "tar.gz", "tar.bz2" oder "tar.xz" vor - die gebräuchlichen Archivtypen für gepackte Dateien unter Linux. Nun sollen diese Dateien aber an Windows-Anwender gehen. Und diese stehen oft ratlos vor den dort unbekannten Dateitypen und Rückfragen gehen ein. Dieses Python-Script wandelt Archive wie "tar.gz", "tar.bz2" oder "tar.xz" nach Zip um. Entweder einzelne Dateien oder auch alle Archive in einem Verzeichnis, das nach dem Schema 
´´´
python tar2zip.py [Pfad]/*
´´´
übergeben wird. Das Script arbeitet dabei rekursiv auch enthaltene Verzeichnisse im Archiv ab. Es benötigt keine weiteren Python-Bibliotheken auf den üblichen Linux-Distributionen.

## :page_with_curl: [gnomeidle.sh](https://github.com/LinuxWelt/Scripts/blob/main/gnomeidle.sh)
BASH-Script für ein Terminal unter Gnome mit Wayland. Es dient dazu, einen angegebenen Befehl oder ein Befehlszeilenprogramm nur bei Inaktivität auszuführen, während keine Benutzereingaben erfolgen. Zwischendurch wird das Script über die Prozessverwaltung von Linux angehalten.

## :page_with_curl: [fast.sh](https://github.com/LinuxWelt/Scripts/blob/main/fast.sh)
Dieses BASH-Script dient dazu, einen Geschwindigkeitstest der Internetverbindung mit den Servern von fast.com (Netflix) als Gegenstelle durchzuführen. Dabei
werden rund 1,22 GB Daten übertragen (Download) bevor das Script beendet wird. Das Script setzt die Tools "pv", "curl" und "mkfifo" voraus,
die sich in den Paketquellen nahezu aller Linux-Distributionen finden.

## :page_with_curl: [laufwerke.sh](https://github.com/LinuxWelt/Scripts/blob/main/laufwerke.sh)
Sind alle schnellen SSDs an den passenden SATA-III-Ports angeschlossen? Dieses BASH-Script der LinuxWelt-Redaktion listet angeschlossene Laufwerke mit ihrer eigenen SATA-Geschwindigkeit und der Geschwindigkeit des SATA-Ports auf.

## :page_with_curl: [laufwerke.py](https://github.com/LinuxWelt/Scripts/blob/main/laufwerke.py)
Das Gegenstück zum Bash-Script: Das Python3-Script hilft ebenfalls mit der Auflistung der angeschlossenen Laufwerke dabei, mehrere SATA-Datenträger in einem Rechner optimal auf die verfügbaren SATA-Ports zu verteilen. Es zeigt mehr Details and und nutzt dazu die "smartmontools", welche bereits installiert sein müssen. Sie finden sich in den Standard-Paketquellen der verbreiteten Linux-Distributionen.


