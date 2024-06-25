//=======================================================================================
//  功能：      主对话框，是演示程序的主界面，处理同用户交互，以及初始化其它对象
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
#include "downloaderlistctrl.h"
#include "infotabctrl.h"


class CDLBT_DemoDlg : public CDialog
{
// 构造
public:
	CDLBT_DemoDlg(CWnd* pParent = NULL);	// 标准构造函数

// 对话框数据
	enum { IDD = IDD_DLBT_DEMO_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持

private:
    UINT_PTR    m_timer;

// 实现
protected:
	HICON m_hIcon;

	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
    CDownloaderListCtrl m_downloaderList;
    CInfoTabCtrl m_infoTab;
    CStatusBarCtrl  m_statusBar;
    afx_msg void OnMenuExit();
    afx_msg void OnMenuAddFile();
    afx_msg void OnMenuMakeTorrent();
    afx_msg void OnMenuConfig();
    afx_msg void OnMenuAbout();
    afx_msg void OnClose();
    afx_msg void OnTimer(UINT nIDEvent);
    afx_msg void OnStopMenu();
    afx_msg void OnPauseMenu();
    afx_msg void OnResumeMenu();
    afx_msg void OnSettingMenu();
    afx_msg void OnOpenFolderMenu();
    afx_msg LRESULT OnShowContextMenu(WPARAM wp, LPARAM lp);
    afx_msg void OnMenuAdvConfig();
    afx_msg void OnSequenceDownload();
};
