unit MoreOptionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMoreOption = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbbEncryptOption: TComboBox;
    Label2: TLabel;
    cbbEncryptLeve: TComboBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    cbbProxyType: TComboBox;
    Label4: TLabel;
    edtProxyServer: TEdit;
    Label5: TLabel;
    edtProxyPort: TEdit;
    Label6: TLabel;
    edtProxyUser: TEdit;
    Label7: TLabel;
    edtProxyPass: TEdit;
    CheckBox1: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMoreOption: TfrmMoreOption;

implementation

{$R *.dfm}

end.
