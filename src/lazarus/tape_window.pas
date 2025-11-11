unit tape_window;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Grids,lenguaje;

type

  { Ttape_window1 }

  Ttape_window1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure BitBtn4Click(Sender: TObject);
    procedure cerrar_cinta(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fPlayCinta(Sender: TObject);
    procedure fstopcinta(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  tape_window1: Ttape_window1;

implementation
uses principal,tap_tzx,main_engine;

{ Ttape_window1 }

procedure Ttape_window1.fPlayCinta(Sender: TObject);
begin
cinta_tzx.play_tape:=true;
cinta_tzx.estados:=0;
BitBtn1.Enabled:=false;
BitBtn2.Enabled:=true;
if addr(cinta_tzx.tape_start)<>nil then cinta_tzx.tape_start
   else main_screen.rapido:=true;
sync_all;
end;

procedure Ttape_window1.cerrar_cinta(Sender: TObject);
begin
if addr(cinta_tzx.tape_stop)<>nil then cinta_tzx.tape_stop;
close;
end;

procedure Ttape_window1.BitBtn4Click(Sender: TObject);
begin
principal1.fLoadCinta(nil);
end;

procedure Ttape_window1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
cinta_tzx.play_tape:=false;
vaciar_cintas;
sync_all;
end;

procedure Ttape_window1.FormCreate(Sender: TObject);
begin
  tape_window_idioma;
end;

procedure Ttape_window1.FormShow(Sender: TObject);
begin
tape_window1.Left:=principal1.Left+principal1.Width;
tape_window1.top:=principal1.top;
//Varios
stringgrid1.ColWidths[0]:=stringgrid1.Width-100;
stringgrid1.ColWidths[1]:=100;
stringgrid1.ColCount:=2;
//stringgrid1.ColWidths[2]:=60;
stringgrid2.ColWidths[0]:=stringgrid1.Width-100;
stringgrid2.ColWidths[1]:=100;
stringgrid2.ColCount:=2;
end;

procedure Ttape_window1.fstopcinta(Sender: TObject);
begin
cinta_tzx.play_tape:=false;
tape_window1.BitBtn1.Enabled:=true;
tape_window1.BitBtn2.Enabled:=false;
main_vars.mensaje_principal:='';
if addr(cinta_tzx.tape_stop)<>nil then cinta_tzx.tape_stop
   else main_screen.rapido:=false;
sync_all;
end;

procedure Ttape_window1.StringGrid1Click(Sender: TObject);
begin
if not(cinta_tzx.click_falso) then begin
   cinta_tzx.grupo:=false;
   cinta_tzx.indice_cinta:=cinta_tzx.indice_select[tape_window1.stringgrid1.Selection.Top];
   siguiente_bloque_tzx;
   sync_all;
end;
end;

procedure Ttape_window1.StringGrid1DblClick(Sender: TObject);
begin
tape_window1.StringGrid1Click(nil);
end;

initialization
  {$I tape_window.lrs}

end.

