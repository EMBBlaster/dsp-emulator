unit loadrom_misc;

interface
uses SysUtils,Grids,graphics;

const
  MAX_ROW_DIFF=10;

procedure show_picture;
procedure test_sort_arcade;
procedure init_game_desc(sort:word);
procedure loadrom_show;
procedure button_click(num:integer);

implementation
uses {$ifndef fpc}pngimage,{$endif}loadrom,init_games,main_engine,lenguaje;

procedure show_picture;
var
  dir:string;
  numero:integer;
begin
numero:=StrToInt(fLoadRom.RomList.Cells[2,fLoadRom.RomList.Selection.Top]);
FLoadRom.label4.caption:=GAMES_DESC[numero].year;
FLoadRom.label5.caption:=sound_tipo[GAMES_DESC[numero].snd];
FLoadRom.label9.caption:=GAMES_DESC[numero].company;
if GAMES_DESC[numero].hi then FLoadRom.label6.caption:='YES'
      else FLoadRom.label6.caption:='NO';
//En el caso de las consolas es especial prefiero poner una imagen fija
case GAMES_DESC[numero].grid of
  3:dir:='plus2a.png';
  1000:dir:='nes.png';
  1001:dir:='coleco.png';
  1002:if GAMES_DESC[numero].zip='gbcolor' then dir:='gbc.png'
        else dir:='gb.png';
  1003:dir:='chip8.png';
  1004:dir:='sms.png';
  1005:dir:='sg1000.png';
  1006:dir:='gg.png';
  1007:dir:='scv.png';
  1008:dir:='genesis.png';
  1009:dir:='pv1000.png';
  1010:dir:='pv2000.png';
  else dir:=GAMES_DESC[numero].zip+'.png';
end;
if FileExists(Directory.Preview+dir) then Floadrom.ImgPreview.Picture.LoadFromFile(Directory.Preview+dir)
      else Floadrom.ImgPreview.Picture.LoadFromFile(Directory.Preview+'preview.png');
end;

procedure test_sort_arcade;
begin
  main_vars.sort:=0;
  if floadrom.checkbox1.Checked then main_vars.sort:=main_vars.sort or $10;
  if floadrom.checkbox2.Checked then main_vars.sort:=main_vars.sort or $20;
  if floadrom.checkbox3.Checked then main_vars.sort:=main_vars.sort or $40;
  if floadrom.checkbox4.Checked then main_vars.sort:=main_vars.sort or $80;
  if floadrom.checkbox5.Checked then main_vars.sort:=main_vars.sort or $100;
  if floadrom.checkbox6.Checked then main_vars.sort:=main_vars.sort or $200;
  if main_vars.sort=0 then main_vars.sort:=1;
end;

procedure init_game_desc(sort:word);
var
  f:word;
  sitio,cantidad:integer;
  myRect:TGridRect;
procedure poner;
var
  test:string;
  numero:integer;
begin
floadrom.romlist.RowCount:=cantidad+1; //Hay que cotar las de arriba!!!
numero:=orden_games[f];
floadrom.RomList.cells[2,cantidad]:=inttostr(numero);
if ((GAMES_DESC[numero].grid>1999) and (GAMES_DESC[numero].grid<3000)) then floadrom.RomList.Cells[0,cantidad]:=GAMES_DESC[numero].name+' - Game & Watch'
  else floadrom.RomList.Cells[0,cantidad]:=GAMES_DESC[numero].name;
if GAMES_DESC[numero].zip='' then floadrom.RomList.cells[1,cantidad]:='N/A'
  else begin
        test:=directory.arcade_list_roms[find_rom_multiple_dirs(GAMES_DESC[numero].zip+'.zip')];
        if fileexists(test+GAMES_DESC[numero].zip+'.zip') then floadrom.RomList.cells[1,cantidad]:='YES'
          else floadrom.RomList.cells[1,cantidad]:='NO';
  end;
cantidad:=cantidad+1;
end;

begin
for f:=1 to floadrom.romlist.RowCount-1 do floadrom.romlist.Rows[f].Clear;
cantidad:=1;
with floadrom.RomList do begin
  for f:=1 to GAMES_CONT do begin
    if sort=0 then poner
      else if (GAMES_DESC[orden_games[f]].tipo and sort)<>0 then poner;
  end;
