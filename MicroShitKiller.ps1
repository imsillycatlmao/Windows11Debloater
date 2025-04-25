# Elevate to Administrator if not already
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as Administrator. Restarting with elevated privileges..."
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb RunAs
    Exit
}

Write-Host "!IF YOU GET ERRORS THEN RUN THE FOLLOWING COMMAND:"
Write-Host "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
Write-Host "Also select all (a) in there"

# Confirmation prompt
$confirmation = Read-Host "Are you sure you want to remove Microsoft bloatware? (y/n) "
if ($confirmation -ne 'y') {
    Write-Host "Exiting the script. No changes were made."
    Exit
}

# Stop processes for Microsoft bloatware
Write-Host "Stopping processes..."
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Cortana" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Skype" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Xbox" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "SearchUI" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "MicrosoftEdge" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Office" -Force -ErrorAction SilentlyContinue

# Remove Microsoft Bloatware
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

# Remove Windows Copilot (if installed)
Write-Host "Removing Windows Copilot (if present)..."
Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = 'Windows Copilot'" | ForEach-Object { $_.Uninstall() }

# Optional: Remove Windows Defender (Be cautious!)
Write-Host "Removing Windows Defender (Optional)..."
Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -match "Windows Defender" } | ForEach-Object { $_.Uninstall() }

# Cleanup Temp Files
Write-Host "Cleaning up temp files..."
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

# Ask if the user wants to install a browser
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


# Final message
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
Write-Host "3. Linux (GNOME)"
$themeChoice = Read-Host "Enter the number of your choice"

switch ($themeChoice) {
    1 {
        Write-Host "Applying Windows 7 theme..." -ForegroundColor Green
        # Set registry to change visual style (Windows 7 theme)
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "Theme" -Value "Windows Classic"
        
        # Move Start Menu to the left
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAlign" -Value "0"  # 0 = Left, 1 = Center
        
        # Change Start Menu logo to Windows 7 logo (if applicable, using third-party tool)
        # Example: Set logo path (Note: this step may require third-party software like StartIsBack or Classic Shell)
        Write-Host "To fully apply Windows 7 Start Menu, install third-party software like 'StartIsBack' or 'Classic Shell'"
        
        break
    }
    2 {
        Write-Host "Applying Windows 10 theme..." -ForegroundColor Green
        # Set registry to change visual style (Windows 10 theme)
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "Theme" -Value "Windows"
        
        # Move Start Menu to the left
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAlign" -Value "0"  # 0 = Left, 1 = Center
        
        # Change Start Menu logo to Windows 10 logo (if applicable, using third-party tool)
        # Example: Set logo path (Note: this step may require third-party software like StartIsBack or similar)
        Write-Host "To fully apply Windows 10 Start Menu, install third-party software like 'StartIsBack'"
        
        break
    }
    3 {
        Write-Host "Applying Linux GNOME theme..." -ForegroundColor Green
        # For GNOME-like style, we can adjust font and taskbar settings (using third-party apps if needed)
        # Apply changes such as taskbar tweaks, font, and window borders
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "FontSmoothing" -Value "2"
        break
    }
    default {
        Write-Host "Invalid choice, no theme applied." -ForegroundColor Red
        break
    }
}
Write-Host "Theme applied successfully!" -ForegroundColor Yellow

