unit cpcconfig_misc;

interface

procedure ConfigCPC_Show;
procedure ConfigCPC_OK;

implementation
uses principal,config_cpc,main_engine,amstrad_cpc,lenslock;

procedure ConfigCPC_Show;
var
  f:integer;
begin
f:=(principal1.left+(principal1.width div 2))-(ConfigCPC.Width div 2);
if f<0 then ConfigCPC.Left:=0
  else ConfigCPC.Left:=f;
f:=(principal1.top+(principal1.Height div 2))-(ConfigCPC.Height div 2);
if f<0 then ConfigCPC.Top:=0
  else ConfigCPC.Top:=f;
case main_vars.tipo_maquina of
  7,8:begin
        ConfigCPC.groupbox3.enabled:=false;
        ConfigCPC.radiobutton5.Enabled:=false;
        ConfigCPC.radiobutton6.Enabled:=false;
        ConfigCPC.radiobutton7.Enabled:=false;
        ConfigCPC.radiobutton5.Checked:=true;
      end;
  9:begin
        ConfigCPC.groupbox3.enabled:=true;
        ConfigCPC.radiobutton5.Enabled:=true;
        ConfigCPC.radiobutton6.Enabled:=true;
        ConfigCPC.radiobutton7.Enabled:=true;
        case cpc_ga.ram_exp of
          0:ConfigCPC.radiobutton5.Checked:=true;
          1:ConfigCPC.radiobutton6.Checked:=true;
          2:ConfigCPC.radiobutton7.Checked:=true;
        end;
    end;
end;
case main_vars.tipo_maquina of
  8:begin //CPC 664
      ConfigCPC.radiobutton2.Enabled:=false;
      ConfigCPC.radiobutton3.Enabled:=false;
      ConfigCPC.radiobutton4.Enabled:=false;
      case cpc_ga.cpc_model of
        4:ConfigCPC.radiobutton8.Checked:=true;
          else ConfigCPC.radiobutton1.Checked:=true;
      end;
    end;
  7,9:begin  //CPC 464 y 6128
      ConfigCPC.radiobutton2.Enabled:=true;
      ConfigCPC.radiobutton3.Enabled:=true;
      ConfigCPC.radiobutton4.Enabled:=true;
      case cpc_ga.cpc_model of
        0:ConfigCPC.radiobutton1.Checked:=true;
        1:ConfigCPC.radiobutton2.Checked:=true;
        2:ConfigCPC.radiobutton3.Checked:=true;
        3:ConfigCPC.radiobutton4.Checked:=true;
        4:ConfigCPC.radiobutton8.Checked:=true;
      end;
    end;
end;
ConfigCPC.Edit7.Text:=cpc_rom[0].name;
ConfigCPC.Edit1.Text:=cpc_rom[1].name;
ConfigCPC.Edit2.Text:=cpc_rom[2].name;
ConfigCPC.Edit3.Text:=cpc_rom[3].name;
ConfigCPC.Edit4.Text:=cpc_rom[4].name;
ConfigCPC.Edit5.Text:=cpc_rom[5].name;
ConfigCPC.Edit6.Text:=cpc_rom[6].name;
//Lenslock
if lenslok.activo then ConfigCPC.radiobutton12.Checked:=true
  else ConfigCPC.radiobutton13.Checked:=true;
ConfigCPC.trackbar1.Position:=cpc_crt.bright;
if cpc_crt.color_monitor then begin
  ConfigCPC.radiobutton9.Checked:=true;
  ConfigCPC.groupbox5.Enabled:=false;
  ConfigCPC.trackbar1.Enabled:=false;
end else begin
  ConfigCPC.radiobutton10.Checked:=true;
  ConfigCPC.groupbox5.Enabled:=true;
  ConfigCPC.trackbar1.Enabled:=true;
end;
end;

procedure ConfigCPC_OK;
begin
if ConfigCPC.radiobutton1.Checked then cpc_ga.cpc_model:=0
  else if ConfigCPC.radiobutton2.Checked then cpc_ga.cpc_model:=1
    else if ConfigCPC.radiobutton3.Checked then cpc_ga.cpc_model:=2
      else if ConfigCPC.radiobutton4.Checked then cpc_ga.cpc_model:=3
        else if ConfigCPC.radiobutton8.Checked then cpc_ga.cpc_model:=4;
lenslok.activo:=ConfigCPC.radiobutton12.Checked;
cpc_crt.color_monitor:=ConfigCPC.radiobutton9.Checked;
if ConfigCPC.radiobutton5.Checked then cpc_ga.ram_exp:=0
  else if ConfigCPC.radiobutton6.Checked then cpc_ga.ram_exp:=1
    else if ConfigCPC.radiobutton7.Checked then cpc_ga.ram_exp:=2;
if lenslok.activo then lenslock1.Show;
cpc_crt.bright:=ConfigCPC.trackbar1.Position;
cpc_load_roms;
amstrad_cpc_paleta;
end;

end.
