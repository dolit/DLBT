<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DLBT_Demo
    Inherits System.Windows.Forms.Form

    'Form 重写 Dispose，以清理组件列表。
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Windows 窗体设计器所必需的
    Private components As System.ComponentModel.IContainer

    '注意: 以下过程是 Windows 窗体设计器所必需的
    '可以使用 Windows 窗体设计器修改它。
    '不要使用代码编辑器修改它。
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.label1 = New System.Windows.Forms.Label()
        Me.txtBoxTorrentFile = New System.Windows.Forms.TextBox()
        Me.btnBrowse = New System.Windows.Forms.Button()
        Me.OpenFileDialog1 = New System.Windows.Forms.OpenFileDialog()
        Me.btnStartDownload = New System.Windows.Forms.Button()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtSaveFolder = New System.Windows.Forms.TextBox()
        Me.txtBoxInfo = New System.Windows.Forms.TextBox()
        Me.txtTaskInfo = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.BtnStopTask = New System.Windows.Forms.Button()
        Me.BtnMakeTorrent = New System.Windows.Forms.Button()
        Me.SuspendLayout()
        '
        'label1
        '
        Me.label1.Location = New System.Drawing.Point(62, 25)
        Me.label1.Name = "label1"
        Me.label1.Size = New System.Drawing.Size(111, 15)
        Me.label1.TabIndex = 21
        Me.label1.Text = "种子文件路径："
        '
        'txtBoxTorrentFile
        '
        Me.txtBoxTorrentFile.Location = New System.Drawing.Point(176, 19)
        Me.txtBoxTorrentFile.Name = "txtBoxTorrentFile"
        Me.txtBoxTorrentFile.Size = New System.Drawing.Size(332, 21)
        Me.txtBoxTorrentFile.TabIndex = 22
        '
        'btnBrowse
        '
        Me.btnBrowse.Location = New System.Drawing.Point(538, 14)
        Me.btnBrowse.Name = "btnBrowse"
        Me.btnBrowse.Size = New System.Drawing.Size(109, 25)
        Me.btnBrowse.TabIndex = 23
        Me.btnBrowse.Text = "浏览..."
        Me.btnBrowse.UseVisualStyleBackColor = True
        '
        'OpenFileDialog1
        '
        Me.OpenFileDialog1.FileName = "OpenFileDialog1"
        '
        'btnStartDownload
        '
        Me.btnStartDownload.Location = New System.Drawing.Point(65, 101)
        Me.btnStartDownload.Name = "btnStartDownload"
        Me.btnStartDownload.Size = New System.Drawing.Size(165, 23)
        Me.btnStartDownload.TabIndex = 24
        Me.btnStartDownload.Text = "启动下载"
        Me.btnStartDownload.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(64, 69)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(111, 15)
        Me.Label2.TabIndex = 21
        Me.Label2.Text = "文件保存路径："
        '
        'txtSaveFolder
        '
        Me.txtSaveFolder.Location = New System.Drawing.Point(176, 63)
        Me.txtSaveFolder.Name = "txtSaveFolder"
        Me.txtSaveFolder.Size = New System.Drawing.Size(332, 21)
        Me.txtSaveFolder.TabIndex = 22
        '
        'txtBoxInfo
        '
        Me.txtBoxInfo.Location = New System.Drawing.Point(65, 167)
        Me.txtBoxInfo.Multiline = True
        Me.txtBoxInfo.Name = "txtBoxInfo"
        Me.txtBoxInfo.ReadOnly = True
        Me.txtBoxInfo.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtBoxInfo.Size = New System.Drawing.Size(669, 99)
        Me.txtBoxInfo.TabIndex = 25
        '
        'txtTaskInfo
        '
        Me.txtTaskInfo.Location = New System.Drawing.Point(66, 300)
        Me.txtTaskInfo.Multiline = True
        Me.txtTaskInfo.Name = "txtTaskInfo"
        Me.txtTaskInfo.ReadOnly = True
        Me.txtTaskInfo.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtTaskInfo.Size = New System.Drawing.Size(669, 218)
        Me.txtTaskInfo.TabIndex = 25
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(64, 149)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(111, 15)
        Me.Label3.TabIndex = 21
        Me.Label3.Text = "BT内核整体信息："
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(62, 282)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(111, 15)
        Me.Label4.TabIndex = 21
        Me.Label4.Text = "当前任务信息："
        '
        'Timer1
        '
        Me.Timer1.Interval = 1000
        '
        'BtnStopTask
        '
        Me.BtnStopTask.Location = New System.Drawing.Point(265, 101)
        Me.BtnStopTask.Name = "BtnStopTask"
        Me.BtnStopTask.Size = New System.Drawing.Size(165, 23)
        Me.BtnStopTask.TabIndex = 24
        Me.BtnStopTask.Text = "停止下载"
        Me.BtnStopTask.UseVisualStyleBackColor = True
        '
        'BtnMakeTorrent
        '
        Me.BtnMakeTorrent.Location = New System.Drawing.Point(468, 101)
        Me.BtnMakeTorrent.Name = "BtnMakeTorrent"
        Me.BtnMakeTorrent.Size = New System.Drawing.Size(165, 23)
        Me.BtnMakeTorrent.TabIndex = 24
        Me.BtnMakeTorrent.Text = "制作种子演示"
        Me.BtnMakeTorrent.UseVisualStyleBackColor = True
        '
        'DLBT_Demo
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 12.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(784, 550)
        Me.Controls.Add(Me.txtTaskInfo)
        Me.Controls.Add(Me.txtBoxInfo)
        Me.Controls.Add(Me.BtnMakeTorrent)
        Me.Controls.Add(Me.BtnStopTask)
        Me.Controls.Add(Me.btnStartDownload)
        Me.Controls.Add(Me.btnBrowse)
        Me.Controls.Add(Me.txtSaveFolder)
        Me.Controls.Add(Me.txtBoxTorrentFile)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.label1)
        Me.Name = "DLBT_Demo"
        Me.Text = "点量BT示例程序（VB.NET）"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Private WithEvents label1 As System.Windows.Forms.Label
    Friend WithEvents txtBoxTorrentFile As System.Windows.Forms.TextBox
    Friend WithEvents btnBrowse As System.Windows.Forms.Button
    Friend WithEvents OpenFileDialog1 As System.Windows.Forms.OpenFileDialog
    Friend WithEvents btnStartDownload As System.Windows.Forms.Button
    Private WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents txtSaveFolder As System.Windows.Forms.TextBox
    Friend WithEvents txtBoxInfo As System.Windows.Forms.TextBox
    Friend WithEvents txtTaskInfo As System.Windows.Forms.TextBox
    Private WithEvents Label3 As System.Windows.Forms.Label
    Private WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents BtnStopTask As System.Windows.Forms.Button
    Friend WithEvents BtnMakeTorrent As System.Windows.Forms.Button

End Class
