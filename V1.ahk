#Persistent
#SingleInstance Force
SendMode Input
SetBatchLines -1

macro_running := false
status_s := "Waiting"
mouseX := 0
mouseY := 0

; -------- Welcome --------
MsgBox, 0, Jujutsu Zero Raid Macro,
(
Hello this is macro Game : Jujutsu Zero (Raid)

Raid : Toji
Req : Gojo , Sukuna Tec
Setting : lock on is N key
)

MsgBox, 0, How to use,
(
1. Go to Toji raid and start 
2. Run macro 
3. Wait... done
)

; -------- GUI STATUS --------
Gui, +AlwaysOnTop -Caption +ToolWindow +LastFound
Gui, Color, FFFFFF        ; พื้นหลังสีขาว
Gui, Font, c000000 s10, Consolas
Gui, Add, Text, vStatusText w260 h150 BackgroundTrans
Gui, Show, x30 y300, StatusOverlay
WinSet, Transparent, 180  ; ทำให้ขุ่น

SetTimer, UpdateStatus, 500
return

; ------------------ START ------------------
F1::
if (macro_running)
    return
macro_running := true
status_s := "start"

while (macro_running)
{
    Gosub, DoMacro
}
return

; ------------------ STOP ------------------
F2::
macro_running := false
status_s := "stop"
return



Random(min, max) {
    Random, out, %min%, %max%
    return out
}


; ------------------ Macro Loop ------------------
DoMacro:
; --- กด N ---
Sleep, 300
Send, {n}
status_s := "press N"
Sleep, 300
SysGet, screenW, 78
SysGet, screenH, 79
centerX := screenW // 2
centerY := screenH // 2
MouseMove, centerX, centerY, 0
; --- หมุนกล้องขวาค้างเมาส์ขวา smooth ---
status_s := "Set center"
Sleep, 50
Send, {Shift up}
Sleep, 100
Send, {RButton down}
Sleep, 100
Loop, 3 {
    Loop, 30
    {
        DllCall("mouse_event", "UInt", 0x01, "Int", 15, "Int", 0)
        Sleep, 15
    }
}
Send, {RButton up}
status_s := "Camera turned"

; --- กด Ctrl ---
Send, {Ctrl}
Sleep, 500

; --- ใช้ Skill ---
status_s := "Use Gojo skill C"
Send, 1
Sleep, 500
Send, {c down}
Sleep, 50
Send, {c up}

Sleep, 10000
status_s := "Use Sukuna skill C"
Send, 2
Sleep, 1000
Send, {c down}
Sleep, 50
Send, {c up}
Sleep, 10000

status_s := "Ctrl..."
Sleep, 1000
Send, {Ctrl}
Sleep, 1000
; --- คลิกตำแหน่ง Raid ---
status_s := "Next..."
MouseMove, 970, 785, 10
Click
MouseMove, 970, 785, 10
Click
Sleep, 1000
Click
MouseMove, 970, 800, 10
Click
Sleep, 3000
status_s := "Retry..."
MouseMove, 871, 170, 100
Sleep, 300
MouseClick, left
Sleep, 500
MouseClick, left
MouseMove, 871, 145, 100
Sleep, 1000
MouseClick, left
Sleep, 1000
MouseClick, left
Click
status_s := "waiting..."
Sleep, 17500

return


UpdateStatus:
value++
MouseGetPos, mouseX, mouseY
status := "===== RAID STATUS =====`n"
status .= "Raid : Toji`n"
status .= "Req  : Gojo, Sukuna Tec`n"
status .= "-----------------------`n"
status .= "F1 : start | F2 : stop | Esc : exit`n"
status .= "-----------------------`n"
status .= "State : " status_s "`n"
status .= "Mouse X : " mouseX "`n"
status .= "Mouse Y : " mouseY

GuiControl,, StatusText, %status%
return

Esc::
SetTimer, UpdateStatus, Off
ExitApp
return
