#Requires -RunAsAdministrator
$ErrorActionPreference = "Stop"
$ScriptRoot = $PSScriptRoot   # resolves to the script's own folder — USB-safe

function Write-Header($msg) { Write-Host "`n=== $msg ===" -ForegroundColor Cyan }
function Write-Ok($msg)     { Write-Host "✔ $msg" -ForegroundColor Green }
function Write-Warn($msg)   { Write-Host "⚠ $msg" -ForegroundColor Yellow }

# ── Step 1: Existing users ────────────────────────────────────────────────────
Write-Header "Step 1 — Existing users"
& "$ScriptRoot\check_users.ps1"

# ── Step 2: Pre-saved file scan ───────────────────────────────────────────────
Write-Header "Step 2 — Scanning for pre-saved design/exported files"
$scanOutput = & "$ScriptRoot\check_files.ps1" 2>&1
$scanOutput | ForEach-Object { Write-Host $_ }

function Invoke-FilesFoundHandler {
    # TODO: implement what happens when suspicious files are found
    # Suggested approaches to consider:
    #   a) Hard-stop — list file paths, exit, require manual cleanup before re-running
    #   b) Soft-warn — display files, prompt "Continue anyway? [Y/N]"
    #   c) Auto-delete — Remove-Item each found path after a confirmation prompt
    #
    # Hard-stop is safest for competition integrity; soft-warn gives proctors flexibility.
}

$suspiciousExtensions = @('.indd','.indt','.ai','.ait','.psd','.psb','.pdf','.eps','.svg','.png','.jpg','.jpeg')
$foundSuspicious = $scanOutput | Where-Object {
    $line = $_; ($suspiciousExtensions | Where-Object { $line -match [regex]::Escape($_) }).Count -gt 0
}

if ($foundSuspicious) {
    Write-Warn "Suspicious files detected."
    Invoke-FilesFoundHandler
}
Write-Ok "File scan complete."

# ── Step 3: Create competitor account ────────────────────────────────────────
Write-Header "Step 3 — Create competitor account"

$Username = Read-Host "Username (e.g. competitor1)"
if (-not $Username) { throw "Username cannot be empty." }

$FullName = Read-Host "Full name (e.g. Competitor 1)"
if (-not $FullName) { throw "Full name cannot be empty." }

$SecurePassword = Read-Host "Password" -AsSecureString

& "$ScriptRoot\create_user.ps1" -Username $Username -Password $SecurePassword -FullName $FullName
Write-Ok "Account '$Username' created."

# ── Step 4: Reminder ─────────────────────────────────────────────────────────
Write-Host "`nSetup complete." -ForegroundColor Green
Write-Host "→ Log out and verify the account before moving to the next laptop."
Write-Host "→ After competition: powershell -ExecutionPolicy Bypass -File remove_user.ps1 -Username $Username -DeleteProfile"
