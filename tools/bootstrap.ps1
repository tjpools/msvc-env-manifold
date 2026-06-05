@"
# Loads MSVC environment and builds the project using CMake + Ninja

cmd /c "$PSScriptRoot\..\load_msvc_env.cmd" | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') {
        Set-Item -Path Env:$($matches[1]) -Value $matches[2]
    }
}

Write-Host "Environment loaded."

Remove-Item -Recurse -Force "$PSScriptRoot\..\build" -ErrorAction SilentlyContinue
cmake -B "$PSScriptRoot\..\build" -G "Ninja"
cmake --build "$PSScriptRoot\..\build"

Write-Host "Build complete."
"@ | Out-File -Encoding utf8 tools/bootstrap.ps1
