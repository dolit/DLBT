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

// ��ʾ��ǰ��������Ϣ
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

// Ӧ���û��޸ĺ��������
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
