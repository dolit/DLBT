Imports System.Runtime.InteropServices
Imports System.Text

Public Class DLBT_Demo
    ' 定义一个任务的句柄（每个任务一个句柄，也可以理解为任务ID，任务号，以后对任务的操作都通过这个ID）
    ' 本示例中演示只同时下载（上传）一个任务，因此只用一个句柄；如果有多个，建议用数组等数据结构存储
    Private m_hDownloader As IntPtr = IntPtr.Zero

    ' 程序启动时开启BT内核
    Private Sub DLBT_Demo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ' 正版用户先输入序列号
        
        ' 加入防火墙例外（方便下载和上传）
        DLBT.DLBT_AddAppToWindowsXPFirewall(Application.ExecutablePath, "点量BT内核示例程序（VB.NET版）")

        Dim param As DLBT.DLBT_KERNEL_START_PARAM = New DLBT.DLBT_KERNEL_START_PARAM()
        param.Init()
        param.startPort = 9010     ' 尝试绑定9010端口，如果9010端口未被占用，则使用。否则，继续尝试下一个端口，直到endPort指定的范围。
        param.endPort = 9010
        If Not (DLBT.DLBT_Startup(param, vbNullChar, False, "")) Then
            MessageBox.Show(" DLBT_Startup失败！")
            Return
        End If
        DLBT.DLBT_DHT_Start(0)
        txtSaveFolder.Text = System.IO.Path.GetDirectoryName(Application.ExecutablePath)
        ' 默认支持加密传输，防止运营商封锁，实际运营时可以考虑使用DLBT_ENCRYPT_PROTOCOL_MIX减少资源使用
        DLBT.DLBT_SetEncryptSetting(DLBT.DLBT_ENCRYPT_OPTION.DLBT_ENCRYPT_FULL, DLBT.DLBT_ENCRYPT_LEVEL.DLBT_ENCRYPT_ALL)

        Timer1.Start()
    End Sub

    ' 选择需要启动下载的torrent文件
    Private Sub btnBrowse_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBrowse.Click
        OpenFileDialog1.InitialDirectory = System.IO.Path.GetDirectoryName(Application.ExecutablePath)
        OpenFileDialog1.Filter = "torrent files (*.torrent)|*.torrent|All files (*.*)|*.*"
        OpenFileDialog1.FilterIndex = 0
        OpenFileDialog1.RestoreDirectory = True
        If OpenFileDialog1.ShowDialog() = DialogResult.OK Then
            txtBoxTorrentFile.Text = OpenFileDialog1.FileName
        End If
    End Sub


    Private Sub BtnStartDownload_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnStartDownload.Click
        If Not (System.IO.File.Exists(txtBoxTorrentFile.Text)) Then
            MessageBox.Show("请先选择正确的torrent文件")
            Return
        End If

        If Not (System.IO.Directory.Exists(txtSaveFolder.Text)) Then
            MessageBox.Show("请先输入正确的保存路径")
            Return
        End If

        ' 如果已经有任务在下载（上传）了，停止掉 -- 这里我们只是演示了单任务下载，如果需要多任务，可以参考C#等示例，使用数组管理句柄队列即可
        StopTask()

        Dim pass As Byte() = System.Text.Encoding.ASCII.GetBytes("")
        m_hDownloader = DLBT.DLBT_Downloader_Initialize(txtBoxTorrentFile.Text, txtSaveFolder.Text, "", DLBT.DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_SPARSE, False,
                                False, pass, vbNullChar, False, False)

        If (m_hDownloader = IntPtr.Zero) Then
            MessageBox.Show("添加任务失败！如果是试用版，可能已经达到了试用版的限制！\r\n或者可能是种子文件损坏或者格式不合法，无法打开这个种子文件！")
            Return
        End If

        ' 刷新显示下载进度
    End Sub

    ' 显示内核整体运行信息
    Private Sub ShowKernelInfo()
        Dim info As DLBT.KERNEL_INFO = New DLBT.KERNEL_INFO()
        DLBT.DLBT_GetKernelInfo(info)

        txtBoxInfo.Text = ""
        txtBoxInfo.Text += "端口:" + info.port.ToString() + vbCrLf
        If Not (info.dhtStarted) Then
            txtBoxInfo.Text += "DHT:未启动"
        Else
            txtBoxInfo.Text += "DHT:已启动（连接上:" + info.dhtConnectedNodeNum.ToString() + ", 缓存: " + info.dhtCachedNodeNum.ToString() + "）"
        End If
        txtBoxInfo.Text += vbCrLf
        txtBoxInfo.Text += "总下载字节数:" + info.totalDownloadedByteCount.ToString().ToString() + vbCrLf
        txtBoxInfo.Text += "总上传字节数:" + info.totalUploadedByteCount.ToString() + vbCrLf
        txtBoxInfo.Text += "总下载速度(/s):" + (info.totalDownloadSpeed.ToString()) + " Bytes/s" + vbCrLf
        txtBoxInfo.Text += "总上传速度(/s):" + (info.totalUploadSpeed.ToString()) + " Bytes/s"
    End Sub

    ' 显示下载任务的运行信息
    Private Sub ShowTaskInfo()
        If (m_hDownloader = IntPtr.Zero) Then
            Return
        End If

        Dim info As DLBT.DOWNLOAD_INFO = New DLBT.DOWNLOAD_INFO()
        DLBT.DLBT_GetDownloaderInfo(m_hDownloader, info)

        Dim test As String = DLBT.DLBT_Downloader_GetTorrentName(m_hDownloader)

        txtTaskInfo.Text = ""
        txtTaskInfo.Text += "状态:" + GetDownloaderState(info.downloadInfoFiexed.state) + vbCrLf

        txtTaskInfo.Text += "进度:" + info.downloadInfoFiexed.percentDone.ToString() + "%   " _
                            + info.downloadInfoFiexed.totalWantedDoneBytes.ToString() + "/" _
                            + info.downloadInfoFiexed.totalWantedBytes.ToString() + vbCrLf
        txtTaskInfo.Text += "分块数:" + info.downloadInfoFiexed.pieceCount.ToString() + vbCrLf
        txtTaskInfo.Text += "分块大小:" + info.downloadInfoFiexed.pieceSize.ToString() + vbCrLf
        txtTaskInfo.Text += "下载速度:" + info.downloadInfoFiexed.downloadSpeed.ToString() + vbCrLf
        txtTaskInfo.Text += "上传速度:" + info.downloadInfoFiexed.uploadSpeed.ToString() + vbCrLf


        ' peer info
        Dim peerArray As ArrayList = New ArrayList
        Dim i As Integer = 0
        DLBT.DLBT_GetDownloaderPeerInfoList(m_hDownloader, peerArray)
        For i = 0 To peerArray.Count - 1
            Dim peer As DLBT.PEER_INFO = peerArray(i)
            txtTaskInfo.Text += "    " + peer.ip + ", " + peer.client + ", " + peer.peerInfoFixed.downloadedBytes.ToString() + vbCrLf
        Next i
    End Sub

    ' 获取下载任务的字符串状态信息
    Private Function GetDownloaderState(ByVal state As DLBT.DLBT_DOWNLOAD_STATE) As String
        Dim str = ""
        If (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_QUEUED) Then
            str = "初始化"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_CHECKING_FILES) Then
            str = "检查文件"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING_TORRENT) Then
            str = "下载种子"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING) Then
            str = "下载中"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_PAUSED) Then
            str = "暂停"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_FINISHED) Then
            str = "下载完成"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_SEEDING) Then
            str = "供种中"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_ALLOCATING) Then
            str = "分配存储空间"
        ElseIf (state = DLBT.DLBT_DOWNLOAD_STATE.BTDS_ERROR) Then
            str = "出错:" + DLBT.DLBT_Downloader_GetLastError(m_hDownloader)
        End If

        Return str
    End Function

    ' 定时刷新显示任务的进度信息和内核整体信息
    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        ShowKernelInfo()
        ShowTaskInfo()
    End Sub

    Private Sub StopTask()
        ' 如果任务在下载，停止任务
        If Not (m_hDownloader = IntPtr.Zero) Then
            DLBT.DLBT_Downloader_Release(m_hDownloader, DLBT.DLBT_RELEASE_FLAG.DLBT_RELEASE_NO_WAIT)
            m_hDownloader = IntPtr.Zero
        End If
    End Sub

    Private Sub BtnStopTask_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnStopTask.Click
        StopTask()
    End Sub

    ' 程序关闭时最好正常停止下载任务，以及BT内核
    Private Sub DLBT_Demo_FormClosed(ByVal sender As System.Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles MyBase.FormClosed
        ' 如果任务在下载，停止任务
        StopTask()
        ' 关闭BT内核
        DLBT.DLBT_Shutdown()
    End Sub

    Private Sub BtnMakeTorrent_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnMakeTorrent.Click
        Dim maker As MakeTorrent = New MakeTorrent()
        maker.ShowDialog()
    End Sub
End Class
