unit PluginFunctions;

interface

uses Windows,Messages,SysUtils,StrUtils,Classes,VidGrab,PlugInForm,PluginInterface;

implementation

// Default Functions

procedure Show; cdecl;
begin
  MainForm.Visible:=True;
  MainForm.VideoGrabber1.StartPreview;
end;

procedure Hide; cdecl;
begin
  MainForm.Visible:=False;
end;

procedure Free; cdecl;
begin
  MainForm.VideoGrabber1.Free;
  SendMessage(MainForm.Handle, WM_DESTROY, 0, 0);
end;

// ******** Plugin Function ********

// Start Preview
Procedure Preview;cdecl;
begin
  try
    MainForm.Visible:=True;
    MainForm.VideoGrabber1.StartPreview;
  except end;
end;

// Stop Preview
Procedure StopPreview;cdecl;
begin
  try
    MainForm.VideoGrabber1.StopPreview;
  except end;
end;

// Start Recording video ( Return ' False ' if record has error else return ' True ' )
Procedure StartRecord;cdecl;
var
  Adress:String;
begin
  try
    MainForm.Visible:=True;
// Set save record adress form input
    Adress:=TextInput[1];
// Check directory is exists ( If exists start record & Return ' True ' )
// Else return ' False ' => Error
    if DirectoryExists(ExtractFilePath(Adress)) then begin
      MainForm.VideoGrabber1.RecordingFileName:=Adress;
      MainForm.VideoGrabber1.StartRecording;
    end else
      TextOutput:='Err';
  except end;
end;

// Stop Preview or Recording
Procedure StopRecord;cdecl;
begin
  try
    MainForm.VideoGrabber1.StopRecording;
  except end;
end;

// Get still BMP image
Procedure CaptureBMP;cdecl;
var
  Adress:string;
begin
try
  Adress:=TextInput[1];
  if DirectoryExists(ExtractFilePath(Adress)) then
    MainForm.VideoGrabber1.CaptureFrameTo(fc_BmpFile, Adress)
  else
    TextOutput:='Err';
except end;
end;

// Get still JPG image
Procedure CaptureJPG;cdecl;
var
  Adress:string;
begin
try
  Adress:=TextInput[1];
  if DirectoryExists(ExtractFilePath(Adress)) then
    MainForm.VideoGrabber1.CaptureFrameTo(fc_JpegFile,Adress)
  else
    TextOutput:='Err';
except end;
end;

// Show Stream dialog
procedure StreamDialog;cdecl;
begin
  try
    MainForm.VideoGrabber1.ShowDialog (dlg_StreamConfig);
  except end;
end;

// Show sourcedialog
procedure DeviceDialog;cdecl;
begin
  try
   MainForm.VideoGrabber1.ShowDialog (dlg_VideoDevice);
  except end;
end;

// Count the number of webcam connected to system
procedure CamCount;cdecl;
begin
  try
    NumOutput:=MainForm.VideoGrabber1.VideoDevicesCount;
  except end;
end;

// Change the current webcam device
procedure SourceCam;cdecl;
begin
  try
    MainForm.VideoGrabber1.VideoDevice:=NumInput[1];
  except end;
end;

exports
  Show,
  Hide,
  Free,
  Preview,
  StopPreview,
  StartRecord,
  StopRecord,
  CaptureBMP,
  CaptureJPG,
  StreamDialog,
  DeviceDialog,
  CamCount,
  SourceCam;
end.
