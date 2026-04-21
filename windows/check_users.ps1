# check_users.ps1
# Lists all local user accounts and their status
# Run as Administrator

Write-Host "=== Local User Accounts ===" -ForegroundColor Cyan

Get-LocalUser | Select-Object Name, Enabled, LastLogon, Description |
    Format-Table -AutoSize
