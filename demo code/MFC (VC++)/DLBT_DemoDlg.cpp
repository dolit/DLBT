//=======================================================================================
//	Copyright:	Copyright (c) ����������޹�˾ 
//  ��Ȩ���У�	����������޹�˾ (QQ:52401692   <support at dolit.cn>)
//
//              ������Ǹ�����Ϊ����ҵĿ��ʹ�ã����������ɡ���ѵ�ʹ�õ���BT�ں˿����ʾ����
//              Ҳ�ڴ��յ�������������ͽ��飬��ͬ�Ľ�����BT
//              ���������ҵʹ�ã���ô����Ҫ��ϵ���������Ʒ����ҵ��Ȩ��
//              ����BT�ں˿�������ʾ����Ĵ�����⹫�����ں˿�Ĵ���ֻ�޸����û�����ʹ�á�
//        
//  �ٷ���վ��  http://www.dolit.cn      http://blog.dolit.cn
//
//=======================================================================================

#include "stdafx.h"
#include "DLBT_Demo.h"
#include "DLBT_DemoDlg.h"
#include ".\dlbt_demodlg.h"

#include "AddFileDialog.h"
#include "MakeTorrentDlg.h"
#include "SettingDlg.h"
#include "UrlStatic.h"
#include "AdvSettingDlg.h"
#include "utils.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


#define REFRESH_TIMER  1
// ����Ӧ�ó��򡰹��ڡ��˵���� CAboutDlg �Ի���

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// �Ի�������
	enum { IDD = IDD_ABOUTBOX };

    CUrlStatic m_urlStatic;
    CUrlStatic m_urlStatic2;

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

// ʵ��
protected:
    CFont m_fontUnderLine;
    virtual BOOL OnInitDialog();
	DECLARE_MESSAGE_MAP()
public:
    afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
//    afx_msg void OnStnClickedHomePage();
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
    ON_WM_CTLCOLOR()
//    ON_STN_CLICKED(IDC_HOME_PAGE, OnStnClickedHomePage)
END_MESSAGE_MAP()

BOOL CAboutDlg::OnInitDialog() 
{
	CDialog::OnInitDialog();

    CFont * fnt = GetFont ();
    LOGFONT lf;
    fnt->GetLogFont (&lf);
    lf.lfUnderline = TRUE;
    m_fontUnderLine.CreateFontIndirect (&lf);

    m_urlStatic.SubclassDlgItem (IDC_HOME_PAGE, this);
    m_urlStatic.Init ();
    m_urlStatic.SetUrl ("http://blog.dolit.cn");

    m_urlStatic2.SubclassDlgItem (IDC_HOME_PAGE2, this);
    m_urlStatic2.Init ();
    m_urlStatic2.SetUrl ("http://www.dolit.cn");

	return TRUE;
}

HBRUSH CAboutDlg::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
    HBRUSH hbr = CDialog::OnCtlColor(pDC, pWnd, nCtlColor);

    if (pWnd->m_hWnd == GetDlgItem (IDC_HOME_PAGE)->m_hWnd
        || pWnd->m_hWnd == GetDlgItem (IDC_HOME_PAGE2)->m_hWnd)
    {
        pDC->SetTextColor (RGB(0,0,255));
        pDC->SelectObject (&m_fontUnderLine);
    }
    return hbr;
}


// CDLBT_DemoDlg �Ի���



CDLBT_DemoDlg::CDLBT_DemoDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CDLBT_DemoDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CDLBT_DemoDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_LIST_DOWNLOADER, m_downloaderList);
    DDX_Control(pDX, IDC_TAB_INFO, m_infoTab);
}

