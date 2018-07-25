# Sites
Import-Module WebAdministration
#log
.\JJlog.ps1 -logname 'log.log'

$sitename = 'Rootops'
$HH = 'rootops.co.uk'
$websitesRoot = 'C:\websites'
$Sitepath = Join-Path -Path $websitesRoot -ChildPath $sitename


# create required website folders

Join-Path $websitesRoot
write-log -message "Creating Folders" -severity Information
if (Test-Path -Path $websitesRoot){write-log -message "Website directory exists" -severity Warning }
    else{New-Item -Path C:\ -name Websites -ItemType Directory}


if (Test-Path -Path $Sitepath){write-log -message "$sitename directory exists" -severity Warning}
    else{New-Item -Path C:\Websites\$sitename -ItemType Directory}

# Application pool creation
write-log -message "Application pools" -severity Information
try {
    Write-Log -Message "Creating Application Pool" -severity Information
    New-WebAppPool -name $sitename  -force
}
catch {
    Write-Log -Message "application pool creating FAILED" -severity Error
    Write-Log -Message $Error -severity Error
}

# Update App pool settings
try {
    Write-Log -Message "Setting Application Pool Config" -severity Information
    $appPool = Get-Item $sitename
    $appPool.processModel.identityType = "NetworkService"
    $appPool.enable32BitAppOnWin64 = 1
    $appPool | Set-Item -ErrorAction Stop

}
catch {
    Write-Log -Message "Application Pool Config Failed" -severity Error
    Write-Log -Message $Error -severity Error
}

# Site creation
try {
    Write-Log -message "Creating WebSite" -severity Information
    $site = new-WebSite -name $sitename -PhysicalPath $Sitepath -HostHeader $HH -ApplicationPool $appPool -force
}
catch {
    Write-Log -Message "Site Creation Failed" -severity Error
    Write-Log -Message $Error -severity Error
}


# Remove Default site

# Remove Default application pools
#if (Get-Item )
#Remove-WebAppPool