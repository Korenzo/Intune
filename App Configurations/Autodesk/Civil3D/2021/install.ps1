# Variables
$Setup = (Get-Item -Path .\Img\Setup.exe).FullName
$Ini = (Get-Item -Path .\Img\Civil3D2021.ini).FullName
$TaskName = "Install Civil 3D 2021"
$TaskPath = "Urban"

# Task Setup
$Action = New-ScheduledTaskAction -Execute "$Setup" -Argument "/q /W /I $Ini /language en-us"
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
$Task = New-ScheduledTask -Action $Action -Principal $Principal

# Register
Register-ScheduledTask -TaskName "$TaskName" -TaskPath "$TaskPath" -InputObject $Task -Force

# Install
Start-ScheduledTask -TaskName "$TaskName" -TaskPath "$TaskPath"

# Wait
while ((Get-ScheduledTask -TaskName "$TaskName").State -ne 'Ready') {
    Start-Sleep -Seconds 60
}

# Cleanup
Unregister-ScheduledTask -TaskName "$TaskName" -Confirm:$false 