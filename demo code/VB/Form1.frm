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
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton CommandSelFile 
      Caption         =   "选择文件"
      Height          =   375
      Left            =   5160
      TabIndex        =   10
      Top             =   7800
      Width           =   1335
   End
   Begin VB.CommandButton CommandMakeTorrent 
      Caption         =   "制作种子"
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
      Caption         =   "打开种子"
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
      Caption         =   "开始下载"
      Height          =   375
      Left            =   7320
      TabIndex        =   0
      Top             =   240
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "当前连接信息："
      Height          =   1455
      Left            =   120
      TabIndex        =   14
      Top             =   6240
      Width           =   10455
   End
   Begin VB.Label Label7 
      Caption         =   "内核整体情况信息："
      Height          =   855
      Left            =   0
      TabIndex        =   13
      Top             =   0
      Width           =   8775
   End
   Begin VB.Label Label4 
      Caption         =   "监听端口："
      Height          =   495
      Left            =   360
      TabIndex        =   12
      Top             =   4200
      Width           =   8655
   End
   Begin VB.Label infoKernel 
      Caption         =   "内核整体情况信息："
      Height          =   855
      Left            =   240
      TabIndex        =   11
      Top             =   5160
      Width           =   8775
   End
   Begin VB.Label Label2 
      Caption         =   "Hash值："
      Height          =   495
      Left            =   360
      TabIndex        =   7
      Top             =   3480
      Width           =   8655
   End
   Begin VB.Label Label6 
      Caption         =   "速度："
      Height          =   375
      Left            =   360
      TabIndex        =   6
      Top             =   2760
      Width           =   3855
   End
   Begin VB.Label Label5 
      Caption         =   "大小："
      Height          =   495
      Left            =   360
      TabIndex        =   5
      Top             =   2040
      Width           =   8055
   End
   Begin VB.Label Label3 
      Caption         =   "状态："
      Height          =   495
      Left            =   360
      TabIndex        =   2
      Top             =   1320
      Width           =   9135
   End
   Begin VB.Label Label1 
      Caption         =   "文件名："
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
        MsgBox ("请选择一个Torrent文件！")
        Exit Sub
    End If
    
    hDownloader = DLBT_Downloader_Initialize(TextTorrentPath.Text, "c:/tmpBT", "", FILE_ALLOCATE_SPARSE, False, False, vbNullString, vbNullString, False, False)

    
End Sub

Private Sub Command2_Click()

End Sub

Private Sub CommandMakeTorrent_Click()
     If TextFilePath.Text = "" Then
        Call TextFilePath.SetFocus
        MsgBox ("请选择一个文件！")
        Exit Sub
    End If
    
    Dim hTorrent As Long
    Dim nPercent As Long
    
    bCancel = False
    hTorrent = DLBT_CreateTorrent(0, TextFilePath.Text, "点量BT", "http://www.dolit.cn/", "备注信息", USE_PUBLIC_DHT_NODE, nPercent, bCancel, -1, False)
    If hTorrent = 0 Then
        MsgBox ("出错")
        Exit Sub
    End If
    
    Dim bRet As Long
    bRet = DLBT_Torrent_AddTracker(hTorrent, "http://localhost:6969/announce", 0)
    
    bRet = DLBT_SaveTorrentFile(hTorrent, "c:/a.torrent", vbNullString, 0, vbNullString)
    DLBT_ReleaseTorrent (hTorrent)
    
    If bRet = 0 Then
      MsgBox ("种子制作成功!")
    Else
      MsgBox ("种子制作失败!")
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
    bRet = DLBT_AddAppToWindowsXPFirewall(App.Path & "\" & App.EXEName & ".exe", "点量BT VB示例程序")
    
    Dim curLimit As Long
    curLimit = DLBT_GetCurrentXPLimit()
    If curLimit <> 0 And curLimit < 256 Then
       bRet = DLBT_ChangeXPConnectionLimit(256)
       If bRet Then
        MsgBox ("点量BT（DLBT内核）检测到您系统上的连接数需要优化，为了更好的下载效果，点量BT已自动进行了系统优化，需要重启电脑后方能生效，如下载效果不好，请手工重启电脑后使用")
       End If
    End If
    
    Dim startInfo As DLBT_KERNEL_START_PARAM
    startInfo.bStartDHT = 1
    startInfo.bStartLocalDiscovery = 1
    startInfo.bStartUPnP = 1
    startInfo.bLanUser = 0
    startInfo.bVODMode = 0
    startInfo.startPort = 9010   '尝试绑定9010端口，如果9010端口未被占用，则使用。否则，继续尝试下一个端口，直到endPort指定的范围。
    startInfo.endPort = 9030
    
    btKernel = DLBT_Startup(startInfo, vbNullString, False, 0)
    DLBT_DHT_Start (0)
    
'    示例设置ReportIP
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
    
    Label4.Caption = "监听端口：" + Str(port)
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
    Label1.Caption = "文件名：" & info
    
   
    
    ' 获取单个文件名的示例
    Dim sFile As String
    sFile = P2P_FileName(hDownloader, 0)
    
    Dim ppInfo As Long
    
    ret = DLBT_GetDownloaderPeerInfoList(hDownloader, ppInfo)
    
    ' 显示当前连接信息
    Label8.Caption = "当前连接信息： 【连接数】："
    Dim count As Long
    count = 0
    Dim offset As Long
    offset = 4          '用于指向PEER_INFO_ENTRY的内存位置，一个是count的占位（4个字节）；所以是4
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
        Label3.Caption = "状态: 分配磁盘空间..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_CHECKING_FILES Then
        Label3.Caption = taskInfo & "状态: 正在检查校验文件..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_CONNECTING_TRACKER Then
        Label3.Caption = taskInfo & "状态: 连接Tracker..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_DOWNLOADING Then
        Label3.Caption = taskInfo & "状态: 正在下载中..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_PAUSED Then
        Label3.Caption = taskInfo & "状态: 暂停..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_FINISHED Then
        Label3.Caption = taskInfo & "状态: 下载完成..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_SEEDING Then
        Label3.Caption = taskInfo & "状态: 供种中..."
    ElseIf DLBT_Downloader_GetState(hDownloader) = BTDS_QUEUED Then
        Label3.Caption = taskInfo & "状态: 已经添加，正在初始化..."
    End If
    
        
    If DLBT_Downloader_GetState(hDownloader) = BTDS_ALLOCATING Then
        Exit Sub
    End If


    Dim uSize As UINT64
    Dim uDone As UINT64
    uSize = DLBT_Downloader_GetTotalFileSize(hDownloader)  '取出来了大小，高低位共同表示64位，2G以下的文件高位是0，2G以上的才用到高位
      
    ' 以下最好加入以下对状态的判断，但由于对VB中的IF语句不熟悉，先不写该判断了
    ' if state == BTDS_CONNECTING_TRACKER || state == BTDS_DOWNLOADING || state == BTDS_FINISHED || state == BTDS_SEEDING)
    
    uDone = DLBT_Downloader_GetDownloadedBytes(hDownloader)  '下载完成的大小
    
    Dim percent As Single
    percent = DLBT_Downloader_GetProgress(hDownloader)
    
    Label5.Caption = "大小：" & UINT64ToDouble(uSize) & " 完成：" & UINT64ToDouble(uDone) & " 百分比： " & percent & "%"
    
    
    Dim speed As Long
    speed = DLBT_Downloader_GetDownloadSpeed(hDownloader)
    Label6.Caption = "下载速度:" & Str(speed)
    speed = DLBT_Downloader_GetUploadSpeed(hDownloader)
    Label6.Caption = Label6.Caption & " 上传速度：" & Str(speed)
    
    Dim hashInfo As String
    hashInfo = Space(64)
    pBufferSize = 64
    ret = DLBT_Downloader_GetInfoHash(hDownloader, hashInfo, pBufferSize)
    Label2.Caption = "文件Hash值：" & hashInfo
    
    Dim kernelInfo As KERNEL_INFO
    Dim kInfo As String
    ret = DLBT_GetKernelInfo(kernelInfo)
    
    kInfo = "内核整体情况信息：  端口 - [" & kernelInfo.port & "] DHT: - [" & kernelInfo.dhtStarted & " 连接上：" & kernelInfo.dhtConnectedNodeNum & ", 缓存：" & kernelInfo.dhtCachedNodeNum & "] \r\n"
    kInfo = kInfo & "总下载字节：[" & Str(kernelInfo.totalDownloadedByteCount.LowLong) & "] 总上传字节：[" & Str(kernelInfo.totalUploadedByteCount.LowLong) & "] 总下载速度：[" & Str(kernelInfo.totalDownloadSpeed) & "] 总上传速度：[" & Str(kernelInfo.totalUploadSpeed) & "] 总下载连接数：[" & Str(kernelInfo.totalDownloadConnectionCount) & "]"

    infoKernel.Caption = kInfo
    
    Dim downloaderInfo As DOWNLOADER_INFO
    Dim dInfo As String
    ret = DLBT_GetDownloaderInfo(hDownloader, downloaderInfo)
    
    ' 这里可以设置断点看downloaderInfo内的各项信息是否正确
    dInfo = "任务整体情况信息： "
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
'比如文件为名51GG\123\abc.dll,则从\号处开始读取为123\abc.dll
info = Mid(info, InStr(1, info, "\") + 1)
P2P_FileName = info
End Function
