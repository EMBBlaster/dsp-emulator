unit jailbreak_hw;

interface
uses rom_engine;

function iniciar_jailbreak:boolean;

const
        jailbreak_rom:array[0..1] of tipo_roms=(
        (n:'507p03.11d';l:$4000;p:$8000;crc:$a0b88dfd),(n:'507p02.9d';l:$4000;p:$c000;crc:$444b7d8e));
        jailbreak_char:array[0..1] of tipo_roms=(
        (n:'507l08.4f';l:$4000;p:0;crc:$e3b7a226),(n:'507j09.5f';l:$4000;p:$4000;crc:$504f0912));
        jailbreak_sprites:array[0..3] of tipo_roms=(
        (n:'507j04.3e';l:$4000;p:0;crc:$0d269524),(n:'507j05.4e';l:$4000;p:$4000;crc:$27d4f6f4),
        (n:'507j06.5e';l:$4000;p:$8000;crc:$717485cb),(n:'507j07.3f';l:$4000;p:$c000;crc:$e933086f));
        jailbreak_vlm:tipo_roms=(n:'507l01.8c';l:$4000;p:0;crc:$0c8a3605);
        jailbreak_pal:array[0..4] of tipo_roms=(
        (n:'507j10.1f';l:$20;p:0;crc:$f1909605),(n:'507j11.2f';l:$20;p:$20;crc:$f70bb122),
        (n:'507j13.7f';l:$100;p:$40;crc:$d4fe5c97),(n:'507j12.6f';l:$100;p:$140;crc:$0266c7db),());

implementation
uses m6809,main_engine,controls_engine,sn_76496,vlm_5030,gfx_engine,
     timer_engine,pal_engine,konami_decrypt,sound_engine;

const
        jailbreak_dip_a:array [0..1] of def_dip2=(
        (mask:$f;name:'Coin A';number:16;val16:(2,5,8,4,1,$f,3,7,$e,6,$d,$c,$b,$a,9,0);name16:('4C 1C','3C 1C','2C 1C','3C 2C','4C 3C','1C 1C','3C 4C','2C 3C','1C 2C','2C 5C','1C 3C','1C 4C','1C 5C','1C 6C','1C 7C','Free Play')),
        (mask:$f0;name:'Coin B';number:16;val16:($20,$50,$80,$40,$10,$f0,$30,$70,$e0,$60,$d0,$c0,$b0,$a0,$90,0);name16:('4C 1C','3C 1C','2C 1C','3C 2C','4C 3C','1C 1C','3C 4C','2C 3C','1C 2C','2C 5C','1C 3C','1C 4C','1C 5C','1C 6C','1C 7C','Invalid')));
        jailbreak_dip_b:array [0..4] of def_dip2=(
        (mask:3;name:'Lives';number:4;val4:(3,2,1,0);name4:('1','2','3','5')),
        (mask:4;name:'Cabinet';number:2;val2:(0,4);name2:('Upright','Cocktail')),
        (mask:8;name:'Bonus Life';number:2;val2:(8,0);name2:('30K 70K+','40K 80K+')),
        (mask:$30;name:'Difficulty';number:4;val4:($30,$20,$10,0);name4:('Easy','Normal','Difficult','Very Difficult')),
        (mask:$80;name:'Demo Sounds';number:2;val2:($80,0);name2:('Off','On')));
        jailbreak_dip_c:array [0..1] of def_dip2=(
        (mask:1;name:'Flip Screen';number:2;val2:(1,0);name2:('Off','On')),
        (mask:2;name:'Upright Controls';number:2;val2:(2,0);name2:('Single','Dual')));

var
 irq_ena,nmi_ena,scroll_dir:boolean;
 mem_opcodes:array[0..$7fff] of byte;
 scroll_lineas:array[0..$1f] of word;

procedure update_video_jailbreak;
var
  y,atrib:byte;
  f,x,nchar,color:word;
begin
for f:=0 to $7ff do begin
    if gfx[0].buffer[f] then begin
      x:=f mod 64;
      y:=f div 64;
      atrib:=memoria[0+f];
      nchar:=memoria[$800+f]+((atrib and $c0) shl 2);
      color:=(atrib and $f) shl 4;
      put_gfx(x*8,y*8,nchar,color,1,0);
      gfx[0].buffer[f]:=false;
    end;
end;
if scroll_dir then scroll__y_part2(1,2,8,@scroll_lineas)
  else scroll__x_part2(1,2,8,@scroll_lineas);