BEGIN_MESSAGE_MAP(CDLBT_DemoDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
    ON_COMMAND(ID_MENU_EXIT, OnMenuExit)
    ON_COMMAND(ID_MENU_ADD_FILE, OnMenuAddFile)
    ON_COMMAND(ID_MENU_MAKE_TORRENT, OnMenuMakeTorrent)
    ON_COMMAND(ID_MENU_CONFIG, OnMenuConfig)
    ON_COMMAND(ID_MENU_ABOUT, OnMenuAbout)
    ON_COMMAND(ID_STOP_MENU, OnStopMenu)
    ON_COMMAND(ID_PAUSE_MENU, OnPauseMenu)
    ON_COMMAND(ID_RESUME_MENU, OnResumeMenu)
    ON_COMMAND(ID_SETTING_MENU, OnSettingMenu)
    ON_COMMAND(ID_OPEN_FOLDER_MENU, OnOpenFolderMenu)
    ON_WM_CLOSE()
    ON_WM_TIMER()  
    ON_MESSAGE(WM_SHOW_CONTEXT_MENU, OnShowContextMenu)
    ON_COMMAND(ID_MENU_ADV_CONFIG, OnMenuAdvConfig)
    ON_COMMAND(ID__32798, &CDLBT_DemoDlg::OnSequenceDownload)
END_MESSAGE_MAP()


// CDLBT_DemoDlg ��Ϣ�������

BOOL CDLBT_DemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// ��\������...\���˵�����ӵ�ϵͳ�˵��С�

	// IDM_ABOUTBOX ������ϵͳ���Χ�ڡ�
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// ���ô˶Ի����ͼ�ꡣ��Ӧ�ó��������ڲ��ǶԻ���ʱ����ܽ��Զ�
	//  ִ�д˲���
	SetIcon(m_hIcon, TRUE);			// ���ô�ͼ��
	SetIcon(m_hIcon, FALSE);		// ����Сͼ��

    m_timer = NULL;

	// �����ʼ������
    m_downloaderList.Init ();
    m_infoTab.Init ();

    m_statusBar.Create(WS_CHILD|WS_VISIBLE|SBT_OWNERDRAW, CRect(0,0,0,0), this, 0);

	int strPartDim[2]= {450, -1};
	m_statusBar.SetParts(2, strPartDim);
    CString str;
    str.LoadString (IDS_STATUSBAR_TEXT);
	m_statusBar.SetText (str, 0, 0);
    m_statusBar.SetText (_T (""), 1, 0);

    
    // BTģ����� 
    TCHAR path[MAX_PATH];  

    // ��Ӧ�ó������ICF����ǽ�����⣬���ⱻ�û�ѡ����"��ֹ�ó���"
    HMODULE hModule = GetModuleHandle (NULL);
    if (hModule != NULL && GetModuleFileName(hModule, path, MAX_PATH) != 0)
    {
        DLBT_AddAppToWindowsXPFirewall (CT2W(path), L"����BT�ں�ʾ������");
    }  


    // ����Ƿ���Ҫ�޸�ϵͳ�Ĳ������������ƣ����Ը�����Ҫѡ���Ƿ��������δ���
    /*
    DWORD curLimit = DLBT_GetCurrentXPLimit (); 
    if (curLimit != 0 && curLimit < 256)
    {
        if (DLBT_ChangeXPConnectionLimit (256))
        {
            CString str;
            str.Format (_T ("����BT��DLBT�ںˣ���⵽��ϵͳ�ϵ���������Ҫ�Ż���Ϊ�˸��õ�����Ч����\r\n ����BT���Զ�������ϵͳ�Ż�����Ҫ�������Ժ�����Ч��������Ч�����ã����ֹ��������Ժ�ʹ�ã�\r\n \r\n ԭ��������������Ϊ%d�����ڸ�Ϊ��256"), curLimit);

            MessageBox (str, _T ("����BT�Զ��Ż�"), MB_OK);
        }
    }*/

    // ��������BT�ں�
    DLBT_KERNEL_START_PARAM param;
    param.startPort = 9010;     // ���԰�9010�˿ڣ����9010�˿�δ��ռ�ã���ʹ�á����򣬼���������һ���˿ڣ�ֱ��endPortָ���ķ�Χ��
    param.endPort = 9030;
	DLBT_Startup (&param);    
	DLBT_DHT_Start ();

    // Ĭ��֧�ּ��ܴ��䣬��ֹ��Ӫ�̷�����ʵ����Ӫʱ���Կ���ʹ��DLBT_ENCRYPT_PROTOCOL_MIX������Դʹ��
    DLBT_SetEncryptSetting (DLBT_ENCRYPT_FULL, DLBT_ENCRYPT_ALL);
	
	return TRUE;  // ���������˿ؼ��Ľ��㣬���򷵻� TRUE
}

void CDLBT_DemoDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// �����Ի��������С����ť������Ҫ����Ĵ���
//  �����Ƹ�ͼ�ꡣ����ʹ���ĵ�/��ͼģ�͵� MFC Ӧ�ó���
//  �⽫�ɿ���Զ���ɡ�

void CDLBT_DemoDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // ���ڻ��Ƶ��豸������

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// ʹͼ���ڹ��������о���
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// ����ͼ��
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//���û��϶���С������ʱϵͳ���ô˺���ȡ�ù����ʾ��
HCURSOR CDLBT_DemoDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CDLBT_DemoDlg::OnMenuExit()
{
    OnClose ();
    OnOK ();
}

void CDLBT_DemoDlg::OnMenuAddFile()
{
    CAddFileDialog dlg;
    if (dlg.DoModal () == IDOK)
    {
        HANDLE hDownloader = NULL;
        if ((hDownloader = m_downloaderList.AddDownloader (dlg.m_torrentPath, dlg.m_savePath)) != NULL)
        {
            if (m_timer == NULL)
                m_timer = SetTimer (REFRESH_TIMER, 1000, NULL);
        }
    }
}

