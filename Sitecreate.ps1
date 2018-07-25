# Sites
Import-Module WebAdministration

$sitename = 'Rootops'
$HH = 'rootops.co.uk'
$websitesRoot = 'C:\websites'
$Sitepath = Join-Path -Path $websitesRoot -ChildPath $sitename

Join-Path $websitesRoot

if (Test-Path -Path $websitesRoot){
    write-host "websites folder exists"
    else{New-Item -Path C:\ -name Websites -ItemType Directory}
}

if (Test-Path -Path $Sitepath){
    Write-Host "$sitename folder exists"
    else{New-Item -Path C:\Websites\$sitename -ItemType Directory}
}

New-WebAppPool -name $sitename  -force

$appPool = Get-Item -name $sitename
$appPool.processModel.identityType = "NetworkService"
$appPool.enable32BitAppOnWin64 = 1
$appPool | Set-Item



# All on one line
$site = new-WebSite -name $sitename -PhysicalPath $Sitepath -HostHeader $HH -ApplicationPool $appPool -force
