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
        # Add semicolon to avoid ambiguous syntax with preceding ) 
        $replace = ';(function()
' + $code + '
end)()'
    }
    $initText = [regex]::Replace($initText, $pattern, $replace)
    Write-Host "Inlined: $m"
}

# Strip non-ASCII from comments only (preserve Cyrillic in strings)
$lines = $initText -split '\r?\n'
$fixed = 0
for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    $trimmed = $line.TrimStart()
    if ($trimmed.StartsWith('--')) {
        $clean = [regex]::Replace($line, '[\x80-\xFF]', '?')
        if ($clean -ne $line) {
            $lines[$i] = $clean
            $fixed++
        }
    }
}
$initText = $lines -join "`n"

[System.IO.File]::WriteAllText("$base\ELITE_HUB_14.0.lua", $initText, (New-Object System.Text.UTF8Encoding $false))
$size = (Get-Item "$base\ELITE_HUB_14.0.lua").Length
Write-Host "Build complete: $size bytes, stripped $fixed comment lines"
