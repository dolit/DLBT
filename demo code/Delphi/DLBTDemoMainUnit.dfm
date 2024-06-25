object frmDLBTDemoMain: TfrmDLBTDemoMain
  Left = 338
  Top = 166
  Width = 775
  Height = 572
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 759
    Height = 292
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object ZTlistview: TListView
      Left = 4
      Top = 4
      Width = 751
      Height = 284
      Align = alClient
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
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = ZTlistviewChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 292
    Width = 759
    Height = 222
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 4
      Top = 4
      Width = 751
      Height = 214
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #22522#26412#20449#24687
        object lvBase: TListView
          Left = 0
          Top = 0
          Width = 743
          Height = 186
          Align = alClient
          Columns = <
            item
              Caption = #21517#31216
              Width = 240
            end
            item
              Caption = #20449#24687
              Width = 400
            end>
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object TabSheet2: TTabSheet
        Caption = #36830#25509#24773#20917
        ImageIndex = 1
        object lvPeer: TListView
          Left = 0
          Top = 0
          Width = 751
          Height = 186
          Align = alClient
          Columns = <
            item
              Caption = 'IP'
              Width = 100
            end
            item
              Caption = #23458#25143#31471
              Width = 100
            end
            item
              Caption = #24050#19978#20256
              Width = 100
            end
            item
              Caption = #24050#19979#36733
              Width = 100
            end>
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object TabSheet3: TTabSheet
        Caption = #25991#20214#20449#24687
        ImageIndex = 2
        object lvFile: TListView
          Left = 0
          Top = 0
          Width = 751
          Height = 186
          Align = alClient
          Columns = <
            item
              Caption = #25991#20214#21517
              Width = 200
            end
            item
              Caption = #25991#20214#22823#23567
              Width = 100
            end
            item
              Caption = #36827#24230
              Width = 100
            end>
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
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
      object N5: TMenuItem
        Caption = #21046#20316#31181#23376
        OnClick = N5Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #36864#20986
      end
    end
    object N2: TMenuItem
      Caption = #37197#32622
      object mniBaseConfig: TMenuItem
        Caption = #22522#26412#37197#32622
        OnClick = mniBaseConfigClick
      end
      object mniMoreConfig: TMenuItem
        Caption = #39640#32423#37197#32622
        OnClick = mniMoreConfigClick
      end
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
  object TimerBTStatus: TTimer
    Interval = 5000
    OnTimer = TimerBTStatusTimer
    Left = 216
    Top = 120
  end
  object PopupMenu1: TPopupMenu
    Left = 288
    Top = 112
    object N7: TMenuItem
      Caption = #21024#38500#20219#21153
      OnClick = N7Click
    end
  end
end
