if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  # Install Chocolatey
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Check and install fd if not present
if (-not (Get-Command fd -ErrorAction SilentlyContinue)) {
  Write-Host "Installing fd..."
  choco install fd -y
}
else {
  Write-Host "fd is already installed."
}

# Check and install fzf if not present
if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
  Write-Host "Installing fzf..."
  choco install fzf -y
}
else {
  Write-Host "fzf is already installed."
}

$installed = choco list --localonly | Where-Object { $_ -match "firacode" }

if ($installed) {
  Write-Host "Fira Code is already installed."
}
else {
  choco install firacode -y
}

function Get-Windows-Terminal-Home-Path {
  param(
    [string]$TargetFolder
  )

  $storePath = "$TargetFolder\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
  $previewPath = "$TargetFolder\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe"

  if (Test-Path $storePath) {
      $wtLocalFilesFolder = $storePath
  }
  elseif (Test-Path $previewPath) {
      $wtLocalFilesFolder = $previewPath
  }
  else {
      # If Windows Terminal is not installed via Store or Preview, install it using Chocolatey
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

          # Wait a moment for the installation to complete
          Start-Sleep -Seconds 30
      }

      # Re-check if the path exists now after installation
      if (Test-Path $storePath) {
          $wtLocalFilesFolder = $storePath
      }
      elseif (Test-Path $previewPath) {
          $wtLocalFilesFolder = $previewPath
      }
      else {
          Write-Error "Failed to install Windows Terminal using Chocolatey or detect its path."
          return
      }
  }

  $windowsTerminalFolder = Join-Path -Path $wtLocalFilesFolder -ChildPath "LocalState"
  return $windowsTerminalFolder
}

function Create-Symlinks {
  param(
    [string]$TargetFolder,
    [string]$SourceFolder,
    [bool]$RunDry = $false
  )

  # SETUP: Execute this in powershell with admin rights
  Get-ChildItem -Path $SourceFolder | ForEach-Object {
    $extension = [System.IO.Path]::GetExtension($_.Name)
    if ($extension -eq ".ps1" -or $extension -eq ".md") {
      continue
    }

    $linkPath = Join-Path $TargetFolder $_.FullName.Substring($SourceFolder.Length)

    if (Test-Path $linkPath) {
      Write-Host "removing $linkPath"
      if (-not $RunDry) {
        Remove-Item $linkPath -Recurse -Force
      }
    }

    if (-not (Test-Path $linkPath)) {
      Write-Host "linking $linkPath -> $($_.FullName)"
      if (-not $RunDry) {
        New-Item -ItemType SymbolicLink -Path $linkPath -Value $_.FullName
      }
    }
  }
}

# Check if running as an administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Error "You need to run this script as an Administrator!"
  Exit
}

# Prompt the user for an option
$option = Read-Host "Do you want to run dry first? (Y/N)"
$homeFolder = Read-Host "Enter the path to the home folder (leave blank to use $HOME):"
# Use the provided home folder or fall back to $HOME
if ($homeFolder -eq "") {
  $homeFolder = $HOME
  Write-Host "homeFolder provided is: $homeFolder"
}
$sourceDotFilesFolder = Join-Path -Path $PWD.Path -ChildPath "home"

# Set flags based on $option
$runDry = ($option -eq "Y")

# Check if the user selected "Y"
if ($runDry) {
  Write-Host "running dry ..."
}

Create-Symlinks -TargetFolder $homeFolder -SourceFolder $sourceDotFilesFolder -RunDry $runDry

# Prompt the user if they also want to run the Windows Terminal script
$runWindowsTerminal = Read-Host "Do you also want to run the Windows Terminal script? (Y/N)"

if ($runWindowsTerminal -eq "Y") {
  $windowsTerminalFolder = Get-Windows-Terminal-Home-Path -TargetFolder $homeFolder
  $sourceWindowsTerminalFolder = Join-Path -Path $PWD.Path -ChildPath "windows-terminal"
  Create-Symlinks -TargetFolder $windowsTerminalFolder -SourceFolder $sourceWindowsTerminalFolder -RunDry $runDry
}

if ($runDry) {
  Write-Host "run dry has finished"
}
