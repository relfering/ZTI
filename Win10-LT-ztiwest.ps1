Write-Host  -ForegroundColor Cyan "Starting Bedrijfs W10 LT OSD's Custom OSDCloud ..."
Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing the OSD PowerShell Module"
Import-Module OSD -Force

#TODO: Spend the time to write a function to do this and put it here
#  Write-Host  -ForegroundColor Cyan "Ejecting ISO"
#  Write-Warning "One moment ..."
#  Start-Sleep -Seconds 5

#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Cyan "Start OSDCloud with West bedrijfs parameters ..... "
#  Start-OSDCloudGUI
Start-OSDCloud  -OSName 'Windows 10 23H2 x64' -OSEdition PRO -OSLanguage nl-nl -ZTI
# Start-OSDCloud  -OSName 'Windows 11 21H2 x64' -OSEdition PRO -OSLanguage nl-nl -ZTI

#  Start-OSDCloud -OSLanguage nl-nl -OSVersion 'Windows 10' -OSBuild 21H2 -OSEdition PRO -ZTI
#  Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI

#Anything I want  can go right here and I can change it at any time since it is in the Cloud!!!!!
#  Write-Host  -ForegroundColor Cyan "Starting OSDCloud PostAction ..."
#  Write-Warning "One moment ..."
#  Write-Warning "Waardes aanpassen naar gelang gewenst wordt ..."
#  Resize-Partition -DriveLetter "C" -Size 100GB
#  New-Partition -DiskNumber 0 -Size 90GB -DriveLetter E
#  Format-Volume -DriveLetter E -FileSystem NTFS -NewFileSystemLabel Edit -Confirm:$false

#Restart from WinPE
Write-Host  -ForegroundColor Cyan "Verwijder de USB drive en press CTRL+C to reboot"
Start-Sleep
Write-Host  -ForegroundColor Cyan "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
