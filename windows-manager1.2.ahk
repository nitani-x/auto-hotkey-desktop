
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SettingsFile = HotkeySettings.ini
class ShortcutsProfile {
__New(profileName, profileFile) {
this.Name := profileName
this.File := profileFile
}
}
class Profiles {
static AltWin := new ShortcutsProfile("Alt+Win shortcuts", "ShortcutDefs-AltWin.ini")
static CtrlWin := new ShortcutsProfile("Ctrl+Win shortcuts", "ShortcutDefs-CtrlWin.ini")
static Custom := new ShortcutsProfile("Custom shortcuts", "ShortcutDefs-Custom.ini")
static Defaults := new ShortcutsProfile("Default shortcuts", "")
static None := new ShortcutsProfile("No shortcuts", "")
static Current := AltWin
}
IniRead, InitialShortcutsProfileName, %SettingsFile%, General, InitialShortcutsProfile
InitialShortcutsProfile := GetShortcutsProfileFromName(InitialShortcutsProfileName)
IniRead, PixelsPerStep, %SettingsFile%, Settings, PixelsPerStep, 50
InitializeIcon()
InitializeMenu()
KeysInUse := []
SetShortcutsProfile(InitialShortcutsProfile)
Return
InitializeIcon() {
if FileExist("AltWinHotKeys.ico") {
Menu, Tray, Icon, AltWinHotKeys.ico
}
}
InitializeMenu() {
Menu, Tray, Add, About Alt+Win HotKeys, ShowAboutDialog
Menu, Tray, Add, Settings, OpenSettings
Menu, Tray, Add, Edit Custom shortcuts, OpenCurrentShortSet
Menu, Tray, Add
Menu, Profiles, Add, % Profiles.AltWin.Name, SetAltKeyShortcuts
Menu, Profiles, Add, % Profiles.CtrlWin.Name, SetCtrlKeyShortcuts
Menu, Profiles, Add, % Profiles.Custom.Name, SetCustomShortcuts
Menu, Profiles, Add, % Profiles.Defaults.Name, SetDefaultShortcuts
Menu, Profiles, Add, % Profiles.None.Name, SetNoShortcuts
Menu, Tray, Add, Shortcut &Profiles, :Profiles
MoveStandardMenuToBottom()
}
GetShortcutsProfileFromName(ShortcutsProfileName) {
switch ShortcutsProfileName {
case Profiles.AltWin.Name: return Profiles.AltWin
case Profiles.CtrlWin.Name: return Profiles.CtrlWin
case Profiles.Custom.Name: return Profiles.Custom
case Profiles.None.Name: return Profiles.None
default: return Profiles.Defaults
}
}
SetAltKeyShortcuts() {
ChangeShortcutsProfile(Profiles.AltWin)
}
SetCtrlKeyShortcuts() {
ChangeShortcutsProfile(Profiles.CtrlWin)
}
SetCustomShortcuts() {
ChangeShortcutsProfile(Profiles.Custom)
}
SetDefaultShortcuts() {
ChangeShortcutsProfile(Profiles.Defaults)
}
SetNoShortcuts() {
ChangeShortcutsProfile(Profiles.None)
}
ChangeShortcutsProfile(ShortcutsProfile) {
if (ShortcutsProfile.File != "" AND NOT FileExist(ShortcutsProfile.File)) {
MsgBox % "Could not find shortcuts profile file: " ShortcutsProfile.File
return
}
ClearAllShortcuts()
UncheckAllProfiles()
SetShortcutsProfile(ShortcutsProfile)
MsgBox % "Move and Resize Windows is now configured for " Profiles.Current.Name
}
ClearAllShortcuts() {
global KeysInUse
For index, Keys in KeysInUse {
Hotkey, %Keys%, Off
}
KeysInUse := []
}
UncheckAllProfiles() {
Menu, Profiles, Uncheck, % Profiles.AltWin.Name
Menu, Profiles, Uncheck, % Profiles.CtrlWin.Name
Menu, Profiles, Uncheck, % Profiles.Custom.Name
Menu, Profiles, Uncheck, % Profiles.Defaults.Name
Menu, Profiles, Uncheck, % Profiles.None.Name
}
SetShortcutsProfile(ShortcutsProfile) {
Profiles.Current := ShortcutsProfile
SetShortcuts(ShortcutsProfile)
Menu, Profiles, Check, % ShortcutsProfile.Name
}
ShowAboutDialog() {
MsgBox 0, Alt+Win HotKeys, Alt+Win HotKeys - Utility to move and resize windows.`n`n Developed by Justin Clareburt
}
OpenSettings() {
global SettingsFile
Run, % "edit " SettingsFile
}
OpenCurrentShortSet() {
Run, % "edit " Profiles.Custom.File
}
MoveStandardMenuToBottom() {
Menu, Tray, Add
Menu, Tray, NoStandard
Menu, Tray, Standard
}
SetShortcuts(ShortcutsProfile) {
ShortcutsFile := ShortcutsProfile.File
if (Profiles.Current == Profiles.None) {
return
}
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveLeft", "", "!#Left")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveRight", "", "!#Right")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveUp", "", "!#Up")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveDown", "", "!#Down")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTop", "MoveTop", "!#PgUp")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTop2", "MoveTop", "!#Numpad8")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottom", "MoveBottom", "!#PgDn")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottom2", "MoveBottom", "!#Numpad2")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardLeft", "MoveHardLeft", "!#Home")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardLeft2", "MoveHardLeft", "!#Numpad4")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardRight", "MoveHardRight", "!#End")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveHardRight2", "MoveHardRight", "!#Numpad6")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTopLeft", "MoveTopLeft", "!#Numpad7")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveTopRight", "MoveTopRight", "!#Numpad9")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottomLeft", "MoveBottomLeft", "!#Numpad1")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveBottomRight", "MoveBottomRight", "!#Numpad3")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveCenter", "MoveCenter", "!#Del")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveCenter2", "MoveCenter", "!#Numpad5")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeLeft", "ResizeLeft", "!+#Left")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeRight", "ResizeRight", "!+#Right")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeUp", "ResizeUp", "!+#Up")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeDown", "ResizeDown", "!+#Down")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeLarger", "ResizeLarger", "!+#PgDn")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeSmaller", "ResizeSmaller", "!+#PgUp")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow", "Grow", "!+#=")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow2", "Grow", "!+#NumpadAdd")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow3", "Grow", "!#=")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow4", "Grow", "!#NumpadAdd")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow5", "Grow", "^#+")
ReadAndStoreHotKeyAction(ShortcutsFile, "Grow6", "Grow", "^#NumpadAdd")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink", "Shrink", "!+#-")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink2", "Shrink", "!+#NumpadSub")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink3", "Shrink", "!#-")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink4", "Shrink", "!#NumpadSub")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink5", "Shrink", "^#-")
ReadAndStoreHotKeyAction(ShortcutsFile, "Shrink6", "Shrink", "^#NumpadSub")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeHalfScreen", "ResizeHalfScreen", "!+#Del")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeThreeQuarterScreen", "ResizeThreeQuarterScreen", "!+#Home")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeFullScreen", "ResizeFullScreen", "!#Enter")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeFullScreen2", "ResizeFullScreen", "!+#Enter")
ReadAndStoreHotKeyAction(ShortcutsFile, "RestoreToPreviousPosn", "RestoreToPreviousPosn", "!#Backspace")
ReadAndStoreHotKeyAction(ShortcutsFile, "RestoreToPreviousPosnAndSize", "RestoreToPreviousPosnAndSize", "!+#Backspace")
ReadAndStoreHotKeyAction(ShortcutsFile, "SwitchToPreviousDesktop", "SwitchToPreviousDesktop", "^#,")
ReadAndStoreHotKeyAction(ShortcutsFile, "SwitchToNextDesktop", "SwitchToNextDesktop", "^#.")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToPreviousDesktop", "MoveToPreviousDesktop", "^+#,")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToPreviousDesktop2", "MoveToPreviousDesktop", "^+#Left")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToNextDesktop", "MoveToNextDesktop", "^+#.")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveToNextDesktop2", "MoveToNextDesktop", "^+#Right")
ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsVertically", "TileWindowsVertically", "!#V")
ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsVertically2", "TileWindowsVertically", "!+#V")
ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsHorizontally", "TileWindowsHorizontally", "!#H")
ReadAndStoreHotKeyAction(ShortcutsFile, "TileWindowsHorizontally2", "TileWindowsHorizontally", "!+#H")
ReadAndStoreHotKeyAction(ShortcutsFile, "CascadeWindows", "CascadeWindows", "!#C")
ReadAndStoreHotKeyAction(ShortcutsFile, "CascadeWindows2", "CascadeWindows", "!+#C")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeTo3Column", "", "!+#3")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeTo4Column", "", "!+#4")
ReadAndStoreHotKeyAction(ShortcutsFile, "ResizeTo5Column", "", "!+#5")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveLeftOneQuarter", "", "!#,")
ReadAndStoreHotKeyAction(ShortcutsFile, "MoveRightOneQuarter", "", "!#.")
return
}
ReadAndStoreHotKeyAction(ShortcutsFile, KeyCode, KeyAction, DefaultKeys) {
if (Profiles.Current == Profiles.Defaults) {
KeyCombo := DefaultKeys
} else {
IniRead, KeyCombo, %ShortcutsFile%, Shortcuts, %KeyCode%
}
if (KeyCombo != "ERROR") {
if (KeyAction == "") {
SetHotkeyAction(KeyCombo, KeyCode)
} else {
SetHotkeyAction(KeyCombo, KeyAction)
}
}
}
SetHotkeyAction(Keys, KeyAction) {
global KeysInUse
Hotkey, %Keys%, %KeyAction%, On
KeysInUse.Push(Keys)
}
MoveLeft:
DoMoveAndResize(-1, 0)
return
MoveRight:
DoMoveAndResize(1, 0)
return
MoveUp:
DoMoveAndResize(0, -1)
return
MoveDown:
DoMoveAndResize(0, 1)
return
MoveTop:
MoveToEdge("Top")
return
MoveBottom:
MoveToEdge("Bottom")
return
MoveHardLeft:
MoveToEdge("HardLeft")
return
MoveHardRight:
MoveToEdge("HardRight")
return
MoveTopLeft:
MoveToEdge("TopLeft")
return
MoveTopRight:
MoveToEdge("TopRight")
return
MoveBottomLeft:
MoveToEdge("BottomLeft")
return
MoveBottomRight:
MoveToEdge("BottomRight")
return
MoveCenter:
MoveWindowToCenter()
return
ResizeLeft:
DoMoveAndResize( , , -1, 0)
return
ResizeRight:
DoMoveAndResize( , , 1, 0)
return
ResizeUp:
DoMoveAndResize( , , 0, -1)
return
ResizeDown:
DoMoveAndResize( , , 0, 1)
return
ResizeLarger:
DoMoveAndResize( , , 1, 1)
return
ResizeSmaller:
DoMoveAndResize( , , -1, -1)
return
Grow:
DoMoveAndResize(-1, -1, 2, 2)
return
Shrink:
DoMoveAndResize(1, 1, -2, -2)
return
ResizeHalfScreen:
ResizeAndCenter(0.5)
return
ResizeThreeQuarterScreen:
ResizeAndCenter(0.75)
return
ResizeFullScreen:
ResizeAndCenter(1)
return
RestoreToPreviousPosn:
EnsureWindowIsRestored()
WinMove, WinX, WinY
return
RestoreToPreviousPosnAndSize:
EnsureWindowIsRestored()
WinMove, A, , WinX, WinY, WinW, WinH
return
TileWindowsVertically:
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return
TileWindowsHorizontally:
DllCall( "TileWindows", uInt,0, Int,0, Int,0, Int,0, Int,0 )
return
CascadeWindows:
DllCall( "CascadeWindows", uInt,0, Int,4, Int,0, Int,0, Int,0 )
return
SwitchToPreviousDesktop()
{
send {LWin down}{LCtrl down}{Left}{LCtrl up}{LWin up}
return
}
SwitchToNextDesktop()
{
send {LWin down}{LCtrl down}{Right}{LCtrl up}{LWin up}
return
}
MoveToPreviousDesktop()
{
MoveWindowToOtherDesktop(-1)
}
MoveToNextDesktop()
{
MoveWindowToOtherDesktop(1)
}
MoveWindowToOtherDesktop(direction)
{
WinWait, A
WinHide
if (direction > 0) {
SwitchToNextDesktop()
} else {
SwitchToPreviousDesktop()
}
Sleep 100
WinShow
WinActivate
}
MoveToEdge(Edge)
{
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
WinGetPos, WinX, WinY, WinW, WinH, A
if InStr(Edge, "Left")
NewX := MonLeft
if InStr(Edge, "Right")
NewX := MonRight - WinW
if InStr(Edge, "Top")
NewY := MonTop
if InStr(Edge, "Bottom")
NewY := MonBottom - WinH
RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
return
}
MoveWindowToCenter() {
WinGetPos, WinX, WinY, WinW, WinH, A
WinNum := GetWindowNumber()
DoResizeAndCenter(WinNum, WinW, WinH)
return
}
DoMoveAndResize(MoveX:=0, MoveY:=0, GrowW:=0, GrowH:=0)
{
GetMoveCoordinates(A, NewX, NewY, NewW, NewH, MoveX, MoveY, GrowW, GrowH)
RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
}
DoResizeAndCenter(WinNum, NewW, NewH)
{
GetCenterCoordinates(A, WinNum, NewX, NewY, NewW, NewH)
RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
}
ResizeAndCenter(Ratio)
{
WinNum := GetWindowNumber()
CalculateSizeByWinRatio(NewW, NewH, WinNum, Ratio)
DoResizeAndCenter(WinNum, NewW, NewH)
}
CalculateSizeByWinRatio(ByRef NewW, ByRef NewH, WinNum, Ratio)
{
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
NewW := (MonRight - MonLeft) * Ratio
NewH := (MonBottom - MonTop) * Ratio
}
RestoreMoveAndResize(A, NewX, NewY, NewW, NewH)
{
EnsureWindowIsRestored()
WinMove, A, , NewX, NewY, NewW, NewH
}
GetMoveCoordinates(ByRef A, ByRef NewX, ByRef NewY, ByRef NewW, ByRef NewH, MovX:=0, MovY:=0, GrowW:=0, GrowH:=0)
{
global PixelsPerStep
WinGetPos, WinX, WinY, WinW, WinH, A
NewW := WinW + (PixelsPerStep * GrowW)
NewH := WinH + (PixelsPerStep * GrowH)
NewX := WinX + (PixelsPerStep * MovX)
NewY := WinY + (PixelsPerStep * MovY)
}
GetCenterCoordinates(ByRef A, WinNum, ByRef NewX, ByRef NewY, WinW, WinH)
{
SysGet, Mon, MonitorWorkArea, %WinNum%
ScreenW := MonRight - MonLeft
ScreenH := MonBottom - MonTop
NewX := (ScreenW-WinW)/2 + MonLeft
NewY := (ScreenH-WinH)/2 + MonTop
}
EnsureWindowIsRestored()
{
WinGet, ActiveWinState, MinMax, A
if (ActiveWinState != 0)
WinRestore, A
}
GetWindowNumber()
{
WinGetPos, WinX, WinY, WinW, WinH, A
SysGet, numMonitors, MonitorCount
Loop %numMonitors% {
SysGet, monitor, MonitorWorkArea, %A_Index%
if (monitorLeft <= WinX && WinX < monitorRight && monitorTop <= WinY && WinY <= monitorBottom){
return %A_Index%
}
}
return 1
}
ResizeTo3Column() {
ResizeToMultiColumn(3)
}
ResizeTo4Column() {
ResizeToMultiColumn(4)
}
ResizeTo5Column() {
ResizeToMultiColumn(5)
}
MoveLeftOneQuarter() {
WinNum := GetWindowNumber()
GoToColNum := GetPrevColNum(4, WinNum)
if (GoToColNum < 1) {
if (WinNum > 1) {
WinNum--
GoToColNum := 4
} else {
GoToColNum := 1
}
}
SnapToQuarterScreen(GoToColNum, WinNum)
}
MoveRightOneQuarter() {
WinNum := GetWindowNumber()
GoToColNum := GetNextColNum(4, WinNum)
if (GoToColNum > 4) {
SysGet, numMonitors, MonitorCount
if (WinNum < numMonitors) {
WinNum++
GoToColNum := 1
} else {
GoToColNum := 4
}
}
SnapToQuarterScreen(GoToColNum, WinNum)
}
ResizeToMultiColumn(ColCount) {
WinGetPos, WinX, WinY, WinW, WinH, A
WinNum := GetWindowNumber()
SysGet, Mon, MonitorWorkArea, %WinNum%
MonWorkingWidth := MonRight - MonLeft
MonWorkingHeight := MonBottom - MonTop
WinPaddingX := 0
NewY := MonTop
NewW := (MonWorkingWidth / ColCount) + (WinPaddingX * 2)
NewH := MonWorkingHeight
RestoreMoveAndResize(A, WinX, NewY, NewW, NewH)
}
SnapToQuarterScreen(ColNum, WinNum) {
WinGetPos, WinX, WinY, WinW, WinH, A
SysGet, Mon, MonitorWorkArea, %WinNum%
MonWorkingWidth := MonRight - MonLeft
ColWidth := MonWorkingWidth / 4
WinPaddingX := 0
NewX := MonLeft + ((ColNum-1) * ColWidth) - WinPaddingX
RestoreMoveAndResize(A, NewX, WinY, WinW, WinH)
}
GetPrevColNum(ColCount, WinNum) {
DestCol := GetCurrentColNum(WinNum, ColCount, bOnColEdge)
if (bOnColEdge) {
DestCol--
}
return DestCol
}
GetNextColNum(ColCount, WinNum) {
DestCol := GetCurrentColNum(WinNum, ColCount)
DestCol++
return DestCol
}
GetCurrentColNum(WinNum, ColCount, ByRef bOnColEdge := false)
{
WinGetPos, WinX, WinY, WinW, WinH, A
SysGet, Mon, MonitorWorkArea, %WinNum%
MonWorkingWidth := MonRight - MonLeft
MonWorkingHeight := MonBottom - MonTop
ColWidth := MonWorkingWidth / ColCount
AdjustX := 0
CurrentCol := 1
loop, %ColCount% {
ColStartX := Floor(MonLeft + (ColWidth * (A_Index-1)))
ColEndX := Floor(MonLeft + (ColWidth * A_Index))
if (WinX+AdjustX < ColEndX) {
bOnColEdge := (WinX = ColStartX-AdjustX)
CurrentCol := A_Index
break
}
}
return CurrentCol
}











