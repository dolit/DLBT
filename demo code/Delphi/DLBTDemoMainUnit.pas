unit DLBTDemoMainUnit;

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
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    BT1: TMenuItem;
    N4: TMenuItem;
    OpenDialog1: TOpenDialog;
    BT2: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Panel1: TPanel;
    ZTlistview: TListView;
    TimerBTStatus: TTimer;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    lvBase: TListView;
    lvPeer: TListView;
    lvFile: TListView;
    mniBaseConfig: TMenuItem;
    mniMoreConfig: TMenuItem;
    PopupMenu1: TPopupMenu;
    N7: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BT1Click(Sender: TObject);
    procedure BT2Click(Sender: TObject);
    procedure TimerBTStatusTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ZTlistviewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure mniBaseConfigClick(Sender: TObject);
    procedure mniMoreConfigClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddTask(ATorrentFile, ASavePath: string);
    procedure DelTask(APTR: PTaskRec);
    procedure ReleaseTask;
    procedure LoadTask;
  public
    { Public declarations }
  end;

var
  frmDLBTDemoMain: TfrmDLBTDemoMain;
  dlbthandle : hwnd =0;

  BTDownloadStates: array[0..7] of string = ('初始化', '校验文件', '连接Track', '下载中', '暂停', '下载完成', '已至最新', '分配空间');

const
  Config = 'config.dat';

implementation

uses OpenTorrentUnit, MakeTorrentUnit, BaseOptionUnit, MoreOptionUnit;

{$R *.dfm}

procedure TfrmDLBTDemoMain.Button2Click(Sender: TObject);
begin
  if dlbthandle <> 0 then
    begin
      //DLBT_Downloader_Release(dlbthandle, false);
      //sleep(500);
      DLBT_DHT_Stop;
      DLBT_PreShutdown;
//      timer1.Enabled := false;

    end;
end;

procedure TfrmDLBTDemoMain.FormCreate(Sender: TObject);
var
  PExeName: PWideChar;
  ExeName: string;
  Len: Integer;
  startInfo:DLBT_KERNEL_START_PARAM;
begin
//  if DLBT_Startup then
//    memo1.Lines.Add('点量BT内核启动成功!')
//  else
//    memo1.Lines.Add('点量BT内核初始化失败!');
  ExeName := ParamStr(0);
  Len := Length(ExeName) + 1;
  PExeName := AllocMem(Len * SizeOf(WideChar));
  try
    StringToWideChar(ExeName, PExeName, Len);
    DLBT_AddAppToWindowsXPFirewall(PExeName, 'DLBT');
  finally
    FreeMem(PExeName);
  end;


  startInfo.bStartLocalDiscovery := True;
  startInfo.bStartUPnP := True;
  startInfo.bStartDHT := True;
  startInfo.bLanUser  := False;
  startInfo.bVODMode  := False;
  startInfo.startPort := 9010;   // 尝试绑定9010端口，如果9010端口未被占用，则使用。否则，继续尝试下一个端口，直到endPort指定的范围。
  startInfo.endPort := 9020;
  DLBT_Startup(@startInfo, nil, False);
  DLBT_DHT_Start(0);
  DLBT_SetEncryptSetting(DLBT_ENCRYPT_FULL, DLBT_ENCRYPT_ALL);
  LoadTask;

  lvBase.DoubleBuffered := True;
  lvPeer.DoubleBuffered := True;
  lvFile.DoubleBuffered := True;
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
//  z_state := DLBT_Downloader_GetState(dlbthandle);
//  case z_state of
//    BTDS_QUEUED: memo1.Lines.Add('已添加任务');
//    BTDS_CHECKING_FILES: memo1.Lines.Add('正在检查校验文件');
//    BTDS_CONNECTING_TRACKER: memo1.Lines.Add('连接Tracker');
//    BTDS_DOWNLOADING: memo1.Lines.Add('正在下载中');
//    BTDS_FINISHED: memo1.Lines.Add('下载完成');
//    BTDS_SEEDING: memo1.Lines.Add('供种中');
//    BTDS_ALLOCATING: memo1.Lines.Add('正在预分配磁盘空间');
//  end;
//  memo1.Lines.Add('已下载: '+ inttostr(
//  DLBT_Downloader_GetProgress(dlbthandle)) + '%');
//  memo1.Lines.Add('下载速度: '+ inttostr(
//  DLBT_Downloader_GetDownloadSpeed(dlbthandle)));
end;

