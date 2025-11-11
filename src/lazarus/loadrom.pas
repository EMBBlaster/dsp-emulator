unit LoadRom;

{$mode delphi}

interface

uses
  {$IFDEF WINDOWS}windows,{$ENDIF}
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Grids, Buttons;

type

  { TFLoadRom }

  TFLoadRom = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    gpxrominfo: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImgPreview: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RomList: TStringGrid;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RomListClick(Sender: TObject);
    procedure RomListDblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FLoadRom: TFLoadRom;

implementation
uses init_games,principal,main_engine,loadrom_misc;

var
   typed:string;

{ TFLoadRom }

procedure TFLoadRom.RomListClick(Sender: TObject);
begin
show_picture;
end;

procedure TFLoadRom.BitBtn3Click(Sender: TObject);
begin
FLoadRom.RomListDblClick(nil);
end;

procedure TFLoadRom.CheckBox1Click(Sender: TObject);
begin
  test_sort_arcade;
  init_game_desc(main_vars.sort);
  show_picture;
end;

procedure TFLoadRom.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  timer1.enabled:=false;
end;

procedure TFLoadRom.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  f:word;
  temps:string;
  myRect:TGridRect;
begin
case key of
  13:begin
    Close;
    FLoadRom.RomListDblClick(nil);
  end;
  27:floadrom.BitBtn1Click(nil);
  38,40:show_picture;
  48..57,65..90:begin
            typed:=typed+lowercase(char(key));
            timer1.Enabled:=false;
            timer1.Enabled:=true;
            for f:=1 to (RomList.RowCount-1) do begin
              temps:=ansilowercase(copy(RomList.Cells[0,f],0,length(typed)));
              if typed=temps then begin
                myRect.Left:=0;
                myRect.Top:=f;
                myRect.Right:=1;
                myRect.Bottom:=f;
                RomList.Selection:=myRect;
                RomList.Row:=f;
                if (f-MAX_ROW_DIFF)<1 then Floadrom.RomList.TopRow:=1
                  else RomList.TopRow:=f-MAX_ROW_DIFF;
                show_picture;
                break;
              end;
            end;
         end;
end;
end;

procedure TFLoadRom.FormShow(Sender: TObject);
var
  j:integer;
begin
j:=(principal1.left+(principal1.width div 2))-(FLoadRom.Width div 2);
if j<0 then FLoadRom.Left:=0
  else FLoadRom.Left:=j;
j:=(principal1.top+(principal1.Height div 2))-(FLoadRom.Height div 2);
if j<0 then FLoadRom.Top:=0
  else FLoadRom.Top:=j;
loadrom_show;
end;

procedure TFLoadRom.RadioButton1Click(Sender: TObject);
begin
  button_click(0);
end;

procedure TFLoadRom.RadioButton2Click(Sender: TObject);
begin
  button_click(2);
end;

procedure TFLoadRom.RadioButton3Click(Sender: TObject);
begin
  button_click(8);
end;

procedure TFLoadRom.RadioButton4Click(Sender: TObject);
begin
  button_click(4);
end;

procedure TFLoadRom.RadioButton5Click(Sender: TObject);
begin
  groupbox2.Enabled:=true;
  groupbox2.visible:=true;
  test_sort_arcade;
  init_game_desc(main_vars.sort);
  show_picture;
end;

procedure TFLoadRom.BitBtn1Click(Sender: TObject);
begin
floadrom.close;
if not(main_vars.driver_ok) then begin
  principal1.BitBtn2.Enabled:=false;
  principal1.BitBtn3.Enabled:=false;
  principal1.BitBtn5.Enabled:=false;
  principal1.BitBtn6.Enabled:=false;
  principal1.BitBtn19.Enabled:=false;
  principal1.BitBtn8.Enabled:=false;
  sync_all;
end;
end;

procedure TFLoadRom.RomListDblClick(Sender: TObject);
var
  numero:integer;
begin
numero:=GAMES_DESC[StrToInt(RomList.Cells[2,RomList.Selection.Top])].grid;
//Si es la misma maquina debe continuar, sino que ejecute la nueva
if main_vars.tipo_maquina<>numero then load_game(numero);
floadrom.close;
end;

procedure TFLoadRom.Timer1Timer(Sender: TObject);
begin
  timer1.Enabled:=false;
  typed:='';
end;

initialization
  {$I loadrom.lrs}

end.

