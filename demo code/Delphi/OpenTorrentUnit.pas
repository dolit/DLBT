unit OpenTorrentUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, FileCtrl;

type
  TfrmOpenTorrent = class(TForm)
    Label1: TLabel;
    edtTorrent: TEdit;
    Label2: TLabel;
    edtDownloadPath: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    btnOpenTorrent: TButton;
    btnDownloadPath: TButton;
    dlgOpen: TOpenDialog;
    procedure btnOpenTorrentClick(Sender: TObject);
    procedure btnDownloadPathClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOpenTorrent: TfrmOpenTorrent;

implementation

{$R *.dfm}

procedure TfrmOpenTorrent.btnOpenTorrentClick(Sender: TObject);
begin
  if not  dlgOpen.Execute then
    Exit;

  edtTorrent.Text := dlgOpen.FileName;
  edtDownloadPath.Text := ExtractFilePath(dlgOpen.FileName);
end;

procedure TfrmOpenTorrent.btnDownloadPathClick(Sender: TObject);
var
  Dir: string;
begin
  Dir := edtDownloadPath.Text;
  if not SelectDirectory('ѡ�񱣴�Ŀ¼', '', Dir) then
    Exit;

  edtDownloadPath.Text := Dir;
end;

end.
