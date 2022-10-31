# some path variables
$CurrentLocation = Split-Path -Parent $MyInvocation.MyCommand.Path;

# uninstall Civil 3D
$Uninstallbatch = $CurrentLocation + "\\" + "uninstall.bat"
Start-Process $uninstallbatch -NoNewWindow -Wait

Start-Sleep 5