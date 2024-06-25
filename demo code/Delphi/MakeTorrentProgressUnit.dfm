object frmMakeTorrentProgress: TfrmMakeTorrentProgress
  Left = 329
  Top = 247
  Width = 371
  Height = 121
  Caption = #29983#25104#31181#23376
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pbView: TProgressBar
    Left = 16
    Top = 16
    Width = 329
    Height = 25
    Smooth = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 136
    Top = 56
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = Button1Click
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 16
    Top = 64
  end
end
