Write-Host -ForegroundColor Cyan "Starting Omroep West Windows 11 Laptop OSDCloud..."
Start-Sleep -Seconds 5

# Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

# Make sure I have the latest OSD Content
Write-Host -ForegroundColor Cyan "Updating the OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host -ForegroundColor Cyan "Importing the OSD PowerShell Module"
Import-Module OSD -Force

# Start OSDCloud ZTI
Write-Host -ForegroundColor Cyan "Starting Windows 11 25H2 Pro nl-NL ZTI deployment..."

Start-OSDCloud `
    -OSName 'Windows 11 25H2 x64' `
    -OSEdition Pro `
    -OSLanguage nl-nl `
    -ZTI

# Restart from WinPE
Write-Host -ForegroundColor Cyan "OSDCloud deployment completed."
Write-Host -ForegroundColor Cyan "Restarting in 20 seconds!"

Start-Sleep -Seconds 20
wpeutil reboot
