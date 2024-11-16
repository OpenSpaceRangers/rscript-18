object FormDialog: TFormDialog
  Left = 350
  Top = 154
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 73
  ClientWidth = 361
  Color = clBtnFace
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
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object EditName: TEdit
    Left = 48
    Top = 8
    Width = 305
    Height = 21
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 200
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 280
    Top = 40
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
