unit junofirst_hw;

interface
uses rom_engine;

function iniciar_junofrst:boolean;

const
        junofrst_rom:array[0..2] of tipo_roms=(
        (n:'jfa_b9.bin';l:$2000;p:$a000;crc:$f5a7ab9d),(n:'jfb_b10.bin';l:$2000;p:$c000;crc:$f20626e0),
        (n:'jfc_a10.bin';l:$2000;p:$e000;crc:$1e7744a7));
        junofrst_bank_rom:array[0..5] of tipo_roms=(
        (n:'jfc1_a4.bin';l:$2000;p:0;crc:$03ccbf1d),(n:'jfc2_a5.bin';l:$2000;p:$2000;crc:$cb372372),
        (n:'jfc3_a6.bin';l:$2000;p:$4000;crc:$879d194b),(n:'jfc4_a7.bin';l:$2000;p:$6000;crc:$f28af80b),
        (n:'jfc5_a8.bin';l:$2000;p:$8000;crc:$0539f328),(n:'jfc6_a9.bin';l:$2000;p:$a000;crc:$1da2ad6e));
        junofrst_sound:tipo_roms=(n:'jfs1_j3.bin';l:$1000;p:0;crc:$235a2893);
        junofrst_sound_sub:tipo_roms=(n:'jfs2_p4.bin';l:$1000;p:0;crc:$d0fa5d5f);
        junofrst_blit:array[0..3] of tipo_roms=(
        (n:'jfs3_c7.bin';l:$2000;p:0;crc:$aeacf6db),(n:'jfs4_d7.bin';l:$2000;p:$2000;crc:$206d954c),
        (n:'jfs5_e7.bin';l:$2000;p:$4000;crc:$1eb87a6e),());

implementation
uses m6809,nz80,main_engine,controls_engine,gfx_engine,pal_engine,sound_engine,
     konami_decrypt,ay_8910,mcs48,dac;

const
        junofrst_dip_a:def_dip2=(
        mask:$f;name:'Coin A';number:16;val16:(2,5,8,4,1,$f,3,7,$e,6,$d,$c,$b,$a,9,0);name16:('4C 1C','3C 1C','2C 1C','3C 2C','4C 3C','1C 1C','3C 4C','2C 3C','1C 2C','2C 5C','1C 3C','1C 4C','1C 5C','1C 6C','1C 7C','Free Play'));
        junofrst_dip_b:array [0..3] of def_dip2=(
        (mask:3;name:'Lives';number:4;val4:(3,2,1,0);name4:('3','4','5','256')),
        (mask:4;name:'Cabinet';number:2;val2:(0,4);name2:('Upright','Cocktail')),
        (mask:$70;name:'Difficulty';number:8;val8:($70,$60,$50,$40,$30,$20,$10,0);name8:('1 (Easiest)','2','3','4','5','6','7','8 (Hardest)')),
        (mask:$80;name:'Demo Sounds';number:2;val2:($80,0);name2:('Off','On')));

var
 rom_bank,rom_bank_dec:array[0..$f,0..$fff] of byte;
 mem_opcodes,blit_mem:array[0..$5fff] of byte;
 irq_enable:boolean;
 i8039_status,xorx,xory,last_snd_val,sound_latch,sound_latch2,rom_nbank,scroll_y:byte;
 blit_data:array[0..3] of byte;
 mem_snd_sub:array[0..$fff] of byte;

procedure update_video_junofrst;
var
  y,x:word;
  effx,effy,vrambyte,shifted:byte;
  punt:array[0..$ffff] of word;
begin
for y:=0 to 255 do begin
		for x:=0 to 255 do begin
			effy:=y xor xory;
      if effy<192 then effx:=(x xor xorx)+scroll_y
        else effx:=(x xor xorx);
			vrambyte:=memoria[effx*128+effy shr 1];
			shifted:=vrambyte shr (4*(effy and 1));
      punt[y*256+x]:=paleta[shifted and $f];
		end;
end;
putpixel(0,0,$10000,@punt,1);
actualiza_trozo(16,0,224,256,1,0,0,224,256,PANT_TEMP);
end;

