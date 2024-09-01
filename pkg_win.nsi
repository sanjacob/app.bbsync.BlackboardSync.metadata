# NSIS BlackboardSync Installer
# Copyright 2024, Jacob Sánchez

# Include Modern UI
!include "MUI2.nsh"

# Installer File and Name
Name "Blackboard Sync"
Outfile "..\dist\Blackboard Sync-${VERSION}.exe"
Unicode True

# Installation Dir
InstallDir "$APPDATA\Blackboard Sync"
InstallDirRegKey HKCU "Software\Blackboard Sync" "InstallDir"
# Request Privileges
RequestExecutionLevel user

# MUI Settings
!define MUI_LICENSEPAGE_TEXT_BOTTOM "You are now aware of your rights. Click next to continue."
!define MUI_LICENSEPAGE_BUTTON "Next"
!define MUI_FINISHPAGE_LINK "https://bbsync.app"
!define MUI_ICON ".\icon.ico"
!define MUI_UNICON ".\icon.ico"

# Installer Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ".\LICENSE"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

# Uninstaller Pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

# Languages
!insertmacro MUI_LANGUAGE "English"

# Uninstall Settings
!define AUTORUN_REGKEY "Software\Microsoft\Windows\CurrentVersion\Run"
!define UNINSTALL_REGKEY '"Software\Microsoft\Windows\CurrentVersion\Uninstall\Blackboard Sync"'


# default section start; every NSIS script has at least one section.
Section "Installation" SecInstall
    SetOutPath "$INSTDIR"
    File /r "..\dist\BBSync\*"

    ; Install Directory
    WriteRegStr HKCU '"Software\Blackboard Sync"' "InstallDir" $INSTDIR

    ; Run on Startup
    WriteRegStr HKCU ${AUTORUN_REGKEY} "Blackboard Sync" '"$INSTDIR\BBSync.exe"'

    ; Shortcut
    CreateDirectory "$SMPROGRAMS\Blackboard Sync"
    CreateShortCut "$SMPROGRAMS\Blackboard Sync\Blackboard Sync.lnk" "$INSTDIR\BBSync.exe"

    ; Uninstall Menu
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "DisplayName" "Blackboard Sync"
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "InstallLocation" $INSTDIR
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "DisplayIcon" "$INSTDIR\blackboard_sync\assets\logo.ico"
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "Publisher" "WeAreMagic"
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "HelpLink" "https://github.com/sanjacob/BlackboardSync"
    WriteRegStr HKCU ${UNINSTALL_REGKEY} "DisplayVersion" ${VERSION}

    WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd


Section "Uninstall"
  Delete "$APPDATA\blackboard_sync"

  ; Remove Application
  RMDir /r $INSTDIR

  ; Run on Startup
  DeleteRegKey HKCU '"${AUTORUN_REGKEY}\Blackboard Sync"'

  ; Install Directory
  DeleteRegKey HKCU '"Software\Blackboard Sync"'

  ; Uninstall Menu Entry
  DeleteRegKey HKLM ${UNINSTALL_REGKEY}

  ; Delete Shortcut
  RMDir /r "$SMPROGRAMS\Blackboard Sync"
SectionEnd