# PowerPrompt

Pimp your PowerShell prompt!

PowerShell Core (6+) only.

## Manual Installation

1. Create PowerPrompt folder in your PowerShell modules folder.
2. Copy all files and folders into the new folder.
3. Add this code to your PowerShell profile (profile.ps1):

```
Import-Module PowerPrompt
function Prompt() {
    PowerPrompt
}
```