procedure TfrmDLBTDemoMain.BT1Click(Sender: TObject);
begin
  with TfrmOpenTorrent.Create(Application) do
  try
    if ShowModal <> mrOk then
      Exit;
      
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
  with TForm2.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;

end;

procedure TfrmDLBTDemoMain.AddTask(ATorrentFile, ASavePath: string);
var
  PTR: PTaskRec;
  Len: Integer;
  PWTorrent, PWOutpath: PWideChar;
  li: TListItem;
  i: Integer;
  torrentName: PWideChar;
  hr: HRESULT;
  pBufferSize: int;
  athandle: HWND;
  icount:int;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + Config) do
  try
//    th := DLBT_OpenTorrent(ATorrent);
    New(PTR);
    Len := Length(ATorrentFile) + 1;
    PWTorrent := AllocMem(Len * SizeOf(WideChar));
    StringToWideChar(ATorrentFile, PWTorrent, Len);
    Len := Length(ASavePath) + 1;
    PWOutpath := AllocMem(Len * SizeOf(WideChar));
    StringToWideChar(ASavePath, PWOutpath, Len);

     athandle := DLBT_OpenTorrent(PWTorrent,nil);
    //获取文件数
    icount := DLBT_Torrent_GetFileCount(athandle);
    if icount > 0 then
    begin
    
    end;
    DLBT_ReleaseTorrent(athandle);


    PTR^.BTHandle := DLBT_Downloader_Initialize(PWTorrent,
                                               PWOutpath,
                                               nil,
                                               FILE_ALLOCATE_SPARSE);
   
    // 设置对一个P2SP网址最多可以有10个连接（默认是1个）--如果有P2SP网址时有效，否则会自动忽略
    // DLBT_Downloader_SetMaxSessionPerHttp(PTR^.BTHandle, 10);

    torrentName := AllocMem((MAX_PATH + 1)* SizeOf(WideChar));
    pBufferSize := MAX_PATH;
    hr := DLBT_Downloader_GetTorrentName(PTR^.BTHandle, torrentName, @pBufferSize);
    PTR^.TaskName := WideCharToString(torrentName);
    PTR^.Torrent := ATorrentFile;
    PTR^.SavePath := ASavePath;
    li := ZTlistview.Items.Add;
    li.Caption := PTR^.TaskName;
    li.Data := PTR;
    for i := 0 to 5 do
      li.SubItems.Add('');
    FreeMem(PWTorrent);
    FreeMem(PWOutpath);

    WriteString(PTR^.TaskName, 'Torrent', PTR^.Torrent);
    WriteString(PTR^.TaskName, 'SavePath', PTR^.SavePath);
  finally
    Free;
  end;


end;

procedure TfrmDLBTDemoMain.TimerBTStatusTimer(Sender: TObject);
var
  i, len, fc: Integer;
  fs : UInt64;
  PTR: PTaskRec;
  dinfo: DOWNLOADER_INFO;
  kinfo: KERNEL_INFO;
  HashInfo: array[0..39] of Char;
  bDHT: Boolean;

  pinfo: PPEER_INFO;
  PeerIp, PeerClient: string;
  PFileName: PWideChar;
begin

  TimerBTStatus.Enabled := False;


