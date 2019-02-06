#Author: psammut
using module ..\components\Git.psm1
using module ..\components\Icons.psm1

# $script:foregroundColor = 'White'
$script:promptColor = 'Yellow'
$script:dynamicPromptColor="on"
$script:colorIndex=0;

function get-NextColor( ) {
    $colors = [Enum]::GetValues( [ConsoleColor] )
    $max = $colors.length - 1

    $script:colorIndex++
    if ($script:colorIndex -gt $max) {
        $script:colorIndex = 0
    }
    $color= $colors[$colorIndex]
    if ("$color" -eq "$((get-host).ui.rawui.BackgroundColor)") {
        $color = get-NextColor
    }
    return $color
}

$folderIcon = [Icons]::folderIcon
$gitLogo = [Icons]::gitLogo
$gitBranchIcon = [Icons]::gitBranchIcon
# $gitRemoteIcon = [Icons]::gitRemoteIcon

function MultilineArrowPrompt {
    # Prompt Colors
    # Black DarkBlue DarkGreen DarkCyan DarkRed DarkMagenta DarkYellow
    # Gray DarkGray Blue Green Cyan Red Magenta Yellow White

    if ("$dynamicPromptColor" -eq "on") {
        $script:promptColor = Get-NextColor
    }

    $currentDrive = (Get-Location).Drive
    $currentDriveLabel = (Get-Volume $currentDrive.Name).FileSystemLabel

    # Write-Host


    # Write-Host "—" -foregroundColor "DarkGray"
    # $drive = (PWD).Drive.Name
    $pwdItem = (Get-Item (Get-Location))
    $pwdPath = $pwdItem.fullname
    $pwdParentPath = $pwdItem.parent.fullname
    $pwdLeaf = $pwdItem.name

    # Write-Host

    if ("$pwdPath" -eq "$home") {
        if ("$pwdPath" -eq "$_home") {
            $folderIcon = "≋"
        }
        else {
            $folderIcon = "~"
        }
    }
    elseif ("$pwdPath" -eq "$_home") {
        $folderIcon = "≈"
    }

    Write-Host "┏━" -foregroundColor "$promptColor" -NoNewLine
    Write-Host " $folderIcon" -NoNewLine -foregroundColor "$promptColor"
    Write-Host " $pwdLeaf" -NoNewLine
    if ("$pwdLeaf" -ne "$pwdPath") {
        Write-Host " ($pwdParentPath)" -NoNewLine -foregroundColor "DarkGray"
    }
    Write-Host

    # $isGit=[Git]::isGit
    [bool]$isGit = $(git rev-parse --is-inside-work-tree)
    if ($isGit) {
        Write-Host "┃ " -foregroundColor "$promptColor"
    }
    Write-Host "┗" -foregroundColor "$promptColor" -NoNewLine

    Write-Host "$([char]0x1b)[s" -NoNewLine
    # Write-Host "$([char]0x1b)[2A" -NoNewLine

    # Line 1

    # Write-Host "$([char]0x1b)[u" -NoNewLine


    # Line 2
    if ($isGit) {

        $git=[Git]::new()

        $gitBranch = $git.branch
        $gitRepoPath = $git.repoPath
        $gitRepoLeaf = $git.repoLeaf
        $gitRemoteName = $git.remoteName
        $gitCommitCount = $git.commitCount
        $gitStagedCount = $git.stagedCount
        $gitUnstagedCount = $git.unstagedCount
        $gitRemoteCommitDiffCount = $git.remoteCommitDiffCount

        Write-Host "$([char]0x1b)[1A" -NoNewLine

        if ("$pwdPath" -ne "$gitRepoPath") {
            # $childPath="$pwdPath".replace("$gitRepoPath", "")
            Write-Host " $gitLogo " -NoNewLine -foregroundColor "Yellow"
            Write-Host "$gitRepoLeaf" -NoNewLine
        }

        Write-Host " $gitBranchIcon "  -NoNewLine -foregroundColor "Yellow"
        Write-Host "$gitBranch " -NoNewLine
        if ($gitCommitCount -eq 0) {
            Write-Host "(no commits) " -NoNewLine -foregroundColor "DarkGray"
        }
        Write-Host $("$gitStagedCount ") -NoNewLine -foregroundColor "Green"
        Write-Host $("$gitUnstagedCount ") -NoNewLine -foregroundColor "Red"
        Write-Host $("$gitRemoteCommitDiffCount") -NoNewLine -foregroundColor "Yellow"
        # warn if remote name != local folder name
        if ("$gitRemoteName" -and ("$gitRemoteName" -ne "$gitRepoLeaf")) {
            Write-Host " 肋" -NoNewLine -foregroundColor "Yellow"
            Write-Host "$gitRemoteName" -NoNewLine -foregroundColor "Yellow"
        }

        # Write-Host
    }

    Write-Host "$([char]0x1b)[u" -NoNewLine

    $windowTitle = "$((Get-Location).Path)"
    if ($windowTitle -eq $HOME) {$windowTitle = "~"}
    $host.UI.RawUI.WindowTitle = "$windowTitle"

    Return " "

}