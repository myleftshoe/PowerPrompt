#Author: psammut
using module ..\components\Git.psm1
using module ..\components\Colors.psm1
using module ..\components\Icons.psm1

$fg=[Colors]::fg
$iconColor=$fg.White
$textColor=$fg.DarkGray


function MinimalGitPrompt {

    function setWindowTitle {
        $windowTitle = "$((Get-Location).Path)"
        if ($windowTitle -eq $HOME) {$windowTitle = "~"}
        $host.UI.RawUI.WindowTitle = "$windowTitle"
    }

    $pwdLeaf = (Get-Item (Get-Location)).name

    [Console]::Write(" ");

    [bool]$isGit = $(git rev-parse --is-inside-work-tree)
    if ($isGit) {

        $git=[Git]::new()

        [Console]::Write("$iconColor$([Icons]::gitLogo) $textColor$($git.repoLeaf) ");
        [Console]::Write("$iconColor$([Icons]::gitBranchIcon) $textColor$($git.branch) ");

        if ($pwdLeaf -ne $git.repoLeaf) {
            [Console]::Write("$iconColor$([Icons]::folderIcon) $textColor$pwdLeaf ");
        }

        if(($git.unstagedCount)) { [Console]::Write(($fg.Red + "❱")) }
        else { [Console]::Write(($iconColor + "❱")) }
        if(($git.stagedCount)) { [Console]::Write(($fg.Green + "❱")) }
        else { [Console]::Write(($iconColor + "❱")) }
        if(($git.remoteCommitDiffCount)) { [Console]::Write(($fg.Yellow + "❱")) }
        else { [Console]::Write(($iconColor + "❱")) }

    } else {

        [Console]::Write("$([Icons]::folderIcon) $pwdLeaf ");
        [Console]::Write(($iconColor + "❱❱❱"))

    }

    setWindowTitle

    Return " "

}