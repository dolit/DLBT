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
#include "MTProgressDlg.h"
#include ".\mtprogressdlg.h"


// CMTProgressDlg 对话框

IMPLEMENT_DYNAMIC(CMTProgressDlg, CDialog)
CMTProgressDlg::CMTProgressDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMTProgressDlg::IDD, pParent)
{
    m_pThread = NULL;
    m_bCancel = FALSE;
}

CMTProgressDlg::~CMTProgressDlg()
{
}

void CMTProgressDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_PROGRESS1, m_progressCtrl);
}


BEGIN_MESSAGE_MAP(CMTProgressDlg, CDialog)
    ON_BN_CLICKED(IDCANCEL, OnBnClickedCancel)
    ON_WM_TIMER()
END_MESSAGE_MAP()

BOOL CMTProgressDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    SetTimer (1, 100, NULL);

    m_result = MT_RUNNING;
    m_pThread = AfxBeginThread (StaticMakeTorrentThreadProc, this, THREAD_PRIORITY_NORMAL, 0);
	if (m_pThread == NULL)
        return FALSE;

    return TRUE;
}

void CMTProgressDlg::Run ()
{
    // m_progressPos 仅在该函数内修改，进度显示的线程（Timer线程只读，因此无需lock）
    m_progressPos = 0;
    m_result = MT_RUNNING;

    if (m_bCancel)
    {
        m_result = MT_CANCEL;
        return;
    }
    
    HANDLE hTorrent = DLBT_CreateTorrent (m_pieceSize * 1024, CT2W(m_fileName), CT2W(m_creator), CT2W(m_creatorUrl), CT2W(m_comment), m_torrentType, &m_progressPos, &m_bCancel);
    if (hTorrent == NULL)
    {
        m_result = MT_CREATE_TORRENT_FAILED;
        return;
    }

    m_announceUrl.Trim();
    m_announceUrl += _T("\n");
    // 添加announce
    int pos = 0, tier = 0;
    while ((pos = m_announceUrl.Find (_T ("\n"))) >= 0)
    {
        CString url = pos > 0 ? m_announceUrl.Left (pos) : _T ("");
        url.Trim ();
        if (url.IsEmpty ())
        {
            m_announceUrl = m_announceUrl.Right (m_announceUrl.GetLength () - pos - 1).Trim ();
            continue;
        }

        // 添加同组等效的Tracker，以|分隔
        int groupPos = 0;
        while ((groupPos = url.Find ('|')) >= 0)
        {
            CString groupUrl = groupPos > 0 ? url.Left (groupPos) : _T ("");
            if (groupUrl.IsEmpty ())
                continue;

            DLBT_Torrent_AddTracker (hTorrent, CT2W(groupUrl), tier);
            url = url.Right (url.GetLength () - groupPos - 1);
        }
        DLBT_Torrent_AddTracker (hTorrent, CT2W(url), tier);
        
        tier ++;
        m_announceUrl = m_announceUrl.Right (m_announceUrl.GetLength () - pos - 1).Trim ();
		if (!m_announceUrl.IsEmpty())
            m_announceUrl += "\n";
    }

    if (!m_announceUrl.Trim ().IsEmpty ())
    {
        DLBT_Torrent_AddTracker (hTorrent, CT2W(m_announceUrl.Trim ()), tier);
    }

    // 添加Http源
    while ((pos = m_httpUrl.Find ('|')) >= 0)
    {
        CString url = pos > 0 ? m_httpUrl.Left (pos) : _T ("");
        if (url.IsEmpty ())
            continue;
        DLBT_Torrent_AddHttpUrl (hTorrent, CT2W(url));
        m_httpUrl = m_httpUrl.Right (m_httpUrl.GetLength () - pos - 1);
    }
    if (!m_httpUrl.IsEmpty ())
        DLBT_Torrent_AddHttpUrl (hTorrent,CT2W(m_httpUrl));

    if (GetFileAttributes (m_torrentPath) != 0xFFFFFFFF)
        DeleteFile (m_torrentPath);

    if (m_bCancel)
    {
        DLBT_ReleaseTorrent (hTorrent);  
        m_result = MT_CANCEL;
        return;
    }
    
    if (DLBT_SaveTorrentFile (hTorrent, CT2W(m_torrentPath)) != S_OK)
    {        
        m_result = MT_SAVE_TORRENT_FAILED;
        DLBT_ReleaseTorrent (hTorrent);   
        return;
    }

    m_result = MT_SUCCESS;
    m_progressPos = 100;
    DLBT_ReleaseTorrent (hTorrent);   
}

// CMTProgressDlg 消息处理程序

void CMTProgressDlg::OnOK()
{
	ASSERT (m_progressPos >= 100 || m_pThread == NULL || m_pThread->m_hThread == NULL || m_result < MT_RUNNING);
    CDialog::OnOK();
}

void CMTProgressDlg::OnBnClickedCancel()
{
    m_bCancel = TRUE;

    if (m_pThread != NULL && m_pThread->m_hThread != NULL)
    {
	    WaitForSingleObject (m_pThread->m_hThread, INFINITE);
    }

    OnCancel();
}

void CMTProgressDlg::OnTimer(UINT nIDEvent)
{    
    if (m_progressCtrl.GetPos () != m_progressPos)
        m_progressCtrl.SetPos (m_progressPos);

    if (m_progressPos >= 100 || m_pThread == NULL || m_pThread->m_hThread == NULL
        || m_result < MT_RUNNING )
    {
        GetDlgItem (IDCANCEL)->EnableWindow (FALSE);
        Sleep (10);
        KillTimer (1);

        OnOK ();
    }

    CDialog::OnTimer(nIDEvent);
}
