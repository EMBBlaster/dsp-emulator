unit drmicro_hw;

interface
uses rom_engine;

function iniciar_drmicro:boolean;

const
        drmicro_rom:array[0..5] of tipo_roms=(
        (n:'dm-00.13b';l:$2000;p:0;crc:$270f2145),(n:'dm-01.14b';l:$2000;p:$2000;crc:$bba30c80),
        (n:'dm-02.15b';l:$2000;p:$4000;crc:$d9e4ca6b),(n:'dm-03.13d';l:$2000;p:$6000;crc:$b7bcb45b),
        (n:'dm-04.14d';l:$2000;p:$8000;crc:$071db054),(n:'dm-05.15d';l:$2000;p:$a000;crc:$f41b8d8a));
        drmicro_gfx1:array[0..1] of tipo_roms=(
        (n:'dm-23.5l';l:$2000;p:0;crc:$279a76b8),(n:'dm-24.5n';l:$2000;p:$2000;crc:$ee8ed1ec));
        drmicro_gfx2:array[0..2] of tipo_roms=(
        (n:'dm-20.4a';l:$2000;p:0;crc:$6f5dbf22),(n:'dm-21.4c';l:$2000;p:$2000;crc:$8b17ff47),
        (n:'dm-22.4d';l:$2000;p:$4000;crc:$84daf771));
        drmicro_adpcm:array[0..1] of tipo_roms=(
        (n:'dm-40.12m';l:$2000;p:0;crc:$3d080af9),(n:'dm-41.13m';l:$2000;p:$2000;crc:$ddd7bda2));
        drmicro_proms:array[0..3] of tipo_roms=(
        (n:'dm-62.9h';l:$20;p:0;crc:$e3e36eaf),(n:'dm-61.4m';l:$100;p:$20;crc:$0dd8e365),
        (n:'dm-60.6e';l:$100;p:$120;crc:$540a3953),());

implementation
uses nz80,main_engine,controls_engine,gfx_engine,pal_engine,sound_engine,
     sn_76496,msm5205;

const
        drmicro_dip_a:array [0..4] of def_dip2=(
        (mask:3;name:'Lives';number:4;val4:(0,1,2,3);name4:('2','3','4','5')),
        (mask:4;name:'Demo Sounds';number:2;val2:(0,4);name2:('Off','On')),
        (mask:$18;name:'Bonus Life';number:4;val4:(0,8,$10,$18);name4:('30000 100000','50000 150000','70000 200000','100000 300000')),
        (mask:$40;name:'Cabinet';number:2;val2:($40,0);name2:('Upright','Cocktail')),
        (mask:$80;name:'Flip Screen';number:2;val2:(0,$80);name2:('Off','On')));
        drmicro_dip_b:def_dip2=(
        mask:7;name:'Coinage';number:8;val8:(7,6,5,0,1,2,3,4);name8:('4C 1C','3C 1C','2C 1C','1C 1C','1C 2C','1C 3C','1C 4C','1C 5C'));

var
  nmi_enable:boolean;
  adpcm_pos:word;

procedure update_video_drmicro;
var
  atrib,x,y:byte;
  f,nchar:word;
  flipx,flipy:boolean;
begin
for f:=0 to $3ff do begin
 x:=f mod 32;
 y:=f div 32;
 if gfx[0].buffer[f] then begin
    atrib:=memoria[$ec00+f];
    nchar:=memoria[$e800+f]+((atrib and $c0) shl 2);
    put_gfx_flip(x*8,y*8,nchar,(atrib and $f) shl 2,1,0,(atrib and $10)<>0,(atrib and $20)<>0);
    gfx[0].buffer[f]:=false;
 end;
 if gfx[1].buffer[f] then begin
    atrib:=memoria[$e400+f];
    nchar:=memoria[$e000+f]+((atrib and $c0) shl 2);
    put_gfx_trans_flip(x*8,y*8,nchar,((atrib and $f) shl 3)+$100,2,1,(atrib and $10)<>0,(atrib and $20)<>0);
    gfx[1].buffer[f]:=false;
 end;
end;
actualiza_trozo(0,0,256,256,1,0,0,256,256,3);
//sprites1
for f:=0 to 7 do begin
  x:=memoria[$e803+(f*4)];
  y:=240-memoria[$e800+(f*4)];
  atrib:=memoria[$e802+(f*4)];
  nchar:=memoria[$e801+(f*4)];
  flipx:=(nchar and 1)<>0;
  flipy:=(nchar and 2)<>0;
  nchar:=(nchar shr 2) or (atrib and $c0);
  put_gfx_sprite(nchar,(atrib and $f) shl 2,flipx,flipy,2);
  actualiza_gfx_sprite(x,y,3,2);
