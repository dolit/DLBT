object frmOpenTorrent: TfrmOpenTorrent
  Left = 291
  Top = 263
  Width = 473
  Height = 217
  Caption = #25171#24320#31181#23376
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
  object Label1: TLabel
    Left = 8
    Top = 32
    Width = 60
    Height = 12
    Caption = #31181#23376#20301#32622#65306
  end
  object Label2: TLabel
    Left = 16
    Top = 96
    Width = 48
    Height = 12
    Caption = #19979#36733#21040#65306
  end
  object edtTorrent: TEdit
    Left = 64
    Top = 28
    Width = 297
    Height = 20
    TabOrder = 0
  end
  object edtDownloadPath: TEdit
    Left = 64
    Top = 92
    Width = 297
    Height = 20
    TabOrder = 1
  end
  object btnOK: TBitBtn
    Left = 112
    Top = 136
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TBitBtn
    Left = 248
    Top = 136
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 3
  end
  object btnOpenTorrent: TButton
    Left = 360
    Top = 26
    Width = 75
    Height = 25
    Caption = #27983#35272
    TabOrder = 4
    OnClick = btnOpenTorrentClick
  end
  object btnDownloadPath: TButton
    Left = 360
    Top = 90
    Width = 75
    Height = 25
    Caption = #27983#35272
    TabOrder = 5
    OnClick = btnDownloadPathClick
  end
  object dlgOpen: TOpenDialog
    Filter = #31181#23376#25991#20214'(*.torrent)|*.torrent'
    Left = 328
    Top = 8
  end
end
