#Author: psammut
using module ..\components\Git.psm1

$script:_showprompt=""
# $script:foregroundColor = 'White'
$script:primary = "Blue"
$script:tint = "DarkBlue"
$script:dynamicPromptColor="on"
$script:colorIndex=0;


function showprompt() {
    $script:_showprompt="on"
}

function get-NextColor( ) {

    $script:colorIndex++
    if ($script:colorIndex -gt ($palette.length - 1)) {
        $script:colorIndex = 0
    }
    $color= $palette[$colorIndex]
    if ("$color" -eq "$((get-host).ui.rawui.BackgroundColor)") {
        $color = get-NextColor
    }
    return $color
}

function Show-Colors( ) {
    $colors = [Enum]::GetValues( [ConsoleColor] )
    $max = ($colors | ForEach-Object { "$_ ".Length } | Measure-Object -Maximum).Maximum
    foreach ( $color in $colors ) {
        Write-Host (" {0,2} {1,$max} " -f [int]$color, $color) -NoNewline
        Write-Host "  " -Background $color
    }
}

$promptState = @{}
$promptState.pwd = ""
$promptState.gitStagedCount = ""
$promptState.gitUnstagedCount = ""
$promptState.gitRemoteCommitDiffCount = ""


$folderIcon = ""
$gitLogo = ""
$gitBranchIcon = ""
$gitRemoteIcon = "肋"

# Prompt Colors
# Black DarkBlue DarkGreen DarkCyan DarkRed DarkMagenta DarkYellow
# Gray DarkGray Blue Green Cyan Red Magenta Yellow White

$esc="$([char]0x1b)"
# Control character sequences
$fg = [ordered]@{
    "Black"         = "$esc[30m";
    "DarkBlue"      = "$esc[34m";
    "DarkGreen"     = "$esc[32m";
    "DarkCyan"      = "$esc[36m";
    "DarkRed"       = "$esc[31m";
    "DarkMagenta"   = "$esc[35m";
    "DarkYellow"    = "$esc[33m";
    "Gray"          = "$esc[37m";
    # "Extended"      = "$esc[38m";
    # "Default"       = "$esc[39m";
    "DarkGray"      = "$esc[90m";
    "Blue"          = "$esc[94m";
    "Green"         = "$esc[92m";
    "Cyan"          = "$esc[96m";
    "Red"           = "$esc[91m";
    "Magenta"       = "$esc[95m";
    "Yellow"        = "$esc[93m";
    "White"         = "$esc[97m";
}
$bg = [ordered]@{
    "Black"         = "$esc[40m";
    "DarkBlue"      = "$esc[44m";
    "DarkGreen"     = "$esc[42m";
    "DarkCyan"      = "$esc[46m";
    "DarkRed"       = "$esc[41m";
    "DarkMagenta"   = "$esc[45m";
    "DarkYellow"    = "$esc[43m";
    "Gray"          = "$esc[47m";
    # "Extended"      = "$esc[38m";
    # "Default"       = "$esc[39m";
    "DarkGray"      = "$esc[100m";
    "Blue"          = "$esc[104m";
    "Green"         = "$esc[102m";
    "Cyan"          = "$esc[106m";
    "Red"           = "$esc[101m";
    "Magenta"       = "$esc[105m";
    "Yellow"        = "$esc[103m";
    "White"         = "$esc[107m";
}