for f:=0 to $2f do begin
  atrib:=memoria[$1001+(f*4)];
  nchar:=memoria[$1000+(f*4)]+((atrib and $40) shl 2);
  color:=(atrib and $f) shl 4;
  x:=memoria[$1002+(f*4)]+((atrib and $80) shl 1);
  y:=memoria[$1003+(f*4)];
  put_gfx_sprite_mask(nchar,color,(atrib and $10)<>0,(atrib and $20)<>0,1,0,$f);
  actualiza_gfx_sprite(x,y,2,1);
end;
actualiza_trozo_final(8,16,240,224,2);
end;

procedure eventos_jailbreak;
begin
if event.arcade then begin
  marcade.in0:=$ff;
  marcade.in1:=$ff;
  marcade.in2:=$ff;
  //P1
  if arcade_input.left[0] then marcade.in0:=marcade.in0 and $fe;
  if arcade_input.right[0] then marcade.in0:=marcade.in0 and $fd;
  if arcade_input.up[0] then marcade.in0:=marcade.in0 and $fb;
  if arcade_input.down[0] then marcade.in0:=marcade.in0 and $f7;
  if arcade_input.but0[0] then marcade.in0:=marcade.in0 and $ef;
  if arcade_input.but1[0] then marcade.in0:=marcade.in0 and $df;
  //P2
  if arcade_input.left[1] then marcade.in1:=marcade.in1 and $fe;
  if arcade_input.right[1] then marcade.in1:=marcade.in1 and $fd;
  if arcade_input.up[1] then marcade.in1:=marcade.in1 and $fb;
  if arcade_input.down[1] then marcade.in1:=marcade.in1 and $f7;
  if arcade_input.but0[1] then marcade.in1:=marcade.in1 and $ef;
  if arcade_input.but1[1] then marcade.in1:=marcade.in1 and $df;
  //SYS
  if arcade_input.coin[0] then marcade.in2:=marcade.in2 and $fe;
  if arcade_input.coin[1] then marcade.in2:=marcade.in2 and $fd;
  if arcade_input.start[0] then marcade.in2:=marcade.in2 and $f7;
  if arcade_input.start[1] then marcade.in2:=marcade.in2 and $ef;
end;
end;

procedure jailbreak_principal;
var
  f:byte;
begin
while EmuStatus=EsRunning do begin
  for f:=0 to $ff do begin
    eventos_jailbreak;
    if f=240 then begin
      if irq_ena then m6809_0.change_irq(HOLD_LINE);
      update_video_jailbreak;
    end;
    m6809_0.run(frame_main);
    frame_main:=frame_main+m6809_0.tframes-m6809_0.contador;
  end;
  video_sync;
end;
end;

function jailbreak_getbyte(direccion:word):byte;
begin
case direccion of
  0..$203f,$3000..$307f:jailbreak_getbyte:=memoria[direccion];
  $3100:jailbreak_getbyte:=marcade.dswb;
  $3200:jailbreak_getbyte:=marcade.dswc;
  $3300:jailbreak_getbyte:=marcade.in2;
  $3301:jailbreak_getbyte:=marcade.in0;
  $3302:jailbreak_getbyte:=marcade.in1;
  $3303:jailbreak_getbyte:=marcade.dswa;
  $6000:jailbreak_getbyte:=vlm5030_0.get_bsy;
  $8000..$ffff:if m6809_0.opcode then jailbreak_getbyte:=mem_opcodes[direccion and $7fff]
                  else jailbreak_getbyte:=memoria[direccion];
end;
end;

procedure jailbreak_putbyte(direccion:word;valor:byte);
begin
case direccion of
  0..$fff:if memoria[direccion]<>valor then begin
              gfx[0].buffer[direccion and $7ff]:=true;
              memoria[direccion]:=valor;
           end;
  $1000..$1fff:memoria[direccion]:=valor;
  $2000..$201f:begin
                  scroll_lineas[direccion and $1f]:=(scroll_lineas[direccion and $1f] and $ff00) or valor;
                  memoria[direccion]:=valor;
               end;
  $2020..$203f:begin
                  scroll_lineas[direccion and $1f]:=(scroll_lineas[direccion and $1f] and $ff) or ((valor and 1) shl 8);
                  memoria[direccion]:=valor;
               end;
  $2042:scroll_dir:=(valor and 4)<>0;
  $2044:begin
          nmi_ena:=((valor and 1)<>0);
          irq_ena:=((valor and 2)<>0);
          main_screen.flip_main_screen:=(valor and 8)<>0;
        end;
  $3100:sn_76496_0.write(valor);
  $4000:begin
           vlm5030_0.set_st((valor shr 1) and 1);
	         vlm5030_0.set_rst((valor shr 2) and 1);
        end;
  $5000:vlm5030_0.data_w(valor);
  $8000..$ffff:; //ROM
