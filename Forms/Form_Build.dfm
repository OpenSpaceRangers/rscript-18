object FormBuild: TFormBuild
  Left = 458
  Top = 86
  BorderStyle = bsDialog
  Caption = 'Build'
  ClientHeight = 681
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 42
    Width = 54
    Height = 13
    Caption = 'Out script :'
  end
  object Label2: TLabel
    Left = 8
    Top = 74
    Width = 48
    Height = 13
    Caption = 'Out text :'
  end
  object Label3: TLabel
    Left = 8
    Top = 10
    Width = 63
    Height = 13
    Caption = 'Script name :'
  end
  object BitBtn1: TBitBtn
    Left = 440
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = BitBtn1Click
    NumGlyphs = 2
  end
  object FilenameEditScript: TEdit
    Left = 80
    Top = 40
    Width = 449
    Height = 21
    TabOrder = 1
  end
  object EditTextSName: TEdit
    Left = 80
    Top = 8
    Width = 449
    Height = 21
    TabOrder = 2
  end
  object BitBtnBuild: TBitBtn
    Left = 360
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 3
    OnClick = BitBtnBuildClick
  end
  object Co: TMemo
    Left = 8
    Top = 144
    Width = 521
    Height = 529
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object FilenameEditText: TEdit
    Left = 80
    Top = 72
    Width = 449
    Height = 21
    TabOrder = 5
  end
  object CheckBoxLite: TCheckBox
    Left = 8
    Top = 108
    Width = 81
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Lite Build'
    TabOrder = 6
  end
end
