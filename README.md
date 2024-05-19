# git-bash dotfiles and windows-terminal symlink setup (windows only)

## PowerShell script for creating symbolic links

setup.ps1 is a PowerShell script for creating symbolic links to all files and directories in a given directory (your home directory for the purpose of this project), excluding files with the extensions ".ps1" and ".md". 

1. Run `setup-symlinks.ps1` in powershell with admin rights:

  ```powershell
  PS <path to this repo>.\home\setup-symlinks.ps1
  ```

  <div style="margin-left: 40px;">
    <p>In case you get the following error:</p>
    <img src="./Resources/powershell-policy-change.png" alt="plot"/>
    <p>Fix it by running:</p>
  </div>

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  ```
  <div style="margin-left: 40px;">
    <p>And go to step 1 again.</p>
  </div>

The script will do the following:

1. Set the current working directory as the starting point defaults to $HOME.
2. Iterate through all items (files and directories) in the current directory.
3. Check if the item has an extension of ".ps1" or ".md". If so, it will skip to the next item.
4. Create a symbolic link to the item in the user's home directory.
5. If a symbolic link to the item already exists, the script will check if it is a symbolic link. If it is not, the existing file will be removed and a new symbolic link will be created.


Additionally, if you want to set msys2 mingw64 (to run C++ apps in windows), you need to install this same ps1 file but pointing to your new home location which for my case was `C:\msys64\home\dennisbot`, after that you will need to include some configurations in vscode for it to work properly in an embeded vscode shell.

see: https://github.com/dennisbot/cp

use pacman to install git, fd and fzf in msys2 env

## Aditional information regarding Windows Terminal

The settings file for Windows Terminal can be found in your user profile directory. The specific location of the file depends on whether you installed Windows Terminal from the Microsoft Store or using preview version from Choco package manager.

If you already have Windows Terminal installed in your windows, the settings file is located at:

```bash
%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```
Otherwise, we will install the preview version using Choco, the settings file is located at:

```bash
%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json
```

Note that %USERPROFILE% is a environment variable that points to a directory. You can access that by typing it into the Windows search bar or by opening the Run dialog (Windows key + R) and typing it there.