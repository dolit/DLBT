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
#include "SettingDlg.h"
#include ".\settingdlg.h"


IMPLEMENT_DYNAMIC(CSettingDlg, CDialog)
CSettingDlg::CSettingDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CSettingDlg::IDD, pParent)
    , m_checkDHT(TRUE)
    , m_checkUPnP(TRUE)
    , m_checkFireWall(TRUE)
    , m_downloadSpeedLimit(_T("-1"))
    , m_uploadSpeedLimit(_T("-1"))
{
}

CSettingDlg::~CSettingDlg()
{
}

void CSettingDlg::DoDataExchange(CDataExchange* pDX)
{
    CDialog::DoDataExchange(pDX);
    DDX_Check(pDX, IDC_CHECK_DHT, m_checkDHT);
    DDX_Check(pDX, IDC_CHECK_UPNP, m_checkUPnP);
    DDX_Check(pDX, IDC_CHECK_FIREWALL, m_checkFireWall);
    DDX_Text(pDX, IDC_EDIT1, m_downloadSpeedLimit);
    DDX_Text(pDX, IDC_EDIT2, m_uploadSpeedLimit);
    DDX_Control(pDX, IDC_IPADDRESS1, m_reportIP);
}


BEGIN_MESSAGE_MAP(CSettingDlg, CDialog)
    ON_BN_CLICKED(IDOK, OnBnClickedOk)
END_MESSAGE_MAP()


 // 演示程序没有使用配置文件，因此使用全局变量用户的选项
CString g_downloadLimit = _T("-1");         // 总下载的限速
CString g_uploadLimit = _T("-1");           // 总上传的限速

// 初始化界面显示
BOOL CSettingDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    // 防火墙在程序开始启动时就调用了自动打开，演示程序为了方便，没有使用配置文件，所以下次启动时无法
    // 记住这次的选择，在演示程序中，暂时不支持修改这两个配置。但实际程序中一般都有自己的配置文件，可以
    // 在启动时检查配置，进行正确的处理。
    GetDlgItem (IDC_CHECK_FIREWALL)->EnableWindow (FALSE);
    GetDlgItem (IDC_CHECK_UPNP)->EnableWindow (FALSE);

    if (!DLBT_DHT_IsStarted ())
        m_checkDHT = FALSE;

    m_downloadSpeedLimit = g_downloadLimit;
    m_uploadSpeedLimit = g_uploadLimit;

    USES_CONVERSION; 

    CStringA ipTxtA = DLBT_GetReportIP ();
    CString ipTxt;
    if (!ipTxtA.IsEmpty ())
        ipTxt = A2T((LPSTR)(LPCSTR)ipTxtA);

    GetDlgItem (IDC_IPADDRESS1)->SetWindowText (ipTxt);

    UpdateData (FALSE);

    return TRUE;
}

void CSettingDlg::OnBnClickedOk()
{
    UpdateData (TRUE);

    m_reportIP.GetWindowText (m_strReportIP);

    g_downloadLimit = m_downloadSpeedLimit;
    g_uploadLimit = m_uploadSpeedLimit;
    OnOK();
}
