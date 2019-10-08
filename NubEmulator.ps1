Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName PresentationCore
$IsOn = $false
$Mode = $false
$ToggleTime = 100
$SpeedMultiplyer = 2

$signature=@' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

while ($true)
{
$PosX = 0
$PosY = 0

$Enable = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightShift) 
$SwitchMode = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightAlt)
$G = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::G)
$H = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::H)
$B = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::B)
$Lclick = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::V)
$Rclick = [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::N)

if ($Enable){
$IsOn = -not $IsOn
Start-Sleep -Milliseconds $ToggleTime
}
if ($SwitchMode){
$Mode = -not $Mode
Start-Sleep -Milliseconds $ToggleTime
}

if ($G)
{
 $PosX += -1
 $PosY += -1
}

if ($H) {
 $PosX += 1
 $PosY += -1
} 

if ($B) {
 $PosX += 0

 if($Mode){
  $PosY += 1
 } else {
  $PosY += 2
 }
}
if($IsOn){
if ($Lclick){
 $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
 $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
}
if ($Rclick){
 $SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0)
 $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0)
}
  $Pos = [System.Windows.Forms.Cursor]::Position
  $x = ($pos.X) + ($PosX * $SpeedMultiplyer)
  $y = ($pos.Y) + ($PosY * $SpeedMultiplyer)
  [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
  Start-Sleep -Milliseconds 1
}
}