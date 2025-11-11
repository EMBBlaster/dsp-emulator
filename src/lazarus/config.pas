unit config;

{$mode delphi}

interface

uses
  Classes, LResources, Forms, Controls,StdCtrls;

type

  { TConfigSP }

  TConfigSP = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    RadioButton19: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton20: TRadioButton;
    RadioButton21: TRadioButton;
    RadioButton22: TRadioButton;
    RadioButton23: TRadioButton;
    RadioButton24: TRadioButton;
    RadioButton25: TRadioButton;
    RadioButton26: TRadioButton;
    RadioButton27: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  ConfigSP:TConfigSP;

implementation
uses spectrumconfig_misc,misc_functions;

{ TConfigSP }

procedure TConfigSP.Button1Click(Sender: TObject);
begin
spectrumconfig_button1;
close;
end;

procedure TConfigSP.Button2Click(Sender: TObject);
begin
close;
end;

procedure TConfigSP.Button3Click(Sender: TObject);
var
   file_name:string;
begin
if OpenRom(file_name,SROM) then Edit1.Text:=file_name;
end;

procedure TConfigSP.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
case key of
  13:Button1Click(nil);
  27:button2click(nil);
end;
end;

procedure TConfigSP.FormShow(Sender: TObject);
begin
spectrumconfig_show;
end;

initialization
  {$I config.lrs}

end.

