object frmMakeTorrent: TfrmMakeTorrent
  Left = 345
  Top = 52
  BorderStyle = bsSingle
  Caption = #21046#20316#31181#23376
  ClientHeight = 581
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 493
    Height = 385
    Caption = #24120#35268#21046#20316
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 50
      Width = 84
      Height = 12
      Caption = #25991#20214#25110#25991#20214#22841#65306
    end
    object Label2: TLabel
      Left = 16
      Top = 82
      Width = 84
      Height = 12
      Caption = #21487#36873'http'#36335#24452#65306
    end
    object Label3: TLabel
      Left = 16
      Top = 106
      Width = 396
      Height = 24
      Caption = #28857#37327'BT'#25903#25345'http'#36335#24452#19979#36733#65292#38450#22791#27809#26377#31181#23376#26102#21487#20197#20174'http'#19979#36733#65292#22810#20010'http'#22320#22336#13#10#20351#29992' | '#38388#38548
    end
    object Label4: TLabel
      Left = 16
      Top = 146
      Width = 60
      Height = 12
      Caption = #20998#22359#22823#23567#65306
    end
    object Label5: TLabel
      Left = 216
      Top = 141
      Width = 6
      Height = 12
      Caption = 'K'
    end
    object Label6: TLabel
      Left = 16
      Top = 184
      Width = 102
      Height = 12
      Caption = 'Track'#26381#21153#22120#21015#34920#65306
    end
    object Label7: TLabel
      Left = 16
      Top = 328
      Width = 449
      Height = 12
      AutoSize = False
      Caption = #27599#34892#19968#20010#26381#21153#22120#65292#20855#26377#30456#21516#30340#31561#25928'Tracker'#26381#21153#22120#65292#35831#20351#29992' | '#38388#38548
    end
    object Label8: TLabel
      Left = 16
      Top = 352
      Width = 96
      Height = 12
      Caption = #29983#25104#30340#31181#23376#25991#20214#65306
    end
    object rbFile: TRadioButton
      Left = 24
      Top = 19
      Width = 113
      Height = 17
      Caption = #21333#20010#25991#20214
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbFolder: TRadioButton
      Left = 192
      Top = 19
      Width = 113
      Height = 17
      Caption = #25972#20010#30446#24405
      TabOrder = 1
    end
    object edtFilePath: TEdit
      Left = 104
      Top = 46
      Width = 265
      Height = 20
      TabOrder = 2
    end
    object Button3: TButton
      Left = 376
      Top = 44
      Width = 57
      Height = 25
      Caption = #27983#35272
      TabOrder = 3
      OnClick = Button3Click
    end
    object edtHttpUrl: TEdit
      Left = 104
      Top = 78
      Width = 265
      Height = 20
      TabOrder = 4
    end
    object edtPieceSize: TEdit
      Left = 88
      Top = 137
      Width = 121
      Height = 20
      TabOrder = 5
      Text = '256'
    end
    object cbbDHT: TComboBox
      Left = 120
      Top = 176
      Width = 313
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 6
      Text = #21152#20837#20844#20849'DHT'#32593#32476'('#25512#33616')'
      Items.Strings = (
        #21152#20837#20844#20849'DHT'#32593#32476'('#25512#33616')'
        #19981#20351#29992#20844#20849'DHT'#32593#32476#33410#28857
        #20165#20351#29992'Tracker'#26381#21153#22120#65292#31105#27490#21152#20837'DHT'#32593#32476#21644#29992#25143#20132#25442#26469#28304)
    end
    object edtTorrent: TEdit
      Left = 112
      Top = 348
      Width = 273
      Height = 20
      TabOrder = 7
    end
    object Button4: TButton
      Left = 392
      Top = 346
      Width = 57
      Height = 25
      Caption = #27983#35272
      TabOrder = 8
      OnClick = Button4Click
    end
    object mmoTrack: TMemo
      Left = 16
      Top = 208
      Width = 369
      Height = 105
      TabOrder = 9
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 400
    Width = 493
    Height = 137
    Caption = #21457#24067#32773
    TabOrder = 1
    object Label9: TLabel
      Left = 24
      Top = 24
      Width = 48
      Height = 12
      Caption = #21457#24067#32773#65306
    end
    object Label10: TLabel
      Left = 24
      Top = 48
      Width = 36
      Height = 12
      Caption = #32593#22336#65306
    end
    object Label11: TLabel
      Left = 24
      Top = 72
      Width = 36
      Height = 12
      Caption = #22791#27880#65306
    end
    object edtCreator: TEdit
      Left = 80
      Top = 20
      Width = 273
      Height = 20
      Color = clBtnFace
      Enabled = False
      TabOrder = 0
      Text = #28857#37327'BT (DLBT) - '#20570#26368#19987#19994#30340'BT'#20869#26680'DLL'#24211
    end
    object edtCreatorUrl: TEdit
      Left = 80
      Top = 44
      Width = 273
      Height = 20
      Color = clBtnFace
      Enabled = False
      TabOrder = 1
      Text = 'http://hi.baidu.com/dlbtsoft/'
    end
    object edtCreatorMemo: TMemo
      Left = 80
      Top = 72
      Width = 273
      Height = 57
      TabOrder = 2
    end
  end
  object Button1: TButton
    Left = 296
    Top = 544
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 400
    Top = 544
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
  end
  object dlgOpenFile: TOpenDialog
    Left = 400
    Top = 96
  end
  object dlgSave: TSaveDialog
    Filter = #31181#23376#25991#20214'(*.torrent)|*.torrent'
    Left = 408
    Top = 344
  end
end
