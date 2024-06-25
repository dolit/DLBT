object frmMoreOption: TfrmMoreOption
  Left = 190
  Top = 114
  BorderStyle = bsDialog
  Caption = '高级设置'
  ClientHeight = 338
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '宋体'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 513
    Height = 97
    Caption = '加密传输（防止ISP封锁或者安全保密数据传输）'
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 162
      Height = 12
      Caption = 'BT协议加密（防止ISP封锁）：'
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 84
      Height = 12
      Caption = '数据传输加密：'
    end
    object cbbEncryptOption: TComboBox
      Left = 192
      Top = 24
      Width = 281
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 0
      Text = '不允许加密'
      Items.Strings = (
        '不允许加密'
        '兼容性加密（发起普通连接，但允许加密连接）'
        '完整加密（发起加密连接，但允许普通连接）'
        '强制加密（仅支持加密连接，不接受普通连接）')
    end
    object cbbEncryptLeve: TComboBox
      Left = 192
      Top = 56
      Width = 281
      Height = 20
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 1
      Text = '不使用加密'
      Items.Strings = (
        '仅协议加密'
        '仅数据加密'
        '主动进行协议加密，但接受对方数据加密'
        '协议和数据均加密')
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 128
    Width = 513
    Height = 153
    Caption = '代理设置'
    TabOrder = 1
    object Label3: TLabel
      Left = 24
      Top = 32
      Width = 96
      Height = 12
      Caption = '代理服务器类型：'
    end
    object Label4: TLabel
      Left = 24
      Top = 60
      Width = 60
      Height = 12
      Caption = '服务器IP：'
    end
    object Label5: TLabel
      Left = 264
      Top = 60
      Width = 36
      Height = 12
      Caption = '端口：'
    end
    object Label6: TLabel
      Left = 24
      Top = 88
      Width = 48
      Height = 12
      Caption = '用户名：'
    end
    object Label7: TLabel
      Left = 264
      Top = 88
      Width = 36
      Height = 12
      Caption = '密码：'
    end
    object cbbProxyType: TComboBox
      Left = 120
      Top = 28
      Width = 249
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 0
      Text = '不使用代理'
      Items.Strings = (
        '不使用代理'
        'Socks4'
        'Socks5'
        'Socks5a'
        'Http'
        'HttpA')
    end
    object edtProxyServer: TEdit
      Left = 120
      Top = 56
      Width = 121
      Height = 20
      TabOrder = 1
    end
    object edtProxyPort: TEdit
      Left = 320
      Top = 56
      Width = 89
      Height = 20
      TabOrder = 2
    end
    object edtProxyUser: TEdit
      Left = 120
      Top = 84
      Width = 121
      Height = 20
      TabOrder = 3
    end
    object edtProxyPass: TEdit
      Left = 320
      Top = 84
      Width = 89
      Height = 20
      TabOrder = 4
    end
    object CheckBox1: TCheckBox
      Left = 24
      Top = 112
      Width = 385
      Height = 17
      Caption = '对全部连接应用代理设置（演示程序为简单，默认统一处理）'
      Enabled = False
      TabOrder = 5
    end
  end
  object btnOK: TButton
    Left = 144
    Top = 296
    Width = 75
    Height = 25
    Caption = '确定'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 304
    Top = 296
    Width = 75
    Height = 25
    Caption = '取消'
    ModalResult = 2
    TabOrder = 3
  end
end
