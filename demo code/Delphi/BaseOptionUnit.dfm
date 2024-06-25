object frmBaseOption: TfrmBaseOption
  Left = 384
  Top = 235
  Width = 392
  Height = 354
  Caption = #22522#26412#37197#32622
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 108
    Height = 12
    Caption = #24635#20307#19979#36733#36895#24230#38480#21046#65306
  end
  object Label2: TLabel
    Left = 272
    Top = 24
    Width = 24
    Height = 12
    Caption = 'KB/s'
  end
  object Label3: TLabel
    Left = 32
    Top = 56
    Width = 108
    Height = 12
    Caption = #24635#20307#19978#20256#36895#24230#38480#21046#65306
  end
  object Label4: TLabel
    Left = 272
    Top = 56
    Width = 24
    Height = 12
    Caption = 'KB/s'
  end
  object Label5: TLabel
    Left = 32
    Top = 88
    Width = 126
    Height = 12
    Caption = #25253#21578#32473'Tracker'#30340#22320#22336#65306
  end
  object Label6: TLabel
    Left = 32
    Top = 168
    Width = 84
    Height = 12
    Caption = #26368#22823#30913#30424#32531#23384#65306
  end
  object Label7: TLabel
    Left = 32
    Top = 192
    Width = 288
    Height = 12
    Caption = #30446#21069#26242#26102#21482#26377#21830#19994#29256#25552#20379#65292#20854#20182#29256#26412#20351#29992#31995#32479#40664#35748#32531#23384
  end
  object Label8: TLabel
    Left = 216
    Top = 216
    Width = 108
    Height = 12
    Caption = #26242#26102#21482#26377#21830#19994#29256#25552#20379
  end
  object edtDownLimit: TEdit
    Left = 168
    Top = 20
    Width = 89
    Height = 20
    TabOrder = 0
    Text = '-1'
  end
  object edtUploadLimit: TEdit
    Left = 168
    Top = 52
    Width = 89
    Height = 20
    TabOrder = 1
    Text = '-1'
  end
  object edtReportIp: TEdit
    Left = 168
    Top = 80
    Width = 153
    Height = 20
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 32
    Top = 104
    Width = 321
    Height = 49
    Color = clBtnFace
    Enabled = False
    Lines.Strings = (
      #22914#26426#22120#22312#20869#32593#65292#25253#21578#32473'tracker'#30340#26159#26412#26426#20869#32593'ip'#65292#21035#20154#26080#27861
      #30452#25509#36830#25509#65292#26368#22909#35774#32622#36335#24452#30001#30340#22806#32593'IP'#22320#22336#65292#30041#31354#40664#35748#20351#29992#26412
      #26426'IP'#65292#19978#20256#30340#26381#21153#22120#23588#20026#38656#35201#27880#24847#27491#30830#35774#32622)
    TabOrder = 3
  end
  object edtDiskCache: TEdit
    Left = 128
    Top = 164
    Width = 89
    Height = 20
    Color = clBtnFace
    Enabled = False
    TabOrder = 4
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 216
    Width = 177
    Height = 17
    Caption = #21551#29992#19987#19994#19978#20256#26381#21153#22120#27169#24335
    Enabled = False
    TabOrder = 5
  end
  object chkDHT: TCheckBox
    Left = 32
    Top = 240
    Width = 73
    Height = 17
    Caption = #21551#29992'DHT'
    TabOrder = 6
  end
  object chkFirewall: TCheckBox
    Left = 120
    Top = 240
    Width = 129
    Height = 17
    Caption = #21551#29992#31995#32479#38450#28779#22681#31359#36879
    TabOrder = 7
  end
  object chkUpnp: TCheckBox
    Left = 264
    Top = 240
    Width = 97
    Height = 17
    Caption = #21551#29992'UPNP'#31359#36879
    TabOrder = 8
  end
  object btnOK: TButton
    Left = 88
    Top = 280
    Width = 75
    Height = 25
    Caption = #30830#23450
    ModalResult = 1
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 208
    Top = 280
    Width = 75
    Height = 25
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 10
  end
end
