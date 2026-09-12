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

$oldFuncPattern = '(?s)-- ELITE HUB 14.0 loader.*?return chunk\r?\nend'
$newFunc = "local function readModule(path) error('ELITE HUB: readModule called in monolith: ' .. path) end`nlocal function loadModuleChunk(path) error('ELITE HUB: loadModuleChunk called in monolith: ' .. path) end"
$initText = [regex]::Replace($initText, $oldFuncPattern, $newFunc)

$uiLibCode = [System.IO.File]::ReadAllText("$base\modules\ui_library.lua", [System.Text.UTF8Encoding]::new($false))
$search1 = 'local Rayfield = loadModuleChunk("modules/ui_library.lua")()'
$replace1 = 'local Rayfield = (function()
' + $uiLibCode + '
end)()'
$initText = $initText.Replace($search1, $replace1)

foreach ($m in $modules) {
    if ($m -eq "ui_library") { continue }
    $code = [System.IO.File]::ReadAllText("$base\modules\$m.lua", [System.Text.UTF8Encoding]::new($false))
    $search = 'loadModuleChunk("modules/' + $m + '.lua")()'
    $replace = '(function()
' + $code + '
end)()'
    $initText = $initText.Replace($search, $replace)
    Write-Host "Inlined: $m"
}

[System.IO.File]::WriteAllText("$base\ELITE_HUB_14.0.lua", $initText, (New-Object System.Text.UTF8Encoding $false))
$size = (Get-Item "$base\ELITE_HUB_14.0.lua").Length
Write-Host "Build complete: $size bytes"
