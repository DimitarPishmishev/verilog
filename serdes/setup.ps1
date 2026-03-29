# Define the commands and point them to your batch scripts
function rs { & ".\src\scripts\run.bat" $args }
function wv { & ".\src\scripts\open_waves.bat" $args }

# Print a nice colorful menu
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Simulation Environment Ready!        " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Commands:"
Write-Host "  rs            "-ForegroundColor Yellow -NoNewline; Write-Host " Run Simulation (Default: Vivado waves)"
Write-Host "  rs -s -r      "-ForegroundColor Yellow -NoNewline; Write-Host " Run Simulation (Read files_tb.f, output VCD for Surfer)"
Write-Host "  wv            "-ForegroundColor Yellow -NoNewline; Write-Host " Open Vivado Wave Viewer"
Write-Host "  wv -s         "-ForegroundColor Yellow -NoNewline; Write-Host " Open Surfer Wave Viewer"
Write-Host "========================================" -ForegroundColor Cyan