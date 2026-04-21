# check_files.ps1
# Scans the whole laptop for pre-saved design and exported files that may indicate cheating
# Run as Administrator
# Usage: powershell -ExecutionPolicy Bypass -File check_files.ps1

$extensions = @(
    "*.indd", "*.indt",
    "*.ai", "*.ait",
    "*.psd", "*.psb",
    "*.pdf", "*.eps", "*.svg",
    "*.png", "*.jpg", "*.jpeg"
)

$scanRoot = "C:\"
$found = @()

Write-Host ""
Write-Host "=== Silahis PubVerse - Pre-Competition File Check ===" -ForegroundColor Cyan
Write-Host "Scanning $scanRoot for suspicious files..." -ForegroundColor Yellow
Write-Host ""

foreach ($ext in $extensions) {
    Write-Host "  Checking $ext ..." -NoNewline -ForegroundColor Gray
    $results = Get-ChildItem -Path $scanRoot -Filter $ext -Recurse -ErrorAction SilentlyContinue |
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

Write-Host ""
Write-Host "Scan complete." -ForegroundColor Cyan
