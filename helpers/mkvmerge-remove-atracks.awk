#!/usr/bin/awk -f

BEGIN {
MKVMerge="/usr/bin/mkvmerge" # for linux
FS="[\t\n: ]"
IGNORECASE=1
MKVVideo=ARGV[1]
AudioKeep=ARGV[2]
SubsKeep=ARGV[3]
ChaptersKeep=ARGV[4]
NewVideo=substr(MKVVideo, 1, length(MKVVideo)-4)".new.mkv"
OrigVideo=substr(MKVVideo, 1, length(MKVVideo)-4)".OLD.mkv"
audioRemoves=0
subRemoves=0
audioFound=0
debug=0
state="."

#set eng as defaults
if(!AudioKeep){AudioKeep = ":eng:und"}
if(!SubsKeep){SubsKeep = 0}
if(!ChaptersKeep){ChaptersKeep = "chapters"}

do {
    Result=("\""MKVMerge"\" --ui-language cs_CZ --identify-verbose \""MKVVideo"\"" | getline Line)

    if (Result>0) {
        FieldCount=split(Line, Fields)
        if (Fields[1]=="Track") {
            NoTr++
            Track[NoTr, "id"]=Fields[3]
            Track[NoTr, "typ"]=Fields[5]
            Track[NoTr, "xtra"]=Fields[6]
            for (i=6; i<=FieldCount; i++) {
                if (Fields[i]=="language") Track[NoTr, "lang"]=Fields[++i]
            }
        }
    }
}    while (Result>0)
if (NoTr==0) {
    if(debug){
        print "Error! No tracks found in \""MKVVideo"\"."
    } else {
        printf "0"
    }   
    exit
}
else {
    if(debug){
        print "\""MKVVideo"\":", NoTr, "tracks found."
        for (q=1; q<=NoTr; q++) {
            print Track[q, "typ"] ": " Track[q, "xtra"]
        }
    }
}
for (i=1; i<=NoTr; i++) {
    if (Track[i, "typ"]=="audio") {
        if (AudioKeep~Track[i, "lang"]) {
            audioFound++
            if(debug){
                print "Keep", Track[i, "typ"], "Track", Track[i, "id"],  Track[i, "lang"]
            }
            if (AudioCommand=="") {AudioCommand=Track[i, "id"]
            } else AudioCommand=AudioCommand","Track[i, "id"]
        } else {
            if(debug){
                print "\tRemove", Track[i, "typ"], "Track", Track[i, "id"],  Track[i, "lang"]
            }
            audioRemoves++
        }
    } else {
        if (Track[i, "typ"]=="subtitles" && SubsKeep) {
            if (SubsKeep~Track[i, "lang"]) {
                if(debug){
                    print "Keep", Track[i, "typ"], "Track", Track[i, "id"],  Track[i, "lang"]
                }       
                if (SubsCommand=="") {SubsCommand=Track[i, "id"]
                } else SubsCommand=SubsCommand","Track[i, "id"]
            } else {
                if(debug){
                    print "\tRemove", Track[i, "typ"], "Track", Track[i, "id"],  Track[i, "lang"]
                }               
                subRemoves++
            }
        }
    }
}
if (AudioCommand=="") {CommandLine="-A"
} else {CommandLine="-a "AudioCommand}
if (!audioFound){
    if(debug){
        print "Warning: Audio found. Keep all: \""MKVVideo"\""
    } else {
        state = "N"
    }
    CommandLine=""
    audioRemoves=0
}
if (SubsCommand=="") {CommandLine=CommandLine" -S"
} else {CommandLine=CommandLine" -s "SubsCommand}
if (!ChaptersKeep) CommandLine=CommandLine" --no-chapters"
if(audioRemoves || subRemoves){

    #process using mkvmerge
    if(debug){
        print "CLI: \"" MKVMerge "\" -o \"" NewVideo "\" " CommandLine " \"" MKVVideo "\""
    }
    if(debug){
        print "Begin Remux"
        out=""
    }
    else {
        state = "P"
        out="> /dev/null"
    }
    Result=system("\"" MKVMerge "\" --ui-language cs_CZ -o \"" NewVideo "\" " CommandLine " \"" MKVVideo "\" |(sed -n /^The/q;cat)" out)
    #print "Result: \"" Result "\""
    if(Result == 0){

        #check resulting duration
#        "ffmpeg -i \"" MKVVideo "\" 2>&1 | grep \"Duration\"| cut -d ' ' -f 4 | sed s/,// | sed 's/.$//'" | getline OLD_DURATION
#        "ffmpeg -i \"" MKVVideo "\" 2>&1 | grep \"Duration\"| cut -d ' ' -f 4 | sed s/,// | sed 's/.$//'" | getline OLD_DURATION
        "mediainfo --Inform=\"General;%Duration/String2%\" \"" MKVVideo "\" " | getline OLD_DURATION
        "mediainfo --Inform=\"General;%Duration/String2%\" \"" NewVideo "\" " | getline NEW_DURATION
#        "ffmpeg -i \"" NewVideo "\" 2>&1 | grep \"Duration\"| cut -d ' ' -f 4 | sed s/,// | sed 's/.$//'" | getline NEW_DURATION
        
        if (OLD_DURATION == NEW_DURATION){
            #if successful, change file permissions of new file
            if(debug){
                print "Set file permissions on new file: chmod 775 \"" NewVideo "\""
            }
            system("chmod 775 \"" NewVideo "\"") 

            #remove old orig video
            if(debug){
                print "Delete original file: rm \"" OrigVideo "\""
            }            
            system("rm \"" MKVVideo "\"")
            system("mv \"" NewVideo "\" \"" MKVVideo "\"")
        }
        else {
            state = "!"
            print ""
            print "ERROR: Duration not equal: \"" MKVVideo "\""
            print "Old duration: \"" OLD_DURATION "\""
            print "New duration: \"" NEW_DURATION "\""
            system("rm \"" NewVideo "\"")
        }
        
    }

}
else{
    if(debug){
        print "Nothing to change, exiting."
    }
}
printf state

if (Result>1){ print "Error "Result" muxing \""MKVVideo"\"!"}
exit
}