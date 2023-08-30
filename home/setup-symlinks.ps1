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

function Add-Home-Symlinks {
  param(
    [string]$HomeFolder,
    [bool]$RunDry = $false
  )

  # SETUP: Execute this in powershell with admin rights
  $currentWorkingDir = $PWD.Path
  # echo $currentWorkingDir
  # echo $currentWorkingDir.Length
  # exit
  # Get-ChildItem -Path . -Recurse | ForEach-Object {
  Get-ChildItem -Path . | ForEach-Object {
    $extension = [System.IO.Path]::GetExtension($_.Name)
    if ($extension -eq ".ps1" -or $extension -eq ".md") {
      continue
    }

    # echo $_.FullName.Substring($currentWorkingDir.Length)
    $linkPath = Join-Path $HomeFolder $_.FullName.Substring($currentWorkingDir.Length)
    # echo $_.FullName.Substring((Join-Path . '').Length)
    # echo "linkPath $linkPath"

    # if (Test-Path $linkPath) {
    #   $item = Get-Item $linkPath
    #   if ($item.LinkType -ne "SymbolicLink") {
        
    #   }
    # }

    if (Test-Path $linkPath) {
      Write-Host "removing $linkPath"
      if (-not $RunDry) {
        Remove-Item $linkPath -Recurse -Force
      }
      # $item = Get-Item $linkPath
      # if ($item.LinkType -ne "SymbolicLink") {
        
      # }
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

# Check if the user selected "Y"
if ($option -eq "Y") {
  Write-Host "running dry ..."
  Add-Home-Symlinks -HomeFolder $homeFolder -RunDry $true
  Write-Host "run dry has finished"
  # Perform some action
}
else {
  Add-Home-Symlinks -HomeFolder $homeFolder -RunDry $false
}

