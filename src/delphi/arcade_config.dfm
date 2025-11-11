object config_arcade: Tconfig_arcade
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Arcade Config'
  ClientHeight = 373
  ClientWidth = 810
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clDefault
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 257
    Height = 297
    Caption = 'DIP A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object Button1: TButton
    Left = 208
    Top = 320
    Width = 121
    Height = 41
    Caption = 'OK'
    TabOrder = 1
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 496
    Top = 320
    Width = 121
    Height = 41
    Caption = 'CANCEL'
    TabOrder = 0
    TabStop = False
    OnClick = Button2Click
  end
  object GroupBox2: TGroupBox
    Left = 280
    Top = 8
    Width = 257
    Height = 297
    Caption = 'DIP B'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
  end
  object GroupBox3: TGroupBox
    Left = 552
    Top = 8
    Width = 257
    Height = 297
    Caption = 'DIP C'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
end
