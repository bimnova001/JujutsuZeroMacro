
#Persistent
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
Process, Priority,, High
SendMode Input
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

global ImageFile    := A_ScriptDir . "\start.png"
global SearchVariance := 100       
global MacroRunning := false
global CurrentState := "Idle"
global MouseX := 0
global MouseY := 0


Gui, +AlwaysOnTop -Caption +ToolWindow +LastFound +E0x20 
Gui, Color, 111111                                      
Gui, Font, cWhite s9, Segoe UI
Gui, Add, Text, vStatusText w280 h160 BackgroundTrans
Gui, Show, x30 y300, StatusOverlay
WinSet, Transparent, 200


SetTimer, UpdateOverlay, 100

MsgBox, 64, Jujutsu Zero Raid Macro,
(
Macro Ready!
Raid: Toji
Req: Gojo, Sukuna Tec

Controls:
[F1] Start
[F2] Stop
[Esc] Exit
)

return 

F1::
    if (MacroRunning)
        return
    
    MacroRunning := true
    CurrentState := "Starting..."
    SoundBeep, 750, 100
    
    while (MacroRunning) {
        RunRaidCycle()
        Sleep, 1000 
    }
return

F2::
    MacroRunning := false
    CurrentState := "Stopped by User"
    SoundBeep, 300, 100
    Tooltip 
return

Esc::
    ExitApp
return

RunRaidCycle() {
    if (!MacroRunning) return

    CurrentState := "Waiting for Game Start..."
    GuiControl,, StatusText, % "Status : " CurrentState 

    
    startTime := A_TickCount
    WaitTimeSeconds := 8  
    gameFound := false

    Loop {
        if (!MacroRunning) return
        
        MouseMove, 1, 1, 0, R
        MouseMove, -1, -1, 0, R

        ImageSearch, foundX, foundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *60 %ImageFile%
        
        if (ErrorLevel = 0) {
            gameFound := true
            CurrentState := ">> GAME FOUND! <<"
            SoundBeep, 1000, 150 
            break 
        }

        ; เช็คว่าหมดเวลาหรือยัง
        if ((A_TickCount - startTime) > (WaitTimeSeconds * 1000)) {
             gameFound := false
             break 
        }

        Sleep, 500 
    }

    if (gameFound) {
        Sleep, 1000 

        if (!MacroRunning) return
        CurrentState := "Combat: Prep & Camera"
        Send, {n}          
        Sleep, 300
        CenterCamera()
        Send, {Ctrl}       
        Sleep, 500

        CurrentState := "Combat: Gojo C"
        Send, 1
        Sleep, 500
        CastSkill("c", 100) 
        Sleep, 10500        
        CurrentState := "Combat: Sukuna C"
        Send, 2
        Sleep, 1000
        CastSkill("c", 100)
        Sleep, 10500

        CurrentState := "Finishing..."
        Send, {Ctrl}
        Sleep, 1000
        
        Loop 3 { 
             ClickPosition(970, 785)
             Sleep, 300
        }
        ClickPosition(970, 800)
        Sleep, 3000
        PerformRetrySequence()
        CurrentState := "Cooling down (17s)..."
        Sleep, 17500

    } else {
        if (!MacroRunning) return
        CurrentState := "xx Not Found -> Retrying xx"
        PerformRetrySequence()
        Sleep, 2000 
    }
}
PerformRetrySequence() {
    MouseMove, 871, 170, 0
    Sleep, 300
    Click, 2 
    
    MouseMove, 871, 145, 0
    Sleep, 1000
    Click, 2
    
    Sleep, 500
    Click
}

CastSkill(key, holdDuration) {
    Send, {%key% down}
    Sleep, %holdDuration%
    Send, {%key% up}
}


ClickPosition(x, y) {
    MouseMove, %x%, %y%, 0
    Click
}


CenterCamera() {
    CurrentState := "Adjusting Camera"
    
    SysGet, screenW, 78
    SysGet, screenH, 79
    centerX := screenW // 2
    centerY := screenH // 2
    MouseMove, centerX, centerY, 0
    
    Send, {Shift up}
    Sleep, 100
    Send, {RButton down}
    Sleep, 100
    
    ; หมุนเมาส์แบบ smooth
    Loop, 3 {
        Loop, 30 {
            DllCall("mouse_event", "UInt", 0x01, "Int", 15, "Int", 0, "UInt", 0, "UInt", 0)
            Sleep, 10 
        }
    }
    Send, {RButton up}
}


UpdateOverlay:
    MouseGetPos, mX, mY
    
    info := "== JUJUTSU ZERO MACRO ==`n"
    info .= "------------------------`n"
    info .= "Status : " . CurrentState . "`n"
    info .= "Time   : " . A_Hour . ":" . A_Min . ":" . A_Sec . "`n"
    info .= "------------------------`n"
    info .= "Mouse  : " . mX . ", " . mY . "`n"
    info .= "[F1] Start | [F2] Stop"
    
    GuiControl,, StatusText, %info%
return