// ��������
void CDLBT_DemoDlg::OnMenuMakeTorrent()
{
    CMakeTorrentDlg dlg;
    if (dlg.DoModal () == IDOK && dlg.m_bAutoUpload && !dlg.m_torrentPath.IsEmpty() && !dlg.m_filePath.IsEmpty()
        && GetFileAttributes(dlg.m_torrentPath) != 0xFFFFFFFF)
    {
        HANDLE hDownloader = NULL;
        if ((hDownloader = m_downloaderList.AddDownloader (dlg.m_torrentPath, GetFilePath(dlg.m_filePath))) != NULL)
        {
            if (m_timer == NULL)
                m_timer = SetTimer (REFRESH_TIMER, 1000, NULL);
        }
    }
}

// �������������
void CDLBT_DemoDlg::OnMenuConfig()
{
    CSettingDlg dlg;
    if (dlg.DoModal () == IDOK)
    {
        DLBT_SetDownloadSpeedLimit (_ttoi (dlg.m_downloadSpeedLimit) * 1024);
        DLBT_SetUploadSpeedLimit (_ttoi (dlg.m_uploadSpeedLimit) * 1024);

        USES_CONVERSION; 
        if (!dlg.m_strReportIP.IsEmpty () && dlg.m_strReportIP != _T ("0.0.0.0"))
            DLBT_SetReportIP (T2A ((LPTSTR)(LPCTSTR)dlg.m_strReportIP));

        if (dlg.m_checkDHT)
            DLBT_DHT_Start ();
        else
            DLBT_DHT_Stop ();
    }
}

void CDLBT_DemoDlg::OnMenuAbout()
{
    CAboutDlg dlgAbout;
	dlgAbout.DoModal();
}

// �ر�ʱ������
void CDLBT_DemoDlg::OnClose()
{
    m_downloaderList.Clear ();
    DLBT_PreShutdown ();
    CDialog::OnClose();
}

void CDLBT_DemoDlg::OnTimer(UINT nIDEvent)
{
    if (nIDEvent == REFRESH_TIMER)
    {
		KillTimer(nIDEvent);
        m_downloaderList.Refresh ();

        HANDLE hDownloader = m_downloaderList.GetDisplayDownloader ();
        m_infoTab.Refresh (hDownloader);

		SetTimer(nIDEvent, 1000, NULL);
    }
    CDialog::OnTimer(nIDEvent);
}


void CDLBT_DemoDlg::OnStopMenu()
{
    m_downloaderList.OnStopMenu ();
}

void CDLBT_DemoDlg::OnPauseMenu()
{
    m_downloaderList.OnPauseMenu ();
}

void CDLBT_DemoDlg::OnResumeMenu()
{
    m_downloaderList.OnResumeMenu ();
}

void CDLBT_DemoDlg::OnSettingMenu()
{
    m_downloaderList.OnSettingMenu ();
}

void CDLBT_DemoDlg::OnOpenFolderMenu()
{
    m_downloaderList.OnOpenFolderMenu ();
}

// �����б�����ʾ�Ҽ��˵�
LRESULT CDLBT_DemoDlg::OnShowContextMenu(WPARAM wparam, LPARAM lparam)
{
    CMenu menu;
    menu.LoadMenu(IDR_MENU2);
    CMenu *pPopup=menu.GetSubMenu(0);
    ASSERT(pPopup);
    POINT point;
    point.x = (LONG)wparam;
    point.y = (LONG)lparam;
    
    pPopup->TrackPopupMenu (TPM_LEFTALIGN | TPM_RIGHTBUTTON, point.x, point.y, this);
    return S_OK;
}

void CDLBT_DemoDlg::OnMenuAdvConfig()
{
    CAdvSettingDlg dlg;
    if (dlg.DoModal () == IDOK)
    {
        DLBT_PROXY_SETTING ps;

        USES_CONVERSION; 

        strcpy (ps.proxyHost, T2A ((LPTSTR)(LPCTSTR)dlg.m_host));
        ps.nPort = _ttoi (dlg.m_port);
        strcpy (ps.proxyUser, T2A ((LPTSTR)(LPCTSTR)dlg.m_userName));
        strcpy (ps.proxyPass, T2A ((LPTSTR)(LPCTSTR)dlg.m_password));
        ps.proxyType = (DLBT_PROXY_SETTING::DLBT_PROXY_TYPE)dlg.m_proxyTypeSel;

        // ��ʾ����������Ĭ�϶�����ʹ�ô������ã�ʵ��Ӧ���У�����������ѡ����ʵ�Ӧ�÷�Χ
        DLBT_SetProxy (ps, DLBT_PROXY_TO_ALL);

        // Encrypt
        DLBT_SetEncryptSetting ((DLBT_ENCRYPT_OPTION)dlg.m_encryptOptionSel, (DLBT_ENCRYPT_LEVEL)dlg.m_encryptLevelSel);
        DLBT_SetP2PTransferAsHttp(dlg.m_bP2PAsHttpChecked, true);   //Ĭ��֧�ֽ���Httpαװ�����ӣ����Լ�����������αװ�������Ҫ����αװ����Ҫ����m_bP2PAsHttpChecked
    }
}

void CDLBT_DemoDlg::OnSequenceDownload()
{
    m_downloaderList.OnSequenceDownload ();
}
