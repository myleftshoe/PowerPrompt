$script:timer=1
$script:savedCommandId

function PowerPromptTimer {
    param(
        [switch]$on,
        [switch]$off
    )
    if ($on) {
        $script:timer=1
        return
    }
    if ($off) {
        $script:timer=0
        return
    }
}

function ShowTimer {
    $previousCommand = Get-History -Count 1
    $previousCommandDurationText = ""
    if ("$($previousCommand.Id)" -ne "$savedCommandId") {
        $previousCommandDuration = [int]$previousCommand.Duration.TotalMilliseconds
        if ($previousCommandDuration -ge 1000) {
            $previousCommandDuration = [math]::round([double]$previousCommand.Duration.TotalSeconds,2)
            $previousCommandDurationText = "$previousCommandDuration s"
        }
        else {
            $previousCommandDurationText = "$previousCommandDuration ms"
        }
        $script:savedCommandId = $previousCommand.Id
    }

    if ($timer) {
        Write-Host
        # Write-Host -NoNewLine "    " -foregroundColor "Yellow"
        Write-Host -NoNewline ("{0:HH}:{0:mm}:{0:ss} " -f (Get-Date)) -foregroundColor "DarkGray"
        if ($previousCommandDurationText) {
            Write-Host -NoNewLine "($previousCommandDurationText)"
        }
        Write-Host
    }
}
