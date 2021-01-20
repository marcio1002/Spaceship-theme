#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $user = $sl.CurrentUser
    $ForeColor = $sl.Colors.SessionInfoForegroundColor
    $BackColor = $sl.Colors.SessionInfoBackgroundColor

    $prompt += Write-Prompt -Object ((Get-ComputerName).ToLower(), $user)[$null -ne $user] -ForegroundColor $sl.Colors.UserInfoForegroundColor -BackgroundColor $BackColor

    $path = ( (Split-Path $pwd -Leaf), "~")[$HOME -eq $pwd]

    $prompt += Write-Prompt -Object " IN " -ForegroundColor $sl.Colors.PromptSymbolColor -BackgroundColor $BackColor

    $prompt += Write-Prompt -Object "$path" -ForegroundColor ($sl.Colors.PromptForegroundColor, [System.ConsoleColor]::Yellow)[$Home -eq $pwd] -BackgroundColor ($sl.Colors.PromptBackgroundColor, $BackColor)[$Home -eq $pwd]
    $prompt += " "

    if ($status = Get-GitStatus) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.GitSymbol -ForegroundColor $sl.Colors.PromptSymbolColor -BackgroundColor $BackColor
        $prompt += " "
        $prompt += Write-Prompt -Object $status.Branch -ForegroundColor $sl.Colors.GitBranchForegroundColor -BackgroundColor $BackColor
        $prompt += " "
        $prompt += Write-Prompt -Object $sl.PromptSymbols.GitSymbol2 -ForegroundColor $sl.Colors.PromptSymbolColor
        $prompt += " "
        $prompt += Write-Prompt -Object $($status.Upstream)  -ForegroundColor $sl.Colors.GitUpstreamForegroundColor -BackgroundColor $BackColor
    }

    if (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -ForegroundColor $sl.Colors.AdminIconForegroundColor -BackgroundColor $ForeColor
    }
    elseif (Test-VirtualEnv) {

        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $ForeColor -BackgroundColor $BackColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -ForegroundColor $sl.Colors.VirtualEnvForegroundColor -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) " -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor -BackgroundColor $sl.Colors.PromptBackgroundColor
    }
    elseif ($lastCommandFailed) {
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.FailedCommandSymbol) " -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor -BackgroundColor $BackColor
    }

    $timestamp = Get-Date -UFormat "%H:%M"

    if ($host.UI.RawUI.CursorPosition.X + $timestamp.Length + 9 -lt $host.UI.RawUI.WindowSize.Width) {
        $prompt += Set-CursorForRightBlockWrite -textLength ($timestamp.Length + 9)
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur2Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur3Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt $timeStamp -ForegroundColor $sl.Colors.PromptForegroundColor -BackgroundColor $sl.Colors.PromptSymbolColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur3Symbol -ForegroundColor $PromptForegroundColor
        $prompt += Write-Prompt -Object $sl.PromptSymbols.Blur2Symbol -ForegroundColor $PromptForegroundColor
    }

    $prompt += Set-Newline

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.Prefix) " -ForegroundColor $sl.Color.PromptSymbolColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.Indicator) " -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt
}

$sl = $global:ThemeSettings
$sl.PromptSymbols.ElevatedSymbol = ''
$sl.PromptSymbols.Indicator = [char]::ConvertFromUtf32(0x279C)
$sl.PromptSymbols.Prefix = [char]::ConvertFromUtf32(0x1F6F8)
$sl.PromptSymbols.SegmentForwardSymbol = [char]::ConvertFromUtf32(0x219D)
$sl.PromptSymbols.Blur2Symbol = [char]::ConvertFromUtf32(0x2592)
$sl.PromptSymbols.Blur3Symbol = [char]::ConvertFromUtf32(0x2593)
$sl.PromptSymbols.GitSymbol = [char]::ConvertFromUtf32(0x21DE)
$sl.PromptSymbols.GitSymbol2 = [char]::ConvertFromUtf32(0x219D)
$sl.Colors.UserInfoForegroundColor = [ConsoleColor]::DarkBlue
$sl.Colors.PromptForegroundColor = [ConsoleColor]::Black
$sl.Colors.PromptBackgroundColor = [ConsoleColor]::Yellow
$sl.Colors.PromptSymbolColor = [ConsoleColor]::White
$sl.Colors.GitBranchForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.GitUpstreamForegroundColor = [ConsoleColor]::DarkMagenta
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkRed
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White
