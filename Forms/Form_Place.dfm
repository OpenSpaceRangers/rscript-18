object FormPlace: TFormPlace
  Left = 230
  Top = 384
  BorderStyle = bsDialog
  Caption = 'Place'
  ClientHeight = 241
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Label26: TLabel
    Left = 8
    Top = 38
    Width = 31
    Height = 13
    Caption = 'Type :'
  end
  object BitBtn1: TBitBtn
    Left = 152
    Top = 210
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 232
    Top = 210
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object EditName: TEdit
    Left = 48
    Top = 8
    Width = 265
    Height = 21
    TabOrder = 2
  end
  object Notebook1: TNotebook
    Left = 8
    Top = 64
    Width = 302
    Height = 137
    TabOrder = 3
    object TPage
      Left = 0
      Top = 0
      Caption = 'Free'
      object Label14: TLabel
        Left = 8
        Top = 11
        Width = 77
        Height = 13
        Caption = 'Angle (0..360) :'
      end
      object Label15: TLabel
        Left = 8
        Top = 44
        Width = 79
        Height = 13
        Caption = 'Distance (0..1) :'
      end
      object Label16: TLabel
        Left = 8
        Top = 76
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object EditFAngle: TEdit
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        TabOrder = 0
      end
      object EditFDist: TEdit
        Left = 88
        Top = 40
        Width = 201
        Height = 21
        TabOrder = 1
      end
      object EditFRadius: TEdit
        Left = 88
        Top = 72
        Width = 201
        Height = 21
        TabOrder = 2
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Near planet'
      object Label17: TLabel
        Left = 8
        Top = 11
        Width = 37
        Height = 13
        Caption = 'Planet :'
      end
      object Label18: TLabel
        Left = 8
        Top = 43
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object ComboBoxNPPlanet: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
      object EditNPRadius: TEdit
        Left = 88
        Top = 40
        Width = 201
        Height = 21
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'In planet'
      object Label19: TLabel
        Left = 8
        Top = 11
        Width = 37
        Height = 13
        Caption = 'Planet :'
      end
      object ComboBoxIPPlanet: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'To star'
      object Label20: TLabel
        Left = 8
        Top = 11
        Width = 27
        Height = 13
        Caption = 'Star :'
      end
      object Label21: TLabel
        Left = 8
        Top = 44
        Width = 79
        Height = 13
        Caption = 'Distance (0..1) :'
      end
      object Label22: TLabel
        Left = 8
        Top = 76
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object Label23: TLabel
        Left = 8
        Top = 107
        Width = 98
        Height = 13
        Caption = 'Angle add (0..360) :'
      end
      object ComboBoxTSStar: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
      object EditTSDist: TEdit
        Left = 88
        Top = 40
        Width = 201
        Height = 21
        TabOrder = 1
      end
      object EditTSRadius: TEdit
        Left = 88
        Top = 72
        Width = 201
        Height = 21
        TabOrder = 2
      end
      object EditTSAngle: TEdit
        Left = 104
        Top = 104
        Width = 185
        Height = 21
        TabOrder = 3
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Near item'
      object Label24: TLabel
        Left = 8
        Top = 11
        Width = 29
        Height = 13
        Caption = 'Item :'
      end
      object Label25: TLabel
        Left = 8
        Top = 43
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object ComboBoxNIItem: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
      object EditNIRadius: TEdit
        Left = 88
        Top = 40
        Width = 201
        Height = 21
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'From group'
      object Label2: TLabel
        Left = 8
        Top = 11
        Width = 36
        Height = 13
        Caption = 'Group :'
      end
      object Label3: TLabel
        Left = 8
        Top = 44
        Width = 76
        Height = 13
        Caption = 'Distance (0..1):'
      end
      object Label4: TLabel
        Left = 8
        Top = 76
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object Label5: TLabel
        Left = 8
        Top = 107
        Width = 98
        Height = 13
        Caption = 'Angle add (0..360) :'
      end
      object ComboBoxFGGroup: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object EditFGDist: TEdit
        Left = 88
        Top = 40
        Width = 201
        Height = 21
        TabOrder = 1
      end
      object EditFGRadius: TEdit
        Left = 88
        Top = 72
        Width = 201
        Height = 21
        TabOrder = 2
      end
      object EditFGAngle: TEdit
        Left = 104
        Top = 104
        Width = 185
        Height = 21
        TabOrder = 3
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'From coords'
      object Label27: TLabel
        Left = 8
        Top = 11
        Width = 29
        Height = 13
        Caption = 'Var X:'
      end
      object Label28: TLabel
        Left = 8
        Top = 43
        Width = 29
        Height = 13
        Caption = 'Var Y:'
      end
      object Label29: TLabel
        Left = 8
        Top = 75
        Width = 72
        Height = 13
        Caption = 'Radius (pixel) :'
      end
      object ComboBoxCRDX: TComboBox
        Left = 88
        Top = 8
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
      object ComboBoxCRDY: TComboBox
        Left = 88
        Top = 43
        Width = 201
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
      object EditCRDRadius: TEdit
        Left = 88
        Top = 75
        Width = 201
        Height = 21
        TabOrder = 1
      end
    end
  end
  object ComboBoxType: TComboBox
    Left = 48
    Top = 36
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ComboBoxTypeChange
    Items.Strings = (
      'Free'
      'Near planet'
      'In planet'
      'To star'
      'Near item'
      'From group'
      'From coords')
  end
end
