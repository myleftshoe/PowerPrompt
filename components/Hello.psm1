class Hello {
    # properties
    [string]$person

    # Default constructor
    Hello(){}

    # Constructor
    Hello(
    [string]$m
    ){
    $this.person=$m
    }

    # method
    [string]Greetings(){
    return "Hello {0}" -f $this.person
    }

    }

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