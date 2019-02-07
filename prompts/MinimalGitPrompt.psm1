#Author: psammut
using module ..\components\Git.psm1
using module ..\components\Colors.psm1
using module ..\components\Icons.psm1

$fg=[Colors]::fg

function MinimalGitPrompt {

    function setWindowTitle {
        $windowTitle = "$((Get-Location).Path)"
        if ($windowTitle -eq $HOME) {$windowTitle = "~"}
        $host.UI.RawUI.WindowTitle = "$windowTitle"
    }

    [Console]::Write(" ");

    [bool]$isGit = $(git rev-parse --is-inside-work-tree)
    if ($isGit) {

        $git=[Git]::new()

        [Console]::Write("$([Icons]::gitBranchIcon) $($git.branch) ");

        if(($git.unstagedCount)) { [Console]::Write(($fg.Red + "❱")) }
        else { [Console]::Write(($fg.Gray + "❱")) }
        if(($git.stagedCount)) { [Console]::Write(($fg.Green + "❱")) }
        else { [Console]::Write(($fg.Gray + "❱")) }
        if(($git.remoteCommitDiffCount)) { [Console]::Write(($fg.Yellow + "❱")) }
        else { [Console]::Write(($fg.Gray + "❱")) }

    } else {

        $folderName = (Get-Item (Get-Location)).name
        [Console]::Write("$([Icons]::folderIcon) $folderName ");
        [Console]::Write(($fg.Gray + "❱❱❱"))

    }

    setWindowTitle

    Return " "

}