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
#include "DownloaderSetting.h"
#include ".\downloadersetting.h"
#include "utils.h"


IMPLEMENT_DYNAMIC(CDownloaderSetting, CDialog)
CDownloaderSetting::CDownloaderSetting(CWnd* pParent /*=NULL*/)
	: CDialog(CDownloaderSetting::IDD, pParent)
{
}

CDownloaderSetting::~CDownloaderSetting()
{
}

void CDownloaderSetting::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}


BEGIN_MESSAGE_MAP(CDownloaderSetting, CDialog)
    ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()

// 显示当前的设置信息
BOOL CDownloaderSetting::OnInitDialog()
{
    CDialog::OnInitDialog();

    ASSERT (m_ds != NULL);
    if (m_ds != NULL)
    {
        SetDlgItemText (IDC_EDIT_DOWNLOAD_SPEED, IntToStr (m_ds->dsLimit));
        SetDlgItemText (IDC_EDIT_UPLOAD_SPEED, IntToStr (m_ds->usLimit));
        SetDlgItemText (IDC_EDIT_DOWNLOAD_CONNECTION, IntToStr (m_ds->dcLimit));
        SetDlgItemText (IDC_EDIT_UPLOAD_CONNECTION, IntToStr (m_ds->ucLimit));
        SetDlgItemText (IDC_EDIT_MAX_SHARE_RATE, FloatToStr (m_ds->shareRate));
    }
    return TRUE;
}

// 应用用户修改后的新设置
void CDownloaderSetting::OnBnClickedOk()
{
    ASSERT (m_ds != NULL);
    if (m_ds != NULL)
    {
        CString str;
        GetDlgItemText (IDC_EDIT_DOWNLOAD_SPEED, str);
        m_ds->dsLimit = _ttoi (str.Trim ());

        GetDlgItemText (IDC_EDIT_UPLOAD_SPEED, str);
        m_ds->usLimit = _ttoi (str.Trim ());

        GetDlgItemText (IDC_EDIT_DOWNLOAD_CONNECTION, str);
        m_ds->dcLimit = _ttoi (str.Trim ());

        GetDlgItemText (IDC_EDIT_UPLOAD_CONNECTION, str);
        m_ds->ucLimit = _ttoi (str.Trim ());

        GetDlgItemText (IDC_EDIT_MAX_SHARE_RATE, str);
        m_ds->shareRate = (float)_tstof(str);
    }
    OnOK();
}
