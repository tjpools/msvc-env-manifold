@"
# msvc-env-manifold
Building the coordinate chart that lets MSVC exist in PowerShell.

This repository demonstrates a fully manual, deterministic MSVC toolchain running in PowerShell 7.6, without relying on Visual Studio’s IDE or Developer Command Prompt. It constructs the environment manifold MSVC requires, then builds a minimal C++ program using CMake + Ninja.

## 1. Why This Exists
MSVC does not discover its environment. It expects one.  
PowerShell does not inherit environment variables from batch files.  
This repo builds the bridge between them.

## 2. Loading the MSVC Environment
The file `load_msvc_env.cmd` calls `vcvars64.bat` and prints the environment.
PowerShell imports it:

cmd /c load_msvc_env.cmd | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path Env:$($matches[1]) -Value $matches[2]
    }
}

After this, PowerShell becomes a fully initialized MSVC development shell.

## 3. Building
Remove-Item -Recurse -Force build
cmake -B build -G "Ninja"
cmake --build build
./build/hello.exe

Expected output:
Hello, world

## 4. Tools
See the /tools directory:
- bootstrap.ps1 — load MSVC + build
- verify-env.ps1 — print INCLUDE/LIB/PATH
- diagram.txt — ASCII environment flow

## 5. Tool Lineage
MSVC is a Third-Age tool: not physical, not symbolic, but procedural.  
It requires a world to be built around it.  
This repo constructs that world explicitly.

## 6. Narrative Appendix
MSVC does not wander. It waits for the world to be prepared.  
PowerShell cannot inherit that world, so we built a bridge.  
Only then does <iostream> resolve.  
Only then does the compiler speak.  
And when it does, it says: Hello, world.

"@ | Out-File -Encoding utf8 README.md
