$cfgFilenames = 'autoexec.cfg', 'prac.cfg', 'usage.cfg'
$videoSettingsName = 'video.txt'

Function Get-Folder($description, $initialDirectory = "")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = $description
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if ($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}

Function Check-Multiple-Account()
{
    $accounts = ls "$steamFolder\userdata"
    $count = $accounts.Count
    if ($count -gt 1)
    {
        Write-Host "You have $count Steam accounts in this computer"
        $correctAccountFolder = Get-Folder "You have $count Steam accounts in this computer.`r`Select your account number inside 'userdata' folder:" "$steamFolder\userdata"
        return $correctAccountFolder
    }
    else
    {
        $number = $accounts[0].Name
        return "$steamFolder\userdata\$number"
    }
}

Function Do-Copy()
{
    $wd = pwd
    $wdp = $wd.Path
    Write-Host "Copying"
    for($i = 0; $i -lt $cfgFilenames.Length; $i++)
    {
        $fname = $cfgFilenames[$i]
        Copy-Item "$wdp\$fname" -Destination "$steamFolder\steamapps\common\Counter-Strike Global Offensive\csgo\cfg"
    }
    Copy-Item "$wdp\$videoSettingsName" -Destination "$accountFolder\730\local\cfg"
    Write-Host "Done!"
}

$steamFolder = Get-Folder "Select your Steam install folder (usually named 'Steam' inside 'ProgramFiles(x86)'):"
$accountFolder = Check-Multiple-Account
Write-Host "Summary:"
Write-Host "Your cfg will be move to: '$steamFolder\steamapps\common\Counter-Strike Global Offensive\csgo\cfg'"
Write-Host "Your video settings will be move to: '$accountFolder\730\local\cfg'"
$uinput = Read-Host "Correct?[Y/n]"
if ($uinput -match "y")
{
    Do-Copy
    $notify = New-Object -ComObject WScript.Shell
    $window = $notify.popup("Your cfg(s) has been moved to: '$steamFolder\steamapps\common\Counter-Strike Global Offensive\csgo\cfg'.`r`Your video settings has been moved to: '$accountFolder\730\local\cfg'", 0, "Notification", 0 + 64)
}