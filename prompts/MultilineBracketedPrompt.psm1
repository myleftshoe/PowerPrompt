#Author: psammut
using module ..\components\Git.psm1
using module ..\components\Colors.psm1
using module ..\components\Icons.psm1

$fg=[Colors]::fg
$bg=[Colors]::bg

# $palette = @("Blue", "Green",  "Cyan", "Red", "Magenta", "Yellow", "Gray")
$palette = @("Blue", "Green",  "Cyan", "Red", "Magenta", "Yellow", "DarkBlue", "DarkGreen",  "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow")

$script:primary = "Blue"
$script:tint = "DarkBlue"
$script:dynamicPromptColor="on"
$script:colorIndex=0;

$folderIcon = [Icons]::folderIcon
$gitLogo = [Icons]::gitLogo
$gitBranchIcon = [Icons]::gitBranchIcon
$gitRemoteIcon = [Icons]::gitRemoteIcon

$promptState = @{}
$promptState.pwd = ""
$promptState.gitStagedCount = ""
$promptState.gitUnstagedCount = ""
$promptState.gitRemoteCommitDiffCount = ""


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


function WriteLine ($text) {
    [Console]::Write($fg.$primary +  " ┃ ")
    [Console]::Write($text)
    [Console]::Write(" $([char]0x1b)[400@")
    [Console]::WriteLine("$([char]0x1b)[0m")
}


function MultilineBracketedPrompt {

    function stateChanged {
        return ( `
            ($promptState.pwd -ne $pwdPath) -or `
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

    $pwdItem = (Get-Item (Get-Location))
    $pwdPath = $pwdItem.fullname
    $pwdParentPath = $pwdItem.parent.fullname
    $pwdLeaf = $pwdItem.name

    if ((stateChanged) -or $env:PowerPromptShow) {

        if ("$dynamicPromptColor" -eq "on") {
            $script:primary = Get-NextColor
            $script:tintTextColor=$primary
            $script:primaryTextColor="White"
        }

        if ("$pwdPath" -eq "$home") {
            if ("$pwdPath" -eq "$START") {
                $folderIcon = "≋"
            }
            else {
                $folderIcon = "~"
            }
        }
        elseif ("$pwdPath" -eq "$START") {
            $folderIcon = "≈"
        }

        [console]::WriteLine($fg.$primary +  " ┏")

        $Icon = $fg.$primaryTextColor + " $folderIcon"
        $Text = $fg.$primaryTextColor + "  $pwdLeaf"
        if ("$pwdLeaf" -ne "$pwdPath") {
            $Text = $Text + $fg.$tintTextColor + " in $pwdParentPath"
        }
        WriteLine($Icon + $Text)

        if ($isGit) {

            if ("$pwdPath" -ne "$gitRepoPath") {
                $Icon = $fg.$primaryTextColor +  " $gitLogo"
                $Text = $fg.$primaryTextColor + "  $gitRepoLeaf"
                WriteLine ($Icon + $Text)
            }
            $Icon = $fg.$primaryTextColor +  " $gitBranchIcon"
            $Text = $fg.$primaryTextColor + "  $gitBranch"
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
            WriteLine ($Icon + $Text)
            # warn if remote name != local folder name
            if ("$gitRemoteName" -and ("$gitRemoteName" -ne "$gitRepoLeaf")) {
                $Icon = $fg.$primaryTextColor +  " $gitRemoteIcon"
                $Text = $fg.$primaryTextColor + " $gitRemoteName"
                WriteLine ($Icon + $Text)
            }
        }
        [console]::WriteLine($fg.$primary +  " ┗")
    }

    [Console]::Write(($fg.$primary + "   ❱❱❱"))
    # [Console]::Write(($fg.$primary + "    "))

    saveState
    setWindowTitle

    Remove-Item env:PowerPromptShow

    Return " "

}