end;
actualiza_trozo(0,0,256,256,2,0,0,256,256,3);
//sprites2
for f:=0 to 7 do begin
  x:=memoria[$e003+(f*4)];
  y:=240-memoria[$e000+(f*4)];
  atrib:=memoria[$e002+(f*4)];
  nchar:=memoria[$e001+(f*4)];
  flipx:=(nchar and 1)<>0;
  flipy:=(nchar and 2)<>0;
  nchar:=(nchar shr 2) or (atrib and $c0);
  put_gfx_sprite(nchar,((atrib and $f) shl 3)+$100,flipx,flipy,3);
  actualiza_gfx_sprite(x,y,3,3);
end;
actualiza_trozo_final(0,16,256,224,3);
end;

procedure eventos_drmicro;
begin
if event.arcade then begin
  marcade.in0:=0;
  marcade.in1:=0;
  //botones
  if arcade_input.up[0] then marcade.in0:=marcade.in0 or 1;
  if arcade_input.right[0] then marcade.in0:=marcade.in0 or 2;
  if arcade_input.down[0] then marcade.in0:=marcade.in0 or 4;
  if arcade_input.left[0] then marcade.in0:=marcade.in0 or 8;
  if arcade_input.but0[0] then marcade.in0:=marcade.in0 or $10;
  if arcade_input.coin[0] then marcade.in0:=marcade.in0 or $20;
  if main_vars.service1 then marcade.in0:=marcade.in0 or $40;
  //players
  if arcade_input.up[1] then marcade.in1:=marcade.in1 or 1;
  if arcade_input.right[1] then marcade.in1:=marcade.in1 or 2;
  if arcade_input.down[1] then marcade.in1:=marcade.in1 or 4;
  if arcade_input.left[1] then marcade.in1:=marcade.in1 or 8;
  if arcade_input.but0[1] then marcade.in1:=marcade.in1 or $10;
  if arcade_input.start[0] then marcade.in1:=marcade.in1 or $20;
  if arcade_input.start[1] then marcade.in1:=marcade.in1 or $40;
end;
end;

procedure drmicro_principal;
var
  f:byte;
begin
while EmuStatus=EsRunning do begin
  for f:=0 to 255 do begin
    eventos_drmicro;
    if f=240 then begin
      update_video_drmicro;
      if nmi_enable then z80_0.change_nmi(PULSE_LINE);
    end;
    z80_0.run(frame_main);
    frame_main:=frame_main+z80_0.tframes-z80_0.contador;
  end;
  video_sync;
end;
end;

function drmicro_getbyte(direccion:word):byte;
begin
  drmicro_getbyte:=memoria[direccion];
end;

procedure drmicro_putbyte(direccion:word;valor:byte);
begin
case direccion of
  0..$bfff:; //ROM
  $c000..$dfff:memoria[direccion]:=valor;
  $e000..$e7ff:if memoria[direccion]<>valor then begin
                  memoria[direccion]:=valor;
                  gfx[1].buffer[direccion and $3ff]:=true;
               end;
  $e800..$efff:if memoria[direccion]<>valor then begin
                  memoria[direccion]:=valor;
                  gfx[0].buffer[direccion and $3ff]:=true;
               end;
  $f000..$ffff:memoria[direccion]:=valor;
end;
end;

function drmicro_inbyte(puerto:word):byte;
begin
case (puerto and $ff) of
  0:drmicro_inbyte:=marcade.in0;
  1:drmicro_inbyte:=marcade.in1;
  3:drmicro_inbyte:=marcade.dswa;
  4:drmicro_inbyte:=marcade.dswb;
end;
end;

procedure snd_adpcm;
var
  valor:byte;
begin
  valor:=msm5205_0.rom_data[adpcm_pos div 2];
  if (valor<>$70) then begin
		if (not(adpcm_pos) and 1)<>0 then valor:=valor shr 4;
		msm5205_0.data_w(valor and $f);
		msm5205_0.reset_w(false);
		adpcm_pos:=(adpcm_pos+1) and $7fff;
  end else msm5205_0.reset_w(true);
end;

procedure drmicro_outbyte(puerto:word;valor:byte);
begin
case (puerto and $ff) of
  0:sn_76496_0.write(valor);
  1:sn_76496_1.write(valor);
  2:sn_76496_2.write(valor);
  3:begin
      adpcm_pos:=(valor and $3f) shl 9;
	    snd_adpcm;
    end;
  4:begin
      nmi_enable:=(valor and 1)<>0;
      main_screen.flip_main_screen:=(valor and 2)<>0;
    end;
end;
end;

procedure drmicro_sound_update;
begin
  sn_76496_0.update;
  sn_76496_1.update;
  sn_76496_2.update;
  msm5205_0.update;
end;

//Main
procedure reset_drmicro;
begin
 z80_0.reset;
 frame_main:=z80_0.tframes;
 sn_76496_0.reset;
 sn_76496_1.reset;
 sn_76496_2.reset;
 msm5205_0.reset;
 marcade.in0:=0;
 marcade.in1:=0;
 nmi_enable:=false;
 adpcm_pos:=0;
