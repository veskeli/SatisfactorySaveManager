#NoEnv
#SingleInstance
SendMode Input 
SetWorkingDir %A_ScriptDir%  

CapsLock::
Click % GetKeyState("RButton") ? "Up" : "Down"
return

Delete::
ExitApp