end;
end;

procedure jailbreak_snd_nmi;
begin
  if nmi_ena then m6809_0.change_nmi(PULSE_LINE);
end;

procedure jailbreak_sound;
begin
  sn_76496_0.update;
  vlm5030_0.update;
end;

//Main
procedure reset_jailbreak;
begin
 m6809_0.reset;
 sn_76496_0.reset;
 vlm5030_0.reset;
 frame_main:=m6809_0.tframes;
 marcade.in0:=$ff;
 marcade.in1:=$ff;
 marcade.in2:=$ff;
 irq_ena:=false;
 nmi_ena:=false;
 scroll_dir:=false;
end;

function iniciar_jailbreak:boolean;
var
    colores:tpaleta;
    f:word;
    memoria_temp:array[0..$ffff] of byte;
const
    ps_x:array[0..15] of dword=(0*4, 1*4, 2*4, 3*4, 4*4, 5*4, 6*4, 7*4,
			32*8+0*4, 32*8+1*4, 32*8+2*4, 32*8+3*4, 32*8+4*4, 32*8+5*4, 32*8+6*4, 32*8+7*4);
    ps_y:array[0..15] of dword=(0*32, 1*32, 2*32, 3*32, 4*32, 5*32, 6*32, 7*32,
			16*32, 17*32, 18*32, 19*32, 20*32, 21*32, 22*32, 23*32);
begin
llamadas_maquina.bucle_general:=jailbreak_principal;
llamadas_maquina.reset:=reset_jailbreak;
llamadas_maquina.fps_max:=60.606060606060;
llamadas_maquina.scanlines:=256;
iniciar_jailbreak:=false;
iniciar_audio(false);
screen_init(1,512,256);
screen_init(2,512,256,false,true);
iniciar_video(240,224);
//Main CPU
m6809_0:=cpu_m6809.create(18432000 div 12,TCPU_M6809);
m6809_0.change_ram_calls(jailbreak_getbyte,jailbreak_putbyte);
m6809_0.init_sound(jailbreak_sound);
if not(roms_load(@memoria,jailbreak_rom)) then exit;
konami1_decode(@memoria[$8000],@mem_opcodes[0],$8000);
//mem_opcodes[$9a7c and $7fff]:=$20;  //inmune
//mem_opcodes[$9aee and $7fff]:=$39;
//mem_opcodes[$9b4b and $7fff]:=$20;
//Sound Chip
sn_76496_0:=sn76496_chip.Create(18432000 div 12);
//cargar rom sonido
vlm5030_0:=vlm5030_chip.create(3579545,$2000,2);
if not(roms_load(@memoria_temp,jailbreak_vlm)) then exit;
copymemory(vlm5030_0.get_rom_addr,@memoria_temp,$2000);
//NMI sonido
timers.init(m6809_0.numero_cpu,1536000/480,jailbreak_snd_nmi,nil,true);
//convertir chars
if not(roms_load(@memoria_temp,jailbreak_char)) then exit;
init_gfx(0,8,8,1024);
gfx_set_desc_data(4,0,32*8,0,1,2,3);
convert_gfx(0,0,@memoria_temp,@ps_x,@ps_y,false,false);
//sprites
if not(roms_load(@memoria_temp,jailbreak_sprites)) then exit;
init_gfx(1,16,16,512);
gfx[1].trans[0]:=true;
gfx_set_desc_data(4,0,128*8,0,1,2,3);
convert_gfx(1,0,@memoria_temp,@ps_x,@ps_y,false,false);
//paleta
if not(roms_load(@memoria_temp,jailbreak_pal)) then exit;
for f:=0 to $1f do begin
  colores[f].r:=((memoria_temp[f] and $f) shl 4) or (memoria_temp[f] and $f);
  colores[f].g:=((memoria_temp[f] shr 4) shl 4) or (memoria_temp[f] shr 4);
  colores[f].b:=((memoria_temp[f+$20] and $f) shl 4) or (memoria_temp[f+$20] and $f);
end;
set_pal(colores,32);
for f:=0 to $ff do begin
  gfx[0].colores[f]:=(memoria_temp[$40+f] and $f)+$10;  //chars
  gfx[1].colores[f]:=memoria_temp[$140+f] and $f;  //sprites
end;
//DIP
init_dips(1,jailbreak_dip_a,$ff);
init_dips(2,jailbreak_dip_b,$19);
init_dips(3,jailbreak_dip_c,3);
//final
iniciar_jailbreak:=true;
end;

end.
