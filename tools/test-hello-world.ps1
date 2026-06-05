$ErrorActionPreference = 'Stop'

Write-Host 'Loading MSVC environment into PowerShell...'
cmd /c "$PSScriptRoot\..\load_msvc_env.cmd" | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') {
        Set-Item -Path Env:$($matches[1]) -Value $matches[2]
    }
}

$buildDir = Join-Path $PSScriptRoot '..\build'
$exePath = Join-Path $buildDir 'hello.exe'

Write-Host 'Cleaning prior build directory...'
Remove-Item -Recurse -Force $buildDir -ErrorAction SilentlyContinue

Write-Host 'Configuring project...'
cmake -B $buildDir -G 'Ninja'

Write-Host 'Building project...'
cmake --build $buildDir

Write-Host 'Running executable...'
$output = & $exePath
Write-Host "Program output: $output"

if ($output -ne 'Hello, world') {
    throw "Validation failed: expected 'Hello, world' but got '$output'"
}

Write-Host 'Validation succeeded.'
