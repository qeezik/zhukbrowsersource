!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"

; Основные настройки
Name "ZhukBrowse"
OutFile "ZhukBrowse-Setup.exe"
InstallDir "$PROGRAMFILES\ZhukBrowse"
InstallDirRegKey HKCU "Software\ZhukBrowse" "Install_Dir"

; Запрашиваем права администратора
RequestExecutionLevel admin

; Интерфейс
!define MUI_ABORTWARNING
!define MUI_ICON "assets\icon.ico"
!define MUI_UNICON "assets\icon.ico"

; Страницы установки
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_CUSTOMFUNCTION_PRE DirectoryShow
!insertmacro MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Страницы удаления
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Языки
!insertmacro MUI_LANGUAGE "Russian"

; Переменные
Var Dialog
Var Label
Var CheckBox
Var InstallType

; Функция показа страницы выбора директории
Function DirectoryShow
    ${If} $InstallType == "auto"
        Abort
    ${EndIf}
FunctionEnd

; Функция после выбора директории
Function DirectoryLeave
    ${If} $InstallType == "auto"
        StrCpy $INSTDIR "$PROGRAMFILES\ZhukBrowse"
    ${EndIf}
FunctionEnd

; Страница выбора типа установки
Page custom InstallTypePage InstallTypePageLeave

Function InstallTypePage
    !insertmacro MUI_HEADER_TEXT "Тип установки" "Выберите способ установки ZhukBrowse"
    
    nsDialogs::Create 1018
    Pop $Dialog
    
    ${If} $Dialog == error
        Abort
    ${EndIf}
    
    ; Заголовок
    ${NSD_CreateLabel} 0 0 100% 20 "Выберите тип установки:"
    Pop $Label
    
    ; Радио кнопки
    ${NSD_CreateRadioButton} 0 30 100% 20 "&Автоматическая установка (рекомендуется)"
    Pop $0
    ${NSD_Check} $0
    ${NSD_OnClick} $0 InstallTypeAuto
    
    ${NSD_CreateRadioButton} 0 55 100% 20 "&Настраиваемая установка"
    Pop $1
    ${NSD_OnClick} $1 InstallTypeCustom
    
    ; Дополнительные опции
    ${NSD_CreateCheckBox} 0 85 100% 20 "Создать ярлык на рабочем столе"
    Pop $CheckBox
    ${NSD_Check} $CheckBox
    
    ${NSD_CreateCheckBox} 0 110 100% 20 "Запустить ZhukBrowse после установки"
    Pop $2
    ${NSD_Check} $2
    
    ${NSD_CreateCheckBox} 0 135 100% 20 "Создать ярлык в меню Пуск"
    Pop $3
    ${NSD_Check} $3
    
    nsDialogs::Show
FunctionEnd

Function InstallTypeAuto
    StrCpy $InstallType "auto"
FunctionEnd

Function InstallTypeCustom
    StrCpy $InstallType "custom"
FunctionEnd

Function InstallTypePageLeave
    ${If} $InstallType == ""
        StrCpy $InstallType "auto"
    ${EndIf}
FunctionEnd

; Секция установки
Section "ZhukBrowse" SecMain
    SectionIn RO
    
    SetOutPath "$INSTDIR"
    
    ; Копируем файлы
    File /r "dist\win-unpacked\*.*"
    
    ; Создаем ярлыки
    ${If} ${SectionIsSelected} ${SecDesktopShortcut}
        CreateShortCut "$DESKTOP\ZhukBrowse.lnk" "$INSTDIR\ZhukBrowse.exe"
    ${EndIf}
    
    ${If} ${SectionIsSelected} ${SecStartMenuShortcut}
        CreateDirectory "$SMPROGRAMS\ZhukBrowse"
        CreateShortCut "$SMPROGRAMS\ZhukBrowse\ZhukBrowse.lnk" "$INSTDIR\ZhukBrowse.exe"
        CreateShortCut "$SMPROGRAMS\ZhukBrowse\Удалить ZhukBrowse.lnk" "$INSTDIR\Uninstall.exe"
    ${EndIf}
    
    ; Записываем информацию об установке
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "Software\ZhukBrowse" "Install_Dir" "$INSTDIR"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "DisplayName" "ZhukBrowse"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "UninstallString" '"$INSTDIR\Uninstall.exe"'
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "DisplayIcon" "$INSTDIR\ZhukBrowse.exe"
    WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "Publisher" "ZhukBrowse Team"
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "NoModify" 1
    WriteRegDWORD HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse" "NoRepair" 1
SectionEnd

; Секция ярлыка на рабочем столе
Section "Desktop Shortcut" SecDesktopShortcut
    CreateShortCut "$DESKTOP\ZhukBrowse.lnk" "$INSTDIR\ZhukBrowse.exe"
SectionEnd

; Секция ярлыка в меню Пуск
Section "Start Menu Shortcut" SecStartMenuShortcut
    CreateDirectory "$SMPROGRAMS\ZhukBrowse"
    CreateShortCut "$SMPROGRAMS\ZhukBrowse\ZhukBrowse.lnk" "$INSTDIR\ZhukBrowse.exe"
    CreateShortCut "$SMPROGRAMS\ZhukBrowse\Удалить ZhukBrowse.lnk" "$INSTDIR\Uninstall.exe"
SectionEnd

; Секция удаления
Section "Uninstall"
    ; Удаляем файлы
    RMDir /r "$INSTDIR"
    
    ; Удаляем ярлыки
    Delete "$DESKTOP\ZhukBrowse.lnk"
    RMDir /r "$SMPROGRAMS\ZhukBrowse"
    
    ; Удаляем записи реестра
    DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\ZhukBrowse"
    DeleteRegKey HKCU "Software\ZhukBrowse"
SectionEnd 