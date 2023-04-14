# git-bash dotfiles setup (windows only)
## PowerShell script for creating symbolic links

setup.ps1 is a PowerShell script for creating symbolic links to all files and directories in a given directory (your home directory for the purpose of this project), excluding files with the extensions ".ps1" and ".md". 

To run this script open a PowerShell with administrator rights and move to this repo location, then.

```powershell
PS <path to your repo>.\setup.ps1
```

The script will do the following:

1. Set the current working directory as the starting point.
2. Iterate through all items (files and directories) in the current directory.
3. Check if the item has an extension of ".ps1" or ".md". If so, it will skip to the next item.
4. Create a symbolic link to the item in the user's home directory.
5. If a symbolic link to the item already exists, the script will check if it is a symbolic link. If it is not, the existing file will be removed and a new symbolic link will be created.
