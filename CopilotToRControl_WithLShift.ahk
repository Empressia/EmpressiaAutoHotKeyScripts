#Requires AutoHotKey v2.0
#SingleInstance Force

global LShifted := false
global LWinDateTime := 0
global RControlLShiftDateTime := 0
global ElapseLimit := 10

; https://github.com/Empressia/
; CopilotキーをRControlとみなして、LShiftとRControlの組み合わせをそれっぽく動かします（厳密じゃない）。
; CopilotキーがLWin+LShift+F23として動くとき用です。
; LShiftキーが押された状態での複数回のCopilotキーの押しなおしはサポートしていません（LShiftが押されていない状態になる）。
; LWinキーとの組み合わせは想定していません。
; RShiftキーの使用は想定していません。
; RControlが押しっぱなしの状態になってしまったら、Copilotキーを押して離すと戻る想定です。
; 確認用メモ。
; shiftdown > copilotdown > copilotup > shiftup OK
; shiftdown > copilotdown > shiftup > copilotup OK
; copilotdown > shiftdown > shiftup > copilotup OK
; copilotdown > shiftdown > copilotup > shiftup OK

~$LWin up::
{
	global LWinDateTime
	LWinDateTime := A_TickCount
}
~$LShift::
{
	global LShifted
	LShifted := true
}
~$>^LShift::
{
	global LShifted
	LShifted := true
}
~$LShift up::
{
	global LShifted
	LShifted := false
}
$>^LShift up::
{
	global LWinDateTime
	global ElapseLimit
	elapsed := A_TickCount - LWinDateTime
	if(elapsed < ElapseLimit)
	{
		; Copilotが離されてすぐ。
	}
	else
	{
		global LShifted
		LShifted := false
		SendInput("{Blind}{LShift up}")
	}
	global RControlLShiftDateTime
	RControlLShiftDateTime := A_TickCount
}
$<+<#F23::
{
	global LShifted
	if(!LShifted)
	{
		SendInput("{Blind}{LWin up}{LShift up}")
	}
	if(LShifted)
	{
		SendInput("{Blind}{LWin up}")
	}
	SendInput("{Blind}{RControl down}")
	KeyWait("F23")
	if(LShifted)
	{
		SendInput("{Blind}{LShift down}")
	}
	if(!LShifted)
	{
		global RControlLShoftDateTime
		global ElapseLimit
		elapsed := A_TickCount - RControlLShiftDateTime
		if(elapsed > ElapseLimit)
		{
			SendInput("{Blind}{LShift down}")
		}
	}
	SendInput("{Blind}{RControl up}")
}
