# Prompt Colors
# Black DarkBlue DarkGreen DarkCyan DarkRed DarkMagenta DarkYellow
# Gray DarkGray Blue Green Cyan Red Magenta Yellow White

# Control character sequences
# https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences

$esc="$([char]0x1b)"

class Colors {

    static $fg = [ordered]@{
        "Black"         = "$esc[30m";
        "DarkBlue"      = "$esc[34m";
        "DarkGreen"     = "$esc[32m";
        "DarkCyan"      = "$esc[36m";
        "DarkRed"       = "$esc[31m";
        "DarkMagenta"   = "$esc[35m";
        "DarkYellow"    = "$esc[33m";
        "Gray"          = "$esc[37m";
        # "Extended"      = "$esc[38;2;$r;$g;$b m]";
        "Default"       = "$esc[39m";
        "DarkGray"      = "$esc[90m";
        "Blue"          = "$esc[94m";
        "Green"         = "$esc[92m";
        "Cyan"          = "$esc[96m";
        "Red"           = "$esc[91m";
        "Magenta"       = "$esc[95m";
        "Yellow"        = "$esc[93m";
        "White"         = "$esc[97m";

    }

    static $bg = [ordered]@{
        "Black"         = "$esc[40m";
        "DarkBlue"      = "$esc[44m";
        "DarkGreen"     = "$esc[42m";
        "DarkCyan"      = "$esc[46m";
        "DarkRed"       = "$esc[41m";
        "DarkMagenta"   = "$esc[45m";
        "DarkYellow"    = "$esc[43m";
        "Gray"          = "$esc[47m";
        # "Extended"      = "$esc[48;2;";
        "Default"       = "$esc[49m";
        "DarkGray"      = "$esc[100m";
        "Blue"          = "$esc[104m";
        "Green"         = "$esc[102m";
        "Cyan"          = "$esc[106m";
        "Red"           = "$esc[101m";
        "Magenta"       = "$esc[105m";
        "Yellow"        = "$esc[103m";
        "White"         = "$esc[107m";
    }

    static [string]fgRGB([int]$r, [int]$g, [int]$b) {
        return "$([char]0x1b)[38;2;$r;$g;$($b)m";
    }

    static [string]bgRGB([int]$r, [int]$g, [int]$b) {
        return "$([char]0x1b)[48;2;$r;$g;$($b)m";
    }

    static [string]$reset = "$esc[0m";

}