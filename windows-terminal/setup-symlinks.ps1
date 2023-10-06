param(
    [Parameter(Mandatory = $false)]
    [switch]$Confirm
)

function New-Symlink {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Get the current user's username
    $username = [Environment]::UserName
    # Define the location of the settings.json file in the Windows Terminal package
    $storePath = "C:\Users\$username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
    $chocoPath = "C:\Users\$username\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe"
    # Determine the destination based on what's installed
    if (Test-Path $storePath) {
        $wtLocalFilesFolder = $storePath
    }
    elseif (Test-Path $chocoPath) {
        $wtLocalFilesFolder = $chocoPath
    }
    else {
        # If Windows Terminal is not installed via Store or Choco, then install it using Choco
        Write-Warning "Windows Terminal not found. Installing using Chocolatey..."
        
        # Check if Chocolatey is installed
        $chocoInstalled = $null -ne (Get-Command choco -ErrorAction SilentlyContinue)
        if (-not $chocoInstalled) {
            Write-Error "Chocolatey is not installed. Please install Chocolatey first."
            return
        }

        # Install Windows Terminal using Chocolatey
        if (-not (Get-Command wt -ErrorAction SilentlyContinue)) {
            choco install microsoft-windows-terminal --pre -y
        }
    
        # Re-check if the Choco path exists now after installation
        if (Test-Path $chocoPath) {
            $wtLocalFilesFolder = $chocoPath
        }
        else {
            Write-Error "Failed to install Windows Terminal using Chocolatey or detect its path."
            return
        }
    }

    # Get the current script directory path
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($PSCommandPath)

    # Define the source of the symbolic link
    $sourceFile = Join-Path -Path $scriptDirectory -ChildPath "settings.json"
    $settingsJsonFileLink = Join-Path -Path $wtLocalFilesFolder -ChildPath "LocalState\settings.json"

    # Check if the destination file already exists, and delete it if it does
    if (Test-Path $settingsJsonFileLink) {
        if ($PSCmdlet.ShouldProcess($settingsJsonFileLink, "Remove existing file")) {
            Remove-Item -Path $settingsJsonFileLink -Force
        }
    }

    # Ask for confirmation before creating the symbolic link
    if ($PSCmdlet.ShouldProcess("$settingsJsonFileLink linked to $sourceFile", "Create symlink")) {
        cmd /c mklink $settingsJsonFileLink $sourceFile
    }
}

# Check if running as an administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "You need to run this script as an Administrator!"
    Exit
}

# Call the function
New-Symlink -Confirm:$Confirm
