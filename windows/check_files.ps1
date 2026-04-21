# check_files.ps1
# Scans the whole laptop for pre-saved design and exported files that may indicate cheating
# Run as Administrator
# Usage: powershell -ExecutionPolicy Bypass -File check_files.ps1

$extensions = @(
    # InDesign
    "*.indd", "*.indt",
    # Illustrator
    "*.ai", "*.ait",
    # Photoshop
    "*.psd", "*.psb",
    # Exported outputs
    "*.pdf", "*.eps", "*.svg",
    "*.png", "*.jpg", "*.jpeg"
)

$scanRoot = "C:\"
$found = @()

Write-Host ""
Write-Host "=== Silahis PubVerse — Pre-Competition File Check ===" -ForegroundColor Cyan
Write-Host "Scanning $scanRoot for suspicious files..." -ForegroundColor Yellow
Write-Host ""

foreach ($ext in $extensions) {
    $results = Get-ChildItem -Path $scanRoot -Filter $ext -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "Windows|Program Files|AppData\\Local\\Microsoft" }
    $found += $results
}

if ($found.Count -eq 0) {
    Write-Host "No suspicious files found. Laptop is clean." -ForegroundColor Green
} else {
    Write-Host "FOUND $($found.Count) suspicious file(s):" -ForegroundColor Red
    Write-Host ""
    $found | Sort-Object Extension, FullName | Format-Table Name, Extension, LastWriteTime, @{
        Label = "Size (KB)"; Expression = { [math]::Round($_.Length / 1KB, 1) }
    }, DirectoryName -AutoSize
}

Write-Host ""
Write-Host "Scan complete." -ForegroundColor Cyan
