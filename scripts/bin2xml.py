import struct
import sys

data = open(sys.argv[2], "rb").read();
xml_type = sys.argv[1]
str_ = ""

if xml_type == "unlock":
    str_ = "<?xml version=\"1.0\" ?>\n<Save>\n    <!-- Save file -->\n    <Data>\n        <currentPatch>22</currentPatch>\n        <unlock>0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,</unlock>\n        <unlocknotify>0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,</unlocknotify>\n        <besttimes>"

if xml_type == "level" or xml_type == "qsave":
    str_ = "<?xml version=\"1.0\" ?>\n<Save>\n    <!-- Save file -->\n    <Data>\n        <worldmap>"

length = int(len(data)/2)

for i in range(0,length):
    num = struct.unpack("<H", data[:2])[0]
    data = data[2:]
    str_ = str_ + str(num) + ","

if xml_type == "unlock":    
    str_ = str_ + "</besttimes>\n        <besttrinkets>-1,-1,-1,-1,-1,-1,</besttrinkets>\n        <bestlives>-1,-1,-1,-1,-1,-1,</bestlives>\n        <bestrank>-1,-1,-1,-1,-1,-1,</bestrank>\n        <bestgamedeaths>-1</bestgamedeaths>\n        <stat_trinkets>0</stat_trinkets>\n        <fullscreen>0</fullscreen>\n        <noflashingmode>0</noflashingmode>\n        <colourblindmode>0</colourblindmode>\n        <setflipmode>0</setflipmode>\n        <invincibility>0</invincibility>\n        <slowdown>30</slowdown>\n        <swnbestrank>0</swnbestrank>\n        <swnrecord>0</swnrecord>\n        <advanced_mode>0</advanced_mode>\n        <advanced_smoothing>0</advanced_smoothing>\n        <advanced_scaling>2</advanced_scaling>\n        <openGL>1</openGL>\n    </Data>\n</Save>"

if xml_type == "level":
    str_ = str_ + "</worldmap>\n    </Data>\n</Save>"
    
if xml_type == "qsave":
    str_ = str_ + "</worldmap>\n        <flags>0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,</flags>\n        <crewstats>1,0,0,0,0,0,</crewstats>\n        <collect>0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,</collect>\n        <finalx>50</finalx>\n        <finaly>50</finaly>\n        <savex>189</savex>\n        <savey>161</savey>\n        <saverx>113</saverx>\n        <savery>105</savery>\n        <savegc>0</savegc>\n        <savedir>0</savedir>\n        <savepoint>0</savepoint>\n        <trinkets>0</trinkets>\n        <currentsong>1</currentsong>\n        <teleportscript></teleportscript>\n        <companion>0</companion>\n        <lastsaved>0</lastsaved>\n        <supercrewmate>0</supercrewmate>\n        <scmprogress>0</scmprogress>\n        <scmmoveme>0</scmmoveme>\n        <finalmode>0</finalmode>\n        <finalstretch>0</finalstretch>\n        <frames>17</frames>\n        <seconds>25</seconds>\n        <minutes>0</minutes>\n        <hours>0</hours>\n        <deathcounts>0</deathcounts>\n        <totalflips>0</totalflips>\n        <hardestroom>Welcome Aboard</hardestroom>\n        <hardestroomdeaths>0</hardestroomdeaths>\n        <summary>Space Station, 00:25</summary>\n    </Data>\n</Save>"
    
open(" ".join(sys.argv[3:]), "w").write(str_)
