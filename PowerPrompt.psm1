$script:defaultPrompt="PanelPrompt"
$script:isOff=0
<#
 .Synopsis
  Pimp your PowerShell prompt!

 .Parameter name

  Set the prompt to the style specifed by name

 .Parameter persist

  Persist the prompt across sessions. Setting the name parameter without this will
  only change the prompt for the duration of the session.

 .Parameter off

  Disable PowerPrompt, i.e. use the standard PS> prompt. Lasts for the duration
  of the session only. (Comment out the prompt function in your powershell profile
  to disable it permanently.)

 .Parameter on

  Re-enable PowerPrompt if you have disabled it using -off.

 .Example
  PowerPrompt MultilineArrowPrompt
  (Changes the prompt to another style)

 .Example
  PowerPrompt PowerlineStyle -persist
  (Changes the prompt and persists it across sessions)

 .Example
  PowerPrompt -off
  (Temporarily disables PowerPrompt)

.Example
  PowerPrompt -on
 (Re-enables it)
#>
function PowerPrompt {

    param(
        [string]$name,
        [switch]$persist,
        [switch]$off,
        [switch]$on
    )

    if ($off) {
        $script:isOff=1
        return
    }
    if ($on) {
        $script:isOff=0
        return
    }
    if ($isOff) {
        return
    }

    if ($name) {
        $env:PowerPromptName=$name
        if ($persist) {
            [environment]::SetEnvironmentVariable("PowerPromptName", "$name", "User")
        }
        return
    }

    if (-not (Test-Path env:PowerPromptName)) {
        $env:PowerPromptName = "$defaultPrompt"
        [environment]::SetEnvironmentVariable("PowerPromptName", "$defaultPrompt", "User")
    }

    ShowTimer
    Write-Host
    & $env:PowerPromptName

    return "  "
}

Export-ModuleMember -Function PowerPrompt
Export-ModuleMember -Function PowerPromptTimer
