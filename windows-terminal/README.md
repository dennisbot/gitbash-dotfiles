The settings file for Windows Terminal can be found in your user profile directory. The specific location of the file depends on whether you installed Windows Terminal from the Microsoft Store or as a standalone application.

If you installed Windows Terminal from the Microsoft Store, the settings file is located at:

```bash
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```
If you installed Windows Terminal as a standalone application, the settings file is located at:

```bash
%USERPROFILE%\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

Note that %LOCALAPPDATA% and %USERPROFILE% are environment variables that point to the respective directories. You can access them by typing them into the Windows search bar or by opening the Run dialog (Windows key + R) and entering them there.

Use mklink in admin mode to link wt settings.json to this settings.json