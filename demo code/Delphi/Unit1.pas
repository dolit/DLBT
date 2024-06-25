unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  dlbt,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  Menus,
  unit2,
  IniFiles;

type
  PTaskRec = ^TTaskRec;
  TTaskRec = record
    TaskName: string;
    Torrent: string[255];
    SavePath: string[255];
    BTHandle: THandle;
  end;

  TfrmDLBTDemoMain = class(TForm)
    Button2: TButton;
    Memo1: TMemo;
    Button1: TButton;
    Button3: TButton;
    ZTlistview: TListView;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    BT1: TMenuItem;
    N4: TMenuItem;
    OpenDialog1: TOpenDialog;
    BT2: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BT1Click(Sender: TObject);
    procedure BT2Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddTask(ATorrentFile, ASavePath: string); 
  public
    { Public declarations }
  end;

var
  frmDLBTDemoMain: TfrmDLBTDemoMain;
  dlbthandle : hwnd =0;

const
  Config = 'config.dat';

implementation

uses OptnTorrentUnit;

{$R *.dfm}

procedure TfrmDLBTDemoMain.Button2Click(Sender: TObject);
begin
  if dlbthandle <> 0 then
    begin
      //DLBT_Downloader_Release(dlbthandle, false);
      //sleep(500);
      DLBT_DHT_Stop;
      DLBT_PreShutdown;
      timer1.Enabled := false;

    end;
end;

procedure TfrmDLBTDemoMain.FormCreate(Sender: TObject);
begin
//  if DLBT_Startup then
//    memo1.Lines.Add('点量BT内核启动成功!')
//  else
//    memo1.Lines.Add('点量BT内核初始化失败!');
  DLBT_Startup();
end;

procedure TfrmDLBTDemoMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DLBT_Shutdown;
end;

procedure TfrmDLBTDemoMain.Button1Click(Sender: TObject);
begin
  showmessage(inttostr(DLBT_GetListenPort));
  DLBT_DHT_Start(0);
end;

procedure TfrmDLBTDemoMain.Button3Click(Sender: TObject);
begin
//  dlbthandle := DLBT_Downloader_Initialize(pchar('c:\aaa.torrent'),
//  pchar('c:\abc'), pchar('c:\temp'), FILE_ALLOCATE_COMPACT,
//  false, false);
//  timer1.Enabled := true;
end;

procedure TfrmDLBTDemoMain.Timer1Timer(Sender: TObject);
var
  z_state: DLBT_DOWNLOAD_STATE;
begin
  z_state := DLBT_Downloader_GetState(dlbthandle);
  case z_state of
    BTDS_QUEUED: memo1.Lines.Add('已添加任务');
    BTDS_CHECKING_FILES: memo1.Lines.Add('正在检查校验文件');
    BTDS_CONNECTING_TRACKER: memo1.Lines.Add('连接Tracker');
    BTDS_DOWNLOADING: memo1.Lines.Add('正在下载中');
    BTDS_FINISHED: memo1.Lines.Add('下载完成');
    BTDS_SEEDING: memo1.Lines.Add('供种中');
    BTDS_ALLOCATING: memo1.Lines.Add('正在预分配磁盘空间');
  end;
  memo1.Lines.Add('已下载: '+ inttostr(
  DLBT_Downloader_GetProgress(dlbthandle)) + '%');
  memo1.Lines.Add('下载速度: '+ inttostr(
  DLBT_Downloader_GetDownloadSpeed(dlbthandle)));
end;

procedure TfrmDLBTDemoMain.BT1Click(Sender: TObject);
begin
//  if opendialog1.Execute then
//    begin
//      dlbthandle := DLBT_Downloader_Initialize(
//                    pchar(opendialog1.FileName),
//                    pchar('c:\'), pchar('c:\'), FILE_ALLOCATE_COMPACT,
//                    false, false);   
//
//      timer1.Enabled := true;
//    end;
  with TfrmOpenTorrent.Create(Application) do
  try
    if (edtTorrent.Text = '') or (not FileExists(edtTorrent.Text)) then
      Exit;

    if edtDownloadPath.Text = '' then
      Exit;

    AddTask(edtTorrent.Text, edtDownloadPath.Text);
  finally
    Free;
  end;

end;

procedure TfrmDLBTDemoMain.BT2Click(Sender: TObject);
begin
//  form2.ShowModal ;
end;

procedure TfrmDLBTDemoMain.AddTask(ATorrentFile, ASavePath: string);
var
  PTR: PTaskRec;
  th: THandle;
  Len: Integer;
  PWTorrent, PWOutpath, PWStatusFile: PWideChar;
  li: TListItem;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + Config) do
  try
//    th := DLBT_OpenTorrent(ATorrent);
    New(PTR);
    Len := Length(ATorrentFile) * SizeOf(WideChar) + 1;
    PWTorrent := AllocMem(Len);
    StringToWideChar(ATorrentFile, PWTorrent, Len);
    Len := Length(ASavePath) * SizeOf(WideChar) + 1;
    PWOutpath := AllocMem(Len);
    StringToWideChar(ASavePath, PWOutpath, Len);
    PTR^.BTHandle := DLBT_Downloader_Initialize(PWTorrent,
                                               PWOutpath,
                                               nil,
                                               FILE_ALLOCATE_SPARSE);

    PTR^.TaskName := DLBT_Downloader_GetTorrentName(PTR^.BTHandle);
    PTR^.Torrent := ATorrentFile;
    PTR^.SavePath := ASavePath;
    li := ZTlistview.Items.Add;
    li.Caption := PTR^.TaskName;
    li.Data := PTR;
    FreeMem(PWTorrent);
    FreeMem(PWOutpath);
  finally
    Free;
  end;


end;

end.
