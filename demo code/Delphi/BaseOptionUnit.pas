unit BaseOptionUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles;

type
  TfrmBaseOption = class(TForm)
    Label1: TLabel;
    edtDownLimit: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtUploadLimit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtReportIp: TEdit;
    Memo1: TMemo;
    Label6: TLabel;
    edtDiskCache: TEdit;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    Label8: TLabel;
    chkDHT: TCheckBox;
    chkFirewall: TCheckBox;
    chkUpnp: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseOption: TfrmBaseOption;

implementation

uses DLBTDemoMainUnit;

{$R *.dfm}

procedure TfrmBaseOption.btnOKClick(Sender: TObject);
begin
//  with TInifile.Create(ExtractFilePath(Config)) do
//  begin
//    WriteInteger('BaseOption', 'DownloadLimit', StrToIntDef(edtDownLimit.Text, 0));
//    WriteInteger('BaseOption', 'UploadLimit', StrToIntDef(edtUploadLimit.Text, 0));
//    WriteString('BaseOption', 'ReportIp', edtReportIp.Text);
//    WriteBool('BaseOption', 'DHT', chkDHT.Checked);
//  end;
end;

end.
