.$PSScriptRoot\JJlog.ps1 -logfile 'loggy'

write-log -Severity "INFO" -Message 'info message test'
$sitepath = 'D:\Websites\ken1\'
$sitename = 'kentiweb'
$body = '<html>
    <header><title>This is title</title></header>
    <body>
     Hello world '+$sitename+'
    </body>
    </html>'


Add-Content -Path $sitepath'default.html' -Value $body