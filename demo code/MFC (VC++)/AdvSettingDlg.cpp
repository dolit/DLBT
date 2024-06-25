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
#include "AdvSettingDlg.h"
#include ".\advsettingdlg.h"

CString CAdvSettingDlg::m_userName;
CString CAdvSettingDlg::m_host;
CString CAdvSettingDlg::m_port;
CString CAdvSettingDlg::m_password;

int CAdvSettingDlg::m_proxyTypeSel = 0;
int CAdvSettingDlg::m_encryptOptionSel = DLBT_ENCRYPT_FULL;
int CAdvSettingDlg::m_encryptLevelSel = DLBT_ENCRYPT_ALL;

bool CAdvSettingDlg::m_bProxyAllChecked = true;
bool CAdvSettingDlg::m_bP2PAsHttpChecked = false;   //默认不启用Http伪装

// CAdvSettingDlg 对话框

IMPLEMENT_DYNAMIC(CAdvSettingDlg, CDialog)
CAdvSettingDlg::CAdvSettingDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CAdvSettingDlg::IDD, pParent)
{
}

CAdvSettingDlg::~CAdvSettingDlg()
{
}

void CAdvSettingDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Control(pDX, IDC_COMBO_ENCRYPT_OPTION, m_encryptOption);
    DDX_Control(pDX, IDC_COMBO_ENCRYPT_LEVEL, m_encryptLevel);
    DDX_Control(pDX, IDC_COMBO_PROXY_TYPE, m_proxyType);
    DDX_Text(pDX, IDC_EDIT_HOST, m_host);
    DDX_Text(pDX, IDC_EDIT_PORT, m_port);
    DDV_MaxChars(pDX, m_port, 65536);
    DDX_Text(pDX, IDC_EDIT_USER, m_userName);
    DDX_Text(pDX, IDC_EDIT_PASS, m_password);
}


BEGIN_MESSAGE_MAP(CAdvSettingDlg, CDialog)
    ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()

BOOL CAdvSettingDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    m_proxyType.SetCurSel (m_proxyTypeSel);
    m_encryptOption.SetCurSel (m_encryptOptionSel);
    m_encryptLevel.SetCurSel (m_encryptLevelSel);

    if (m_bProxyAllChecked)
        ((CButton *)GetDlgItem (IDC_CHECK_ALL))->SetCheck (1);

    if (m_bP2PAsHttpChecked)
        ((CButton *)GetDlgItem (IDC_CHECK_P2PAsHttp))->SetCheck (1);

    return TRUE;
}

// CAdvSettingDlg 消息处理程序

void CAdvSettingDlg::OnBnClickedOk()
{
    UpdateData (TRUE);

    m_proxyTypeSel = this->m_proxyType.GetCurSel ();
    m_encryptOptionSel = this->m_encryptOption.GetCurSel ();
    m_encryptLevelSel = this->m_encryptLevel.GetCurSel ();

    m_bProxyAllChecked = ((CButton *)GetDlgItem (IDC_CHECK_ALL))->GetCheck () == 0 ? false : true;
    m_bP2PAsHttpChecked = ((CButton *)GetDlgItem (IDC_CHECK_P2PAsHttp))->GetCheck() == 0 ? false : true;

    OnOK();
}
