object FormStateLink: TFormStateLink
  Left = 177
  Top = 285
  Width = 1000
  Height = 119
  Caption = 'State if'
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 400
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
  object Panel2: TPanel
    Left = 0
    Top = 59
    Width = 992
    Height = 33
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object RxSpeedButton2: TSpeedButton
      Left = 88
      Top = 4
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object Label2: TLabel
      Left = 2
      Top = 9
      Width = 41
      Height = 13
      Caption = 'Priority :'
    end
    object Panel3: TPanel
      Left = 815
      Top = 0
      Width = 177
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 4
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = BitBtn1Click
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 4
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
    object EditPriority: TEdit
      Left = 41
      Top = 6
      Width = 32
      Height = 21
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 73
    Height = 59
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 59
      Height = 13
      Caption = 'Expression :'
    end
  end
  object Panel4: TPanel
    Left = 985
    Top = 0
    Width = 7
    Height = 59
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel5: TPanel
    Left = 73
    Top = 0
    Width = 912
    Height = 59
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 912
      Height = 9
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object Panel7: TPanel
      Left = 0
      Top = 50
      Width = 912
      Height = 9
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
    end
    object EditExpr: TRichEdit
      Left = 0
      Top = 9
      Width = 912
      Height = 41
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
