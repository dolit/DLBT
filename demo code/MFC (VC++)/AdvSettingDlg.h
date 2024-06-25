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

#pragma once
#include "afxwin.h"


// CAdvSettingDlg 对话框

class CAdvSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CAdvSettingDlg)

public:
	CAdvSettingDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CAdvSettingDlg();

// 对话框数据
	enum { IDD = IDD_ADVSETTINGDLG };

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    CComboBox m_encryptOption;
    CComboBox m_encryptLevel;
    CComboBox m_proxyType;
    static CString m_host;
    static CString m_port;
    static CString m_userName;
    static CString m_password;

    static int     m_proxyTypeSel;
    static int     m_encryptOptionSel;
    static int     m_encryptLevelSel;

    static bool    m_bProxyAllChecked;
    static bool    m_bP2PAsHttpChecked;

    afx_msg void OnBnClickedOk();
};
