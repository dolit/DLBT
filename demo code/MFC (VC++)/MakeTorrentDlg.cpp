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
#include "MakeTorrentDlg.h"
#include ".\maketorrentdlg.h"
#include "MTProgressDlg.h"


IMPLEMENT_DYNAMIC(CMakeTorrentDlg, CDialog)
CMakeTorrentDlg::CMakeTorrentDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CMakeTorrentDlg::IDD, pParent)
    , m_pieceSize(16)
    , m_bAutoUpload(FALSE)
{
}

CMakeTorrentDlg::~CMakeTorrentDlg()
{
}

void CMakeTorrentDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Text(pDX, IDC_EDIT_PIECE_SIZE, m_pieceSize);
    DDV_MinMaxUInt(pDX, m_pieceSize, 0, 8192);
    DDX_Control(pDX, IDC_COMBO_TYPE, m_types);
    DDX_Check(pDX, IDC_CHECK_AutoUpload, m_bAutoUpload);
}


BEGIN_MESSAGE_MAP(CMakeTorrentDlg, CDialog)
    ON_BN_CLICKED(IDC_BUTTON_BROWSER_FILE, OnBnClickedButtonBrowserFile)
    ON_BN_CLICKED(IDC_BUTTON_BROWSER_TORRENT, OnBnClickedButtonBrowserTorrent)
    ON_BN_CLICKED(IDOK, OnBnClickedOk)
//    ON_WM_TIMER()
END_MESSAGE_MAP()

// ��ʼ�����ڵ���ʾ
BOOL CMakeTorrentDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    ((CButton *)GetDlgItem (IDC_RADIO_FILE))->SetCheck (BST_CHECKED);
    SetDlgItemText (IDC_EDIT_PIECE_SIZE, _T ("0"));

    SetDlgItemText (IDC_EDIT_PUBLISHER, _T ("����BT (DLBT) - ����רҵ���õ�BT�ں�DLL��"));
    SetDlgItemText (IDC_EDIT_PUBLISHER_URL, _T ("http://www.dolit.cn/"));
    GetDlgItem (IDC_EDIT_PUBLISHER)->EnableWindow (FALSE);
    GetDlgItem (IDC_EDIT_PUBLISHER_URL)->EnableWindow (FALSE);
    ((CButton *)GetDlgItem (IDC_CHECK_AutoUpload))->SetCheck(BST_CHECKED);

    m_types.SetCurSel (0);

    return TRUE;
}

// ѡ��Դ�ļ������ļ���
void CMakeTorrentDlg::OnBnClickedButtonBrowserFile()
{    
    CString path;
    if (((CButton *)GetDlgItem (IDC_RADIO_FILE))->GetCheck ())
    {
        CString strFilter = _T ("All File(*.*)|*.*||");
        CFileDialog dlg (TRUE, _T ("*.*" ),  _T (""),  OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER | OFN_FILEMUSTEXIST, strFilter);

        if (IDOK != dlg.DoModal())
            return;

        path = dlg.GetPathName ();
    }
    else
    {
        ASSERT (((CButton *)GetDlgItem (IDC_RADI_DIRECTORY))->GetCheck ());
        
        BROWSEINFO bInfo;
        ZeroMemory (&bInfo, sizeof (bInfo));

        bInfo.hwndOwner = m_hWnd;
        bInfo.lpszTitle = _T ("��ѡ��Ҫ�������ӵ�Ŀ¼:");
        bInfo.ulFlags = BIF_RETURNONLYFSDIRS;

        LPITEMIDLIST lpDlist;
        lpDlist = SHBrowseForFolder (&bInfo);
        if (lpDlist == NULL)
            return;

        TCHAR tPath [MAX_PATH];
        SHGetPathFromIDList (lpDlist, tPath);
        path = tPath;
    }

    SetDlgItemText (IDC_EDIT_FILE_PATH, path);
    if (path.GetLength () <= 3)  
        path += _T ("Torrent");

    path += _T (".torrent");

    SetDlgItemText (IDC_EDIT_TORRENT_PATH, path);
}

// ѡ�����ӵı���·��
void CMakeTorrentDlg::OnBnClickedButtonBrowserTorrent()
{
    CString strFilter = _T ("BitTorrent File(*.Torrent)|*.torrent||");
    CFileDialog dlg (TRUE, _T ("torrent"), _T (""),
                         OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER ,
                         strFilter);

    if (IDOK != dlg.DoModal())
        return;

    SetDlgItemText (IDC_EDIT_TORRENT_PATH, dlg.GetPathName ());
}

// ��ʼ��������
void CMakeTorrentDlg::OnBnClickedOk()
{
    UpdateData (TRUE);

    CMTProgressDlg  dlg;

    GetDlgItemText (IDC_EDIT_TRACKER, dlg.m_announceUrl);
    GetDlgItemText (IDC_EDIT_FILE_PATH, dlg.m_fileName);
    GetDlgItemText (IDC_EDIT_HTTP_PATH, dlg.m_httpUrl);
    GetDlgItemText (IDC_EDIT_TORRENT_PATH, dlg.m_torrentPath);
    GetDlgItemText (IDC_EDIT_PUBLISHER, dlg.m_creator);
    GetDlgItemText (IDC_EDIT_COMMENT, dlg.m_comment);
    GetDlgItemText (IDC_EDIT_PUBLISHER_URL, dlg.m_creatorUrl);

    if (dlg.m_fileName.Trim ().IsEmpty ())
    {
        MessageBox (_T ("��ѡ��Դ�ļ�����һ��Ŀ¼"));
        return;
    }
    if (dlg.m_torrentPath.Trim ().IsEmpty ())
    {
        MessageBox (_T ("��ѡ�����ӵı���·��"));
        return;
    }

    dlg.m_torrentType = (DLBT_TORRENT_TYPE)m_types.GetCurSel ();

    if (dlg.m_announceUrl.Trim ().IsEmpty () && dlg.m_torrentType != USE_PUBLIC_DHT_NODE)
    {
        MessageBox (_T ("����������һ��Tracker��ַ������ʹ�ù���DHT����"));
        return;
    }

    dlg.m_pieceSize = m_pieceSize;

    if (dlg.DoModal () == IDOK)
    {
        if (dlg.m_result == MT_SUCCESS)
        {
            m_torrentPath = dlg.m_torrentPath;
            m_filePath = dlg.m_fileName;
            MessageBox (_T ("   ���������ɹ���  "));
            OnOK();
        }
        else if (dlg.m_result == MT_CREATE_TORRENT_FAILED)            
            MessageBox (_T ("��������ʧ�ܣ����������!"));
        else if (dlg.m_result == MT_SAVE_TORRENT_FAILED)
            MessageBox (_T ("���������ļ�ʧ��"));
        else 
            MessageBox (_T ("��������ʧ��! ���������"));
    }    
}