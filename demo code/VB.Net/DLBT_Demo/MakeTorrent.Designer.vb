<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MakeTorrent
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.cancelBt = New System.Windows.Forms.Button()
        Me.labelInfo = New System.Windows.Forms.Label()
        Me.filePathText = New System.Windows.Forms.TextBox()
        Me.BtnMake = New System.Windows.Forms.Button()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.txtBoxSavePath = New System.Windows.Forms.TextBox()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.SuspendLayout()
        '
        'cancelBt
        '
        Me.cancelBt.Location = New System.Drawing.Point(169, 191)
        Me.cancelBt.Name = "cancelBt"
        Me.cancelBt.Size = New System.Drawing.Size(96, 24)
        Me.cancelBt.TabIndex = 10
        Me.cancelBt.Text = "取消"
        '
        'labelInfo
        '
        Me.labelInfo.Location = New System.Drawing.Point(22, 102)
        Me.labelInfo.Name = "labelInfo"
        Me.labelInfo.Size = New System.Drawing.Size(344, 86)
        Me.labelInfo.TabIndex = 9
        Me.labelInfo.Text = "当前制作进度："
        '
        'filePathText
        '
        Me.filePathText.Location = New System.Drawing.Point(190, 32)
        Me.filePathText.Name = "filePathText"
        Me.filePathText.Size = New System.Drawing.Size(176, 21)
        Me.filePathText.TabIndex = 7
        '
        'BtnMake
        '
        Me.BtnMake.Location = New System.Drawing.Point(55, 191)
        Me.BtnMake.Name = "BtnMake"
        Me.BtnMake.Size = New System.Drawing.Size(72, 24)
        Me.BtnMake.TabIndex = 6
        Me.BtnMake.Text = "制作种子"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(18, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(149, 12)
        Me.Label2.TabIndex = 11
        Me.Label2.Text = "要制作的文件或者文件夹："
        '
        'txtBoxSavePath
        '
        Me.txtBoxSavePath.Location = New System.Drawing.Point(190, 59)
        Me.txtBoxSavePath.Name = "txtBoxSavePath"
        Me.txtBoxSavePath.Size = New System.Drawing.Size(176, 21)
        Me.txtBoxSavePath.TabIndex = 7
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(18, 62)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(77, 12)
        Me.Label3.TabIndex = 11
        Me.Label3.Text = "生成的文件："
        '
        'Timer1
        '
        '
        'MakeTorrent
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 12.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(410, 303)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.cancelBt)
        Me.Controls.Add(Me.labelInfo)
        Me.Controls.Add(Me.txtBoxSavePath)
        Me.Controls.Add(Me.filePathText)
        Me.Controls.Add(Me.BtnMake)
        Me.Name = "MakeTorrent"
        Me.Text = "MakeTorrent"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Private WithEvents cancelBt As System.Windows.Forms.Button
    Private WithEvents labelInfo As System.Windows.Forms.Label
    Private WithEvents filePathText As System.Windows.Forms.TextBox
    Private WithEvents BtnMake As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Private WithEvents txtBoxSavePath As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
End Class
