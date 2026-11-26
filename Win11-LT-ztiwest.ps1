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


# Find Omroep West Laptop Autopilot configuration on USB
Write-Host -ForegroundColor Cyan "Finding Omroep West Laptop Autopilot configuration..."

$OSDCloudVolume = Get-Volume -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FileSystemLabel -eq 'OSDCloud' -and
        $_.DriveLetter
    } |
    Select-Object -First 1

if (-not $OSDCloudVolume) {
    Write-Host -ForegroundColor Red "ERROR: OSDCloud USB data partition not found!"
    throw "OSDCloud USB data partition not found"
}

$AutopilotSource = "$($OSDCloudVolume.DriveLetter):\AutopilotJSON\AutopilotConfigurationFile-OW-LT.json"

if (-not (Test-Path $AutopilotSource)) {
    Write-Host -ForegroundColor Red "ERROR: Laptop Autopilot JSON not found!"
    Write-Host -ForegroundColor Red "Expected: $AutopilotSource"
    throw "AutopilotConfigurationFile-OW-LT.json not found"
}

Write-Host -ForegroundColor Green "Autopilot configuration found:"
Write-Host -ForegroundColor Green $AutopilotSource


# Create safe temporary copy in WinPE before Windows deployment
$AutopilotTemp = "X:\Windows\Temp\AutopilotConfigurationFile.json"

Copy-Item `
    -Path $AutopilotSource `
    -Destination $AutopilotTemp `
    -Force

Write-Host -ForegroundColor Green "Autopilot configuration staged in WinPE."


# Start OSDCloud ZTI
Write-Host -ForegroundColor Cyan "Starting Windows 11 25H2 Pro nl-NL ZTI deployment..."

Start-OSDCloud `
    -OSName 'Windows 11 25H2 x64' `
    -OSEdition Pro `
    -OSLanguage nl-nl `
    -ZTI


# Add Autopilot configuration to installed Windows
Write-Host -ForegroundColor Cyan "Adding Omroep West Laptop Autopilot configuration to Windows..."

$AutopilotDestination = "C:\Windows\Provisioning\Autopilot"

if (-not (Test-Path "C:\Windows")) {
    Write-Host -ForegroundColor Red "ERROR: Installed Windows not found on C:"
    throw "Installed Windows not found"
}

New-Item `
    -Path $AutopilotDestination `
    -ItemType Directory `
    -Force | Out-Null

Copy-Item `
    -Path $AutopilotTemp `
    -Destination "$AutopilotDestination\AutopilotConfigurationFile.json" `
    -Force


# Verify Autopilot configuration
if (Test-Path "$AutopilotDestination\AutopilotConfigurationFile.json") {
    Write-Host -ForegroundColor Green "Autopilot configuration copied successfully."
    Write-Host -ForegroundColor Green "$AutopilotDestination\AutopilotConfigurationFile.json"
}
else {
    Write-Host -ForegroundColor Red "ERROR: Autopilot configuration could not be copied!"
    throw "Autopilot configuration installation failed"
}


# Restart from WinPE
Write-Host -ForegroundColor Green "OSDCloud deployment completed successfully."
Write-Host -ForegroundColor Cyan "Restarting in 20 seconds..."

Start-Sleep -Seconds 20
wpeutil reboot
