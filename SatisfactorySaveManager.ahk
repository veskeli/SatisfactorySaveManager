/*
Satisfactory Ahk menu:
*/
;//////////////[Start settings]///////////////
SendMode Input
SetWorkingDir %A_ScriptDir%
EnvGet, A_LocalAppData, LocalAppData
;###
#NoEnv
#SingleInstance Force
;____________________________________________________________
;//////////////[vars]/////////////// 
version = 0.3
AppFolderName = AHKGameScriptsByVeskeli/SatisfactorySaveManager
appFolder = %A_AppData%\%appfoldername%
settingsFolder = %A_AppData%\%appfoldername%\Settings

IfExist, %AppFolderName%\Old_satisfactorySaveManager.ahk
{
    FileDelete, %AppFolderName%\Old_satisfactorySaveManager.ahk
}
;____________________________________________________________
;//////////////[Gui]/////////////// 
Gui Font, s9, Segoe UI
Gui Add, GroupBox, x8 y8 w348 h99, Saves
Gui Add, Text, x16 y32 w86 h23 +0x200, Custom saves:
Gui Add, Text, x16 y64 w74 h23 +0x200, Game saves:
Gui Add, DropDownList, x112 y32 w120 vlist1, Empty||
Gui Add, DropDownList, x112 y64 w120 vlist2, Empty||
Gui Add, Button, x240 y32 w97 h23 gCopyFirstToDesktop, Copy to desktop
Gui Add, Button, x240 y64 w97 h23 gCopySecondToDesktop, Copy to desktop
Gui Add, Button, x16 y112 w108 h32 gImportSave +Disabled, Import save file
Gui Add, GroupBox, x127 y98 w175 h80, App updates
Gui Add, CheckBox, x144 y120 w145 h23 +Checked gAutoUpdates vcheckup, Check updates on start
Gui Add, Button, x152 y144 w119 h23 gcheckForupdates, Check for updates
Gui Add, Button, x24 y152 w80 h23 gOpenDesktop, Open desktop
Gui Add, Button, x304 y112 w52 h38 gOpenSaves, Open`nSaves

Gui Show, w367 h185, SatisfactorySaveManager

SpecialFolder = %A_LocalAppData%\FactoryGame\Saved\SaveGames
loop, Files, % SpecialFolder "\*.*"
{
	SplitPath, A_LoopFileName,,,, FileName
	List .= FileName "|"
}
T_list := RTrim(List, "|")
T_list := StrReplace(List, "|", "||",, 1) ; make first item default
if(T_list != "")
{
    GuiControl,,list1,|
}
GuiControl,,list1,%T_list%
;List 2
SpecialFolder = %A_LocalAppData%\FactoryGame\Saved\SaveGames\common
loop, Files, % SpecialFolder "\*.*"
{
	SplitPath, A_LoopFileName,,,, FileName
	List3 .= FileName "|"
}
T_list := RTrim(List3, "|")
T_list := StrReplace(List3, "|", "||",, 1) ; make first item default
if(T_list != "")
{
    GuiControl,,list2,|
}
GuiControl,,list2,%T_list%
Return
GuiEscape:
GuiClose:
    ExitApp
;____________________________________________________________
;//////////////[Exit]///////////////
Delete::
ExitApp
;____________________________________________________________
;//////////////[Funct]///////////////
OpenSaves:
run, %A_LocalAppData%\FactoryGame\Saved\SaveGames
return
OpenDesktop:
run, %A_Desktop%
return
CopyFirstToDesktop:
Gui, Submit, Nohide
FileCopy, %A_LocalAppData%\FactoryGame\Saved\SaveGames\%list1%.sav, %A_Desktop%\%list1%.sav
return
CopySecondToDesktop:
Gui, Submit, Nohide
FileCopy, %A_LocalAppData%\FactoryGame\Saved\SaveGames\common\%list2%.sav, %A_Desktop%\%list2%.sav
return
ImportSave:
FileSelectFile,SelectedFile, 1, , Select Save File, Save file (*.sav)
if (SelectedFile = "")
{
    MsgBox, The user didn't select anything.
}
else
{
    FileCopy, %SelectedFile%,%A_LocalAppData%\FactoryGame\Saved\SaveGames\common\,0
}
return
;____________________________________________________________
;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/SatisfactorySaveManager/main/Version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "")
{
    if(newversion > version)
    {
        MsgBox, 1,Update,New version is  %newversion% `nOld is %version% `nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            FileMove, %A_ScriptFullPath%, %AppFolderName%\Old_satisfactorySaveManager.ahk, 1
            sleep 1000
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/SatisfactorySaveManager/main/SatisfactorySaveManager.ahk, %A_ScriptFullPath%
            Sleep 1000
            loop
            {
                IfExist %A_ScriptFullPath%
                {
                    Run, %A_ScriptFullPath%
                }
            }
			ExitApp
        }
    }
}
return
;Check updates on start button
AutoUpdates:
Gui, Submit, Nohide
FileCreateDir, %settingsFolder%
IniWrite, %checkup%, %settingsFolder%\Settings.ini, Settings, Updates
return