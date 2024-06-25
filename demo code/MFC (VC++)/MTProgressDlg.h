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
#include "afxcmn.h"

enum MAKE_TORRENT_RESULT
{
    MT_SUCCESS  = 0,
    MT_CREATE_TORRENT_FAILED,
    MT_SAVE_TORRENT_FAILED,
    MT_RUNNING,
    MT_CANCEL
};

// CMTProgressDlg 对话框

class CMTProgressDlg : public CDialog
{
	DECLARE_DYNAMIC(CMTProgressDlg)

public:
	CMTProgressDlg(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CMTProgressDlg();

// 对话框数据
	enum { IDD = IDD_MT_PROGRESS_DLG };

protected:

    static UINT StaticMakeTorrentThreadProc(LPVOID pvParams)
    {
        ASSERT (pvParams != NULL);
        ((CMTProgressDlg *)pvParams)->Run ();
        return 0;
    };

    void Run ();
    virtual BOOL OnInitDialog();
    virtual void OnOK();

	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedCancel();

    int m_progressPos;
    BOOL         m_bCancel;
    CWinThread * m_pThread;

    MAKE_TORRENT_RESULT m_result;

    CString m_announceUrl;
    CString m_fileName;
    CString m_creator;
    CString m_creatorUrl;
    CString m_comment;
    CString m_httpUrl;
    CString m_torrentPath;

    DWORD m_pieceSize;

    DLBT_TORRENT_TYPE   m_torrentType;
    CProgressCtrl m_progressCtrl;

    afx_msg void OnTimer(UINT nIDEvent);
};
