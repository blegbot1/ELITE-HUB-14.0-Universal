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

foreach ($m in $modules) {
    $code = [System.IO.File]::ReadAllText("$base\modules\$m.lua", [System.Text.UTF8Encoding]::new($false))
    if ($m -eq "ui_library") {
        $pattern = 'local\s+Rayfield\s*=\s*loadModuleChunk\("modules/ui_library\.lua"\)\(\)'
        $replace = 'local Rayfield = (function()
' + $code + '
end)()'
    } else {
        $pattern = 'loadModuleChunk\("modules/' + $m + '\.lua"\)\(\)'
        $replace = ';(function()
' + $code + '
end)()'
    }
    $initText = [regex]::Replace($initText, $pattern, $replace)
    Write-Host "Inlined: $m"
}

[System.IO.File]::WriteAllText("$base\ELITE_HUB_14.0.lua", $initText, (New-Object System.Text.UTF8Encoding $false))
$size = (Get-Item "$base\ELITE_HUB_14.0.lua").Length
Write-Host "Build complete: $size bytes"
