# $git = [PSCustomObject]@{
#     isGit                   = $(git rev-parse --is-inside-work-tree)
#     branch                  = $(git symbolic-ref --short HEAD)
#     repoPath                = $(git rev-list HEAD...origin/master --count)
#     repoLeaf                = Split-Path (git rev-parse --show-toplevel) -Leaf
#     commitCount             = $(git rev-list --all --count)
#     stagedCount             = 0
#     unstagedCount           = 0
#     remoteCommitDiffCount   = 0

# }

class Git {
    # properties
    static [bool]$isGit = $(git rev-parse --is-inside-work-tree)
    [string]$branch
    [string]$repoPath
    [string]$repoLeaf
    [string]$remoteName
    [int]$commitCount
    [int]$stagedCount
    [int]$unstagedCount
    [int]$remoteCommitDiffCount

    # Default constructor
    Git(){
		# $this.isGit                   = $(git rev-parse --is-inside-work-tree)
		$this.branch = $(git symbolic-ref --short HEAD)
		$this.repoPath = $(git rev-list HEAD...origin/master --count)
		$this.repoLeaf = Split-Path (git rev-parse --show-toplevel) -Leaf
		$this.commitCount = $(git rev-list --all --count)

        $this.remoteCommitDiffCount = 0
        $this.remoteCommitDiffCount = $(git rev-list HEAD...origin/master --count)

        $this.remoteName = ""
        Try {
            $this.remoteName = $(Split-Path -Leaf (git remote get-url origin)).replace(".git", "")
        }
        Catch {}

        $this.stagedCount = 0
		$this.unstagedCount = 0
        git status --porcelain | ForEach-Object {
            if ($_.substring(0, 1) -ne " ") {
                $this.stagedCount += 1
            }
            if ($_.substring(1, 1) -ne " ") {
                $this.unstagedCount += 1
            }
        }
    }
}
