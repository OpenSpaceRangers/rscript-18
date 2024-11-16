object FormExprInsert: TFormExprInsert
  Left = 307
  Top = 305
  BorderStyle = bsDialog
  Caption = 'insert'
  ClientHeight = 601
  ClientWidth = 881
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
  object BitBtn1: TBitBtn
    Left = 720
    Top = 570
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
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
    Left = 800
    Top = 570
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 865
    Height = 553
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Function'
      object StringGridFun: TStringGrid
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ParentFont = False
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
        ColWidths = (
          67
          344
          506)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Star'
      ImageIndex = 1
      object ListBoxStar: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Planet'
      ImageIndex = 2
      object ListBoxPlanet: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Place'
      ImageIndex = 3
      object ListBoxPlace: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Item'
      ImageIndex = 4
      object ListBoxItem: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Group'
      ImageIndex = 5
      object ListBoxGroup: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Variable'
      ImageIndex = 6
      object ListBoxVar: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'Dialog'
      ImageIndex = 7
      object ListBoxDialog: TListBox
        Left = 0
        Top = 0
        Width = 857
        Height = 525
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
  end
end
