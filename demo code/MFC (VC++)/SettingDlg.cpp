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


 // ��ʾ����û��ʹ�������ļ������ʹ��ȫ�ֱ����û���ѡ��
CString g_downloadLimit = _T("-1");         // �����ص�����
CString g_uploadLimit = _T("-1");           // ���ϴ�������

// ��ʼ��������ʾ
BOOL CSettingDlg::OnInitDialog()
{
    CDialog::OnInitDialog();

    // ����ǽ�ڳ���ʼ����ʱ�͵������Զ��򿪣���ʾ����Ϊ�˷��㣬û��ʹ�������ļ��������´�����ʱ�޷�
    // ��ס��ε�ѡ������ʾ�����У���ʱ��֧���޸����������á���ʵ�ʳ�����һ�㶼���Լ��������ļ�������
    // ������ʱ������ã�������ȷ�Ĵ���
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
