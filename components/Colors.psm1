# Prompt Colors
# Black DarkBlue DarkGreen DarkCyan DarkRed DarkMagenta DarkYellow
# Gray DarkGray Blue Green Cyan Red Magenta Yellow White

$esc="$([char]0x1b)"
# Control character sequences
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

    static $bg = [ordered]@{
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

}