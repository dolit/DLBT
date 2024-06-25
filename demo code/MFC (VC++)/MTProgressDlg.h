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
#include "afxcmn.h"

enum MAKE_TORRENT_RESULT
{
    MT_SUCCESS  = 0,
    MT_CREATE_TORRENT_FAILED,
    MT_SAVE_TORRENT_FAILED,
    MT_RUNNING,
    MT_CANCEL
};

// CMTProgressDlg �Ի���

class CMTProgressDlg : public CDialog
{
	DECLARE_DYNAMIC(CMTProgressDlg)

public:
	CMTProgressDlg(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CMTProgressDlg();

// �Ի�������
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

	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

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
