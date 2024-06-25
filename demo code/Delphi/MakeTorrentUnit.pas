unit MakeTorrentUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  FileCtrl;

type
  TfrmMakeTorrent = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    rbFile: TRadioButton;
    rbFolder: TRadioButton;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    edtFilePath: TEdit;
    Button3: TButton;
    Label2: TLabel;
    edtHttpUrl: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtPieceSize: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    cbbDHT: TComboBox;
    edtCreator: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtTorrent: TEdit;
    Button4: TButton;
    Label9: TLabel;
    Label10: TLabel;
    edtCreatorUrl: TEdit;
    Label11: TLabel;
    edtCreatorMemo: TMemo;
    dlgOpenFile: TOpenDialog;
    dlgSave: TSaveDialog;
    mmoTrack: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMakeTorrent: TfrmMakeTorrent;

implementation

uses MakeTorrentProgressUnit;

{$R *.dfm}

procedure TfrmMakeTorrent.Button3Click(Sender: TObject);
var
  FilePath: string;
begin
  if rbFile.Checked then
  begin
    if not dlgOpenFile.Execute then
      Exit;
    FilePath := dlgOpenFile.FileName;
//    edtTorrent.Text := ChangeFileExt(dlgOpenFile.FileName, '.torrent');
  end
  else if rbFolder.Checked then
  begin
    if not SelectDirectory('选择目录', '', FilePath) then
      Exit;
  end;

  edtFilePath.Text := FilePath;
  edtTorrent.Text := ChangeFileExt(FilePath, '.torrent');
end;

procedure TfrmMakeTorrent.Button4Click(Sender: TObject);
begin
  if not dlgSave.Execute then
    Exit;

  edtTorrent.Text := dlgSave.FileName;
end;

procedure TfrmMakeTorrent.Button1Click(Sender: TObject);
begin
  with TfrmMakeTorrentProgress.Create(Application) do
  try
    FFilePath := edtFilePath.Text;
    FHttpUrl := edtHttpUrl.Text;
    FPieceSize := StrToIntDef(edtPieceSize.Text, 256) * 1024;
    FDHT := cbbDHT.ItemIndex;
    FTracker := mmoTrack.Lines.CommaText;
    FTorrent := edtTorrent.Text;
    FCreator := edtCreator.Text;
    FCreatorUrl := edtCreatorUrl.Text;
    FCreatorMemo := edtCreatorMemo.Lines.Text;
    ShowModal;
//    DoTorrent;
  finally
    Free;
  end;

  ShowMessage('制作种子成功');
  Close;
end;

end.
