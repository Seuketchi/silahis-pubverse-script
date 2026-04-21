# setup_laptop.ps1
# Full pre-competition laptop setup: check users, scan files, create competitor account
# Run as Administrator

# Step 0 — Verify running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script must be run as Administrator." -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'." -ForegroundColor Yellow
    exit 1
}

function Pause-AndAsk {
    param([string]$Question)
    Write-Host ""
    $answer = Read-Host "$Question (yes/no)"
    if ($answer -notmatch "^(yes|y)$") {
        Write-Host "Stopped. Resolve the issue before continuing." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Silahis PubVerse - Laptop Setup Script   " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# --------------------------------------------------
# Step 1 — Check existing users
# --------------------------------------------------
Write-Host ""
Write-Host "[ Step 1 of 4 ] Checking existing user accounts..." -ForegroundColor Yellow
Write-Host ""

Get-LocalUser | Select-Object Name, Enabled, LastLogon, Description | Format-Table -AutoSize

Pause-AndAsk "Do the existing users look correct? Continue to file scan?"

# --------------------------------------------------
# Step 2 — Scan for suspicious files
# --------------------------------------------------
Write-Host ""
Write-Host "[ Step 2 of 4 ] Scanning for pre-saved design files..." -ForegroundColor Yellow
Write-Host ""

$extensions = @(
    "*.indd", "*.indt",
    "*.ai", "*.ait",
    "*.psd", "*.psb",
    "*.pdf", "*.eps", "*.svg",
    "*.png", "*.jpg", "*.jpeg"
)

$found = @()
foreach ($ext in $extensions) {
    Write-Host "  Checking $ext ..." -NoNewline -ForegroundColor Gray
    $results = Get-ChildItem -Path "C:\" -Filter $ext -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "Windows|Program Files|AppData\\Local\\Microsoft" }
    $found += $results
    if ($results.Count -gt 0) {
        Write-Host " $($results.Count) found" -ForegroundColor Red
    } else {
        Write-Host " none" -ForegroundColor Green
    }
}
Write-Host ""

if ($found.Count -eq 0) {
    Write-Host "No suspicious files found. Laptop is clean." -ForegroundColor Green
} else {
    Write-Host "FOUND $($found.Count) suspicious file(s):" -ForegroundColor Red
    Write-Host ""
    $found | Sort-Object Extension, FullName | Format-Table Name, Extension, LastWriteTime, @{
        Label = "Size (KB)"; Expression = { [math]::Round($_.Length / 1KB, 1) }
    }, DirectoryName -AutoSize
}

Pause-AndAsk "Is the laptop clean and ready? Continue to create competitor account?"

# --------------------------------------------------
# Step 3 — Create competitor account
# --------------------------------------------------
Write-Host ""
Write-Host "[ Step 3 of 4 ] Creating competitor account..." -ForegroundColor Yellow
Write-Host ""

$Username = Read-Host "Enter username (e.g. competitor1)"
$FullName = Read-Host "Enter full label (e.g. Competitor 1)"
$Password  = "pubverse2026"

if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
    Write-Host "User '$Username' already exists. Skipping creation." -ForegroundColor Yellow
} else {
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    New-LocalUser -Name $Username `
                  -Password $securePassword `
                  -FullName $FullName `
                  -Description "Journalism Competition User" `
                  -PasswordNeverExpires `
                  -UserMayNotChangePassword
    Add-LocalGroupMember -Group "Users" -Member $Username
    Write-Host "User '$Username' created with password: $Password" -ForegroundColor Green
}

# --------------------------------------------------
# Step 4 — Prompt to verify
# --------------------------------------------------
Write-Host ""
Write-Host "[ Step 4 of 4 ] Verification" -ForegroundColor Yellow
Write-Host ""
Write-Host "Please log out and log in as '$Username' to verify the account works." -ForegroundColor Cyan
Write-Host "Password: $Password" -ForegroundColor Cyan
Write-Host ""
Pause-AndAsk "Did the login work? Mark this laptop as done?"

Write-Host ""
Write-Host "Laptop setup complete for '$Username'." -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