end;

function iniciar_drmicro:boolean;
const
  ps_x:array[0..15] of dword=(7,6,5,4,3,2,1,0,
		71, 70, 69, 68, 67, 66, 65, 64);
  ps_y:array[0..15] of dword=(0*8, 1*8, 2*8, 3*8, 4*8, 5*8, 6*8, 7*8,
		128+0*8, 128+1*8, 128+2*8, 128+3*8, 128+4*8, 128+5*8, 128+6*8, 128+7*8);
var
  memoria_temp:array[0..$7fff] of byte;
  bit0,bit1,bit2:byte;
  colores:tpaleta;
  f:word;
begin
iniciar_drmicro:=false;
llamadas_maquina.bucle_general:=drmicro_principal;
llamadas_maquina.reset:=reset_drmicro;
llamadas_maquina.scanlines:=256;
iniciar_audio(false);
screen_init(1,256,256);
screen_init(2,256,256,true);
screen_init(3,256,256,false,true);
main_screen.rot270_screen:=true;
iniciar_video(256,224);
//Main CPU
z80_0:=cpu_z80.create(18432000 div 6);
z80_0.change_ram_calls(drmicro_getbyte,drmicro_putbyte);
z80_0.change_io_calls(drmicro_inbyte,drmicro_outbyte);
z80_0.init_sound(drmicro_sound_update);
if not(roms_load(@memoria,drmicro_rom)) then exit;
//Audio chips
sn_76496_0:=sn76496_chip.create(18432000 div 4,nil,0.75);
sn_76496_1:=sn76496_chip.create(18432000 div 4,nil,0.75);
sn_76496_2:=sn76496_chip.create(18432000 div 4,nil,0.75);
msm5205_0:=MSM5205_chip.create(384000,MSM5205_S64_4B,1,$4000);
msm5205_0.change_advance(snd_adpcm);
if not(roms_load(msm5205_0.rom_data,drmicro_adpcm)) then exit;
//convertir chars1
if not(roms_load(@memoria_temp,drmicro_gfx1)) then exit;
init_gfx(0,8,8,$400);
gfx_set_desc_data(2,0,8*8,0,$2000*8);
convert_gfx(0,0,@memoria_temp,@ps_x,@ps_y,false,false);
//convertir sprites1
init_gfx(2,16,16,$100);
gfx_set_desc_data(2,0,8*8*4,0,$2000*8);
convert_gfx(2,0,@memoria_temp,@ps_x,@ps_y,false,false);
gfx[2].trans[0]:=true;
//convertir char2
if not(roms_load(@memoria_temp,drmicro_gfx2)) then exit;
init_gfx(1,8,8,$400);
gfx_set_desc_data(3,0,8*8,$2000*16,$2000*8,0);
convert_gfx(1,0,@memoria_temp,@ps_x,@ps_y,false,false);
gfx[1].trans[0]:=true;
//convertir sprites2
init_gfx(3,16,16,$100);
gfx_set_desc_data(3,0,8*8*4,$2000*16,$2000*8,0);
convert_gfx(3,0,@memoria_temp,@ps_x,@ps_y,false,false);
gfx[3].trans[0]:=true;
//colores
if not(roms_load(@memoria_temp,drmicro_proms)) then exit;
for f:=0 to $1f do begin
		// red component
		bit0:=(memoria_temp[f] shr 0) and 1;
		bit1:=(memoria_temp[f] shr 1) and 1;
		bit2:=(memoria_temp[f] shr 2) and 1;
		colores[f].r:=$21*bit0+$47*bit1+$97*bit2;
		// green component
		bit0:=(memoria_temp[f] shr 3) and 1;
		bit1:=(memoria_temp[f] shr 4) and 1;
		bit2:=(memoria_temp[f] shr 5) and 1;
		colores[f].g:=$21*bit0+$47*bit1+$97*bit2;
		// blue component
    bit0:=0;
		bit1:=(memoria_temp[f] shr 6) and 1;
		bit2:=(memoria_temp[f] shr 7) and 1;
		colores[f].b:=$21*bit0+$47*bit1+$97*bit2;
end;
set_pal(colores,$20);
for f:=0 to $1ff do begin
  gfx[0].colores[f]:=memoria_temp[$20+f] and $f;
  gfx[1].colores[f]:=memoria_temp[$20+f] and $f;
  gfx[2].colores[f]:=memoria_temp[$20+f] and $f;
  gfx[3].colores[f]:=memoria_temp[$20+f] and $f;
end;
init_dips(1,drmicro_dip_a,$4d);
init_dips(2,drmicro_dip_b,0);
//final
iniciar_drmicro:=true;
end;

end.
