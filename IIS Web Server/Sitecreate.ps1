# Sites
Import-Module WebAdministration
#log
.$PSScriptRoot\jjlog.ps1 -logfile 'loggy'

$sitename = 'Rootops'
$HH = 'rootops.co.uk'
$websitesRoot = 'C:\websites'
$Sitepath = Join-Path -Path $websitesRoot -ChildPath $sitename
$body = '<html>
    <header><title>This is title</title></header>
    <body>
     Hello world '+$sitename+'
    </body>
    </html>'



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

Write-Log -severity Info -Message "Housekeeping default application pools and websites" 
# Remove Default site
if (Get-Website -Name "Default Web Site"){
    Write-Log -severity Warn -Message "Default website exists, removing" 
    Remove-Website -Name "Default Web Site"
}

# Remove Default application pools
if (Test-Path 'IIS:\AppPools\.NET v4.5'){
    Write-Log -severity Warn -Message ".NET v4.5 app pool exists, removing" 
    Remove-WebAppPool -Name '.NET v4.5'
}
if (Test-Path 'IIS:\AppPools\.NET v4.5 Classic'){
    Write-Log -severity Warn -Message ".NET v4.5 Classic app pool exists, removing" 
    Remove-WebAppPool -Name '.NET v4.5 Classic'
}
if (Test-Path 'IIS:\AppPools\DefaultAppPool'){
    Write-Log -severity Warn -Message "DefaultAppPool app pool exists, removing" 
    Remove-WebAppPool -Name 'DefaultAppPool'
}

# Add test page
Write-Log -severity Info -Message "Adding Test Page"  
try {
    Add-Content -Path $Sitepath'\default.html' -Value $body -ErrorAction Stop
}
catch {
    Write-Log -severity Error -Message "Test page failed" 
    Write-Log -severity Error -Message $_.Exception.Message 
}



Write-Log -severity Info -Message "Set up Completed"  