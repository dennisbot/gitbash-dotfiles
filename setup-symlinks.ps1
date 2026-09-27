# Check if running as an administrator before installing anything.
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Error "You need to run this script as an Administrator!"
  Exit
}

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Write-Host "Installing Chocolatey..."
  # Install Chocolatey
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

$chocoInstallPath = [System.Environment]::GetEnvironmentVariable('ChocolateyInstall', 'Machine')
if (-not $chocoInstallPath) {
  $chocoInstallPath = $env:ChocolateyInstall
}
if (-not $chocoInstallPath) {
  $chocoInstallPath = Join-Path $env:ProgramData 'chocolatey'
}
$chocoBinPath = Join-Path $chocoInstallPath 'bin'
$machinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
$env:Path = "$machinePath;$userPath;$chocoBinPath;$env:Path"

if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  throw "Chocolatey installation did not provide choco.exe at '$chocoBinPath'."
}

# WinGet is normally included with App Installer. If it is unavailable, install
# the WinGet CLI through Chocolatey (which was bootstrapped above if necessary).
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "Installing WinGet..."
  choco install winget-cli -y

  # Make newly installed commands available in this PowerShell session.
  $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User') + ";$chocoBinPath;$env:Path"
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "WinGet is still unavailable after installation. Install Microsoft's App Installer and run this script again."
}

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

# Check and install eza if not present
if (-not (Get-Command eza -ErrorAction SilentlyContinue)) {
  Write-Host "Installing eza..."
  winget install --id eza-community.eza --exact --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -ne 0) {
    throw "WinGet failed to install eza (exit code $LASTEXITCODE)."
  }

  $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User') + ";$chocoBinPath;$env:Path"
}
else {
  Write-Host "eza is already installed."
}

$installed = choco list --localonly | Where-Object { $_ -match "firacode" }

if ($installed) {
  Write-Host "Fira Code is already installed."
}
else {
  choco install firacode -y
}

$hackNerdFontInstalled = choco list nerd-fonts-Hack --exact --limit-output
if ($hackNerdFontInstalled -match '(?im)^nerd-fonts-Hack\|') {
  Write-Host "Hack Nerd Font is already installed."
}
else {
  Write-Host "Installing Hack Nerd Font..."
  choco install nerd-fonts-Hack -y
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

if ($runDry) {
  Write-Host "run dry has finished"
}
