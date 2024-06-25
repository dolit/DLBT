program DLBT_Demo;

uses
  Forms,
  dlbt in 'dlbt.pas',
  DLBTDemoMainUnit in 'DLBTDemoMainUnit.pas' {frmDLBTDemoMain},
  Unit2 in 'Unit2.pas' {Form2},
  OpenTorrentUnit in 'OpenTorrentUnit.pas' {frmOpenTorrent},
  MakeTorrentUnit in 'MakeTorrentUnit.pas' {frmMakeTorrent},
  MakeTorrentProgressUnit in 'MakeTorrentProgressUnit.pas' {frmMakeTorrentProgress},
  BaseOptionUnit in 'BaseOptionUnit.pas' {frmBaseOption},
  MoreOptionUnit in 'MoreOptionUnit.pas' {frmMoreOption};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDLBTDemoMain, frmDLBTDemoMain);
  Application.Run;
end.
