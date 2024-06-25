using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Diagnostics;
using System.IO;

namespace DLBT_Demo
{
	/// <summary>
	/// Form1 的摘要说明。
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
        private System.Windows.Forms.MainMenu mainMenuTitle;
        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.MenuItem menuItem2;
        private System.Windows.Forms.MenuItem menuItem3;
        private System.Windows.Forms.ListView listDownloader;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.ColumnHeader columnHeader7;
        private System.Windows.Forms.StatusBar statusBar1;
        private System.Windows.Forms.StatusBarPanel statusBarPanel1;
        private System.Windows.Forms.StatusBarPanel statusBarPanel2;
        private System.Windows.Forms.TabControl infoTab;
        private System.Windows.Forms.TabPage GerneralTabPage;
        private System.Windows.Forms.TabPage connectTabPage;
        private System.Windows.Forms.TabPage fileTabPage;
        private System.Windows.Forms.ListView gerneralList;
        private System.Windows.Forms.ColumnHeader columnHeader8;
        private System.Windows.Forms.ColumnHeader columnHeader9;
        private System.Windows.Forms.ListView connectList;
        private System.Windows.Forms.ColumnHeader columnHeader10;
        private System.Windows.Forms.ColumnHeader columnHeader11;
        private System.Windows.Forms.ColumnHeader columnHeader12;
        private System.Windows.Forms.ColumnHeader columnHeader13;
        private System.Windows.Forms.ListView fileList;
        private System.Windows.Forms.ColumnHeader columnHeader14;
        private System.Windows.Forms.ColumnHeader columnHeader15;
        private System.Windows.Forms.ColumnHeader columnHeader16;
        private System.Windows.Forms.MenuItem menuAddDownload;
        private System.Windows.Forms.MenuItem menuMakeTorrent;
        private System.Windows.Forms.MenuItem menuExit;
        private System.Windows.Forms.Timer refreshTimer;
        private System.ComponentModel.IContainer components;
        private System.Windows.Forms.MenuItem menuItem4;
        private System.Windows.Forms.MenuItem menuItemAbout;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.ColumnHeader columnHeader17;

        private Hashtable m_downloaderTable = new Hashtable ();

		public Form1()
		{
            if (Process.GetProcessesByName(Process.GetCurrentProcess().ProcessName).Length > 1)
            {
                MessageBox.Show ("只允许同时运行一个点量BT内核的演示程序！", this.Text);
                Process.GetCurrentProcess().Kill();
                return;
            }

			//
			// Windows 窗体设计器支持所必需的
			//
			InitializeComponent();

			//
			// TODO: 在 InitializeComponent 调用后添加任何构造函数代码
			//

            string pathName = Application.ExecutablePath;
            DLBT.DLBT_AddAppToWindowsXPFirewall (pathName, "点量BT内核示例程序（C#版）");

         
            // 检测是否需要修改系统的并发连接数限制，可以根据需要选择是否打开下面这段代码
            /*
            UInt32 curLimit = DLBT.DLBT_GetCurrentXPLimit (); 
            if (curLimit != 0 && curLimit < 256)
            {
                if (DLBT.DLBT_ChangeXPConnectionLimit (256))
                {
                    string str = string.Format ("点量BT（DLBT内核）检测到您系统上的连接数需要优化，为了更好的下载效果，\r\n 点量BT已自动进行了系统优化，需要重启电脑后方能生效，如下载效果不好，请手工重启电脑后使用！\r\n \r\n 原来的连接限制数为%d，现在改为了256", curLimit);
                    MessageBox.Show (str, "点量BT内核自动优化");
                }
            }
            */
        
            DLBT.DLBT_KERNEL_START_PARAM param = new DLBT.DLBT_KERNEL_START_PARAM();            
            param.Init();
            param.startPort = 9010;     // 尝试绑定9010端口，如果9010端口未被占用，则使用。否则，继续尝试下一个端口，直到endPort指定的范围。
            param.endPort = 9010;
            if (!DLBT.DLBT_Startup (ref param, null, false, null))
            {
                MessageBox.Show (" DLBT_Startup失败！");
                return;
            }
            DLBT.DLBT_DHT_Start (0);
            // 默认支持加密传输，防止运营商封锁，实际运营时可以考虑使用DLBT_ENCRYPT_PROTOCOL_MIX减少资源使用
            DLBT.DLBT_SetEncryptSetting (DLBT.DLBT_ENCRYPT_OPTION.DLBT_ENCRYPT_FULL, DLBT.DLBT_ENCRYPT_LEVEL.DLBT_ENCRYPT_ALL);

            this.refreshTimer.Enabled = true;
		}

