# bulk_create_users.ps1
# Creates multiple users from a CSV file
# Run as Administrator
# CSV format: Username,FullName,Password,Description
# Usage: powershell -ExecutionPolicy Bypass -File bulk_create_users.ps1 -CsvPath "users.csv"

param(
    [Parameter(Mandatory)][string]$CsvPath
)

if (-not (Test-Path $CsvPath)) {
    Write-Host "CSV file not found: $CsvPath" -ForegroundColor Red
    exit 1
}

$users = Import-Csv -Path $CsvPath

foreach ($user in $users) {
    $username    = $user.Username
    $fullName    = $user.FullName
    $password    = $user.Password
    $description = if ($user.Description) { $user.Description } else { "Journalism Competition User" }

    if (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        Write-Host "SKIP: '$username' already exists." -ForegroundColor Yellow
        continue
    }

    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    New-LocalUser -Name $username `
                  -Password $securePassword `
                  -FullName $fullName `
                  -Description $description `
                  -PasswordNeverExpires `
                  -UserMayNotChangePassword

    Add-LocalGroupMember -Group "Users" -Member $username

    Write-Host "Created: '$username' ($fullName)" -ForegroundColor Green
}

Write-Host "`nDone." -ForegroundColor Cyan
