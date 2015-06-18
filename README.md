# flush
Festplattenanalyse

In dem hardware_check Ordner befindet sich ein Bash-Script zur Hardwarenanalyse. Das Script wird jeden Tag auf dem drei Server gestartet. Es konntrolliert die im RAID eingebundenen Festplatten auf Fehler.
Nach dem Start des Scriptes werden drei Dateien erzeugt. Es reicht die "hardware_error.txt" - Datei zu prüfen, ob 
Predictive Failure Count > 0 ist.

hardware_error.txt - hier werden die Fehlermeldungen als Zahl erfasst. Bsp.
2015-06-16
Predictive Failure Count: 0
Predictive Failure Count: 0
.
.
.
error.log - Fehler.Meldungen bei der Ausführung des Scriptes

pdlist.log - Informationen über die Festplatten. Bsp.
Adapter #0
Enclosure Device ID: 27
Slot Number: 0
Drive's position: DiskGroup: 0, Span: 0, Arm: 0
Enclosure position: 1
Device Id: 15
WWN: 5000c5003edab160
Sequence Number: 2
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA
