VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   9015
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   10905
   LinkTopic       =   "Form1"
   ScaleHeight     =   9015
   ScaleWidth      =   10905
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton CommandSelFile 
      Caption         =   "ѡ���ļ�"
      Height          =   375
      Left            =   5160
      TabIndex        =   10
      Top             =   7800
      Width           =   1335
   End
   Begin VB.CommandButton CommandMakeTorrent 
      Caption         =   "��������"
      Height          =   375
      Left            =   7320
      TabIndex        =   9
      Top             =   7800
      Width           =   2055
   End
   Begin VB.TextBox TextFilePath 
      Height          =   375
      Left            =   120
      TabIndex        =   8
      Top             =   7800
      Width           =   4815
   End
   Begin MSComDlg.CommonDialog CommonDialogFile 
      Left            =   480
      Top             =   8520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton SelectTorrent 
      Caption         =   "������"
      Height          =   375
      Left            =   5520
      TabIndex        =   4
      Top             =   240
      Width           =   1455
   End
   Begin VB.TextBox TextTorrentPath 
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   240
      Width           =   4815
   End
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   0
      Top             =   8520
   End
   Begin VB.CommandButton Command1 
      Caption         =   "��ʼ����"
      Height          =   375
      Left            =   7320
      TabIndex        =   0
      Top             =   240
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "��ǰ������Ϣ��"
      Height          =   1455
      Left            =   120
      TabIndex        =   14
      Top             =   6240
      Width           =   10455
   End
   Begin VB.Label Label7 
      Caption         =   "�ں����������Ϣ��"
      Height          =   855
      Left            =   0
      TabIndex        =   13
      Top             =   0
      Width           =   8775
   End
   Begin VB.Label Label4 
      Caption         =   "�����˿ڣ�"
      Height          =   495
      Left            =   360
      TabIndex        =   12
      Top             =   4200
      Width           =   8655
   End
   Begin VB.Label infoKernel 
      Caption         =   "�ں����������Ϣ��"
      Height          =   855
      Left            =   240
      TabIndex        =   11
      Top             =   5160
      Width           =   8775
   End
   Begin VB.Label Label2 
      Caption         =   "Hashֵ��"
      Height          =   495
      Left            =   360
      TabIndex        =   7
      Top             =   3480
      Width           =   8655
   End
   Begin VB.Label Label6 
      Caption         =   "�ٶȣ�"
      Height          =   375
      Left            =   360
      TabIndex        =   6
      Top             =   2760
      Width           =   3855
   End
   Begin VB.Label Label5 
      Caption         =   "��С��"
      Height          =   495
      Left            =   360
      TabIndex        =   5
      Top             =   2040
      Width           =   8055
   End
   Begin VB.Label Label3 
      Caption         =   "״̬��"
      Height          =   495
      Left            =   360
      TabIndex        =   2
      Top             =   1320
      Width           =   9135
   End
   Begin VB.Label Label1 
      Caption         =   "�ļ�����"
      Height          =   495
      Left            =   360
      TabIndex        =   1
      Top             =   840
      Width           =   9375
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim btKernel As Long
Dim hDownloader As Long

Dim bCancel As Boolean

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, ByVal hpvSource As Long, ByVal cbCopy As Long)

Private Sub Command1_Click()
     If TextTorrentPath.Text = "" Then
        Call TextTorrentPath.SetFocus
        MsgBox ("��ѡ��һ��Torrent�ļ���")
        Exit Sub
    End If
    
    hDownloader = DLBT_Downloader_Initialize(TextTorrentPath.Text, "c:/tmpBT", "", FILE_ALLOCATE_SPARSE, False, False, vbNullString, vbNullString, False, False)

    
End Sub

Private Sub Command2_Click()

End Sub

Private Sub CommandMakeTorrent_Click()
     If TextFilePath.Text = "" Then
        Call TextFilePath.SetFocus
        MsgBox ("��ѡ��һ���ļ���")
        Exit Sub
    End If
    
    Dim hTorrent As Long
    Dim nPercent As Long
    
    bCancel = False
    hTorrent = DLBT_CreateTorrent(0, TextFilePath.Text, "����BT", "http://www.dolit.cn/", "��ע��Ϣ", USE_PUBLIC_DHT_NODE, nPercent, bCancel, -1, False)
    If hTorrent = 0 Then
        MsgBox ("����")
        Exit Sub
    End If
    
    Dim bRet As Long
    bRet = DLBT_Torrent_AddTracker(hTorrent, "http://localhost:6969/announce", 0)
    
    bRet = DLBT_SaveTorrentFile(hTorrent, "c:/a.torrent", vbNullString, 0, vbNullString)
    DLBT_ReleaseTorrent (hTorrent)
    
    If bRet = 0 Then
      MsgBox ("���������ɹ�!")
    Else
      MsgBox ("��������ʧ��!")
    End If
    
    
End Sub

Private Sub CommandSelFile_Click()
    CommonDialogFile.Filter = "(*.*)|*.*"
    CommonDialogFile.FilterIndex = 1
    CommonDialogFile.ShowOpen
    TextFilePath.Text = CommonDialogFile.FileName
