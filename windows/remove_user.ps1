# remove_user.ps1
# Removes a local user account and optionally deletes their profile folder
# Run as Administrator
# Usage: powershell -ExecutionPolicy Bypass -File remove_user.ps1 -Username "competitor1"

param(
    [Parameter(Mandatory)][string]$Username,
    [switch]$DeleteProfile
)

if (-not (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue)) {
    Write-Host "User '$Username' not found." -ForegroundColor Yellow
    exit 0
}

Remove-LocalUser -Name $Username

if ($DeleteProfile) {
    $profilePath = "C:\Users\$Username"
    if (Test-Path $profilePath) {
        Remove-Item -Recurse -Force $profilePath
        Write-Host "Profile folder deleted: $profilePath" -ForegroundColor Gray
    }
}

Write-Host "User '$Username' removed." -ForegroundColor Green
