Imports System.Runtime.InteropServices
Imports System.Threading

Public Class MakeTorrent

    ' 制作种子对象的句柄
    Private m_hTorrent As IntPtr = IntPtr.Zero
    ' 制作进度
    Private m_percent As Integer = 0
    ' 是否取消掉制作（一个指针）
    Private m_bCancel As IntPtr = IntPtr.Zero
    ' 已经成功取消了
    Private m_canceled As Boolean = False

    Private Sub BtnMake_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BtnMake.Click
        If (filePathText.Text.Length <= 0) Or Not ((System.IO.Directory.Exists(filePathText.Text)) Or (System.IO.File.Exists(filePathText.Text))) Then
            MessageBox.Show("请选择需要制作种子的文件或者文件夹的路径!")
            Return
        End If

        If Not (m_hTorrent = IntPtr.Zero) Then
            MessageBox.Show("程序出错!")
            Return
        End If

        BtnMake.Enabled = False
        cancelBt.Enabled = True
        m_canceled = False
        m_bCancel = Marshal.AllocCoTaskMem(4)   '分配一个指针
        Marshal.WriteInt32(m_bCancel, 0)    ' 设置不取消（0是不取消）
        m_percent = 0   '设置当前进度

        Timer1.Start()
        ' 启动一个线程开始制作（也可以直接在本线程中，但一般制作种子需要时间，单独线程可以显示进度和中间随时取消
        Dim th As Thread = New Thread(New ThreadStart(AddressOf ThreadMakeTorrent))
        th.Start()
    End Sub

    Private Sub ThreadMakeTorrent()
        If (m_hTorrent = IntPtr.Zero) Then
            m_hTorrent = DLBT.DLBT_CreateTorrent(0, filePathText.Text, "点量BT", "http://www.dolit.cn", vbNullChar, _
                                       DLBT.DLBT_TORRENT_TYPE.USE_PUBLIC_DHT_NODE, m_percent, m_bCancel, _
                                       -1, False)
            If Not (m_hTorrent = IntPtr.Zero) Then
                DLBT.DLBT_Torrent_AddTracker(m_hTorrent, "http://127.0.0.1:6969/announce", 0)   '请设置自己的tracker地址
                DLBT.DLBT_SaveTorrentFile(m_hTorrent, txtBoxSavePath.Text, vbNullChar, False, vbNullChar)
                DLBT.DLBT_ReleaseTorrent(m_hTorrent)
                m_hTorrent = IntPtr.Zero
                m_percent = 100
                MessageBox.Show("制作完成！")
            ElseIf Not (m_canceled) Then
                MessageBox.Show("制作失败！")
            End If
            If Not (m_bCancel = IntPtr.Zero) Then
                Marshal.FreeCoTaskMem(m_bCancel)
            End If
            m_bCancel = IntPtr.Zero
        End If
    End Sub

    Private Sub MakeTorrent_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        txtBoxSavePath.Text = "H:\Test\a.torrent"
        cancelBt.Enabled = False
    End Sub

    Private Sub cancelBt_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cancelBt.Click
        m_canceled = True
        If Not (m_bCancel = IntPtr.Zero) Then
            Marshal.WriteInt32(m_bCancel, 1)    '通过这4个字节的一小块内存设置为1，通知dlbt内部，取消制作
        End If
    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        labelInfo.Text = "当前进度：" + m_percent.ToString() + "%"
    End Sub
End Class