//=======================================================================================
//  ���ܣ�      �������ӵ����ý��棬���������ӳ��߱��ٷ�Э���еĸ��������⣬���ο�����
//              ����BT�ͻ��˵����ã��ṩ���õ���չ���ã����ݸ���BT�ͻ���
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
#include "afxcmn.h"


class CMakeTorrentDlg : public CDialog
{
	DECLARE_DYNAMIC(CMakeTorrentDlg)

public:
	CMakeTorrentDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CMakeTorrentDlg();

// �Ի�������
	enum { IDD = IDD_MAKETORRENTDLG };

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedButtonBrowserFile();
    afx_msg void OnBnClickedButtonBrowserTorrent();
    DWORD m_pieceSize;
    afx_msg void OnBnClickedOk();
    CComboBox m_types;    
public:
    BOOL m_bAutoUpload;
    CString m_torrentPath;
    CString m_filePath;
};