;#c::Manager_closeWindow()
















; alt-click-move.ahk
;
; When Alt + left mouse button is pressed, move the window under the cursor,
; as long as the window is not maximized, or a vnc viewer.
;
; Cody Cziesler
#SingleInstance force
!LButton::

  ; Get window under cursor
  MouseGetPos, , , id

  ; Abort if window is maximized
  ignore := flase
  WinGet, window_minmax, MinMax, ahk_id %id%
  if (window_minmax <> 0) {
    ignore := true
  }

  ; Abort if app is a vnc viewer
  WinGetClass, class, A
  if (InStr(class, "vnc")) {
    ignore := true
  }

  ; Send win + left mouse button (if not ignoring)
  if (ignore) {
    Send {Alt down}{LButton down}
  }

  ; Get mouse and window position
  CoordMode, Mouse, Screen
  MouseGetPos, mouse_x, mouse_y
  WinGetPos, win_x, win_y, , , ahk_id %id%

  ; Change win_x/win_y based on initial mouse position
  win_x := mouse_x - win_x
  win_y := mouse_y - win_y

  ; Reduce latency of movements
  SetWinDelay, 0

  ; Set the transparency
  if (!ignore) {
    WinActivate, ahk_id %id%
    WinSet Transparent, 150, ahk_id %id%
  }

  ; Loop until left button released
  loop {
    if !GetKeyState("LButton", "P") {
      break
    }
    if (!ignore) {
      MouseGetPos, mouse_x, mouse_y
      WinMove ahk_id %id%, , (mouse_x - win_x), (mouse_y - win_y)
    }
  }

  ; Reset the transparency
  WinSet Transparent, Off, ahk_id %id%

  ; Release Alt + left mouse button
  Send {Alt up}{LButton up}

  return






































