object frmMoreOption: TfrmMoreOption
  Left = 190
  Top = 114
  BorderStyle = bsDialog
  Caption = '�߼�����'
  ClientHeight = 338
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '����'
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
    Caption = '���ܴ��䣨��ֹISP�������߰�ȫ�������ݴ��䣩'
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 162
      Height = 12
      Caption = 'BTЭ����ܣ���ֹISP��������'
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 84
      Height = 12
      Caption = '���ݴ�����ܣ�'
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
      Text = '���������'
      Items.Strings = (
        '���������'
        '�����Լ��ܣ�������ͨ���ӣ�������������ӣ�'
        '�������ܣ�����������ӣ���������ͨ���ӣ�'
        'ǿ�Ƽ��ܣ���֧�ּ������ӣ���������ͨ���ӣ�')
    end
    object cbbEncryptLeve: TComboBox
      Left = 192
      Top = 56
      Width = 281
      Height = 20
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 1
      Text = '��ʹ�ü���'
      Items.Strings = (
        '��Э�����'
        '�����ݼ���'
        '��������Э����ܣ������ܶԷ����ݼ���'
        'Э������ݾ�����')
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 128
    Width = 513
    Height = 153
    Caption = '��������'
    TabOrder = 1
    object Label3: TLabel
      Left = 24
      Top = 32
      Width = 96
      Height = 12
      Caption = '������������ͣ�'
    end
    object Label4: TLabel
      Left = 24
      Top = 60
      Width = 60
      Height = 12
      Caption = '������IP��'
    end
    object Label5: TLabel
      Left = 264
      Top = 60
      Width = 36
      Height = 12
      Caption = '�˿ڣ�'
    end
    object Label6: TLabel
      Left = 24
      Top = 88
      Width = 48
      Height = 12
      Caption = '�û�����'
    end
    object Label7: TLabel
      Left = 264
      Top = 88
      Width = 36
      Height = 12
      Caption = '���룺'
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
      Text = '��ʹ�ô���'
      Items.Strings = (
        '��ʹ�ô���'
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
      Caption = '��ȫ������Ӧ�ô������ã���ʾ����Ϊ�򵥣�Ĭ��ͳһ����'
      Enabled = False
      TabOrder = 5
    end
  end
  object btnOK: TButton
    Left = 144
    Top = 296
    Width = 75
    Height = 25
    Caption = 'ȷ��'
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 304
    Top = 296
    Width = 75
    Height = 25
    Caption = 'ȡ��'
    ModalResult = 2
    TabOrder = 3
  end
end
