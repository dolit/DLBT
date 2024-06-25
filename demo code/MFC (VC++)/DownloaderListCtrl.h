//=======================================================================================
//  ���ܣ�      ��ʾ�����б�Ŀؼ���ͬʱ�ṩ��������������Ĺ������ӡ���ʾ������Ϣ�����á�ɾ���ȣ�
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

#include "DownloaderSetting.h"
#include <afxtempl.h>

#define WM_SHOW_CONTEXT_MENU    (WM_USER + 1)       // ������Ҽ�ʱ��֪ͨ��������ʾ�Ҽ��˵����Զ�����Ϣ

class CDownloaderListCtrl : public CListCtrl
{
	DECLARE_DYNAMIC(CDownloaderListCtrl)

public:
	CDownloaderListCtrl();
	virtual ~CDownloaderListCtrl();

    BOOL Init ();
    void Clear ();

    HANDLE AddDownloader (LPCTSTR torrentFile, LPCTSTR outPath); 

    void Refresh ();    
    HANDLE GetDisplayDownloader ();

protected:
	DECLARE_MESSAGE_MAP()

    virtual void OnRButtonDown(CPoint point, int nItem);

private:
    DOWNLOADER_SETTING * FindDownloaderSetting (HANDLE hDownloader)
    {        
        DOWNLOADER_SETTING * ds = NULL;
        m_dldSettings.Lookup (hDownloader, ds);
        return ds;
    }

    void AddDownloaderSetting (DOWNLOADER_SETTING * ds)
    {
        ASSERT (ds != NULL);
        ASSERT (FindDownloaderSetting (ds->hDownloader) == NULL);
        m_dldSettings.SetAt (ds->hDownloader, ds);
    }

    void RemoveDownloaderSetting (HANDLE hDownloader)
    {
        DOWNLOADER_SETTING * ds = NULL;
        m_dldSettings.Lookup (hDownloader, ds);
        m_dldSettings.RemoveKey (hDownloader);
        
        ASSERT (ds != NULL);
        delete ds;
    }

    CMap <HANDLE, HANDLE &, DOWNLOADER_SETTING *, DOWNLOADER_SETTING *&> m_dldSettings;     // ��¼ÿ�������������õ�map�������������HandleΪkey
public:
    afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
    void OnStopMenu();
    void OnPauseMenu();
    void OnResumeMenu();
    void OnSettingMenu();
    void OnOpenFolderMenu();
    void OnSequenceDownload();
};


