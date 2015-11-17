{
   Change the plugins form in this file
}

unit PluginForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, VidGrab;

type
  TMainForm = class(TForm)
    VideoGrabber1: TVideoGrabber;

  private
    { Private declarations }
  protected
    procedure DestroyPlugin(var Msg: TMessage); message WM_DESTROY;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses PluginInterface;

//Don't remove this
procedure TMainForm.DestroyPlugin(var Msg: TMessage);
var
  i: Integer;
begin
  for i := ComponentCount - 1 downto 0 do
  begin
    if (Components[i] is TControl) then
      TControl(Components[i]).Parent := nil;
    Components[i].Free;
  end;
  release;
  inherited;
end;

//Sample functions


end.
