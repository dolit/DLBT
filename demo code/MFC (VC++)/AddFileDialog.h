//=======================================================================================
//  ���ܣ�      ����һ������ʱ��ʾ�ĶԻ������û�ѡ�������ļ����ڵ�·���ͱ���·��
// 
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

class CAddFileDialog : public CDialog
{
	DECLARE_DYNAMIC(CAddFileDialog)

public:
	CAddFileDialog(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CAddFileDialog();

// �Ի�������
	enum { IDD = IDD_ADDFILEDIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
    CString m_torrentPath;
    CString m_savePath;
    afx_msg void OnBnClickedButtonBrowser1();
    afx_msg void OnBnClickedButtonBrowser2();
    afx_msg void OnBnClickedCancel();
    afx_msg void OnBnClickedOk();
};
