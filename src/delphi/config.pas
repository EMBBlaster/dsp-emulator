unit config;

interface

uses
  Controls, Classes, Forms, StdCtrls;

type
  TConfigSP = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox11: TGroupBox;
    GroupBox8: TGroupBox;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    GroupBox10: TGroupBox;
    RadioButton21: TRadioButton;
    RadioButton22: TRadioButton;
    GroupBox9: TGroupBox;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    GroupBox13: TGroupBox;
    RadioButton26: TRadioButton;
    RadioButton27: TRadioButton;
    GroupBox12: TGroupBox;
    GroupBox4: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton25: TRadioButton;
    GroupBox6: TGroupBox;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton20: TRadioButton;
    GroupBox14: TGroupBox;
    RadioButton23: TRadioButton;
    RadioButton24: TRadioButton;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    Button3: TButton;
    GroupBox3: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    GroupBox5: TGroupBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    GroupBox7: TGroupBox;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    Button4: TButton;
    GroupBox15: TGroupBox;
    Edit3: TEdit;
    Button5: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyUp(Sender:TObject;var Key:word;Shift:TShiftState);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigSP:TConfigSP;

implementation
uses spectrumconfig_misc,misc_functions;

{$R *.dfm}

procedure TConfigSP.Button2Click(Sender: TObject);
begin
close;
end;

procedure TConfigSP.FormShow(Sender: TObject);
begin
spectrumconfig_show;
end;

procedure TConfigSP.FormKeyUp(Sender:TObject;var Key:word;Shift:TShiftState);
begin
case key of
  13:Button1Click(nil);
  27:button2click(nil);
end;
end;

procedure TConfigSP.Button1Click(Sender: TObject);
begin
spectrumconfig_button1;
close;
end;

procedure TConfigSP.Button3Click(Sender: TObject);
var
  file_name:string;
begin
if OpenRom(file_name,SROM) then Edit1.Text:=file_name;
end;

procedure TConfigSP.Button4Click(Sender: TObject);
var
  file_name:string;
begin
if OpenRom(file_name,SROM) then Edit2.Text:=file_name;
end;

procedure TConfigSP.Button5Click(Sender: TObject);
var
  file_name:string;
begin
if OpenRom(file_name,SROM) then Edit3.Text:=file_name;
end;

end.
