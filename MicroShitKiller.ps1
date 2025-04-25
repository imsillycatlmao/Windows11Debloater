
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as Administrator. Restarting with elevated privileges..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    Exit
}



$EdgeRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate"
New-Item -Path $EdgeRegPath -Force
New-ItemProperty -Path $EdgeRegPath -Name "DoNotUpdateToEdgeWithChromium" -Value 1 -PropertyType DWORD -Force


$StoreRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Store"
New-Item -Path $StoreRegPath -Force
New-ItemProperty -Path $StoreRegPath -Name "AutoDownload" -Value 2 -PropertyType DWORD -Force


Write-Host "!IF YOU GET ERRORS THEN RUN THE FOLLOWING COMMAND:"
Write-Host "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
Write-Host "Also select all (a) in there"

$confirmation = Read-Host "Are you sure you want to remove Microsoft bloatware? (y/n) "
if ($confirmation -ne 'y') {
    Write-Host "Exiting the script. No changes were made."
    Exit
}


Write-Host "Stopping processes..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Cortana" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Skype" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Xbox" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "SearchUI" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "MicrosoftEdge" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Office" -Force -ErrorAction SilentlyContinue

Write-Host "Removing Microsoft Bloatware..."
$bloatware = @(
    "Microsoft.OneDrive", "Microsoft.Cortana", "Microsoft.XboxApp", "Microsoft.SkypeApp", 
    "Microsoft.WindowsStore", "Microsoft.BingNews", "Microsoft.GetHelp", "Microsoft.Messaging",
    "Microsoft.People", "Microsoft.3DBuilder", "Microsoft.MicrosoftSolitaireCollection", 
    "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.Office.OneNote", "Microsoft.OneConnect"
)

foreach ($app in $bloatware) {
    Get-AppxPackage -AllUsers $app | Remove-AppxPackage 
}


Get-CimInstance -Class Win32_Product | Where-Object { $_.Name -like "Microsoft Office*" } | ForEach-Object { $_.Uninstall() }


Write-Host "Removing Windows Copilot (broken)..."
Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'Windows Copilot'" | ForEach-Object { $_.Uninstall() }

Write-Host "Removing Windows Defender (broken)..."
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "Windows Defender" } | ForEach-Object { $_.Uninstall() }


Write-Host "Cleaning up temp files..."
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue


$browserChoice = Read-Host "Which browser would you like to install? (1) Firefox (2) Opera GX (3) Brave (4) Chrome (If you do not want one then just input anything else than a number 1-4)"

switch ($browserChoice) {
    '1' {
        Write-Host "Installing Firefox..."
        Start-Process "https://www.mozilla.org/en-US/firefox/new/" -Wait
    }
    '2' {
        Write-Host "Installing Opera GX..."
        Start-Process "https://www.opera.com/gx" -Wait
    }
    '3' {
        Write-Host "Installing Brave..."
        Start-Process "https://brave.com/download/" -Wait
    }
    '4' {
        Write-Host "Installing Chrome..."
        Start-Process "https://www.google.com/chrome/" -Wait
    }
    default {
        Write-Host "Invalid choice. No browser will be installed."
    }
}




Write-Host "Force killing microshit edge"

Remove-Item -Path "C:\Program Files (x86)\Microsoft\Edge" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Program Files\Microsoft\Edge" -Recurse -Force -ErrorAction SilentlyContinue


Remove-Item -Path "HKCU:\Software\Microsoft\Edge" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\Software\Microsoft\Edge" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue


Get-AppxPackage -AllUsers -Name "*MicrosoftEdge*" | Remove-AppxPackage -AllUsers


Write-Host "debloated win11 successfully(maybe)"
Write-Host "Removed:
    "Microsoft.OneDrive", "Microsoft.Cortana", "Microsoft.XboxApp", "Microsoft.SkypeApp", 
    "Microsoft.WindowsStore", "Microsoft.BingNews", "Microsoft.GetHelp", "Microsoft.Messaging",
    "Microsoft.People", "Microsoft.3DBuilder", "Microsoft.MicrosoftSolitaireCollection", 
    "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.Office.OneNote", "Microsoft.OneConnect"   
"






$themesdad = Read-Host "Do you also want a custom theme? (y/n) "
if ($confirmation -ne 'y') {
    Write-Host "Exiting the script. No changes were made."
    Exit
}

Write-Host "Choose a theme to apply:" -ForegroundColor Cyan
Write-Host "1. Windows 7"
Write-Host "2. Windows 10"
$themeChoice = Read-Host "Enter the number of your choice"

switch ($themeChoice) {
    1 {
        Write-Host "Applying Windows 7 theme..." -ForegroundColor Green
        
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "Theme" -Value "Windows Classic"
        
        
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAlign" -Value "0"  
        
       
        Write-Host "To fully apply Windows 7 Start Menu, install third-party software like 'StartIsBack' or 'Classic Shell'"
        
        break
    }
    2 {
        Write-Host "Applying Windows 10 theme..." -ForegroundColor Green
        
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "Theme" -Value "Windows"
        

        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAlign" -Value "0"  
        

        Write-Host "To fully apply Windows 10 Start Menu, install third-party software like 'StartIsBack'"
        
        break
    }

    default {
        Write-Host "Invalid choice, no theme applied." -ForegroundColor Red
        break
    }
}
Write-Host "Theme applied successfully!" -ForegroundColor Yellow

