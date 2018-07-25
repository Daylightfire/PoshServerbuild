###
# The one ring script
# This script should be used to bind together all the other scripts used in a serverbuild
# This will all go away when we move to Chef / DSC / Azure but it's a good practice
###

# Adding loggin
$LogScriptPath = ""
./$LogScriptPath

#InstallIIS
try {
    ./installIIS.ps1 
}
catch {
    write-log -Message $Error -Severity Error 
} 


#Create sites

try {
    ./Sitecreate.ps1
}
catch {
    write-log -Message $Error -Severity Error
}