		/// <summary>
		/// 清理所有正在使用的资源。
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows 窗体设计器生成的代码
		/// <summary>
		/// 设计器支持所需的方法 - 不要使用代码编辑器修改
		/// 此方法的内容。
		/// </summary>
		private void InitializeComponent()
		{
            this.components = new System.ComponentModel.Container();
            this.mainMenuTitle = new System.Windows.Forms.MainMenu();
            this.menuItem1 = new System.Windows.Forms.MenuItem();
            this.menuAddDownload = new System.Windows.Forms.MenuItem();
            this.menuMakeTorrent = new System.Windows.Forms.MenuItem();
            this.menuExit = new System.Windows.Forms.MenuItem();
            this.menuItem2 = new System.Windows.Forms.MenuItem();
            this.menuItem4 = new System.Windows.Forms.MenuItem();
            this.menuItem3 = new System.Windows.Forms.MenuItem();
            this.menuItemAbout = new System.Windows.Forms.MenuItem();
            this.listDownloader = new System.Windows.Forms.ListView();
            this.columnHeader1 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader2 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader3 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader4 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader5 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader6 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader7 = new System.Windows.Forms.ColumnHeader();
            this.statusBar1 = new System.Windows.Forms.StatusBar();
            this.statusBarPanel1 = new System.Windows.Forms.StatusBarPanel();
            this.statusBarPanel2 = new System.Windows.Forms.StatusBarPanel();
            this.infoTab = new System.Windows.Forms.TabControl();
            this.GerneralTabPage = new System.Windows.Forms.TabPage();
            this.gerneralList = new System.Windows.Forms.ListView();
            this.columnHeader8 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader9 = new System.Windows.Forms.ColumnHeader();
            this.connectTabPage = new System.Windows.Forms.TabPage();
            this.connectList = new System.Windows.Forms.ListView();
            this.columnHeader10 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader11 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader12 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader13 = new System.Windows.Forms.ColumnHeader();
            this.fileTabPage = new System.Windows.Forms.TabPage();
            this.fileList = new System.Windows.Forms.ListView();
            this.columnHeader14 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader15 = new System.Windows.Forms.ColumnHeader();
            this.columnHeader16 = new System.Windows.Forms.ColumnHeader();
            this.refreshTimer = new System.Windows.Forms.Timer(this.components);
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.columnHeader17 = new System.Windows.Forms.ColumnHeader();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).BeginInit();
            this.infoTab.SuspendLayout();
            this.GerneralTabPage.SuspendLayout();
            this.connectTabPage.SuspendLayout();
            this.fileTabPage.SuspendLayout();
            this.SuspendLayout();
            // 
            // mainMenuTitle
            // 
            this.mainMenuTitle.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                          this.menuItem1,
                                                                                          this.menuItem2,
                                                                                          this.menuItem3});
            // 
            // menuItem1
            // 
            this.menuItem1.Index = 0;
            this.menuItem1.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                      this.menuAddDownload,
                                                                                      this.menuMakeTorrent,
                                                                                      this.menuExit});
            this.menuItem1.Text = "文件";
            // 
            // menuAddDownload
            // 
            this.menuAddDownload.Index = 0;
            this.menuAddDownload.Text = "新增BT下载";
            this.menuAddDownload.Click += new System.EventHandler(this.menuAddDownload_Click);
            // 
            // menuMakeTorrent
            // 
            this.menuMakeTorrent.Index = 1;
            this.menuMakeTorrent.Text = "制作种子";
            this.menuMakeTorrent.Click += new System.EventHandler(this.menuMakeTorrent_Click);
            // 
            // menuExit
            // 
            this.menuExit.Index = 2;
            this.menuExit.Text = "退出";
            this.menuExit.Click += new System.EventHandler(this.menuExit_Click);
            // 
            // menuItem2
            // 
            this.menuItem2.Index = 1;
            this.menuItem2.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                      this.menuItem4});
            this.menuItem2.Text = "选项";
            // 
            // menuItem4
            // 
            this.menuItem4.Index = 0;
            this.menuItem4.Text = "时间关系，设置暂时不演示，如需要，请看MFC的示例程序";
            // 
            // menuItem3
            // 
            this.menuItem3.Index = 2;
            this.menuItem3.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                      this.menuItemAbout});
            this.menuItem3.Text = "帮助";
            // 
            // menuItemAbout
            // 
            this.menuItemAbout.Index = 0;
            this.menuItemAbout.Text = "关于点量BT内核";
            this.menuItemAbout.Click += new System.EventHandler(this.menuItemAbout_Click);
            // 
            // listDownloader
            // 
            this.listDownloader.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                             this.columnHeader1,
                                                                                             this.columnHeader2,
                                                                                             this.columnHeader3,
                                                                                             this.columnHeader4,
                                                                                             this.columnHeader5,
                                                                                             this.columnHeader6,
                                                                                             this.columnHeader7});
            this.listDownloader.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listDownloader.Location = new System.Drawing.Point(0, 0);
            this.listDownloader.Name = "listDownloader";
            this.listDownloader.Size = new System.Drawing.Size(728, 534);
            this.listDownloader.TabIndex = 0;
            this.listDownloader.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "文件名";
            this.columnHeader1.Width = 199;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "状态";
            this.columnHeader2.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader2.Width = 82;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "大小";
            this.columnHeader3.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader3.Width = 76;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "已下载";
            this.columnHeader4.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader4.Width = 79;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "剩余时间";
            this.columnHeader5.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader5.Width = 107;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "下载速度";
            this.columnHeader6.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader6.Width = 87;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "上传速度";
            this.columnHeader7.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader7.Width = 79;
            // 
            // statusBar1
            // 
            this.statusBar1.Location = new System.Drawing.Point(0, 514);
            this.statusBar1.Name = "statusBar1";
            this.statusBar1.Panels.AddRange(new System.Windows.Forms.StatusBarPanel[] {
                                                                                          this.statusBarPanel1,
                                                                                          this.statusBarPanel2});
            this.statusBar1.ShowPanels = true;
            this.statusBar1.Size = new System.Drawing.Size(728, 20);
            this.statusBar1.TabIndex = 1;
            // 
            // statusBarPanel1
            // 
            this.statusBarPanel1.Text = "  点量BT内核的演示程序。  点量BT内核，做最专业的P2P传输库  ";
            this.statusBarPanel1.Width = 500;
            // 
            // statusBarPanel2
            // 
            this.statusBarPanel2.Width = 1000;
            // 
            // infoTab
            // 
            this.infoTab.Controls.Add(this.GerneralTabPage);
            this.infoTab.Controls.Add(this.connectTabPage);
            this.infoTab.Controls.Add(this.fileTabPage);
            this.infoTab.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.infoTab.Location = new System.Drawing.Point(0, 291);
            this.infoTab.Name = "infoTab";
            this.infoTab.SelectedIndex = 0;
            this.infoTab.Size = new System.Drawing.Size(728, 223);
            this.infoTab.TabIndex = 2;
            // 
            // GerneralTabPage
            // 
            this.GerneralTabPage.Controls.Add(this.gerneralList);
            this.GerneralTabPage.Location = new System.Drawing.Point(4, 21);
            this.GerneralTabPage.Name = "GerneralTabPage";
            this.GerneralTabPage.Size = new System.Drawing.Size(720, 198);
            this.GerneralTabPage.TabIndex = 0;
            this.GerneralTabPage.Text = "基本信息";
            // 
            // gerneralList
            // 
            this.gerneralList.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                           this.columnHeader8,
                                                                                           this.columnHeader9});
            this.gerneralList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.gerneralList.Location = new System.Drawing.Point(0, 0);
            this.gerneralList.Name = "gerneralList";
            this.gerneralList.Size = new System.Drawing.Size(720, 198);
            this.gerneralList.TabIndex = 0;
            this.gerneralList.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader8
            // 
            this.columnHeader8.Text = "名称";
            this.columnHeader8.Width = 270;
            // 
            // columnHeader9
            // 
            this.columnHeader9.Text = "信息";
            this.columnHeader9.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader9.Width = 420;
            // 
            // connectTabPage
            // 
            this.connectTabPage.Controls.Add(this.connectList);
            this.connectTabPage.Location = new System.Drawing.Point(4, 21);
            this.connectTabPage.Name = "connectTabPage";
            this.connectTabPage.Size = new System.Drawing.Size(720, 198);
            this.connectTabPage.TabIndex = 1;
            this.connectTabPage.Text = "连接信息";
            // 
            // connectList
            // 
            this.connectList.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                          this.columnHeader10,
                                                                                          this.columnHeader11,
                                                                                          this.columnHeader17,
                                                                                          this.columnHeader12,
                                                                                          this.columnHeader13});
            this.connectList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.connectList.Location = new System.Drawing.Point(0, 0);
            this.connectList.Name = "connectList";
            this.connectList.Size = new System.Drawing.Size(720, 198);
            this.connectList.TabIndex = 0;
            this.connectList.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader10
            // 
            this.columnHeader10.Text = "IP";
            this.columnHeader10.Width = 224;
            // 
            // columnHeader11
            // 
            this.columnHeader11.Text = "客户端";
            this.columnHeader11.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader11.Width = 126;
            // 
            // columnHeader12
            // 
            this.columnHeader12.Text = "已下载";
            this.columnHeader12.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader12.Width = 111;
            // 
            // columnHeader13
            // 
            this.columnHeader13.Text = "已上传";
            this.columnHeader13.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader13.Width = 120;
            // 
            // fileTabPage
            // 
            this.fileTabPage.Controls.Add(this.fileList);
            this.fileTabPage.Location = new System.Drawing.Point(4, 21);
            this.fileTabPage.Name = "fileTabPage";
            this.fileTabPage.Size = new System.Drawing.Size(720, 198);
            this.fileTabPage.TabIndex = 2;
            this.fileTabPage.Text = "文件信息";
            // 
            // fileList
            // 
            this.fileList.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
                                                                                       this.columnHeader14,
                                                                                       this.columnHeader15,
                                                                                       this.columnHeader16});
            this.fileList.Dock = System.Windows.Forms.DockStyle.Fill;
            this.fileList.Location = new System.Drawing.Point(0, 0);
            this.fileList.Name = "fileList";
            this.fileList.Size = new System.Drawing.Size(720, 198);
            this.fileList.TabIndex = 0;
            this.fileList.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader14
            // 
            this.columnHeader14.Text = "文件名";
            this.columnHeader14.Width = 411;
            // 
            // columnHeader15
            // 
            this.columnHeader15.Text = "文件大小";
            this.columnHeader15.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader15.Width = 127;
            // 
            // columnHeader16
            // 
            this.columnHeader16.Text = "进度";
            this.columnHeader16.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader16.Width = 108;
            // 
            // refreshTimer
            // 
            this.refreshTimer.Interval = 1000;
            this.refreshTimer.Tick += new System.EventHandler(this.refreshTimer_Tick);
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.Filter = "Torrent文件(*.torrent)|*.torrent|所有文件(*.*)|*.*";
            // 
            // columnHeader17
            // 
            this.columnHeader17.Text = "连接类型";
            // 
            // Form1
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(6, 14);
            this.ClientSize = new System.Drawing.Size(728, 534);
            this.Controls.Add(this.infoTab);
            this.Controls.Add(this.statusBar1);
            this.Controls.Add(this.listDownloader);
            this.Menu = this.mainMenuTitle;
            this.Name = "Form1";
            this.Text = "点量BT内核的演示程序（C#版本）";
            this.Closed += new System.EventHandler(this.Form1_Closed);
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.statusBarPanel2)).EndInit();
            this.infoTab.ResumeLayout(false);
            this.GerneralTabPage.ResumeLayout(false);
            this.connectTabPage.ResumeLayout(false);
            this.fileTabPage.ResumeLayout(false);
            this.ResumeLayout(false);

        }
		#endregion

		/// <summary>
		/// 应用程序的主入口点。
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

        private void menuAddDownload_Click(object sender, System.EventArgs e)
        {
            if (this.openFileDialog1.ShowDialog () != DialogResult.OK)
                return;

            string fileName = this.openFileDialog1.FileName;
            if (m_downloaderTable.Contains (fileName))
            {
                MessageBox.Show ("该种子文件已经存在于下载列表中，不能重复添加!");
                return;
            }

            try
            {
                StartSeed (fileName);
            }
            catch (Exception err)
            {
                MessageBox.Show ("启动下载失败，异常信息为：" + err.Message);
            }
        }

        private bool StartSeed (string torrentFullName)
        {
            TSeedInfo info = new TSeedInfo ();
            info.torrentFile = torrentFullName;
            
            string filePath = Path.GetDirectoryName (torrentFullName);
            filePath = filePath.Replace ("\\", "/");
            filePath = filePath.TrimEnd ('/');
            filePath += "/";

            //IntPtr hPassword = System.Runtime.InteropServices.Marshal.StringToHGlobalAnsi("test"); 如果有密码

            info.hDownloader = DLBT.DLBT_Downloader_Initialize (torrentFullName, filePath, "",
                                            DLBT.DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_REVERSED, false, false, IntPtr.Zero, null, false, false);
            //string url = "magnet:?xt=urn:btih:2c3390072a73b2d403a7741fc65db7d74fbc9fdf";
            //info.hDownloader = DLBT.DLBT_Downloader_Initialize_FromUrl(url, filePath, "", DLBT.DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_SPARSE, false, null, false, false); 
            // 如果有密码
            //if (hPassword != IntPtr.Zero)
            //    System.Runtime.InteropServices.Marshal.FreeHGlobal(hPassword);

            if (info.hDownloader == IntPtr.Zero)
            {
                MessageBox.Show ("添加任务失败！如果是试用版，可能已经达到了试用版的限制！\r\n或者可能是种子文件损坏或者格式不合法，无法打开这个种子文件！");
                return false;
            }

            // 设置P2SP（如果有设置P2SP连接），对一个url，最多可以建立10个连接（多连接提升下载速度）
            DLBT.DLBT_Downloader_SetMaxSessionPerHttp(info.hDownloader, 10);
            

            ListViewItem item = this.listDownloader.Items.Add (new ListViewItem (new string[] {
                                                                                            info.torrentFile,
                                                                                            "",
                                                                                            "",
                                                                                            "",
                                                                                            "",
                                                                                            "",
                                                                                            ""
                                                                                        }));
            
            m_downloaderTable.Add (torrentFullName, info);

            // 刷新刚刚加入的该任务信息
            RefreshDownloaderItem (this.listDownloader.Items.Count - 1);

            return true;
        }

        private void refreshTimer_Tick(object sender, System.EventArgs e)
        {
            this.refreshTimer.Enabled = false;

            RefreshInfo ();

            this.refreshTimer.Enabled = true;
        }

        private void RefreshInfo ()
        {
            RefreshDownloaderList ();

            // 获取一个要显示的任务，显示它的详细信息
            if (this.listDownloader.Items.Count <= 0)
                return;

            ListViewItem item = this.listDownloader.Items[0];
            if (this.listDownloader.SelectedItems.Count > 0)
                item = this.listDownloader.SelectedItems[0];

            if (!m_downloaderTable.ContainsKey (item.SubItems[0].Text))
                return;

            TSeedInfo tInfo = (TSeedInfo)m_downloaderTable[item.SubItems[0].Text];
            IntPtr hDownloader = tInfo.hDownloader;

            // 显示基本信息
            RefreshGerneralInfo (hDownloader);
            // 显示连接信息
            RefreshConnectInfo (hDownloader);
            // 显示文件信息
            RefreshFileInfo (hDownloader);
        }

        // 刷新某一行的Downloader信息（i是index）
        private void RefreshDownloaderItem (int i)
        {
            if (!m_downloaderTable.ContainsKey (this.listDownloader.Items[i].SubItems [0].Text))
            {
                Debug.Assert (false);
                return;
            }

            TSeedInfo info = (TSeedInfo)m_downloaderTable[this.listDownloader.Items[i].SubItems[0].Text];                   
            if (info.hDownloader == IntPtr.Zero)
            {
                Debug.Assert (false);
                return;
            }

            // 以下信息也可直接调用DLBT_GetDownloaderInfo函数，可以获取的更全并且只需调用一次，效率更高些

            //this.listDownloader.Items[i].SubItems[0].Text = DLBT.DLBT_Downloader_GetTorrentName (info.hDownloader);

            DLBT.DLBT_DOWNLOAD_STATE state = DLBT.DLBT_Downloader_GetState (info.hDownloader);
            switch (state)
            {
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_QUEUED:
                    this.listDownloader.Items[i].SubItems[1].Text = "初始化";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_CHECKING_FILES:
                    this.listDownloader.Items[i].SubItems[1].Text = "检查文件";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING_TORRENT:
                    this.listDownloader.Items[i].SubItems[1].Text = "下载种子"; //无种子模式
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING:                            
                    this.listDownloader.Items[i].SubItems[1].Text = "下载中";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_PAUSED:                            
                    this.listDownloader.Items[i].SubItems[1].Text = "暂停";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_FINISHED:
                    this.listDownloader.Items[i].SubItems[1].Text = "下载完成";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_SEEDING:
                    this.listDownloader.Items[i].SubItems[1].Text = "供种中";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_ALLOCATING:
                    this.listDownloader.Items[i].SubItems[1].Text = "分配存储空间";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_ERROR:            
                    this.listDownloader.Items[i].SubItems[1].Text = "出错: " + DLBT.DLBT_Downloader_GetLastError (info.hDownloader);
                    break;
            }

            UInt64 uSize = DLBT.DLBT_Downloader_GetTotalFileSize (info.hDownloader);
            this.listDownloader.Items[i].SubItems[2].Text = ByteToString (uSize.ToString ());

            if (state == DLBT.DLBT_DOWNLOAD_STATE.BTDS_CHECKING_FILES ||
                state == DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING ||
                state == DLBT.DLBT_DOWNLOAD_STATE.BTDS_FINISHED ||
                state == DLBT.DLBT_DOWNLOAD_STATE.BTDS_SEEDING)
            {
                UInt64 uDone = DLBT.DLBT_Downloader_GetDownloadedBytes (info.hDownloader);
                this.listDownloader.Items[i].SubItems[3].Text = ByteToString (uDone.ToString ())
                                                + " [" +  DLBT.DLBT_Downloader_GetProgress (info.hDownloader).ToString () + "%]";

                UInt64 uSpeed = (UInt64)DLBT.DLBT_Downloader_GetDownloadSpeed (info.hDownloader);
                UInt64 uLeft = uSize - uDone;

                if (uSpeed == 0 || uLeft == UInt64.MaxValue)
                    this.listDownloader.Items[i].SubItems[4].Text = "";
                else
                    this.listDownloader.Items[i].SubItems[4].Text = TimeInSecondToStr (uLeft / uSpeed);
            }

            this.listDownloader.Items[i].SubItems[5].Text = ByteToString (DLBT.DLBT_Downloader_GetDownloadSpeed (info.hDownloader).ToString ()) + "/s";
            this.listDownloader.Items[i].SubItems[6].Text = ByteToString (DLBT.DLBT_Downloader_GetUploadSpeed (info.hDownloader).ToString ()) + "/s";
        }

        private void RefreshDownloaderList ()
        {
            for (int i = 0; i < this.listDownloader.Items.Count; i ++)
            {
                try
                {
                    RefreshDownloaderItem (i);                
                }
                catch {}
            }
        }


        private void RefreshGerneralInfo (IntPtr hDownloader)
        {
            if (!this.gerneralList.Visible)
                return;
            
            this.gerneralList.Items.Clear ();

            string str = "";
            // 显示某个下载任务的概况信息
                                    
            string infoHash = DLBT.DLBT_Downloader_GetInfoHash (hDownloader);

            // 显示infoHash时这样转换下会更加直观好看
            if (infoHash.Length > 0)  //无种子开始可能没有infoHash，要等过一会才有
            {
                infoHash = infoHash.ToUpper();
                infoHash = infoHash.Insert(8, " ");
                infoHash = infoHash.Insert(8 + 8 + 1, " ");
                infoHash = infoHash.Insert(8 + 8 + 8 + 2, " ");
                infoHash = infoHash.Insert(8 + 8 + 8 + 8 + 3, " ");
            }
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"Info Hash:", infoHash}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"文件分块信息:", ByteToString (DLBT.DLBT_Downloader_GetPieceCount (hDownloader).ToString ())}));

            // 插入一个间隔的空行
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"", ""}));
        
            str = "速度：[" + ByteToString (DLBT.DLBT_Downloader_GetUploadSpeed (hDownloader).ToString ()) + "/s]";
            str += " 共上传：[" + ByteToString (DLBT.DLBT_Downloader_GetUploadedBytes (hDownloader).ToString ()) + "]";
            str += " 分享率：[" + DLBT.DLBT_Downloader_GetShareRate (hDownloader).ToString () + "]";
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"上传情况:", str}));
        

            int connectedPeers = 0, totalSeeds = 0, seedsConnected = 0, inCompleteCount = 0, totalCurrentSeedCount = 0, totalCurrentPeerCount = 0;
            DLBT.DLBT_Downloader_GetPeerNums (hDownloader, out connectedPeers, out totalSeeds, out seedsConnected, out inCompleteCount, out totalCurrentSeedCount, out  totalCurrentPeerCount);
            
            int allDownloaded = totalSeeds + inCompleteCount;
            if (totalSeeds != -1 && inCompleteCount != -1)
            {
                str = "共" + allDownloaded.ToString () + "人下载过该文件，其中" + totalSeeds.ToString () + 
                    "人已经完成, 当前在线 " + totalCurrentPeerCount.ToString () + " 用户，其中" + 
                    totalCurrentSeedCount.ToString () + "个种子； 已经连接上 " + connectedPeers.ToString () + " 用户, 连接上 " + seedsConnected.ToString () + " 种子";
            }
            else
            {
                str = "当前在线 " + totalCurrentPeerCount.ToString () + " 用户，其中" + totalCurrentSeedCount.ToString () + 
                    "个种子； 已经连接上 " + connectedPeers.ToString () + " 用户, " + seedsConnected.ToString () + " 种子";
            }

            this.gerneralList.Items.Add (new ListViewItem (new string[] {"种子和普通用户情况:", str}));


            // 显示整个内核的概况信息

            DLBT.KERNEL_INFO info = new DLBT.KERNEL_INFO ();
            DLBT.DLBT_GetKernelInfo (ref info);

            // 插入一个间隔的空行
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"", ""}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"内核整体情况如下", ""}));

            if (!info.dhtStarted)
                str = "未启动";
            else
                str = "已启动（连接上:" + info.dhtConnectedNodeNum.ToString () + ", 缓存: " + info.dhtCachedNodeNum.ToString () + "）";

            this.gerneralList.Items.Add (new ListViewItem (new string[] {"DHT:", str}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"端口:", info.port.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"总下载字节数:", info.totalDownloadedByteCount.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"总上传字节数:", info.totalUploadedByteCount.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"总下载速度(/s):", ByteToString (info.totalDownloadSpeed.ToString ()) + "/s"}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"总上传速度(/s):", ByteToString (info.totalUploadSpeed.ToString ()) + "/s"})); 
        }


        private void RefreshConnectInfo (IntPtr hDownloader)
        {
            if (!this.connectList.Visible)
                return;
            
            this.connectList.Items.Clear ();

            int count = 0;
            DLBT.PEER_INFO[] peerInfoList = null;
            DLBT.DLBT_GetDownloaderPeerInfoList (hDownloader, ref count, ref  peerInfoList);

            if (count <= 0 || peerInfoList == null)
                return;

            for (int i = 0; i < count && i < peerInfoList.Length; i++)
            {
                DLBT.PEER_INFO pInfo = peerInfoList[i];
                string peerType = "标准BT";
                if (pInfo.peerInfoFixed.connectionType == 1)
                    peerType = "P2SP";
                else if (pInfo.peerInfoFixed.connectionType == 2)
                    peerType = "udp穿透";

                this.connectList.Items.Add (new ListViewItem (new string[] 
                                {
                                    pInfo.ip,
                                    pInfo.client,
                                    peerType,
                                    ByteToString (pInfo.peerInfoFixed.downloadSpeed.ToString ()), 
                                    ByteToString (pInfo.peerInfoFixed.downloadedBytes.ToString ()),
                                    ByteToString (pInfo.peerInfoFixed.uploadSpeed.ToString ()),
                                    ByteToString (pInfo.peerInfoFixed.uploadedBytes.ToString ())
                                    
                                }));       
            }                
        }

        private void RefreshFileInfo (IntPtr hDownloader)
        {
            if (!this.fileList.Visible)
                return;
            this.fileList.Items.Clear ();

            int fileCount = DLBT.DLBT_Downloader_GetFileCount (hDownloader);
            for (int i = 0; i < fileCount; i ++)
            {
                string file = "";
                if (DLBT.DLBT_Downloader_GetFilePathName (hDownloader, i, ref file, false) != 0)
                    continue;
                
                file = file.Replace ("/", "\\");
                int pos = file.LastIndexOf ("\\");
                if (pos >= 0 && (pos + 1) < file.Length)
                    file = file.Substring (pos + 1);

                Single percent = DLBT.DLBT_Downloader_GetFileProgress (hDownloader, i) * 100;
                string filePercent = percent.ToString () + "%";

                this.fileList.Items.Add (new ListViewItem (new string[] 
                                {
                                    file,
                                    ByteToString (DLBT.DLBT_Downloader_GetFileSize (hDownloader, i).ToString ()),
                                    filePercent                                    
                                }));    
            }
        }

        private string TimeInSecondToStr (UInt64 seconds)
        {
            return string.Format ("{0:D2}:{1:D2}:{2:D2}", (int)(seconds / 3600), (int)((seconds % 3600) / 60), (int)(seconds % 60));
        }

        private string ByteToString (string str)
        {
            int len = str.Length;
            int segLen = len % 3;
            int i = 0;
            string ret ="";
            while (i < len)
            {
                if (i > 0)
                    ret += ",";
                ret += str.Substring (i, segLen);
                i += segLen;
                segLen = 3;
            }
            return ret;
        }

        private void Form1_Closed(object sender, System.EventArgs e)
        {
            this.listDownloader.Clear ();

            try
            {
                foreach (DictionaryEntry de in m_downloaderTable)
                {
                    TSeedInfo info = (TSeedInfo)de.Value;
                    if (info.hDownloader != IntPtr.Zero)
                        DLBT.DLBT_Downloader_Release (info.hDownloader, DLBT.DLBT_RELEASE_FLAG.DLBT_RELEASE_NO_WAIT);
                    info.hDownloader = IntPtr.Zero;
                }
            }
            catch (Exception err)
            {
                MessageBox.Show ("退出时有异常" + err.Message);
            }
            m_downloaderTable.Clear ();

            DLBT.DLBT_Shutdown ();
        }

        private void menuItemAbout_Click(object sender, System.EventArgs e)
        {
            MessageBox.Show ("请访问：http://blog.dolit.cn 或 http://www.dolit.cn 了解更多信息");
        }

        private void menuMakeTorrent_Click(object sender, System.EventArgs e)
        {
            TorrentMaker tm = new TorrentMaker ();
            tm.ShowDialog ();
        }

        private void menuExit_Click(object sender, System.EventArgs e)
        {
            this.Close ();
        }
	}

    public class TSeedInfo
    {
        public IntPtr hDownloader;  
        public string torrentFile; 

        public TSeedInfo ()
        {
            hDownloader = IntPtr.Zero;
            torrentFile = null;
        }
    }
}