end;
for f:=1 to cantidad-1 do begin
    if main_vars.tipo_maquina=GAMES_DESC[strtoint(floadrom.RomList.cells[2,f])].grid then begin
      {$ifndef fpc}
      myRect.Left:=0;
      myRect.Top:=f;
      myRect.Right:=1;
      myRect.Bottom:=f;
      Floadrom.RomList.Selection:=myRect;
      {$else}
      Floadrom.RomList.Row:=f;
      {$endif}
      if (f-MAX_ROW_DIFF)<1 then sitio:=1
        else sitio:=f-MAX_ROW_DIFF;
      if cantidad>27 then Floadrom.RomList.TopRow:=sitio;
    end;
end;
end;

procedure loadrom_show;
var
  {$ifndef fpc}
  png:TPngImage;
  {$else}
  png:TPortableNetworkGraphic;
  {$endif}
  f,h,pos:word;
begin
Floadrom.BitBtn1.Caption:=leng.mensajes[8];
Floadrom.romlist.ColWidths[0]:=Floadrom.romlist.Width-65;
Floadrom.romlist.ColWidths[1]:={$ifndef fpc}40{$else}60{$endif};
Floadrom.romlist.ColWidths[2]:={$ifndef fpc}-1{$else}0{$endif};
Floadrom.romlist.Visible:=true;
Floadrom.romlist.Cells[0,0]:='Driver Name';
Floadrom.romlist.Cells[1,0]:='ROM';
//Creo la imagen si no existe
if not(FileExists(Directory.Preview+'preview.png')) then begin
   Floadrom.ImgPreview.canvas.Brush.Color:=clWhite;
   Floadrom.ImgPreview.canvas.Brush.Style:=bsSolid;
   Floadrom.ImgPreview.canvas.Rectangle(0,0,Floadrom.ImgPreview.Width,Floadrom.ImgPreview.Height);
   Floadrom.ImgPreview.Canvas.Font.Color:=clblue;
   Floadrom.ImgPreview.Canvas.Font.Size:=12;
   Floadrom.ImgPreview.Canvas.TextOut(70,80,'Image not available!');
   {$ifndef fpc}
   png:=TPngImage.Create;
   {$else}
   png:=TPortableNetworkGraphic.Create;
   {$endif}
   png.Assign(Floadrom.imgpreview.Picture.Bitmap);
   png.SaveToFile(Directory.Preview+'preview.png');
   png.free;
end;
//Los ordeno...
for f:=1 to GAMES_CONT do orden_games[f]:=f;
  for f:=1 to GAMES_CONT-1 do begin
    for h:=1 to GAMES_CONT-1 do begin
      if GAMES_DESC[orden_games[h]].name>GAMES_DESC[orden_games[h+1]].name then begin
        pos:=orden_games[h];
        orden_games[h]:=orden_games[h+1];
        orden_games[h+1]:=pos;
    end;
  end;
end;
//Añado las entradas a la lista
case main_vars.sort of
  0:begin
      Floadrom.RadioButton1.Checked:=true;
      {$ifdef linux}Floadrom.radiobutton1Click(nil);{$endif}
    end;
  2:begin
      Floadrom.RadioButton2.Checked:=true;
      {$ifdef linux}Floadrom.radiobutton2Click(nil);{$endif}
    end;
  4:begin
      Floadrom.RadioButton4.Checked:=true;
      {$ifdef linux}Floadrom.radiobutton4Click(nil);{$endif}
    end;
  8:begin
      Floadrom.RadioButton3.Checked:=true;
      {$ifdef linux}Floadrom.radiobutton3Click(nil);{$endif}
    end;
  1,$10..$ffff:begin
      Floadrom.CheckBox1.Checked:=(main_vars.sort and $10)<>0;
      Floadrom.CheckBox2.Checked:=(main_vars.sort and $20)<>0;
      Floadrom.CheckBox3.Checked:=(main_vars.sort and $40)<>0;
      Floadrom.CheckBox4.Checked:=(main_vars.sort and $80)<>0;
      Floadrom.CheckBox5.Checked:=(main_vars.sort and $100)<>0;
      Floadrom.CheckBox6.Checked:=(main_vars.sort and $200)<>0;
      //El orden es importante!!
      Floadrom.radiobutton5.checked:=true;
      {$ifdef linux}Floadrom.radiobutton5Click(nil);{$endif}
    end;
end;
init_game_desc(main_vars.sort);
show_picture;
end;

procedure button_click(num:integer);
begin
  init_game_desc(num);
  main_vars.sort:=num;
  Floadrom.groupbox2.Enabled:=false;
  Floadrom.groupbox2.visible:=false;
  show_picture;
end;

end.
