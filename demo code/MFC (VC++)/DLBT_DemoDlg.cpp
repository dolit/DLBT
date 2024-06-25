//=======================================================================================
//	Copyright:	Copyright (c) 点量软件有限公司 
//  版权所有：	点量软件有限公司 (QQ:52401692   <support at dolit.cn>)
//
//              如果您是个人作为非商业目的使用，您可以自由、免费的使用点量BT内核库和演示程序，
//              也期待收到您反馈的意见和建议，共同改进点量BT
//              如果您是商业使用，那么您需要联系作者申请产品的商业授权。
//              点量BT内核库所有演示程序的代码对外公开，内核库的代码只限付费用户个人使用。
//        
//  官方网站：  http://www.dolit.cn      http://blog.dolit.cn
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
// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// 对话框数据
	enum { IDD = IDD_ABOUTBOX };

    CUrlStatic m_urlStatic;
    CUrlStatic m_urlStatic2;

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

// 实现
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


// CDLBT_DemoDlg 对话框



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


// CDLBT_DemoDlg 消息处理程序

BOOL CDLBT_DemoDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// 将\“关于...\”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
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

	// 设置此对话框的图标。当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

    m_timer = NULL;

	// 界面初始化代码
    m_downloaderList.Init ();
    m_infoTab.Init ();

    m_statusBar.Create(WS_CHILD|WS_VISIBLE|SBT_OWNERDRAW, CRect(0,0,0,0), this, 0);

	int strPartDim[2]= {450, -1};
	m_statusBar.SetParts(2, strPartDim);
    CString str;
    str.LoadString (IDS_STATUSBAR_TEXT);
	m_statusBar.SetText (str, 0, 0);
    m_statusBar.SetText (_T (""), 1, 0);

    
    // BT模块代码 
    TCHAR path[MAX_PATH];  

    // 将应用程序加入ICF防火墙的例外，以免被用户选择了"阻止该程序"
    HMODULE hModule = GetModuleHandle (NULL);
    if (hModule != NULL && GetModuleFileName(hModule, path, MAX_PATH) != 0)
    {
        DLBT_AddAppToWindowsXPFirewall (CT2W(path), L"点量BT内核示例程序");
    }  


    // 检测是否需要修改系统的并发连接数限制，可以根据需要选择是否打开下面这段代码
    /*
    DWORD curLimit = DLBT_GetCurrentXPLimit (); 
    if (curLimit != 0 && curLimit < 256)
    {
        if (DLBT_ChangeXPConnectionLimit (256))
        {
            CString str;
            str.Format (_T ("点量BT（DLBT内核）检测到您系统上的连接数需要优化，为了更好的下载效果，\r\n 点量BT已自动进行了系统优化，需要重启电脑后方能生效，如下载效果不好，请手工重启电脑后使用！\r\n \r\n 原来的连接限制数为%d，现在改为了256"), curLimit);

            MessageBox (str, _T ("点量BT自动优化"), MB_OK);
        }
    }*/

    // 启动点量BT内核
    DLBT_KERNEL_START_PARAM param;
    param.startPort = 9010;     // 尝试绑定9010端口，如果9010端口未被占用，则使用。否则，继续尝试下一个端口，直到endPort指定的范围。
    param.endPort = 9030;
	DLBT_Startup (&param);    
	DLBT_DHT_Start ();

    // 默认支持加密传输，防止运营商封锁，实际运营时可以考虑使用DLBT_ENCRYPT_PROTOCOL_MIX减少资源使用
    DLBT_SetEncryptSetting (DLBT_ENCRYPT_FULL, DLBT_ENCRYPT_ALL);
	
	return TRUE;  // 除非设置了控件的焦点，否则返回 TRUE
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

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CDLBT_DemoDlg::OnPaint() 
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标显示。
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

// 制作种子
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

// 程序的整体设置
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

// 关闭时的清理
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

// 下载列表中显示右键菜单
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

        // 演示程序简单起见，默认对所有使用代理设置，实际应用中，您可以自由选择合适的应用范围
        DLBT_SetProxy (ps, DLBT_PROXY_TO_ALL);

        // Encrypt
        DLBT_SetEncryptSetting ((DLBT_ENCRYPT_OPTION)dlg.m_encryptOptionSel, (DLBT_ENCRYPT_LEVEL)dlg.m_encryptLevelSel);
        DLBT_SetP2PTransferAsHttp(dlg.m_bP2PAsHttpChecked, true);   //默认支持接受Http伪装的连接，但自己不主动发起伪装。如果需要发起伪装，需要设置m_bP2PAsHttpChecked
    }
}

void CDLBT_DemoDlg::OnSequenceDownload()
{
    m_downloaderList.OnSequenceDownload ();
}
