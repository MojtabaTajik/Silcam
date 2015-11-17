{
   MMB Plugin SDK
   Updated by Yuraj (4.9.8 Support)
}

unit PluginInterface;

interface

uses Windows, SysUtils, Variants, Graphics, PluginForm;

function GetColor(Input: string): TColor;
function GetWindowsTempDir: string;
function GetWindowsDir: string;
function GetSystemDir: string;
procedure ExpandPathMacros (var path: string);
procedure CallMMBScript(ScriptCode: string; EnableSyntaxChecker:boolean=false);
function GetMMBScriptInt(PluginName: string;VariableName: string): integer;
function GetMMBScriptStr(PluginName: string;VariableName: string): string;

type
  TPluginMode = (pmDesigner, pmRuntime);

var
  MainForm: TMainForm;
  hMMBWindow: Cardinal;
  PluginMode: TPluginMode;
  AppDir: string;
  TextInput: array [1..5] of string;
  TextOutput: string;
  NumInput: array [1..5] of Integer;
  NumOutput: Integer;

//PlugIn Info
const
PluginCopyright = 'SilCam PlugIn for MMB';
PluginInformation ='Author: Mojtaba Tajik'+#13#10+'E_Mail :Mojtaba@silversoft.org'+#13#10+'YahooID : silversoft2008'+#13#10+'www.silvercoder.blogfa.com';

//Don't edit
const
WM_RUNSCRIPTCODE=$008C7;
RUNSCRIPTCODE_QUIET=0;
RUNSCRIPTCODE_LOUD=1;

implementation

function Copyright: pChar; cdecl;
begin
  Result := pChar(PluginCopyright);
end;

function GetInfo: pChar; cdecl;
begin

  Result := pChar(PluginInformation);
end;

procedure SetPath(sPath: pChar); cdecl;
begin
  AppDir := sPath;
end;

procedure SetFile(s: pChar); cdecl;
begin
  TextInput[5] := TextInput[4];
  TextInput[4] := TextInput[3];
  TextInput[3] := TextInput[2];
  TextInput[2] := TextInput[1];
  TextInput[1] := s;
end;

function GetFile: pChar; cdecl;
begin
  Result := pChar(TextOutput);
end;

procedure SetData(nData: Integer); cdecl;
begin
  NumInput[5] := NumInput[4];
  NumInput[4] := NumInput[3];
  NumInput[3] := NumInput[2];
  NumInput[2] := NumInput[1];
  NumInput[1] := nData;
end;

function GetData: Integer; cdecl;
begin
  Result := NumOutput;
end;

procedure SetParentWindow(hwnd: HWND); cdecl;
begin
  hMMBWindow := hwnd;
//Note: If you don't want use a form, then comment these last lines (in this procedure):
  if GetParent(hMMBWindow) <> 0 then
  begin
    PluginMode := pmDesigner;
    MainForm := TMainForm.CreateParented(GetParent(hMMBWindow));
    SetParent(MainForm.Handle, hMMBWindow);
  end else
  begin
    PluginMode := pmRuntime;
    MainForm := TMainForm.CreateParented(hMMBWindow);
  end;
end;

procedure Draw(pDC: HDC; x, y, nWidth, nHeight: Integer); cdecl;
begin
//Note: If you don't want use a form, then comment this line:
  MainForm.SetBounds(x, y, nWidth, nHeight);
end;

// whether or not there is a plug-in property panel, see also _Interface
function HasIntDlg: integer; cdecl;
begin
Result:=0;
end;

//For working this, must be HasIntDlg = 1
//For more see also plugin sdk functions: SetIntString,SetString,GetIntString,GetString
function _Interface: pChar; cdecl;
begin
//MessageBox(FindWindow('#32770','MMB PlugIn'),'You can here add e.g.: form with plugin options...','PlugIn Properties',0);
Result := nil;
end;

//Rountine: Calling script from plugin
procedure CallMMBScript(ScriptCode: string; EnableSyntaxChecker: boolean=false);
begin
if EnableSyntaxChecker=false then
SendMessage(hMMBWindow, WM_RUNSCRIPTCODE, RUNSCRIPTCODE_QUIET, LPARAM(ScriptCode));
if EnableSyntaxChecker=true then
SendMessage(hMMBWindow, WM_RUNSCRIPTCODE, RUNSCRIPTCODE_LOUD, LPARAM(ScriptCode));
end;

//Rountine: Get variable from MMB to Plugin, it's stupid idea, because problem is PlugIn name :(
//But maybe in new version will be possible to get variable from MMB to Plugin.
function GetMMBScriptInt(PluginName: string;VariableName: string): integer;
begin
CallMMBScript('PlugInSet("'+PluginName+'","'+VariableName+'")');
Result:=NumInput[1];
end;
function GetMMBScriptStr(PluginName: string;VariableName: string): string;
begin
CallMMBScript('PlugInSet("'+PluginName+'","'+VariableName+'$")');
Result:=TextInput[1];
end;

//Convert string to color
function GetColor(Input: string): TColor;
var
  R,G,B : Integer;
begin
  try
    R := StrToInt(Copy(Input,1,Pos(',',Input)-1));
    Delete(Input,1,Pos(',',Input));
    G := StrToInt(Copy(Input,1,Pos(',',Input)-1));
    Delete(Input,1,Pos(',',Input));
    B := StrToInt(Copy(Input,1,Length(Input)));
  except
    R := 0;
    G := 0;
    B := 0;
  end;
  Result := StrToInt('$'+IntToHex(B,2) + IntToHex(G,2) + IntToHex(R,2));
end;

// Gets the temporary directory
function GetWindowsTempDir: string;
var
  path: array [0 .. 512] of char;
begin
  GetTempPath (512, path);
  Result := path;
end;

// Gets the windows directory
function GetWindowsDir: string;
var
  path: array [0 .. 512] of char;
begin
  GetWindowsDirectory (path, 512);
  Result := path;
end;

// Gets the system directory
function GetSystemDir: string;
var
  path: array [0 .. 512] of char;
begin
  GetSystemDirectory (path, 512);
  Result := path;
end;

// In-place expansion of MMB path macros, only frequented
procedure ExpandPathMacros (var path: string);
var
  macroPos: integer;
begin
  macroPos := Pos ('<Embedded>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 10);
    Insert (GetWindowsTempDir()+'\MMBPlayer', path, macroPos);
  end;
  //
  macroPos := Pos ('<Temp>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 6);
    Insert (GetWindowsTempDir, path, macroPos);
  end;
  //
  macroPos := Pos ('<Windows>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 9);
    Insert (GetWindowsDir(), path, macroPos);
  end;
  //
  macroPos := Pos ('<System>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 8);
    Insert (GetSystemDir(), path, macroPos);
  end;
  //
  macroPos := Pos ('<SrcDir>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 8);
    Insert (AppDir, path, macroPos);
  end;
  //
  macroPos := Pos ('<SrcDrive>', path);
  if (macroPos <> 0) then
  begin
    Delete (path, macroPos, 10);
    Insert (ExtractFileDrive(AppDir), path, macroPos);
  end;
end;

exports
  Copyright,
  GetInfo,
  SetPath,
  SetParentWindow,
  Draw,
  HasIntDlg,
  _Interface name 'Interface',
  SetFile,
  GetFile,
  SetData,
  GetData;

end.
