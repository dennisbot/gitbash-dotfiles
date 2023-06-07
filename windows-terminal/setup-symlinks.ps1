param(
    [Parameter(Mandatory=$false)]
    [switch]$Confirm
)

function New-Symlink {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Get the current user's username
    $username = [Environment]::UserName

    # Define the location of the settings.json file in the Windows Terminal package
    $destinationLink = "C:\Users\$username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

    # Get the current script directory path
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($PSCommandPath)

    # Define the source of the symbolic link
    $sourceLink = Join-Path -Path $scriptDirectory -ChildPath "settings.json"

    # Check if the destination file already exists, and delete it if it does
    if(Test-Path $destinationLink) {
        if($PSCmdlet.ShouldProcess($destinationLink, "Remove existing file")) {
            Remove-Item -Path $destinationLink -Force
        }
    }

    # Ask for confirmation before creating the symbolic link
    if($PSCmdlet.ShouldProcess("$destinationLink linked to $sourceLink", "Create symlink")) {
        cmd /c mklink $destinationLink $sourceLink
    }
}

# Call the function
New-Symlink -Confirm:$Confirm
