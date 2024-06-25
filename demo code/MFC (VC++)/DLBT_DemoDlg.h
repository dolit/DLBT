//=======================================================================================
//  ���ܣ�      ���Ի�������ʾ����������棬����ͬ�û��������Լ���ʼ����������
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
#include "downloaderlistctrl.h"
#include "infotabctrl.h"


class CDLBT_DemoDlg : public CDialog
{
// ����
public:
	CDLBT_DemoDlg(CWnd* pParent = NULL);	// ��׼���캯��

// �Ի�������
	enum { IDD = IDD_DLBT_DEMO_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV ֧��

private:
    UINT_PTR    m_timer;

// ʵ��
protected:
	HICON m_hIcon;

	// ���ɵ���Ϣӳ�亯��
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
