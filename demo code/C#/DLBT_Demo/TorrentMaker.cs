using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Windows.Forms.Design;
using System.Threading;
using System.Runtime.InteropServices;

namespace DLBT_Demo
{
    /// <summary>
    /// TorrentMaker ��ժҪ˵����
    /// </summary>
    public class TorrentMaker : System.Windows.Forms.Form
    {
        private System.Windows.Forms.Button browseFolder;
        private System.Windows.Forms.Button makeTorrent;
        private System.Windows.Forms.TextBox filePathText;
        private System.ComponentModel.IContainer components;

        private IntPtr m_hTorrent = IntPtr.Zero;
        private int m_percent = 0;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button cancelBt;
        private IntPtr m_bCancel = IntPtr.Zero;
		private bool   m_canceled = false;

        public TorrentMaker()
        {
            //
            // Windows ���������֧���������
            //
            InitializeComponent();

            //
            // TODO: �� InitializeComponent ���ú�����κι��캯������
            //
        }

        /// <summary>
        /// ������������ʹ�õ���Դ��
        /// </summary>
        protected override void Dispose( bool disposing )
        {
            if( disposing )
            {
                if(components != null)
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
            this.makeTorrent = new System.Windows.Forms.Button();
            this.filePathText = new System.Windows.Forms.TextBox();
            this.browseFolder = new System.Windows.Forms.Button();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.label1 = new System.Windows.Forms.Label();
            this.cancelBt = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // makeTorrent
            // 
            this.makeTorrent.Location = new System.Drawing.Point(48, 168);
            this.makeTorrent.Name = "makeTorrent";
            this.makeTorrent.Size = new System.Drawing.Size(72, 24);
            this.makeTorrent.TabIndex = 1;
            this.makeTorrent.Text = "��������";
            this.makeTorrent.Click += new System.EventHandler(this.makeTorrent_Click);
            // 
            // filePathText
            // 
            this.filePathText.Location = new System.Drawing.Point(24, 16);
            this.filePathText.Name = "filePathText";
            this.filePathText.Size = new System.Drawing.Size(176, 21);
            this.filePathText.TabIndex = 2;
            this.filePathText.Text = "";
            // 
            // browseFolder
            // 
            this.browseFolder.Location = new System.Drawing.Point(216, 16);
            this.browseFolder.Name = "browseFolder";
            this.browseFolder.Size = new System.Drawing.Size(56, 24);
            this.browseFolder.TabIndex = 3;
            this.browseFolder.Text = "���";
            this.browseFolder.Click += new System.EventHandler(this.browseFolder_Click);
            // 
            // timer1
            // 
            this.timer1.Enabled = true;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(24, 80);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(224, 64);
            this.label1.TabIndex = 4;
            this.label1.Text = "��ǰ�������ȣ�";
            // 
            // cancelBt
            // 
            this.cancelBt.Enabled = true;
            this.cancelBt.Location = new System.Drawing.Point(144, 168);
            this.cancelBt.Name = "cancelBt";
            this.cancelBt.Size = new System.Drawing.Size(96, 24);
            this.cancelBt.TabIndex = 5;
            this.cancelBt.Text = "ȡ��";
            this.cancelBt.Click += new System.EventHandler(this.cancelBt_Click);
            // 
            // TorrentMaker
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(6, 14);
            this.ClientSize = new System.Drawing.Size(292, 266);
            this.Controls.Add(this.cancelBt);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.browseFolder);
            this.Controls.Add(this.filePathText);
            this.Controls.Add(this.makeTorrent);
            this.Name = "TorrentMaker";
            this.Text = "TorrentMaker";
            this.ResumeLayout(false);

        }
        #endregion

        private void browseFolder_Click(object sender, System.EventArgs e)
        {
            FolderDialog fd = new FolderDialog ();
            
            if (fd.DisplayDialog () == DialogResult.OK)
            {
                this.filePathText.Text = fd.Path.ToString ();
            }
        }

        private void makeTorrent_Click(object sender, System.EventArgs e)
        {
            if (this.filePathText.Text.Trim ().Length <= 0)
            {
                MessageBox.Show ("��ѡ����Ҫ�������ӵ��ļ��л��������ļ���·��!");
                return;
            }

            if (m_hTorrent != IntPtr.Zero)
            {
                MessageBox.Show ("�������!");
                return;
            }

			m_canceled = false;
            m_bCancel = Marshal.AllocCoTaskMem(4);
			Marshal.WriteInt32(m_bCancel, 0);
            m_percent = 0;
            Thread th = new Thread (new ThreadStart (ThreadMakeTorrent));
            th.Start ();            
        }

        private void ThreadMakeTorrent ()
        {
            if (m_hTorrent == IntPtr.Zero)
            {
			
				m_hTorrent = DLBT.DLBT_CreateTorrent (0, this.filePathText.Text, "����BT", "http://www.dolit.cn", null, 
                                        DLBT.DLBT_TORRENT_TYPE.USE_PUBLIC_DHT_NODE, ref m_percent, m_bCancel,
                                        -1, false);

                if (m_hTorrent != IntPtr.Zero)
                {
                    DLBT.DLBT_Torrent_AddTracker (m_hTorrent, "http://127.0.0.1:6969/announce", 0);
                    DLBT.DLBT_SaveTorrentFile (m_hTorrent, "D:\\a.torrent", null, false, null);
                    DLBT.DLBT_ReleaseTorrent (m_hTorrent);
                    m_hTorrent = IntPtr.Zero;
                    
                    m_percent = 100;

                    MessageBox.Show ("������ɣ�");
                }
                else if (!m_canceled)
                {
                    MessageBox.Show ("����ʧ�ܣ�");
                }
            }

			if (m_bCancel != IntPtr.Zero)
				Marshal.FreeCoTaskMem(m_bCancel);
			m_bCancel = IntPtr.Zero;
        }

        private void cancelBt_Click(object sender, System.EventArgs e)
        {
			m_canceled = true;
			if (m_bCancel != IntPtr.Zero)
				Marshal.WriteInt32(m_bCancel, 1);
        }

        private void timer1_Tick(object sender, System.EventArgs e)
        {
            if (!this.makeTorrent.Enabled)
            {
                this.label1.Text = "��ǰ���ȣ�" + m_percent.ToString () + "%";
            }
        }
    }

    public class FolderDialog : FolderNameEditor
    {
        FolderNameEditor.FolderBrowser fDialog = new
            System.Windows.Forms.Design.FolderNameEditor.FolderBrowser();

        public FolderDialog()
        {
        }

        public DialogResult DisplayDialog()
        {
            return DisplayDialog ("��ѡ��һ���ļ���");
        }

        public DialogResult DisplayDialog(string description)
        {
            fDialog.Description = description;
            return fDialog.ShowDialog();
        }

        public string Path
        {
            get
            { 
                return fDialog.DirectoryPath;
            }
        }

        ~FolderDialog()
        {
            fDialog.Dispose();
        }
    }


}
