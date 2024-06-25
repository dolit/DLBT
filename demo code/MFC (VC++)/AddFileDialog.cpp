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
#include "AddFileDialog.h"
#include ".\addfiledialog.h"

IMPLEMENT_DYNAMIC(CAddFileDialog, CDialog)
CAddFileDialog::CAddFileDialog(CWnd* pParent /*=NULL*/)
	: CDialog(CAddFileDialog::IDD, pParent)
    , m_torrentPath(_T(""))
    , m_savePath(_T(""))
{
}

CAddFileDialog::~CAddFileDialog()
{
}

void CAddFileDialog::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Text(pDX, IDC_EDIT_TORRENT_PATH, m_torrentPath);
    DDX_Text(pDX, IDC_EDIT_SAVE_PATH, m_savePath);
}


BEGIN_MESSAGE_MAP(CAddFileDialog, CDialog)
    ON_BN_CLICKED(IDC_BUTTON_BROWSER1, OnBnClickedButtonBrowser1)
    ON_BN_CLICKED(IDC_BUTTON_BROWSER2, OnBnClickedButtonBrowser2)
    ON_BN_CLICKED(IDCANCEL, OnBnClickedCancel)
    ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()


void CAddFileDialog::OnBnClickedButtonBrowser1()
{
    UpdateData (TRUE);
    CString strFilter = _T ("BitTorrent File(*.Torrent)|*.torrent||");
    CFileDialog dlg (TRUE, _T ("torrent"), _T ("*.Torrent"),
                         OFN_HIDEREADONLY | OFN_OVERWRITEPROMPT | OFN_EXPLORER | OFN_FILEMUSTEXIST,
                         strFilter);

    if (IDOK != dlg.DoModal())
        return;

    m_torrentPath = dlg.GetPathName ();
    m_torrentPath.Replace ('/', '\\');
    m_savePath = m_torrentPath.Left (m_torrentPath.ReverseFind ('\\') + 1);

    UpdateData (FALSE);
}

void CAddFileDialog::OnBnClickedButtonBrowser2()
{
    UpdateData (TRUE);
    BROWSEINFO bInfo;
    ZeroMemory (&bInfo, sizeof (bInfo));

    bInfo.hwndOwner = m_hWnd;
    bInfo.lpszTitle = _T ("请选择文件保存目录:");
    bInfo.ulFlags = BIF_RETURNONLYFSDIRS;

    LPITEMIDLIST lpDlist;
    lpDlist = SHBrowseForFolder (&bInfo);
    if (lpDlist != NULL)
    {
        TCHAR tPath [MAX_PATH];
        SHGetPathFromIDList (lpDlist, tPath);

        m_savePath = tPath;
    }
    UpdateData (FALSE);
}

void CAddFileDialog::OnBnClickedCancel()
{
    OnCancel();
}

void CAddFileDialog::OnBnClickedOk()
{
    UpdateData (TRUE);
    OnOK();
}
