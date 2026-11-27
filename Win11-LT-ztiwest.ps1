# Omroep West - Windows 11 Laptop ZTI
# Windows 11 25H2 Pro nl-NL
# Autopilot configuratie wordt vanaf de USB ingelezen door OSDCloud

$ErrorActionPreference = 'Stop'

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " Omroep West - Windows 11 Laptop ZTI" -ForegroundColor Cyan
Write-Host " Windows 11 25H2 Pro nl-NL" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

try {
    # Update OSD PowerShell Module
    Write-Host -ForegroundColor Cyan "Updating the OSD PowerShell Module..."

    Install-Module OSD `
        -Force `
        -SkipPublisherCheck `
        -ErrorAction Stop

    # Import OSD PowerShell Module
    Write-Host -ForegroundColor Cyan "Importing the OSD PowerShell Module..."

    Import-Module OSD `
        -Force `
        -ErrorAction Stop

    $OSDVersion = (Get-Module OSD).Version

    Write-Host -ForegroundColor Green "OSD PowerShell Module loaded: $OSDVersion"

    # Start Windows 11 ZTI deployment
    Write-Host ""
    Write-Host -ForegroundColor Cyan "Starting Omroep West Windows 11 Laptop deployment..."
    Write-Host -ForegroundColor Cyan "OS        : Windows 11 25H2 x64"
    Write-Host -ForegroundColor Cyan "Edition   : Pro"
    Write-Host -ForegroundColor Cyan "Language  : nl-NL"
    Write-Host -ForegroundColor Cyan "Mode      : ZTI"
    Write-Host ""

    Start-OSDCloud `
        -OSName 'Windows 11 25H2 x64' `
        -OSEdition Pro `
        -OSLanguage nl-nl `
        -ZTI

    # Deployment completed
    Write-Host ""
    Write-Host -ForegroundColor Green "OSDCloud deployment completed successfully."
    Write-Host -ForegroundColor Cyan "Restarting in 20 seconds..."

    Start-Sleep -Seconds 20

    wpeutil reboot
}
catch {
    Write-Host ""
    Write-Host -ForegroundColor Red "============================================================"
    Write-Host -ForegroundColor Red " OSDCloud deployment failed"
    Write-Host -ForegroundColor Red "============================================================"
    Write-Host -ForegroundColor Red $_.Exception.Message

    Write-Host ""
    Write-Host -ForegroundColor Yellow "Automatic reboot has been cancelled."
    Write-Host -ForegroundColor Yellow "WinPE remains open for troubleshooting."

    exit 1
}
