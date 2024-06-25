//=======================================================================================
//  功能：      制作种子的配置界面，制作的种子除具备官方协议中的各项特性外，还参考其它
//              流行BT客户端的设置，提供常用的扩展设置，兼容各类BT客户端
// 
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
#include "afxcmn.h"


class CMakeTorrentDlg : public CDialog
{
	DECLARE_DYNAMIC(CMakeTorrentDlg)

public:
	CMakeTorrentDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CMakeTorrentDlg();

// 对话框数据
	enum { IDD = IDD_MAKETORRENTDLG };

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

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