procedure eventos_junofrst;
begin
if event.arcade then begin
  marcade.in0:=$ff;
  marcade.in1:=$ff;
  marcade.in2:=$ff;
  //marcade.in1
  if arcade_input.left[0] then marcade.in1:=marcade.in1 and $fe;
  if arcade_input.right[0] then marcade.in1:=marcade.in1 and $fd;
  if arcade_input.up[0] then marcade.in1:=marcade.in1 and $fb;
  if arcade_input.down[0] then marcade.in1:=marcade.in1 and $f7;
  if arcade_input.but1[0] then marcade.in1:=marcade.in1 and $ef;
  if arcade_input.but0[0] then marcade.in1:=marcade.in1 and $df;
  if arcade_input.but2[0] then marcade.in1:=marcade.in1 and $bf;
  //marcade.in2
  if arcade_input.left[1] then marcade.in2:=marcade.in2 and $fe;
  if arcade_input.right[1] then marcade.in2:=marcade.in2 and $fd;
  if arcade_input.up[1] then marcade.in2:=marcade.in2 and $fb;
  if arcade_input.down[1] then marcade.in2:=marcade.in2 and $f7;
  if arcade_input.but1[1] then marcade.in2:=marcade.in2 and $ef;
  if arcade_input.but0[1] then marcade.in2:=marcade.in2 and $df;
  if arcade_input.but2[1] then marcade.in2:=marcade.in2 and $bf;
  //service
  if arcade_input.coin[0] then marcade.in0:=marcade.in0 and $fe;
  if arcade_input.coin[1] then marcade.in0:=marcade.in0 and $fd;
  if arcade_input.start[0] then marcade.in0:=marcade.in0 and $f7;
  if arcade_input.start[1] then marcade.in0:=marcade.in0 and $ef;
end;
end;

procedure junofrst_principal;
var
  irq_req:boolean;
  f:byte;
begin
irq_req:=false;
while EmuStatus=EsRunning do begin
  for f:=0 to 255 do begin
    eventos_junofrst;
    if f=240 then begin
      if (irq_req and irq_enable) then m6809_0.change_irq(ASSERT_LINE);
      update_video_junofrst;
    end;
    //Main CPU
    m6809_0.run(frame_main);
    frame_main:=frame_main+m6809_0.tframes-m6809_0.contador;
    //Sound CPU
    z80_0.run(frame_snd);
    frame_snd:=frame_snd+z80_0.tframes-z80_0.contador;
    //snd sub
    mcs48_0.run(frame_snd2);
    frame_snd2:=frame_snd2+mcs48_0.tframes-mcs48_0.contador;
  end;
  irq_req:=not(irq_req);
  video_sync;
end;
end;

function junofrst_getbyte(direccion:word):byte;
begin
case direccion of
  0..$800f,$8100..$8fff:junofrst_getbyte:=memoria[direccion];
  $8010:junofrst_getbyte:=marcade.dswb; //dsw2
  $8020:junofrst_getbyte:=marcade.in0;
  $8024:junofrst_getbyte:=marcade.in1;
  $8028:junofrst_getbyte:=marcade.in2;
  $802c:junofrst_getbyte:=marcade.dswa; //dsw1
  $9000..$9fff:if m6809_0.opcode then junofrst_getbyte:=rom_bank_dec[rom_nbank,direccion and $fff]
                  else junofrst_getbyte:=rom_bank[rom_nbank,direccion and $fff];
  $a000..$ffff:if m6809_0.opcode then junofrst_getbyte:=mem_opcodes[direccion-$a000]
                  else junofrst_getbyte:=memoria[direccion];
end;
end;

procedure junofrst_putbyte(direccion:word;valor:byte);
var
  color:tcolor;
procedure draw_blitter;
var
  i,j,copy,data:byte;
  src,dest:word;
begin
		src:=((blit_data[2] shl 8) or blit_data[3]) and $fffc;
		dest:=(blit_data[0] shl 8) or blit_data[1];
		copy:=blit_data[3] and 1;
		// 16x16 graphics
		for i:=0 to 15 do begin
			for j:=0 to 15 do begin
				if (src and 1)<>0 then data:=blit_mem[src shr 1] and $f
				  else data:=blit_mem[src shr 1] shr 4;
				src:=src+1;
				// if there is a source pixel either copy the pixel or clear the pixel depending on the copy flag
				if (data<>0) then begin
					if (copy=0) then data:=0;
					if (dest and 1)<>0 then memoria[dest shr 1]:=(memoria[dest shr 1] and $f) or (data shl 4)
					  else memoria[dest shr 1]:=(memoria[dest shr 1] and $f0) or data;
				end;
				dest:=dest+1;
			end; //del j
			dest:=dest+240;
		end; //del i
end;
begin
case direccion of
  0..$7fff,$8100..$8fff:memoria[direccion]:=valor;
  $8000..$800f:begin
                color.r:=pal3bit(valor shr 0);
                color.g:=pal3bit(valor shr 3);
                color.b:=pal2bit(valor shr 6);
                set_pal_color(color,direccion and $f);
               end;
  $8030:begin
            irq_enable:=(valor and 1)<>0;
            if not(irq_enable) then m6809_0.change_irq(CLEAR_LINE);
        end;
  $8031:; //Coin counter...
  $8033:scroll_y:=valor;
  $8034:xorx:=((valor and 1) xor 1)*$ff;
  $8035:xory:=(valor and 1)*$ff;
  $8040:begin
          if ((last_snd_val=0) and ((valor and 1)=1))then z80_0.change_irq(HOLD_LINE);
          last_snd_val:=valor and 1;
        end;
  $8050:sound_latch:=valor;
  $8060:rom_nbank:=valor and $f;
  $8070..$8072:blit_data[direccion and 3]:=valor;
  $8073:begin
          blit_data[3]:=valor;
          draw_blitter;
        end;
  $9000..$ffff:;
