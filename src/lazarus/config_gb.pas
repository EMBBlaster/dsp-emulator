unit config_gb;

{$mode Delphi}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tconfiggb }

  Tconfiggb = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox7: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  configgb: Tconfiggb;

implementation
uses principal,gb;

{ Tconfiggb }

procedure Tconfiggb.Button1Click(Sender: TObject);
begin
  if radiobutton1.Checked then gb_0.palette:=0
    else if radiobutton2.Checked then gb_0.palette:=1;
  configgb.Close;
end;

procedure Tconfiggb.Button2Click(Sender: TObject);
begin
  configgb.Close;
end;

procedure Tconfiggb.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
      13:button1Click(nil);
      27:button2click(nil);
  end;
end;

procedure Tconfiggb.FormShow(Sender: TObject);
var
  f:integer;
begin
f:=(principal1.left+(principal1.width div 2))-(Configgb.Width div 2);
if f<0 then Configgb.Left:=0
  else Configgb.Left:=f;
f:=(principal1.top+(principal1.Height div 2))-(Configgb.Height div 2);
if f<0 then Configgb.Top:=0
  else Configgb.Top:=f;
if gb_0.is_gbc then begin
      groupbox7.Enabled:=false;
      radiobutton1.Enabled:=false;
      radiobutton2.Enabled:=false;
end else begin
      groupbox7.Enabled:=true;
      radiobutton1.Enabled:=true;
      radiobutton2.Enabled:=true;
end;
case gb_0.palette of
      0:radiobutton1.Checked:=true;
      1:radiobutton2.Checked:=true;
end;
end;

initialization
  {$I config_gb.lrs}

end.