//  lvBase.Items.BeginUpdate;
  try
  for i := 0 to ZTlistview.Items.Count - 1 do
  begin
    PTR := ZTlistview.Items[i].Data;
    if (PTR = nil) or (PTR^.BTHandle = 0) then
      Continue;

    ZeroMemory(@dinfo, SizeOf(dinfo));
    DLBT_GetDownloaderInfo(PTR^.BTHandle, @dinfo);
    ZTlistview.Items[i].SubItems[0] := BTDownloadStates[Integer(dinfo.state)];
    ZTlistview.Items[i].SubItems[1] := Format('%.2fM', [dinfo.totalFileSize / 1024 / 1024]);
    ZTlistview.Items[i].SubItems[2] := Format('%.2fM', [dinfo.totalDownloadedBytes / 1024 / 1024]);
    ZTlistview.Items[i].SubItems[3] := Format('%.2fK/S', [dinfo.downloadSpeed / 1024]);
    ZTlistview.Items[i].SubItems[4] := Format('%.2fK/S', [dinfo.uploadSpeed / 1024]);
    if dinfo.downloadSpeed > 0 then
      ZTlistview.Items[i].SubItems[5] := Format('%d分钟', [Trunc((dinfo.totalFileSize - dinfo.totalDownloadedBytes) / dinfo.downloadSpeed / 60)])
    else
      ZTlistview.Items[i].SubItems[5] := '--';

    len := SizeOf(HashInfo);
    DLBT_Downloader_GetInfoHash(PTR^.BTHandle, @HashInfo, @len);




  end;

  if ZTlistview.Selected = nil then
    Exit;
  PTR := ZTlistview.Selected.Data;
  if (PTR = nil) or (PTR^.BTHandle = 0) then
    Exit;

//  DLBT_Downloader_GetPieceCount()
//  if (PTR <> nil) and (PTR^.BTHandle > 0) then
//  begin
  LockWindowUpdate(lvBase.Handle);
  lvBase.Clear;
  lvBase.Items.BeginUpdate;
  ZeroMemory(@dinfo, SizeOf(dinfo));

  DLBT_GetDownloaderInfo(PTR^.BTHandle, @dinfo);
  with lvBase.Items.Add do
  begin
    Caption := 'HashInfo';
    SubItems.Add( dinfo.infoHash );
  end;

  with lvBase.Items.Add do
  begin
    Caption := '文件分块信息';
    SubItems.Add( Format('%d x %d KB', [dinfo.pieceCount, dinfo.pieceSize div 1024]));
  end;

  with lvBase.Items.Add do
  begin
    Caption := '上传情况';
    SubItems.Add( Format('速度：[%d B/s], 共上传：[%d B], 分享率：[%d]',
                         [dinfo.uploadSpeed, dinfo.totalUploadedBytes, 0]) );
  end;

  with lvBase.Items.Add do
  begin
    Caption := '种子和普通用户情况';
    SubItems.Add( Format('总数：%d, 种子：%d, 连接上：%d 用户, 连接上 %d 种子; 当前连接 [%d] 种子,当前连接 [%d] 用户',
                         [dinfo.connectionCount, dinfo.totalCompletedSeeds,
                          dinfo.downConnectionCount, dinfo.seedConnected,
                          dinfo.totalCurrentSeedCount, dinfo.totalCurrentPeerCount]) );

  end;

//  with lvBase.Items.Add do
//  begin
//    Caption := 
//  end;
//  end;
  lvBase.Items.Add.Caption := '内核情况如下：';
  ZeroMemory(@kinfo, SizeOf(kinfo));
  DLBT_GetKernelInfo(@kinfo);
  bDHT := kinfo.dhtStarted;
  with lvBase.Items.Add do
  begin
    Caption := 'DHT';
    if bDHT then
      SubItems.Add('已启动')
    else SubItems.Add('未启动');
  end;
  with lvBase.Items.Add do
  begin
    Caption := '端口';
    SubItems.Add( Format('%d', [kinfo.port]) );
  end;
  with lvBase.Items.Add do
  begin
    Caption := '总下载字节数';
    SubItems.Add( Format('%d', [kinfo.totalDownloadedByteCount]));
  end;
  with lvBase.Items.Add do
  begin
    caption := '总上传字节数';
    SubItems.Add( Format('%d', [kinfo.totalUploadedByteCount]) );
  end;
  with lvBase.Items.Add do
  begin
    Caption := '总下载速度';
    SubItems.Add( Format('%d', [kinfo.totalDownloadSpeed]) );
  end;
  with lvBase.items.Add do
  begin
    Caption := '总上传速度';
    SubItems.Add( Format('%d', [kinfo.totalUploadSpeed]) );
  end;
  lvBase.Items.EndUpdate;
  LockWindowUpdate(0);

  //连接Peer
  DLBT_GetDownloaderPeerInfoList(PTR^.BTHandle, @pinfo);
  try
    LockWindowUpdate(lvPeer.Handle);
    lvPeer.Clear;
    lvPeer.Items.BeginUpdate;
    if pinfo <> nil then
