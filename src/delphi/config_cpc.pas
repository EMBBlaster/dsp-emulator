unit config_cpc;
interface

uses
  System.Classes,Vcl.Forms,Vcl.StdCtrls,Vcl.ComCtrls,Vcl.Controls;

type
  TConfigCPC = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    Button3: TButton;
    Button4: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    Button5: TButton;
    Button6: TButton;
    Label4: TLabel;
    Edit4: TEdit;
    Button7: TButton;
    Button8: TButton;
    Label5: TLabel;
    Edit5: TEdit;
    Button9: TButton;
    Button10: TButton;
    Label6: TLabel;
    Edit6: TEdit;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    GroupBox7: TGroupBox;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    GroupBox3: TGroupBox;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Edit7: TEdit;
    Button15: TButton;
    GroupBox4: TGroupBox;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    GroupBox5: TGroupBox;
    TrackBar1: TTrackBar;
    procedure Button15Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigCPC: TConfigCPC;

implementation
uses misc_functions,cpcconfig_misc,amstrad_cpc;
{$R *.dfm}

procedure TConfigCPC.Button13Click(Sender: TObject);
begin
ConfigCPC_OK;
configcpc.Close;
end;

procedure TConfigCPC.Button14Click(Sender: TObject);
begin
configcpc.Close;
end;

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

procedure TConfigCPC.Button15Click(Sender: TObject);
begin
put_text_file(0);
end;

procedure TConfigCPC.Button1Click(Sender: TObject);
begin
put_text_file(1);
end;

procedure TConfigCPC.Button3Click(Sender: TObject);
begin
put_text_file(2);
end;

procedure TConfigCPC.Button4Click(Sender: TObject);
begin
clear_text_file(2);
end;

procedure TConfigCPC.Button5Click(Sender: TObject);
begin
put_text_file(3);
end;

procedure TConfigCPC.Button6Click(Sender: TObject);
begin
clear_text_file(3);
end;

procedure TConfigCPC.Button7Click(Sender: TObject);
begin
put_text_file(4);
end;

procedure TConfigCPC.Button8Click(Sender: TObject);
begin
clear_text_file(4);
end;

procedure TConfigCPC.Button9Click(Sender: TObject);
begin
put_text_file(5);
end;

procedure TConfigCPC.FormKeyUp(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
case key of
    13:button13Click(nil);
    27:button14click(nil);
end;
end;

procedure TConfigCPC.FormShow(Sender: TObject);
begin
  ConfigCPC_Show;
end;

procedure TConfigCPC.RadioButton10Click(Sender: TObject);
begin
  trackbar1.Enabled:=true;
  groupbox5.Enabled:=true;
end;

procedure TConfigCPC.RadioButton9Click(Sender: TObject);
begin
  trackbar1.Enabled:=false;
  groupbox5.Enabled:=false;
end;

procedure TConfigCPC.Button10Click(Sender: TObject);
begin
clear_text_file(5);
end;

procedure TConfigCPC.Button11Click(Sender: TObject);
begin
put_text_file(6);
end;

procedure TConfigCPC.Button12Click(Sender: TObject);
begin
clear_text_file(6);
end;

procedure TConfigCPC.Button2Click(Sender: TObject);
begin
clear_text_file(1);
end;

end.