# $palette = @("Blue", "Green",  "Cyan", "Red", "Magenta", "Yellow", "Gray")
$palette = @("DarkBlue", "DarkGreen",  "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "DarkGray")

function WriteLinePadded ($text) {
    [Console]::Write($text)
    [Console]::Write(" $([char]0x1b)[400@")
    [Console]::WriteLine("$([char]0x1b)[0m")
}


function PanelPrompt {

    function stateChanged {
        return ($_showprompt) -or
            (($promptState.pwd -ne $pwdPath) -or `
            ($gitRepoPath -ne $promptState.gitRepoPath) -or `
            ($gitStagedCount -ne $promptState.gitStagedCount) -or `
            ($gitUnstagedCount -ne $promptState.gitUnstagedCount) -or `
            ($gitRemoteCommitDiffCount -ne $promptState.gitRemoteCommitDiffCount)
        )
    }

    function saveState {
        $promptState.pwd = "$pwdPath"
        $promptState.gitRepoPath = $gitRepoPath
        $promptState.gitStagedCount = $gitStagedCount
        $promptState.gitUnstagedCount = $gitUnstagedCount
        $promptState.gitRemoteCommitDiffCount = $gitRemoteCommitDiffCount
    }

    function setWindowTitle {
        $windowTitle = "$((Get-Location).Path)"
        if ($windowTitle -eq $HOME) {$windowTitle = "~"}
        $host.UI.RawUI.WindowTitle = "$windowTitle"
    }


    # $currentDrive = (Get-Location).Drive
    # $currentDriveLabel = (Get-Volume $currentDrive.Name).FileSystemLabel

    # $isGit=[Git]::isGit
    # get all git info before any write-host to prevent delay when prompt displayed
    [bool]$isGit = $(git rev-parse --is-inside-work-tree)
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

    }

    # Write-Host "—" -foregroundColor "DarkGray"
    # $drive = (PWD).Drive.Name
    $pwdItem = (Get-Item (Get-Location))
    $pwdPath = $pwdItem.fullname
    $pwdParentPath = $pwdItem.parent.fullname
    $pwdLeaf = $pwdItem.name


    if (stateChanged) {

        if ("$dynamicPromptColor" -eq "on") {
            $script:primary = Get-NextColor
            $script:tintTextColor=$primary
            if ($primary.startsWith("Dark")) {
                $script:primaryTextColor="White"
                $script:secondaryTextColor="Black"
                $script:tint = $primary.replace("Dark", "")
            }
            else {
                $script:primaryTextColor="Black"
                $script:secondaryTextColor="White"
                $script:tint = "Dark$($primary)"
            }
        }

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
        # [Console]::Write("$([char]0x1b)[44m")
        # Write-Host -NoNewLine "    ▕" -foregroundColor "Black" -backgroundColor "$primary"

        # [Console]::Write($bg.Red)
        $Icon = $bg.$primary +  "     "
        $Text = $bg.$tint
        WriteLinePadded ($Icon + $Text)

        $Icon = $bg.$primary + $fg.$primaryTextColor + "  $folderIcon  "
        $Text = $bg.$tint  + $fg.$secondaryTextColor + "  $pwdLeaf"
        if ("$pwdLeaf" -ne "$pwdPath") {
            $Text = $Text + $fg.$tintTextColor + " in $pwdParentPath"
        }
        WriteLinePadded ($Icon + $Text)

        if ($isGit) {

            # Write-Host "█" -foregroundColor "$primary" -NoNewLine
            if ("$pwdPath" -ne "$gitRepoPath") {
                $Icon = $bg.$primary + $fg.$primaryTextColor +  "  $gitLogo  "
                $Text = $bg.$tint + $fg.$secondaryTextColor + "  $gitRepoLeaf"
                WriteLinePadded ($Icon + $Text)
            }
            $Icon = $bg.$primary + $fg.$primaryTextColor +  "  $gitBranchIcon  "
            $Text = $bg.$tint + $fg.$secondaryTextColor + "  $gitBranch"
            if ($gitCommitCount -eq 0) {
                $Text = $Text + $fg.$tintTextColor + " (no commits)"
            }
            $green=$fg.Green
            $red=$fg.Red
            $yellow=$fg.Yellow

            switch ($tint)
            {
                "Green" {$green=$fg.DarkGreen}
                "Red" {$red=$fg.DarkRed}
                "Yellow" {$yellow=$fg.DarkYellow}
            }

            $Text = $Text + $green + " $gitStagedCount"
            $Text = $Text + $red + " $gitUnstagedCount"
            $Text = $Text + $yellow + " $gitRemoteCommitDiffCount"
            WriteLinePadded ($Icon + $Text)
            # warn if remote name != local folder name
            if ("$gitRemoteName" -and ("$gitRemoteName" -ne "$gitRepoLeaf")) {
                $Icon = $bg.$primary + $fg.$primaryTextColor +  "  $gitRemoteIcon "
                $Text = $bg.$tint + $fg.$secondaryTextColor + "  $gitRemoteName"
                WriteLinePadded ($Icon + $Text)
            }
        }
        $Icon = $bg.$primary +  "     "
        $Text = $bg.$tint
        WriteLinePadded ($Icon + $Text)
        [Console]::WriteLine()
    }

    [Console]::Write(($fg.$primary + " "))

    saveState
    setWindowTitle
    $script:_showprompt=""

    Return "  "

}