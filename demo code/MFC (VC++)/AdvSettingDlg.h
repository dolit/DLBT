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

#pragma once
#include "afxwin.h"


// CAdvSettingDlg �Ի���

class CAdvSettingDlg : public CDialog
{
	DECLARE_DYNAMIC(CAdvSettingDlg)

public:
	CAdvSettingDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CAdvSettingDlg();

// �Ի�������
	enum { IDD = IDD_ADVSETTINGDLG };

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

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
