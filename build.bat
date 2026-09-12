@echo off
echo Building self-contained ELITE_HUB_14.0.lua ...
node build.js
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Build complete!
pause
