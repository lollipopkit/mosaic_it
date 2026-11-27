; Inno Setup 6 script for MosaicIt Windows installer.
; Invoked by CI (`ISCC.exe`) with AppName, AppVersion, SourceDir, OutputDir,
; and OutputBaseFilename defined on the command line.
;
; Per user, into %LOCALAPPDATA%\Programs, so no administrator is needed. User
; preferences stay in the app-data directory across upgrades and uninstalls.

#ifndef AppName
  #error AppName is not defined
#endif
#ifndef AppVersion
  #error AppVersion is not defined
#endif
#ifndef SourceDir
  #error SourceDir is not defined
#endif
#ifndef OutputDir
  #define OutputDir "."
#endif
#ifndef OutputBaseFilename
  #define OutputBaseFilename AppName + "_setup"
#endif
#define AppExe AppName + ".exe"

[Setup]
; Fixed unique GUID for MosaicIt upgrades.
AppId={{4E7A2C91-8F3B-4D62-B15E-9A3C7E1F6D48}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher=lollipopkit
AppPublisherURL=https://mosaic.lollipopkit.com/
AppSupportURL=https://github.com/lollipopkit/mosaic_it/issues
AppUpdatesURL=https://github.com/lollipopkit/mosaic_it/releases
VersionInfoVersion={#AppVersion}
DefaultDirName={autopf}\{#AppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=commandline
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir={#OutputDir}
OutputBaseFilename={#OutputBaseFilename}
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
WizardStyle=modern
Compression=lzma2/max
SolidCompression=yes
CloseApplications=force
RestartApplications=no
ShowLanguageDialog=auto

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ja"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "ko"; MessagesFile: "compiler:Languages\Korean.isl"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "pt"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"
Name: "zh"; MessagesFile: "installer\ChineseSimplified.isl"
Name: "zh_tw"; MessagesFile: "installer\ChineseTraditional.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[InstallDelete]
; Replace Flutter assets and bundled models cleanly so stale files do not linger.
Type: filesandordirs; Name: "{app}\data\flutter_assets"
Type: filesandordirs; Name: "{app}\models"
Type: files; Name: "{app}\data\app.so"
Type: files; Name: "{app}\data\icudtl.dat"

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
