$ErrorActionPreference = "Stop"

# Check if the Windows Update service is running
$service = Get-Service -Name wuauserv -ErrorAction SilentlyContinue
if ($service.Status -ne "Running") {
    # Start the Windows Update service if it's not already running
    Start-Service -Name wuauserv
}

# Trigger Windows Update to check for updates and install them
$session = New-Object -ComObject Microsoft.Update.Session
$downloader = $session.CreateUpdateDownloader()
$downloader.Download()
$installer = $session.CreateUpdateInstaller()
$installer.Install()

# Check if the updates were successfully installed
$updates = $session.CreateUpdateSearcher().Search("IsInstalled=1")
if ($updates.Updates.Count -gt 0) {
    Write-Output "Windows updates installed successfully."
} else {
    Write-Output "Windows updates installation failed."
    exit 1
}
