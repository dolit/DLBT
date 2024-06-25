object frmDLBTDemoMain: TfrmDLBTDemoMain
  Left = 211
  Top = 131
  Width = 731
  Height = 457
  Caption = #28857#37327'BT'#30340#20869#26680#28436#31034#31243#24207'(DELPHI'#29256')'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button2: TButton
    Left = 392
    Top = 336
    Width = 185
    Height = 25
    Caption = 'Button2'
    TabOrder = 0
    Visible = False
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 248
    Width = 705
    Height = 97
    TabOrder = 1
  end
  object Button1: TButton
    Left = 136
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    Visible = False
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 208
    Top = 336
    Width = 185
    Height = 25
    Caption = #19979#36733
    TabOrder = 3
    Visible = False
    OnClick = Button3Click
  end
  object ZTlistview: TListView
    Left = 8
    Top = 8
    Width = 705
    Height = 233
    Columns = <
      item
        Caption = #25991#20214#21517
        Width = 200
      end
      item
        Caption = #29366#24577
      end
      item
        Caption = #22823#23567
        Width = 100
      end
      item
        Caption = #24050#19979#36733
      end
      item
        Caption = #19979#36733#36895#24230
        Width = 60
      end
      item
        Caption = #19978#20256#36895#24230
        Width = 60
      end
      item
        Caption = #21097#20313#26102#38388
        Width = 60
      end>
    TabOrder = 4
    ViewStyle = vsReport
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 728
    Top = 512
  end
  object MainMenu1: TMainMenu
    Left = 232
    Top = 24
    object N1: TMenuItem
      Caption = #25991#20214
      object BT1: TMenuItem
        Caption = #25171#24320'BT'#31181#23376
        OnClick = BT1Click
      end
      object N4: TMenuItem
        Caption = #36864#20986
      end
    end
    object N2: TMenuItem
      Caption = #37197#32622
    end
    object N3: TMenuItem
      Caption = #24110#21161
      object BT2: TMenuItem
        Caption = #20851#20110#28857#37327'BT'#20869#26680
        OnClick = BT2Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'BT'#31181#23376#25991#20214'(*.torrent)|*.torrent'
    InitialDir = '.'
    Left = 480
    Top = 48
  end
end