//          Exit;

    for i := 0 to pinfo.count - 1 do
    begin
      PeerIp := string(pinfo.entries[i].ip);
      PeerClient := string(pinfo.entries[i].client);
      with lvPeer.Items.Add do
      begin
        Caption := PeerIp;
        SubItems.Add(PeerClient);
        SubItems.Add(Format('%d B/S', [pinfo.entries[i].downloadSpeed]));
        SubItems.Add(Format('%d B/S', [pinfo.entries[i].uploadSpeed]));
      end;

//      strTemp := Format('IP:[%s], Client:[%s], D:[%.2fK/S], U[%.2fK/S], DBytes:[%.2fK], UBytes:[%.2fK]',
//                         [PeerIp, PeerClient,
//                          pinfo.entries[i].downloadSpeed / 1024, pinfo.entries[i].uploadSpeed / 1024,
//                          pinfo.entries[i].downloadedBytes / 1024, pinfo.entries[i].uploadedBytes / 1024]);
//      lbPeerInfo.items.Add(strTemp);
      
    end;
    lvPeer.Items.EndUpdate;
    LockWindowUpdate(0);
  finally
    if pinfo <> nil then
      DLBT_FreeDownloaderPeerInfoList(pinfo);
  end;

  //获取文件信息
  LockWindowUpdate(lvFile.Handle);
  lvFile.Clear;
  lvFile.Items.BeginUpdate;
  fc := DLBT_Downloader_GetFileCount(PTR^.BTHandle);
  for i := 0 to fc - 1 do
  begin
    PFileName := AllocMem((MAX_PATH + 1)* SizeOf(WideChar));
    fs := MAX_PATH;
    DLBT_Downloader_GetFilePathName(PTR^.BTHandle, i, PFileName, @fs);
    fs := DLBT_Downloader_GetFileSize(PTR^.BTHandle, i);
    with lvFile.Items.Add do
    begin
      Caption := PFileName;
      SubItems.Add(Format('%.2f M', [fs / 1024 / 1024]));
      SubItems.Add(Format('%.2f', [DLBT_Downloader_GetFileProgress(PTR^.BTHandle, i)]) + '%');
    end;
    FreeMem(PFileName);
  end;
  lvFile.Items.EndUpdate;
  LockWindowUpdate(0);

  finally
    TimerBTStatus.Enabled := True;
  end;
end;

procedure TfrmDLBTDemoMain.FormDestroy(Sender: TObject);
begin
  ReleaseTask;
  DLBT_Shutdown;
end;

procedure TfrmDLBTDemoMain.DelTask(APTR: PTaskRec);
begin
  if APTR^.BTHandle > 0 then
    DLBT_Downloader_Release(APTR^.BTHandle);
  APTR^.BTHandle := 0;

  
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + Config) do
  try
    EraseSection(APTR^.TaskName);
  finally
    Free;
  end;


end;

procedure TfrmDLBTDemoMain.ReleaseTask;
var
  i: Integer;
  PTR: PTaskRec;
begin
  for i := 0 to ZTlistview.Items.Count - 1 do
  begin
    PTR := ZTlistview.Items[i].Data;
    if (PTR = nil) or (PTR^.BTHandle = 0) then
      Continue;

    DLBT_Downloader_Release(PTR^.BTHandle);
    PTR^.BTHandle := 0;
  end;
end;

procedure TfrmDLBTDemoMain.LoadTask;
var
  SL: TStrings;
//  li: TListItem;
// PTR: PTaskRec;
  i: Integer;
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0)) + Config) do
  try
    SL := TStringList.Create;
    try
      ReadSections(SL);
      for i := 0 to SL.Count - 1 do
      begin
        AddTask(ReadString(SL[i], 'Torrent', ''), ReadString(SL[i], 'SavePath', ''));
//        New(PTR);
//        PTR^.TaskName := SL[i];
//        PTR^.Torrent := ;
//        PTR^.
      end;

    finally
      SL.Free;
    end;
  finally
    Free;
  end;

end;

procedure TfrmDLBTDemoMain.N5Click(Sender: TObject);
begin
  with TfrmMakeTorrent.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;

end;

procedure TfrmDLBTDemoMain.ZTlistviewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  PTR: PTaskRec;
begin
  PTR := Item.Data;
  if (PTR = nil) or (PTR^.BTHandle = 0) then
    Exit                         
