unit config_cpc;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls;

type

  { Tconfigcpc }

  Tconfigcpc = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    TrackBar1: TTrackBar;
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  configcpc: Tconfigcpc;

implementation
uses amstrad_cpc,misc_functions,cpcconfig_misc;

{ Tconfigcpc }

procedure put_text_file(number:byte);
var
    file_name:string;
begin
if OpenRom(file_name,SAMSTRADROM) then begin
    case number of
      0:configcpc.Edit7.Text:=file_name;
      1:configcpc.Edit1.Text:=file_name;
      2:configcpc.Edit2.Text:=file_name;
      3:configcpc.Edit3.Text:=file_name;
      4:configcpc.Edit4.Text:=file_name;
      5:configcpc.Edit5.Text:=file_name;
      6:configcpc.Edit6.Text:=file_name;
    end;
    cpc_rom[number].name:=file_name;
end;
end;

procedure clear_text_file(number:byte);
begin
  case number of
    0:configcpc.Edit7.Text:='';
    1:configcpc.Edit1.Text:='';
    2:configcpc.Edit2.Text:='';
    3:configcpc.Edit3.Text:='';
    4:configcpc.Edit4.Text:='';
    5:configcpc.Edit5.Text:='';
    6:configcpc.Edit6.Text:='';
  end;
  cpc_rom[number].name:='';
end;

procedure Tconfigcpc.FormShow(Sender: TObject);
begin
ConfigCPC_Show;
end;

procedure Tconfigcpc.RadioButton10Click(Sender: TObject);
begin
  trackbar1.Enabled:=true;
  groupbox5.Enabled:=true;
end;

procedure Tconfigcpc.RadioButton9Click(Sender: TObject);
begin
  trackbar1.Enabled:=false;
  groupbox5.Enabled:=false;
end;

procedure Tconfigcpc.Button1Click(Sender: TObject);
begin
  put_text_file(1);
end;

procedure Tconfigcpc.Button2Click(Sender: TObject);
begin
  clear_text_file(1);
end;

procedure Tconfigcpc.Button11Click(Sender: TObject);
begin
  put_text_file(6);
end;

procedure Tconfigcpc.Button12Click(Sender: TObject);
begin
  clear_text_file(6);
end;

procedure Tconfigcpc.Button13Click(Sender: TObject);
begin
ConfigCPC_OK;
configcpc.Close;
end;

procedure Tconfigcpc.Button14Click(Sender: TObject);
begin
  configcpc.Close;
end;

procedure Tconfigcpc.Button15Click(Sender: TObject);
begin
  put_text_file(0);
end;

procedure Tconfigcpc.Button10Click(Sender: TObject);
begin
  clear_text_file(5);
end;

procedure Tconfigcpc.Button3Click(Sender: TObject);
begin
  put_text_file(2);
end;

procedure Tconfigcpc.Button4Click(Sender: TObject);
begin
  clear_text_file(2);
end;

procedure Tconfigcpc.Button5Click(Sender: TObject);
begin
  put_text_file(3);
end;

procedure Tconfigcpc.Button6Click(Sender: TObject);
begin
  clear_text_file(3);
end;

procedure Tconfigcpc.Button7Click(Sender: TObject);
begin
  put_text_file(4);
end;

procedure Tconfigcpc.Button8Click(Sender: TObject);
begin
  clear_text_file(4);
end;

procedure Tconfigcpc.Button9Click(Sender: TObject);
begin
  put_text_file(5);
end;

procedure Tconfigcpc.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case key of
    13:button13Click(nil);
    27:button14click(nil);
end;
end;

initialization
  {$I config_cpc.lrs}

end.

