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
  $linkPath = Join-Path $HOME $_.FullName.Substring($currentWorkingDir.Length)
  # echo $_.FullName.Substring((Join-Path . '').Length)
  # echo "linkPath $linkPath"

  if(Test-Path $linkPath) {
    $item = Get-Item $linkPath
    if($item.LinkType -ne "SymbolicLink") {
      echo "removing $linkPath"
      Remove-Item $linkPath -Force
    }
  }

  if(-not (Test-Path $linkPath)) {
    echo "linking $linkPath -> $($_.FullName)"
      New-Item -ItemType SymbolicLink -Path $linkPath -Value $_.FullName
  }
}