end;

procedure TfrmDLBTDemoMain.mniBaseConfigClick(Sender: TObject);
var
  DownloadLimit, UploadLimit: Integer;
  DHT, Firewall, Upnp: Boolean;
  ReportIp: string;
begin
  with TfrmBaseOption.Create(Application) do
  try
    if ShowModal = mrOk then
    begin
//      with TIniFile.Create(ExtractFilePath(ParamStr(0)) + Config) do
//      try
        DownloadLimit := StrToIntDef(edtDownLimit.Text, 0); //ReadInteger('BaseOption', 'DownloadLimit', 0);
        UploadLimit := StrToIntDef(edtUploadLimit.Text, 0); // ReadInteger('BaseOption', 'UploadLimit', 0);
        DHT := chkDHT.Checked; // ReadBool('BaseOption', 'DHT', False);
        ReportIp := edtReportIp.Text; // ReadString('BaseOption', 'ReportIp', '');
        Firewall := chkFirewall.Checked;
        Upnp := chkUpnp.Checked;
//      finally
//        Free;
//      end;
    end;
  finally
    Free;
  end;

  DLBT_SetDownloadSpeedLimit(DownloadLimit * 1024);
  DLBT_SetUploadSpeedLimit(UploadLimit * 1024);
  if DHT then
    DLBT_DHT_Start(0);

  if Firewall then
    DLBT_AddAppToWindowsXPFirewall(PWideChar(ParamStr(0)), 'DLBT');

  if ReportIp <> '' then
    DLBT_SetReportIP(PChar(ReportIp));
end;

procedure TfrmDLBTDemoMain.mniMoreConfigClick(Sender: TObject);
var
  eoption: DLBT_ENCRYPT_OPTION;
  elevel: DLBT_ENCRYPT_LEVEL;
  proxytype: DLBT_PROXY_TYPE;
  proxyip, proxyuser, proxypass: string;
  proxyport: Integer;
  proxySetting:DLBT_PROXY_SETTING;
begin
  // 初始化
  ZeroMemory(@proxySetting, SizeOf(proxySetting));

  with TfrmMoreOption.Create(Application) do
  try
    if ShowModal = mrOk then
    begin
      eoption := DLBT_ENCRYPT_OPTION(cbbEncryptOption.ItemIndex);
      elevel := DLBT_ENCRYPT_LEVEL(cbbEncryptLeve.ItemIndex);
      proxytype := DLBT_PROXY_TYPE(cbbProxyType.ItemIndex);
      proxyip := edtProxyServer.Text;
      proxyport := StrToIntDef(edtProxyPort.Text, 0);
      proxyuser := edtProxyUser.Text;
      proxypass := edtProxyPass.Text;
    end;
  finally
    Free;
  end;

  if proxyip <> '' then
      begin
        Move(PAnsiChar(proxyip)^, proxySetting.proxyHost, Length(proxyip));
      end;
  if proxyuser <> '' then
  begin
    Move(PAnsiChar(proxyuser)^, proxySetting.proxyUser, Length(proxyuser));
  end;
  if proxypass <> '' then
  begin
    Move(PAnsiChar(proxypass)^, proxySetting.proxyPass, Length(proxypass));
  end;

  proxySetting.nPort := proxyport;
  proxySetting.proxyType := proxytype;

  DLBT_SetProxy(proxySetting, 15);  // 15 = (1 | 2 | 4 | 8)    DLBT_PROXY_TO_TRACKER or DLBT_PROXY_TO_DOWNLOAD ...

  //DLBT_SetEncryptSetting(DLBT_ENCRYPT_FULL, DLBT_ENCRYPT_ALL);

  DLBT_SetEncryptSetting(eoption, elevel);

end;

procedure TfrmDLBTDemoMain.N7Click(Sender: TObject);
var
  PTR: PTaskRec;
begin
  if ZTlistview.Selected = nil then
    Exit;

  PTR := ZTlistview.Selected.Data;
  DelTask(PTR);

  FreeMem(PTR);
  ZTlistview.DeleteSelected;
//  if PTR^.BTHandle > 0 then
//    DLBT_Downloader_Release(PTR^.BTHandle);

  
end;

end.
