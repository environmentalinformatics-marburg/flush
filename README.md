# flush
<p><b> Bash_scripts </b></p>
Scripte für das Backup 182-er, und etc. .

<p><b> hardware_check </b></p>
 
In dem Ordner "hardware_check" befindet sich ein Bash-Script zur Hardwarenanalyse. 
Das Script wird jeden Tag auf dem entsprechenden Server gestartet. 
Es konntrolliert auf Fehlern die im RAID eingebundenen Festplatten.
Nach dem Start des Scriptes werden drei Dateien erzeugt. 
Es reicht die "hardware_error.txt" - Datei zu prüfen, ob 
ein Predictive Failure Count > 0 ist.


error.log - Fehler-Meldungen bei der Ausführung des Scriptes

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


<p><b> java_code </b></p>
Java Programme zur unterschiedlichen Zwecken

