$ErrorActionPreference = "Stop"
$base = Split-Path -Parent $MyInvocation.MyCommand.Path

$modules = @(
    "ui_library", "overlay", "hubs", "fe_scripts", "game_scripts",
    "main", "aimbot", "esp", "chams", "players", "teleport",
    "kill_all", "visual", "visual_plus", "environment", "movement",
    "combat_plus", "camera", "utilities", "music", "range",
    "item_finder", "settings", "anti_fling", "watchdog"
)

$initText = [System.IO.File]::ReadAllText("$base\modules\init.lua", [System.Text.UTF8Encoding]::new($false))

# Remove readModule and loadModuleChunk function definitions
$initText = $initText -replace "(?s)local function readModule\(path\).*?return chunk\r?\nend\r?\n?", ""

# Replace each loadModuleChunk call with the module code
foreach ($m in $modules) {
    $code = [System.IO.File]::ReadAllText("$base\modules\$m.lua", [System.Text.UTF8Encoding]::new($false))
    # Match both "local X = loadModuleChunk(...)" and bare "loadModuleChunk(...)"
    $pattern = '(?:local\s+\w+\s*=\s*)?loadModuleChunk\("modules/' + $m + '\.lua"\)\(\)'
    $initText = [regex]::Replace($initText, $pattern, $code)
    Write-Host "Inlined: $m"
}

[System.IO.File]::WriteAllText("$base\ELITE_HUB_14.0.lua", $initText, (New-Object System.Text.UTF8Encoding $false))
$size = (Get-Item "$base\ELITE_HUB_14.0.lua").Length
Write-Host "Build complete: $size bytes"
