# Sites
Import-Module WebAdministration
#log
.$PSScriptRoot\jjlog.ps1 -logfile 'loggy'

$sitename = 'Rootops'
$HH = 'rootops.co.uk'
$websitesRoot = 'C:\websites'
$Sitepath = Join-Path -Path $websitesRoot -ChildPath $sitename


# create required website folders

write-log -severity Info -message "Creating Folders" 
if (Test-Path -Path $websitesRoot){write-log -severity Warn -message "Website directory exists"  }
    else{New-Item -Path C:\ -name Websites -ItemType Directory}


if (Test-Path -Path $Sitepath){write-log -severity Warn -message "$sitename directory exists" }
    else{New-Item -Path C:\Websites\$sitename -ItemType Directory}

# Application pool creation
write-log -severity Info -message "Application pools" 
try {
    Write-Log -severity Info -Message "Creating Application Pool" 
    New-WebAppPool -name $sitename  -force -ErrorAction Stop
}
catch {
    Write-Log -severity Error -Message "application pool creating FAILED" 
    Write-Log -severity Error -Message $_.Exception.Message 
}

# Update App pool settings
try {
    Write-Log -severity Info -Message "Setting Application Pool Config" 
    $appPool = Get-Item IIS:\AppPools\$sitename
    $appPool.processModel.identityType = "NetworkService"
    $appPool.enable32BitAppOnWin64 = 'False'
    $appPool | Set-Item -ErrorAction Stop

}
catch {
    Write-Log -severity Error -Message "Application Pool Config Failed" 
    Write-Log -severity Error -Message $_.Exception.Message  
}

# Site creation
try {
    Write-Log -severity Info -message "Creating WebSite" 
    $site = new-WebSite -name $sitename -PhysicalPath $Sitepath -HostHeader $HH -ApplicationPool $sitename -force
}
catch {
    Write-Log -severity Error -Message "Site Creation Failed" 
    Write-Log -severity Error -Message $_.Exception.Message 
}


# Remove Default site

# Remove Default application pools
#if (Get-Item )
#Remove-WebAppPool