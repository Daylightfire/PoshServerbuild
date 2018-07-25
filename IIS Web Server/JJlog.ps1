###
# generic logging module to go with most scripts
# use via .source JJlog.ps1
###
param(
    [Parameter(Mandatory=$True)]
    [string]
    $logname
)

function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$False)]
        [ValidateSet("INFO","WARN","ERROR","FATAL","DEBUG")]
        [String]
        $Severity = "INFO",

        [Parameter(Mandatory=$True)]
        [string]
        $Message,

        [Parameter(Mandatory=$False)]
        [string]
        $logfile
    )

    [pscustomobject]$Line=@{
        Time = (Get-Date -f g)
        Message = $Message
        Severity = $Severity
    } 
    If($logfile) {
        Add-Content $logfile -Value $Line
    }
    Else {
        Write-Output $Line
    }
}