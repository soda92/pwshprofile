Push-Location $PSScriptRoot/../
if (Test-Path build) {
    Remove-Item -Path "build" -Recurse
}
Pop-Location