End Sub

Private Sub Form_Load()

    Dim bRet As Boolean
    bRet = DLBT_AddAppToWindowsXPFirewall(App.Path & "\" & App.EXEName & ".exe", "����BT VBʾ������")
    
    Dim curLimit As Long
    curLimit = DLBT_GetCurrentXPLimit()
    If curLimit <> 0 And curLimit < 256 Then
       bRet = DLBT_ChangeXPConnectionLimit(256)
       If bRet Then
        MsgBox ("����BT��DLBT�ںˣ���⵽��ϵͳ�ϵ���������Ҫ�Ż���Ϊ�˸��õ�����Ч��������BT���Զ�������ϵͳ�Ż�����Ҫ�������Ժ�����Ч��������Ч�����ã����ֹ��������Ժ�ʹ��")
       End If
    End If
    
    Dim startInfo As DLBT_KERNEL_START_PARAM
    startInfo.bStartDHT = 1
    startInfo.bStartLocalDiscovery = 1
    startInfo.bStartUPnP = 1
    startInfo.bLanUser = 0
    startInfo.bVODMode = 0
    startInfo.startPort = 9010   '���԰�9010�˿ڣ����9010�˿�δ��ռ�ã���ʹ�á����򣬼���������һ���˿ڣ�ֱ��endPortָ���ķ�Χ��
    startInfo.endPort = 9030
    
    btKernel = DLBT_Startup(startInfo, vbNullString, False, 0)
    DLBT_DHT_Start (0)
    
'    ʾ������ReportIP
'    DLBT_SetReportIP ("172.16.1.1")
'
'    Dim reportIpAddr As Long
'    reportIpAddr = DLBT_GetReportIP()
'
'    Dim reportIP As String
'    Dim ret As Long
'
'    reportIP = Space(1024)
'    ret = lstrcpy(reportIP, reportIpAddr)
 
    hDownloader = 0
    Dim port As Long
    port = DLBT_GetListenPort()
    
    Label4.Caption = "�����˿ڣ�" + Str(port)
End Sub


Private Sub Form_Unload(Cancel As Integer)
    Dim tmp
    Dim hResult
    If (hDownloader <> 0) Then
        hResult = DLBT_Downloader_Release(hDownloader, DLBT_RELEASE_NO_WAIT)
    End If
    
    tmp = DLBT_Shutdown()
    
End Sub

Private Sub SelectTorrent_Click()
    CommonDialogFile.Filter = "(*.torrent)|*.torrent"
    CommonDialogFile.FilterIndex = 1
    CommonDialogFile.ShowOpen
    TextTorrentPath.Text = CommonDialogFile.FileName
End Sub

Private Sub Timer1_Timer()
    If hDownloader <= 0 Then
        Exit Sub
    End If
    
    Dim info As String
    Dim ret As Long
    
    Dim pBuffer As String
    Dim pBufferSize As Long
    
    pBuffer = Space(1024)
    pBufferSize = 1024
    ret = DLBT_Downloader_GetTorrentName(hDownloader, pBuffer, pBufferSize)
    
    info = pBuffer
    Label1.Caption = "�ļ�����" & info
    
   
    
    ' ��ȡ�����ļ�����ʾ��
    Dim sFile As String
    sFile = P2P_FileName(hDownloader, 0)
    
    Dim ppInfo As Long
    
    ret = DLBT_GetDownloaderPeerInfoList(hDownloader, ppInfo)
    
    ' ��ʾ��ǰ������Ϣ
    Label8.Caption = "��ǰ������Ϣ�� ������������"
    Dim count As Long
    count = 0
    Dim offset As Long
    offset = 4          '����ָ��PEER_INFO_ENTRY���ڴ�λ�ã�һ����count��ռλ��4���ֽڣ���������4
    If ppInfo > 0 Then
        CopyMemory count, ppInfo, 4
        Dim str1 As String
        
        Label8.Caption = Label8.Caption & count & " "
        
        For ii = 1 To count
            Dim entry As PEER_INFO_ENTRY
            CopyMemory entry, ppInfo + offset, LenB(entry)
            offset = offset + LenB(entry)
            Label8.Caption = Label8.Caption & " [" & StrConv(entry.ip, vbUnicode) & " - " & StrConv(entry.client, vbUnicode) & " - downSpeed: " & entry.downloadSpeed & " - upSpeed:" & entry.uploadSpeed & " - downBytes:" & UINT64ToDouble(entry.downloadedBytes) & " - upBytes:" & UINT64ToDouble(entry.uploadedBytes) & "]"
            str1 = " [" & StrConv(entry.ip, vbUnicode) & " - " & StrConv(entry.client, vbUnicode) & " - downSpeed: " & entry.downloadSpeed & " - upSpeed:" & entry.uploadSpeed & " - downBytes:" & UINT64ToDouble(entry.downloadedBytes) & " - upBytes:" & UINT64ToDouble(entry.uploadedBytes) & "]"
        Next ii
        DLBT_FreeDownloaderPeerInfoList (ppInfo)

    End If
    
    If DLBT_Downloader_GetState(hDownloader) = BTDS_ALLOCATING Then
        Label3.Caption = "״̬: ������̿ռ�..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_CHECKING_FILES Then
        Label3.Caption = taskInfo & "״̬: ���ڼ��У���ļ�..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_CONNECTING_TRACKER Then
        Label3.Caption = taskInfo & "״̬: ����Tracker..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_DOWNLOADING Then
        Label3.Caption = taskInfo & "״̬: ����������..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_PAUSED Then
        Label3.Caption = taskInfo & "״̬: ��ͣ..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_FINISHED Then
        Label3.Caption = taskInfo & "״̬: �������..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_SEEDING Then
        Label3.Caption = taskInfo & "״̬: ������..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_QUEUED Then
        Label3.Caption = taskInfo & "״̬: �Ѿ���ӣ����ڳ�ʼ��..."
    End If
    
        
    If DLBT_Downloader_GetState(hDownloader) = BTDS_ALLOCATING Then
        Exit Sub
    End If


    Dim uSize As UINT64
    Dim uDone As UINT64
    uSize = DLBT_Downloader_GetTotalFileSize(hDownloader)  'ȡ�����˴�С���ߵ�λ��ͬ��ʾ64λ��2G���µ��ļ���λ��0��2G���ϵĲ��õ���λ
      
    ' ������ü������¶�״̬���жϣ������ڶ�VB�е�IF��䲻��Ϥ���Ȳ�д���ж���
    ' if state == BTDS_CONNECTING_TRACKER || state == BTDS_DOWNLOADING || state == BTDS_FINISHED || state == BTDS_SEEDING)
    
    uDone = DLBT_Downloader_GetDownloadedBytes(hDownloader)  '������ɵĴ�С
    
    Dim percent As Single
    percent = DLBT_Downloader_GetProgress(hDownloader)
    
    Label5.Caption = "��С��" & UINT64ToDouble(uSize) & " ��ɣ�" & UINT64ToDouble(uDone) & " �ٷֱȣ� " & percent & "%"
    
    
    Dim speed As Long
    speed = DLBT_Downloader_GetDownloadSpeed(hDownloader)
    Label6.Caption = "�����ٶ�:" & Str(speed)
    speed = DLBT_Downloader_GetUploadSpeed(hDownloader)
    Label6.Caption = Label6.Caption & " �ϴ��ٶȣ�" & Str(speed)
    
    Dim hashInfo As String
    hashInfo = Space(64)
    pBufferSize = 64
    ret = DLBT_Downloader_GetInfoHash(hDownloader, hashInfo, pBufferSize)
    Label2.Caption = "�ļ�Hashֵ��" & hashInfo
    
    Dim kernelInfo As KERNEL_INFO
    Dim kInfo As String
    ret = DLBT_GetKernelInfo(kernelInfo)
    
    kInfo = "�ں����������Ϣ��  �˿� - [" & kernelInfo.port & "] DHT: - [" & kernelInfo.dhtStarted & " �����ϣ�" & kernelInfo.dhtConnectedNodeNum & ", ���棺" & kernelInfo.dhtCachedNodeNum & "] \r\n"
    kInfo = kInfo & "�������ֽڣ�[" & Str(kernelInfo.totalDownloadedByteCount.LowLong) & "] ���ϴ��ֽڣ�[" & Str(kernelInfo.totalUploadedByteCount.LowLong) & "] �������ٶȣ�[" & Str(kernelInfo.totalDownloadSpeed) & "] ���ϴ��ٶȣ�[" & Str(kernelInfo.totalUploadSpeed) & "] ��������������[" & Str(kernelInfo.totalDownloadConnectionCount) & "]"

    infoKernel.Caption = kInfo
    
    Dim downloaderInfo As DOWNLOADER_INFO
    Dim dInfo As String
    ret = DLBT_GetDownloaderInfo(hDownloader, downloaderInfo)
    
    ' ����������öϵ㿴downloaderInfo�ڵĸ�����Ϣ�Ƿ���ȷ
    dInfo = "�������������Ϣ�� "
End Sub

Public Function sTrim(sName As String) As String
Dim x As Integer
x = InStr(sName, vbNullChar)
If x > 0 Then sTrim = Left$(sName, x - 1) Else sTrim = sName
End Function

Public Function P2P_FileName(TaskHwnd As Long, Index As Long) As String
If TaskHwnd = 0 Then Exit Function

Dim pBuffer As String
Dim pBufferSize As Long
Dim info As String

pBuffer = Space(1024)
pBufferSize = 1024
Call DLBT_Downloader_GetFilePathName(TaskHwnd, Index, StrPtr(pBuffer), pBufferSize, False)
info = sTrim(pBuffer)
'�����ļ�Ϊ��51GG\123\abc.dll,���\�Ŵ���ʼ��ȡΪ123\abc.dll
info = Mid(info, InStr(1, info, "\") + 1)
P2P_FileName = info
End Function