; alt-click-move.ahk
;
; When Alt + left mouse button is pressed, move the window under the cursor,
; as long as the window is not maximized, or a vnc viewer.
;
; Cody Cziesler
#SingleInstance force
#LButton::

  ; Get window under cursor
  MouseGetPos, , , id

  ; Abort if window is maximized
  ignore := flase
  WinGet, window_minmax, MinMax, ahk_id %id%
  if (window_minmax <> 0) {
    ignore := true
  }

  ; Abort if app is a vnc viewer
  WinGetClass, class, A
  if (InStr(class, "vnc")) {
    ignore := true
  }

  ; Send Alt + left mouse button (if not ignoring)
  if (ignore) {
    Send {Alt down}{LButton down}
  }

  ; Get mouse and window position
  CoordMode, Mouse, Screen
  MouseGetPos, mouse_x, mouse_y
  WinGetPos, win_x, win_y, , , ahk_id %id%

  ; Change win_x/win_y based on initial mouse position
  win_x := mouse_x - win_x
  win_y := mouse_y - win_y

  ; Reduce latency of movements
  SetWinDelay, 0

  ; Set the transparency
  if (!ignore) {
    WinActivate, ahk_id %id%
    WinSet Transparent, 150, ahk_id %id%
  }

  ; Loop until left button released
  loop {
    if !GetKeyState("LButton", "P") {
      break
    }
    if (!ignore) {
      MouseGetPos, mouse_x, mouse_y
      WinMove ahk_id %id%, , (mouse_x - win_x), (mouse_y - win_y)
    }
  }

  ; Reset the transparency
  WinSet Transparent, Off, ahk_id %id%

  ; Release Alt + left mouse button
  Send {Alt up}{LButton up}

  return