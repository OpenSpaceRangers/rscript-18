object FormDialogMsg: TFormDialogMsg
  Left = 363
  Top = 277
  Width = 542
  Height = 338
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Caption = 'Dialog msg'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 49
    Height = 235
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 6
      Top = 2
      Width = 29
      Height = 13
      Caption = 'Text :'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 276
    Width = 534
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object RxSpeedButton2: TSpeedButton
      Left = 47
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object Panel5: TPanel
      Left = 358
      Top = 0
      Width = 176
      Height = 35
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = BitBtn1Click
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 534
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 7
      Top = 10
      Width = 34
      Height = 13
      Caption = 'Name :'
    end
    object EditName: TEdit
      Left = 49
      Top = 8
      Width = 331
      Height = 21
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 522
    Top = 41
    Width = 12
    Height = 235
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
  end
  object MemoText: TRichEdit
    Left = 49
    Top = 41
    Width = 473
    Height = 235
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnChange = MemoTextChange
  end
end
