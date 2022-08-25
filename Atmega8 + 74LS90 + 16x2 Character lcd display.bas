'======================================================================='

' Title: LCD Display frequency meter
' Last Updated :  01.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega8 + 74LS90 + 16x2 Character lcd display

'======================================================================='

$regfile = "m8def.dat"
$crystal = 11059200
$hwstack = 64
$swstack = 64
$framesize = 64


Config Lcdpin = Pin , Db4 = Pinc.3 , Db5 = Pinc.2 , Db6 = Pinc.1 , Db7 = _
Pinc.0 , E = Pinc.4 , Rs = Pinc.5
Config Lcd = 16 * 2
Cursor Off : Cls


Open "comb.5:9600,8,n,1,inverted" For Output As #1
Print #1 , "serial output test"


Config Pinb.0 = Input
Set Portb.0


Config Timer1 = Counter , Edge = Falling
Config Timer0 = Timer , Prescale = 64
Enable Interrupts
Enable Timer0
Enable Timer1
On Ovf1 Pulse
On Ovf0 Ov0


Dim A As Long
Dim I As Long
Dim B As Byte
Dim C As Single


Cls
Cursor Off
Home : Lcd "    Digital"
Lowerline
Lcd "Frequency Meter"
Waitms 500
Start Timer0

'-----------------------------------------------------------

Do
Loop
End

''''''''''''''''''''''''''''''

Ov0:
Incr I
If I = 675 Then

  Stop Timer0
  A = B * 65536
  A = A + Counter1
  Cls : Home
  If Pinb.0 = 0 Then
     Lcd "High: 1MHz-1GHz"
     Lowerline
     A = A * 12800
     C = A / 1000000
     Lcd "F= " ; Fusing(c , "#.&&&&&&") ; "MHz"
     Print #1 , "~"
     Print #1 , "F= " ; Fusing(c , "#.&&&&&&") ; "MHz"
  Else
     Lcd "Low: 1Hz-1MHz"
     Lowerline
     If A < 1000 Then
        Lcd "F= " ; A ; " Hz"
        Print #1 , "~"
        Print #1 , "F= " ; A ; "Hz"
     End If
     If A > 1000 Then
         C = A / 1000
         Lcd "F= " ; Fusing(c , "#.&&&") ; " KHz"
         Print #1 , "~"
         Print #1 , "F= " ; Fusing(c , "#.&&&") ; "KHz"
     End If
  End If
  Counter1 = 0 : B = 0 : I = 0
  Start Timer0
End If
Return

''''''''''''''''''''''''''''''

Pulse:
Incr B
Counter1 = 0
Return

'-----------------------------------------------------------