$ErrorActionPreference = 'Stop'

# Loads MSVC environment and builds the project using CMake + Ninja.
cmd /c "$PSScriptRoot\..\load_msvc_env.cmd" | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') {
        Set-Item -Path Env:$($matches[1]) -Value $matches[2]
    }
}

Write-Host 'Environment loaded.'

$buildDir = Join-Path $PSScriptRoot '..\build'
Remove-Item -Recurse -Force $buildDir -ErrorAction SilentlyContinue

cmake -B $buildDir -G 'Ninja'
cmake --build $buildDir

Write-Host 'Build complete.'
