object FormIf: TFormIf
  Left = 164
  Top = 467
  Width = 1016
  Height = 125
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'if'
  Color = clBtnFace
  Constraints.MinHeight = 120
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 73
    Height = 55
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 59
      Height = 13
      Caption = 'Expression :'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 55
    Width = 1008
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object RxSpeedButton2: TSpeedButton
      Left = 98
      Top = 7
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object Panel3: TPanel
      Left = 831
      Top = 0
      Width = 177
      Height = 43
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 7
        Width = 75
        Height = 25
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 0
        OnClick = BitBtn1Click
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 7
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
    object ComboBoxType: TComboBox
      Left = 13
      Top = 9
      Width = 78
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Normal'
        'Init'
        'Global'
        'DialogBegin')
    end
  end
  object Panel4: TPanel
    Left = 1000
    Top = 0
    Width = 8
    Height = 55
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel5: TPanel
    Left = 73
    Top = 0
    Width = 927
    Height = 55
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 927
      Height = 9
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object Panel7: TPanel
      Left = 0
      Top = 46
      Width = 927
      Height = 9
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
    end
    object EditExpr: TRichEdit
      Left = 0
      Top = 9
      Width = 927
      Height = 37
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      WantReturns = False
      WordWrap = False
    end
  end
end
