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
	/// Form1 ��ժҪ˵����
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
                MessageBox.Show ("ֻ����ͬʱ����һ������BT�ں˵���ʾ����", this.Text);
                Process.GetCurrentProcess().Kill();
                return;
            }

			//
			// Windows ���������֧���������
			//
			InitializeComponent();

			//
			// TODO: �� InitializeComponent ���ú�����κι��캯������
			//

            string pathName = Application.ExecutablePath;
            DLBT.DLBT_AddAppToWindowsXPFirewall (pathName, "����BT�ں�ʾ������C#�棩");

         
            // ����Ƿ���Ҫ�޸�ϵͳ�Ĳ������������ƣ����Ը�����Ҫѡ���Ƿ��������δ���
            /*
            UInt32 curLimit = DLBT.DLBT_GetCurrentXPLimit (); 
            if (curLimit != 0 && curLimit < 256)
            {
                if (DLBT.DLBT_ChangeXPConnectionLimit (256))
                {
                    string str = string.Format ("����BT��DLBT�ںˣ���⵽��ϵͳ�ϵ���������Ҫ�Ż���Ϊ�˸��õ�����Ч����\r\n ����BT���Զ�������ϵͳ�Ż�����Ҫ�������Ժ�����Ч��������Ч�����ã����ֹ��������Ժ�ʹ�ã�\r\n \r\n ԭ��������������Ϊ%d�����ڸ�Ϊ��256", curLimit);
                    MessageBox.Show (str, "����BT�ں��Զ��Ż�");
                }
            }
            */
        
            DLBT.DLBT_KERNEL_START_PARAM param = new DLBT.DLBT_KERNEL_START_PARAM();            
            param.Init();
            param.startPort = 9010;     // ���԰�9010�˿ڣ����9010�˿�δ��ռ�ã���ʹ�á����򣬼���������һ���˿ڣ�ֱ��endPortָ���ķ�Χ��
            param.endPort = 9010;
            if (!DLBT.DLBT_Startup (ref param, null, false, null))
            {
                MessageBox.Show (" DLBT_Startupʧ�ܣ�");
                return;
            }
            DLBT.DLBT_DHT_Start (0);
            // Ĭ��֧�ּ��ܴ��䣬��ֹ��Ӫ�̷�����ʵ����Ӫʱ���Կ���ʹ��DLBT_ENCRYPT_PROTOCOL_MIX������Դʹ��
            DLBT.DLBT_SetEncryptSetting (DLBT.DLBT_ENCRYPT_OPTION.DLBT_ENCRYPT_FULL, DLBT.DLBT_ENCRYPT_LEVEL.DLBT_ENCRYPT_ALL);

            this.refreshTimer.Enabled = true;
		}

		/// <summary>
		/// ������������ʹ�õ���Դ��
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

		#region Windows ������������ɵĴ���
		/// <summary>
		/// �����֧������ķ��� - ��Ҫʹ�ô���༭���޸�
		/// �˷��������ݡ�
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
            this.menuItem1.Text = "�ļ�";
            // 
            // menuAddDownload
            // 
            this.menuAddDownload.Index = 0;
            this.menuAddDownload.Text = "����BT����";
            this.menuAddDownload.Click += new System.EventHandler(this.menuAddDownload_Click);
            // 
            // menuMakeTorrent
            // 
            this.menuMakeTorrent.Index = 1;
            this.menuMakeTorrent.Text = "��������";
            this.menuMakeTorrent.Click += new System.EventHandler(this.menuMakeTorrent_Click);
            // 
            // menuExit
            // 
            this.menuExit.Index = 2;
            this.menuExit.Text = "�˳�";
            this.menuExit.Click += new System.EventHandler(this.menuExit_Click);
            // 
            // menuItem2
            // 
            this.menuItem2.Index = 1;
            this.menuItem2.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                      this.menuItem4});
            this.menuItem2.Text = "ѡ��";
            // 
            // menuItem4
            // 
            this.menuItem4.Index = 0;
            this.menuItem4.Text = "ʱ���ϵ��������ʱ����ʾ������Ҫ���뿴MFC��ʾ������";
            // 
            // menuItem3
            // 
            this.menuItem3.Index = 2;
            this.menuItem3.MenuItems.AddRange(new System.Windows.Forms.MenuItem[] {
                                                                                      this.menuItemAbout});
            this.menuItem3.Text = "����";
            // 
            // menuItemAbout
            // 
            this.menuItemAbout.Index = 0;
            this.menuItemAbout.Text = "���ڵ���BT�ں�";
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
            this.columnHeader1.Text = "�ļ���";
            this.columnHeader1.Width = 199;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "״̬";
            this.columnHeader2.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader2.Width = 82;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "��С";
            this.columnHeader3.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader3.Width = 76;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "������";
            this.columnHeader4.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader4.Width = 79;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "ʣ��ʱ��";
            this.columnHeader5.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader5.Width = 107;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "�����ٶ�";
            this.columnHeader6.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader6.Width = 87;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "�ϴ��ٶ�";
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
            this.statusBarPanel1.Text = "  ����BT�ں˵���ʾ����  ����BT�ںˣ�����רҵ��P2P�����  ";
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
            this.GerneralTabPage.Text = "������Ϣ";
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
            this.columnHeader8.Text = "����";
            this.columnHeader8.Width = 270;
            // 
            // columnHeader9
            // 
            this.columnHeader9.Text = "��Ϣ";
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
            this.connectTabPage.Text = "������Ϣ";
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
            this.columnHeader11.Text = "�ͻ���";
            this.columnHeader11.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader11.Width = 126;
            // 
            // columnHeader12
            // 
            this.columnHeader12.Text = "������";
            this.columnHeader12.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader12.Width = 111;
            // 
            // columnHeader13
            // 
            this.columnHeader13.Text = "���ϴ�";
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
            this.fileTabPage.Text = "�ļ���Ϣ";
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
            this.columnHeader14.Text = "�ļ���";
            this.columnHeader14.Width = 411;
            // 
            // columnHeader15
            // 
            this.columnHeader15.Text = "�ļ���С";
            this.columnHeader15.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            this.columnHeader15.Width = 127;
            // 
            // columnHeader16
            // 
            this.columnHeader16.Text = "����";
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
            this.openFileDialog1.Filter = "Torrent�ļ�(*.torrent)|*.torrent|�����ļ�(*.*)|*.*";
            // 
            // columnHeader17
            // 
            this.columnHeader17.Text = "��������";
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
            this.Text = "����BT�ں˵���ʾ����C#�汾��";
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
		/// Ӧ�ó��������ڵ㡣
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
                MessageBox.Show ("�������ļ��Ѿ������������б��У������ظ����!");
                return;
            }

            try
            {
                StartSeed (fileName);
            }
            catch (Exception err)
            {
                MessageBox.Show ("��������ʧ�ܣ��쳣��ϢΪ��" + err.Message);
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

            //IntPtr hPassword = System.Runtime.InteropServices.Marshal.StringToHGlobalAnsi("test"); ���������

            info.hDownloader = DLBT.DLBT_Downloader_Initialize (torrentFullName, filePath, "",
                                            DLBT.DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_REVERSED, false, false, IntPtr.Zero, null, false, false);
            //string url = "magnet:?xt=urn:btih:2c3390072a73b2d403a7741fc65db7d74fbc9fdf";
            //info.hDownloader = DLBT.DLBT_Downloader_Initialize_FromUrl(url, filePath, "", DLBT.DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_SPARSE, false, null, false, false); 
            // ���������
            //if (hPassword != IntPtr.Zero)
            //    System.Runtime.InteropServices.Marshal.FreeHGlobal(hPassword);

            if (info.hDownloader == IntPtr.Zero)
            {
                MessageBox.Show ("�������ʧ�ܣ���������ð棬�����Ѿ��ﵽ�����ð�����ƣ�\r\n���߿����������ļ��𻵻��߸�ʽ���Ϸ����޷�����������ļ���");
                return false;
            }

            // ����P2SP�����������P2SP���ӣ�����һ��url�������Խ���10�����ӣ����������������ٶȣ�
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

            // ˢ�¸ոռ���ĸ�������Ϣ
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

            // ��ȡһ��Ҫ��ʾ��������ʾ������ϸ��Ϣ
            if (this.listDownloader.Items.Count <= 0)
                return;

            ListViewItem item = this.listDownloader.Items[0];
            if (this.listDownloader.SelectedItems.Count > 0)
                item = this.listDownloader.SelectedItems[0];

            if (!m_downloaderTable.ContainsKey (item.SubItems[0].Text))
                return;

            TSeedInfo tInfo = (TSeedInfo)m_downloaderTable[item.SubItems[0].Text];
            IntPtr hDownloader = tInfo.hDownloader;

            // ��ʾ������Ϣ
            RefreshGerneralInfo (hDownloader);
            // ��ʾ������Ϣ
            RefreshConnectInfo (hDownloader);
            // ��ʾ�ļ���Ϣ
            RefreshFileInfo (hDownloader);
        }

        // ˢ��ĳһ�е�Downloader��Ϣ��i��index��
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

            // ������ϢҲ��ֱ�ӵ���DLBT_GetDownloaderInfo���������Ի�ȡ�ĸ�ȫ����ֻ�����һ�Σ�Ч�ʸ���Щ

            //this.listDownloader.Items[i].SubItems[0].Text = DLBT.DLBT_Downloader_GetTorrentName (info.hDownloader);

            DLBT.DLBT_DOWNLOAD_STATE state = DLBT.DLBT_Downloader_GetState (info.hDownloader);
            switch (state)
            {
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_QUEUED:
                    this.listDownloader.Items[i].SubItems[1].Text = "��ʼ��";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_CHECKING_FILES:
                    this.listDownloader.Items[i].SubItems[1].Text = "����ļ�";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING_TORRENT:
                    this.listDownloader.Items[i].SubItems[1].Text = "��������"; //������ģʽ
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_DOWNLOADING:                            
                    this.listDownloader.Items[i].SubItems[1].Text = "������";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_PAUSED:                            
                    this.listDownloader.Items[i].SubItems[1].Text = "��ͣ";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_FINISHED:
                    this.listDownloader.Items[i].SubItems[1].Text = "�������";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_SEEDING:
                    this.listDownloader.Items[i].SubItems[1].Text = "������";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_ALLOCATING:
                    this.listDownloader.Items[i].SubItems[1].Text = "����洢�ռ�";
                    break;
                case DLBT.DLBT_DOWNLOAD_STATE.BTDS_ERROR:            
                    this.listDownloader.Items[i].SubItems[1].Text = "����: " + DLBT.DLBT_Downloader_GetLastError (info.hDownloader);
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
            // ��ʾĳ����������ĸſ���Ϣ
                                    
            string infoHash = DLBT.DLBT_Downloader_GetInfoHash (hDownloader);

            // ��ʾinfoHashʱ����ת���»����ֱ�ۺÿ�
            if (infoHash.Length > 0)  //�����ӿ�ʼ����û��infoHash��Ҫ�ȹ�һ�����
            {
                infoHash = infoHash.ToUpper();
                infoHash = infoHash.Insert(8, " ");
                infoHash = infoHash.Insert(8 + 8 + 1, " ");
                infoHash = infoHash.Insert(8 + 8 + 8 + 2, " ");
                infoHash = infoHash.Insert(8 + 8 + 8 + 8 + 3, " ");
            }
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"Info Hash:", infoHash}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�ļ��ֿ���Ϣ:", ByteToString (DLBT.DLBT_Downloader_GetPieceCount (hDownloader).ToString ())}));

            // ����һ������Ŀ���
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"", ""}));
        
            str = "�ٶȣ�[" + ByteToString (DLBT.DLBT_Downloader_GetUploadSpeed (hDownloader).ToString ()) + "/s]";
            str += " ���ϴ���[" + ByteToString (DLBT.DLBT_Downloader_GetUploadedBytes (hDownloader).ToString ()) + "]";
            str += " �����ʣ�[" + DLBT.DLBT_Downloader_GetShareRate (hDownloader).ToString () + "]";
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�ϴ����:", str}));
        

            int connectedPeers = 0, totalSeeds = 0, seedsConnected = 0, inCompleteCount = 0, totalCurrentSeedCount = 0, totalCurrentPeerCount = 0;
            DLBT.DLBT_Downloader_GetPeerNums (hDownloader, out connectedPeers, out totalSeeds, out seedsConnected, out inCompleteCount, out totalCurrentSeedCount, out  totalCurrentPeerCount);
            
            int allDownloaded = totalSeeds + inCompleteCount;
            if (totalSeeds != -1 && inCompleteCount != -1)
            {
                str = "��" + allDownloaded.ToString () + "�����ع����ļ�������" + totalSeeds.ToString () + 
                    "���Ѿ����, ��ǰ���� " + totalCurrentPeerCount.ToString () + " �û�������" + 
                    totalCurrentSeedCount.ToString () + "�����ӣ� �Ѿ������� " + connectedPeers.ToString () + " �û�, ������ " + seedsConnected.ToString () + " ����";
            }
            else
            {
                str = "��ǰ���� " + totalCurrentPeerCount.ToString () + " �û�������" + totalCurrentSeedCount.ToString () + 
                    "�����ӣ� �Ѿ������� " + connectedPeers.ToString () + " �û�, " + seedsConnected.ToString () + " ����";
            }

            this.gerneralList.Items.Add (new ListViewItem (new string[] {"���Ӻ���ͨ�û����:", str}));


            // ��ʾ�����ں˵ĸſ���Ϣ

            DLBT.KERNEL_INFO info = new DLBT.KERNEL_INFO ();
            DLBT.DLBT_GetKernelInfo (ref info);

            // ����һ������Ŀ���
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"", ""}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�ں������������", ""}));

            if (!info.dhtStarted)
                str = "δ����";
            else
                str = "��������������:" + info.dhtConnectedNodeNum.ToString () + ", ����: " + info.dhtCachedNodeNum.ToString () + "��";

            this.gerneralList.Items.Add (new ListViewItem (new string[] {"DHT:", str}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�˿�:", info.port.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�������ֽ���:", info.totalDownloadedByteCount.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"���ϴ��ֽ���:", info.totalUploadedByteCount.ToString ()}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"�������ٶ�(/s):", ByteToString (info.totalDownloadSpeed.ToString ()) + "/s"}));
            this.gerneralList.Items.Add (new ListViewItem (new string[] {"���ϴ��ٶ�(/s):", ByteToString (info.totalUploadSpeed.ToString ()) + "/s"})); 
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
                string peerType = "��׼BT";
                if (pInfo.peerInfoFixed.connectionType == 1)
                    peerType = "P2SP";
                else if (pInfo.peerInfoFixed.connectionType == 2)
                    peerType = "udp��͸";

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
                MessageBox.Show ("�˳�ʱ���쳣" + err.Message);
            }
            m_downloaderTable.Clear ();

            DLBT.DLBT_Shutdown ();
        }

        private void menuItemAbout_Click(object sender, System.EventArgs e)
        {
            MessageBox.Show ("����ʣ�http://blog.dolit.cn �� http://www.dolit.cn �˽������Ϣ");
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
