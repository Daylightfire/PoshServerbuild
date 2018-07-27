###
# generic logging module to go with most scripts
# use via .source JJlog.ps1
###
param(
    [Parameter(Mandatory=$False)]
    [string]
    $logfile
)
$logroot = 'C:\logs\'
$log = $logfile+'.log'
$logger = $logroot+$log
#if(Test-Path $logroot){
   # write-host "logs are stored in $logroot$log"
   # }
#else{
   # New-Item -Path $logroot -ItemType 'Directory'
   # write-host "logs are stored in $logroot\$log"
   # }

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False)]
        [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
        [String]
        $Severity = "INFO",

        [Parameter(Mandatory=$True)]
        [string]
        $Message

  )

    $line=[pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $Message
        Severity = $Severity
    } 
    If($logfile) {
        Add-Content $logger -Value $Line
    }
    Else {
        Write-Output $Line
    }
}