end;
end;

function junofrst_snd_getbyte(direccion:word):byte;
begin
case direccion of
  0..$fff,$2000..$23ff:junofrst_snd_getbyte:=mem_snd[direccion];
  $3000:junofrst_snd_getbyte:=sound_latch;
  $4001:junofrst_snd_getbyte:=ay8910_0.read;
end;
end;

procedure junofrst_snd_putbyte(direccion:word;valor:byte);
begin
case direccion of
  0..$fff:;
  $2000..$23ff:mem_snd[direccion]:=valor;
  $4000:ay8910_0.control(valor);
  $4002:ay8910_0.write(valor);
  $5000:sound_latch2:=valor;
  $6000:mcs48_0.change_irq(ASSERT_LINE);
end;
end;

function junofrst_sound2_getbyte(direccion:word):byte;
begin
if direccion<$1000 then junofrst_sound2_getbyte:=mem_snd_sub[direccion];
end;

function junofrst_sound2_inport(puerto:word):byte;
begin
if puerto<$100 then junofrst_sound2_inport:=sound_latch2;
end;

procedure junofrst_sound2_outport(puerto:word;valor:byte);
begin
case puerto of
  MCS48_PORT_P1:dac_0.data8_w(valor);
  MCS48_PORT_P2:begin
                  if (valor and $80)=0 then mcs48_0.change_irq(CLEAR_LINE);
                  i8039_status:=(valor and $70) shr 4;
                end;
end;
end;

function junofrst_portar:byte;
var
  timer:byte;
begin
timer:=(z80_0.totalt div (1024 div 2)) and $f;
junofrst_portar:=(timer shl 4) or i8039_status;
end;

procedure junofrst_portbw(valor:byte); //filter RC
begin
end;

procedure junofrst_sound_update;
begin
  ay8910_0.update;
  dac_0.update;
end;

//Main
procedure reset_junofrst;
begin
 m6809_0.reset;
 z80_0.reset;
 mcs48_0.reset;
 ay8910_0.reset;
 dac_0.reset;
 frame_main:=m6809_0.tframes;
 frame_snd:=z80_0.tframes;
 frame_snd2:=mcs48_0.tframes;
 marcade.in0:=$ff;
 marcade.in1:=$ff;
 marcade.in2:=$ff;
 irq_enable:=false;
 fillchar(blit_data,4,0);
 xorx:=0;
 xory:=0;
 last_snd_val:=0;
 sound_latch:=0;
 rom_nbank:=0;
 scroll_y:=0;
 i8039_status:=0;
end;

function iniciar_junofrst:boolean;
var
  f:byte;
  memoria_temp,memoria_temp_bank:array[0..$ffff] of byte;
begin
llamadas_maquina.bucle_general:=junofrst_principal;
llamadas_maquina.reset:=reset_junofrst;
llamadas_maquina.scanlines:=256;
iniciar_junofrst:=false;
iniciar_audio(false);
//Pantallas
screen_init(1,256,256);
iniciar_video(224,256);
//Main CPU
m6809_0:=cpu_m6809.Create(1500000,TCPU_M6809);
m6809_0.change_ram_calls(junofrst_getbyte,junofrst_putbyte);
if not(roms_load(@memoria,junofrst_rom)) then exit;
konami1_decode(@memoria[$a000],@mem_opcodes,$6000);
if not(roms_load(@memoria_temp,junofrst_bank_rom)) then exit;
konami1_decode(@memoria_temp,@memoria_temp_bank,$c000);
for f:=0 to $f do begin
  copymemory(@rom_bank[f,0],@memoria_temp[f*$1000],$1000);
  copymemory(@rom_bank_dec[f,0],@memoria_temp_bank[f*$1000],$1000);
end;
if not(roms_load(@blit_mem,junofrst_blit)) then exit;
//Sound CPU
z80_0:=cpu_z80.create(1789750);
z80_0.change_ram_calls(junofrst_snd_getbyte,junofrst_snd_putbyte);
z80_0.init_sound(junofrst_sound_update);
if not(roms_load(@mem_snd,junofrst_sound)) then exit;
//Sound CPU 2
mcs48_0:=cpu_mcs48.create(8000000,I8039);
mcs48_0.change_ram_calls(junofrst_sound2_getbyte,nil);
mcs48_0.change_io_calls(nil,junofrst_sound2_outport,junofrst_sound2_inport,nil);
if not(roms_load(@mem_snd_sub,junofrst_sound_sub)) then exit;
//Sound Chip
ay8910_0:=ay8910_chip.create(1789750,AY8910);
ay8910_0.change_io_calls(junofrst_portar,nil,nil,junofrst_portbw);
dac_0:=dac_chip.Create(1);
//DIP
init_dips(1,junofrst_dip_a,$ff);
init_dips(2,junofrst_dip_b,$7b);
//final
iniciar_junofrst:=true;
end;

end.
