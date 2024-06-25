//=======================================================================================
//  功能：      启动一个下载时显示的对话框，让用户选择种子文件所在的路径和保存路径
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

class CAddFileDialog : public CDialog
{
	DECLARE_DYNAMIC(CAddFileDialog)

public:
	CAddFileDialog(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CAddFileDialog();

// 对话框数据
	enum { IDD = IDD_ADDFILEDIALOG };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    CString m_torrentPath;
    CString m_savePath;
    afx_msg void OnBnClickedButtonBrowser1();
    afx_msg void OnBnClickedButtonBrowser2();
    afx_msg void OnBnClickedCancel();
    afx_msg void OnBnClickedOk();
};
