# create_user.ps1
# Creates a new local standard user account
# Run as Administrator
# Usage: powershell -ExecutionPolicy Bypass -File create_user.ps1 -Username "competitor1" -Password "Pass123!" -FullName "John Doe"

param(
    [Parameter(Mandatory)][string]$Username,
    [Parameter(Mandatory)][string]$Password,
    [string]$FullName = "",
    [string]$Description = "Journalism Competition User"
)

$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

New-LocalUser -Name $Username `
              -Password $securePassword `
              -FullName $FullName `
              -Description $Description `
              -PasswordNeverExpires `
              -UserMayNotChangePassword

Add-LocalGroupMember -Group "Users" -Member $Username

Write-Host "User '$Username' created successfully." -ForegroundColor Green
