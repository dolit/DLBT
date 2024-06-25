unit MakeTorrentProgressUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TMTThread = class(TThread)
  private
    FFilePath, FHttpUrl, FTracker, FTorrent, FCreator, FCreatorUrl, FCreatorMemo: string;
    FPieceSize, FDHT: Integer;
    FPos: PInteger;
    FCancel: PBOOL;
  protected
    procedure Execute; override;
  public
    constructor Create(AFilePath, AHttpUrl, ATracker, ATorrent, ACreator, ACreatorUrl, ACreatorMemo: string;
                       APieceSize, ADHT: Integer; APos: PInteger; ACancel: PBOOL);
    destructor Destroy; override;

  end;

  TfrmMakeTorrentProgress = class(TForm)
    pbView: TProgressBar;
    Button1: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    FPos: Integer;
    FCancel: BOOL;
  public
    { Public declarations }
    FFilePath, FHttpUrl, FTracker, FTorrent, FCreator, FCreatorUrl, FCreatorMemo: string;
    FPieceSize, FDHT: Integer;

    procedure DoTorrent;
  end;

var
  frmMakeTorrentProgress: TfrmMakeTorrentProgress;

implementation

uses dlbt;

{$R *.dfm}

{ TfrmMakeTorrentProgress }

procedure TfrmMakeTorrentProgress.DoTorrent;
begin

  FPos := 0;
  FCancel := False;
  TMTThread.Create(FFilePath,
                        FHttpUrl,
                        FTracker,
                        FTorrent,
                        FCreator,
                        FCreatorUrl,
                        FCreatorMemo,
                        FPieceSize,
                        FDHT,
                        @FPos,
                        @FCancel);
end;

{ TMTThread }

constructor TMTThread.Create(AFilePath, AHttpUrl, ATracker, ATorrent,
  ACreator, ACreatorUrl, ACreatorMemo: string; APieceSize, ADHT: Integer;
  APos:PInteger; ACancel: PBOOL);
begin
  FFilePath := AFilePath;
  FHttpUrl := AHttpUrl;
  FTracker := ATracker;
  FTorrent := ATorrent;
  FCreator := ACreator;
  FCreatorUrl := ACreatorUrl;
  FCreatorMemo := ACreatorMemo;
  FPieceSize := APieceSize;
  FDHT := ADHT;
  FPos := APos;
  FCancel := ACancel;
  FreeOnTerminate := True;
  inherited Create(False);
end;

destructor TMTThread.Destroy;
begin
  FPos^ := 100;
  inherited;
end;

procedure TMTThread.Execute;
var
  mh: THandle;
  PTemp, PPath: PWideChar;
  Len: Integer;
  SL: TStrings;
  i: Integer;
begin
  inherited;

  Len := Length(FFilePath) * SizeOf(WideChar) + 1;
  PPath := AllocMem(Len);
  StringToWideChar(FFilePath, PPath, Len);
  mh := DLBT_CreateTorrent(FPieceSize,
                           PPath,
                           PWideChar(FCreator),
                           PWideChar(FCreatorUrl),
                           PWideChar(FCreatorMemo),
                           DLBT_TORRENT_TYPE(FDHT),
                           FPos,
                           FCancel,
                           -1,
                           False);

  FreeMem(PPath);
  if mh <> 0 then
    Exit;

  SL := TStringList.Create;
  try
    SL.Delimiter := '|';
    SL.DelimitedText := FHttpUrl;
    for i := 0 to SL.Count - 1 do
    begin
      Len := Length(SL[i]) * SizeOf(WideChar) + 1;
      PTemp := AllocMem(Len);
      StringToWideChar(SL[i], PTemp, Len);
//      DLBT_Torrent_AddTracker(mh, PTemp, i);
      DLBT_Torrent_AddHttpUrl(mh, PTemp);
      FreeMem(PTemp);
    end;

    SL.CommaText := FTracker;
    for i := 0 to SL.Count - 1 do
    begin
      Len := Length(SL[i]) * SizeOf(WideChar) + 1;
      PTemp := AllocMem(Len);
      StringToWideChar(SL[i], PTemp, Len);
      DLBT_Torrent_AddTracker(mh, PTemp, i);
      FreeMem(PTemp);
    end;

    Len := Length(FTorrent) * SizeOf(WideChar) + 1;
    PTemp := AllocMem(Len);
    StringToWideChar(FTorrent, PTemp, Len);
    DLBT_SaveTorrentFile(mh, PTemp, nil);
    FreeMem(PTemp);
  finally
    SL.Free;
  end;

end;

procedure TfrmMakeTorrentProgress.Button1Click(Sender: TObject);
begin
  FCancel := True;
end;

procedure TfrmMakeTorrentProgress.FormShow(Sender: TObject);
begin
  DoTorrent;
end;

procedure TfrmMakeTorrentProgress.Timer1Timer(Sender: TObject);
begin
  pbView.Min := 0;
  pbView.Max := 100;
  pbView.Position := FPos;

  if FPos >= 99 then
    Close;
end;

end.
