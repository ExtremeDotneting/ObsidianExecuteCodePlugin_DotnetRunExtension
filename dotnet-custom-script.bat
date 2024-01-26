@echo off
rem Set encoding, define variables.
chcp 65001 > nul
set scriptTempFilePath=%1 
rem Replace / with \
set scriptTempFilePath=%scriptTempFilePath:/=\%
set currentScriptDirPath=%~dp0
set csprojName=DotnetProject
set csprojPath=%currentScriptDirPath%%csprojName%

rem Go to current script dir.
pushd "%currentScriptDirPath%"

rem Read first word from .csx file.
for /f %%a in (%scriptTempFilePath%) do (
  set firstWord=%%a
  goto endLoop
)
:endLoop

rem Choose which execute strategy to use.
if "%firstWord%"=="//use-csproj" (
  goto csprojPart
)
if "%firstWord%"=="//use-dotnet-script" (
  goto dotnetScriptPart
)
rem Default case you can set here.
goto csprojPart


rem If decided to execute via DotnetProject.csproj.
:csprojPart
if not exist "%csprojPath%" (
  dotnet new console -n %csprojName%
)
type "%scriptTempFilePath%" > "%csprojPath%\Program.cs"
dotnet run --project "%csprojPath%
goto exit

rem If decided to execute via dotnet-script tool.
:dotnetScriptPart
dotnet-script %scriptTempFilePath%
goto exit

:exit
