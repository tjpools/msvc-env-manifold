@"
Write-Host "INCLUDE:"
Write-Host $env:INCLUDE
Write-Host "`nLIB:"
Write-Host $env:LIB
Write-Host "`nPATH:"
Write-Host $env:PATH
"@ | Out-File -Encoding utf8 tools/verify-env.ps1
