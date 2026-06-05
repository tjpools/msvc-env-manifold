# msvc-env-manifold

Building the coordinate chart that lets MSVC exist in PowerShell.

This repository demonstrates a fully manual, deterministic MSVC toolchain running in PowerShell 7.6, without relying on Visual Studio's IDE or Developer Command Prompt. It constructs the environment that MSVC expects, imports that environment into PowerShell, and then proves the setup by building and running a small C++ program with CMake and Ninja.

## Why This Exists

MSVC does not discover its environment. It expects one.
PowerShell does not inherit environment variables from batch files.
This repo builds the bridge between them.

## Loading the MSVC Environment

The file `load_msvc_env.cmd` calls `vcvars64.bat` and prints the environment. PowerShell imports it like this:

```powershell
cmd /c .\load_msvc_env.cmd | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') {
        Set-Item -Path Env:$($matches[1]) -Value $matches[2]
    }
}
```

After this, PowerShell becomes a fully initialized MSVC development shell.

## Building

```powershell
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
cmake -B build -G "Ninja"
cmake --build build
.\build\hello.exe
```

Expected output:

```text
Hello, world
```

## Tools

See the `tools/` directory:

- `bootstrap.ps1` — load MSVC and build the project
- `verify-env.ps1` — print `INCLUDE`, `LIB`, and `PATH`
- `test-hello-world.ps1` — run an end-to-end validation build and check output
- `diagram.txt` — ASCII environment flow

## Validation

Confirmed working via an end-to-end hello-world build in PowerShell after loading the MSVC environment. The project configured, compiled, linked, and executed successfully, printing `Hello, world`.

This validates the repository's core premise: PowerShell can be transformed into a usable MSVC development shell by explicitly importing the environment produced by `vcvars64.bat`.

## Tool Lineage

MSVC is a Third-Age tool: not physical, not symbolic, but procedural.
It requires a world to be built around it.
This repo constructs that world explicitly.

## Narrative Appendix

MSVC does not wander. It waits for the world to be prepared.
PowerShell cannot inherit that world, so we built a bridge.
Only then does `<iostream>` resolve.
Only then does the compiler speak.
And when it does, it says: Hello, world.
