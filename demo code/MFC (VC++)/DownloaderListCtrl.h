//=======================================================================================
//  功能：      显示下载列表的控件，同时提供对所有下载任务的管理（增加、显示基本信息、设置、删除等）
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

#include "DownloaderSetting.h"
#include <afxtempl.h>

#define WM_SHOW_CONTEXT_MENU    (WM_USER + 1)       // 点击了右键时，通知主窗口显示右键菜单的自定义消息

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

    CMap <HANDLE, HANDLE &, DOWNLOADER_SETTING *, DOWNLOADER_SETTING *&> m_dldSettings;     // 记录每个下载任务设置的map，以下载任务的Handle为key
public:
    afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
    void OnStopMenu();
    void OnPauseMenu();
    void OnResumeMenu();
    void OnSettingMenu();
    void OnOpenFolderMenu();
    void OnSequenceDownload();
};


