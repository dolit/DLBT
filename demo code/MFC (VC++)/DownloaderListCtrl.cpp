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

#include "stdafx.h"
#include "DLBT_Demo.h"
#include "DownloaderListCtrl.h"
#include "utils.h"
#include ".\downloaderlistctrl.h"
#include "DownloaderSetting.h"


const int g_downloaderListColumnWidth [] = {180, 90, 60, 90, 80, 90, 90};
const LPCTSTR g_downloaderListColumnText [] = {_T("文件名"), _T("状态"), _T("大小"), _T("已下载"), _T("剩余时间"), _T("下载速度"), _T("上传速度")};


IMPLEMENT_DYNAMIC(CDownloaderListCtrl, CListCtrl)
CDownloaderListCtrl::CDownloaderListCtrl()
{
}

CDownloaderListCtrl::~CDownloaderListCtrl()
{
}


BEGIN_MESSAGE_MAP(CDownloaderListCtrl, CListCtrl)
    ON_WM_RBUTTONDOWN()
END_MESSAGE_MAP()

// 构建初始化的界面
BOOL CDownloaderListCtrl::Init ()
{
    SetExtendedStyle (GetExtendedStyle () | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
    int nFormat = LVCFMT_CENTER | DT_CENTER | DT_SINGLELINE | DT_VCENTER;

    for (int i = 0; i < sizeof (g_downloaderListColumnWidth) / sizeof (g_downloaderListColumnWidth[0]); i ++)
    {
        InsertColumn (i, g_downloaderListColumnText[i], nFormat, g_downloaderListColumnWidth [i]);
    }

    return TRUE;
}

// 关闭时的清理工作
void CDownloaderListCtrl::Clear ()
{
    for (int i = 0; i < GetItemCount (); i++)
    {
        HANDLE hDownloader = (HANDLE)GetItemData (i);
        DLBT_Downloader_Release (hDownloader);
    }

    DOWNLOADER_SETTING * ds;
    HANDLE key;
    POSITION pos = m_dldSettings.GetStartPosition ();
    while (pos != NULL)
    {
        m_dldSettings.GetNextAssoc (pos, key, ds);
        delete ds;
    }
    m_dldSettings.RemoveAll();
    DeleteAllItems ();
}

// 添加一个下载任务
HANDLE CDownloaderListCtrl::AddDownloader (LPCTSTR torrentFile, LPCTSTR outPath)
{
    USES_CONVERSION; 
    HANDLE hDownloader = DLBT_Downloader_Initialize (CT2W(torrentFile), CT2W(outPath));
 
    if (hDownloader != NULL)
    {
        // 设置P2SP连接（如果有的话）对单个地址最多使用10个连接
        DLBT_Downloader_SetMaxSessionPerHttp(hDownloader, 10);

        int pos = InsertItem (GetItemCount (), _T (""));
        SetItemData (pos, (DWORD_PTR)hDownloader);

        DOWNLOADER_SETTING * ds = new DOWNLOADER_SETTING;
        ds->hDownloader = hDownloader;
        AddDownloaderSetting (ds);

        Refresh ();
    }
    else
    {
        MessageBox (_T ("添加任务失败！如果是试用版，可能已经达到了试用版的限制！\r\n或者可能是种子文件损坏或者格式不合法，无法打开这个种子文件！"));
    }
    return hDownloader;
}

// 定时刷新下载的信息
void CDownloaderListCtrl::Refresh ()
{
    for (int i = 0; i < GetItemCount (); i ++)
    {
        HANDLE hDownloader = (HANDLE)GetItemData (i);
        
        USES_CONVERSION; 

        DOWNLOADER_INFO info;
        DLBT_GetDownloaderInfo (hDownloader, &info);

        //TODO: 示例程序可以这样写，正式程序最好判断下名字的程度，动态分配空间
        int nameLen = 1024;
        WCHAR name[1025];
        if (DLBT_Downloader_GetTorrentName (hDownloader, name, &nameLen) == S_OK)
        {
            wcscpy (name, name);            
            SetItemText (i, 0, CW2T(name));
        }

        DLBT_DOWNLOAD_STATE state = info.state;          
        switch (state)
        {
        case BTDS_QUEUED:
            SetItemText (i, 1, _T ("初始化"));
            break;
        case BTDS_CHECKING_FILES:
            SetItemText (i, 1, _T ("检查文件"));
            break;
        case BTDS_DOWNLOADING_TORRENT:
            SetItemText (i, 1, _T ("获取种子"));
            break;
        case BTDS_DOWNLOADING:
            SetItemText (i, 1, _T ("下载中"));
            break;
        case BTDS_PAUSED:
            SetItemText (i, 1, _T ("暂停"));
            break;
        case BTDS_FINISHED:
            SetItemText (i, 1, _T ("下载完成"));
            break;
        case BTDS_SEEDING:
            SetItemText (i, 1, _T ("供种中"));
            break;
        case BTDS_ALLOCATING:
            SetItemText (i, 1, _T ("分配存储空间"));
            break;
        case BTDS_ERROR:   
            int bufSize = 0;
            CString err;
            if (DLBT_Downloader_GetLastError (hDownloader, NULL, &bufSize) == S_OK && bufSize > 0)
            {
                char * errBuf = new char[bufSize];
                if (errBuf != NULL)
                {
                    if (DLBT_Downloader_GetLastError( hDownloader, errBuf, &bufSize ) == S_OK)
                        err = A2T (errBuf);
                    delete [] errBuf;
                }
            }
            SetItemText (i, 1, CString (_T ("出错: ")) + err);
            break;
        }

        SetItemText (i, 2, BytesToString (info.totalFileSize));        
        CString str;
        if (state == BTDS_DOWNLOADING || state == BTDS_CHECKING_FILES || state == BTDS_FINISHED 
			|| state == BTDS_SEEDING || state == BTDS_PAUSED)
        {
            UINT64 uDone = info.totalDownloadedBytes;
            float val;
		    TCHAR szDim [10];
		    BytesToDisplayBytes (uDone, &val, szDim);
		    if (info.totalFileSize != _UI64_MAX)
			    str.Format (_T ("%.1f%% [%.*g %s]"), info.currentTaskProgress, val > 999 ? 4 : 3, val, szDim);
		    else
			    str.Format (_T ("%.*g %s"), val > 999 ? 4 : 3, val, szDim);
            SetItemText (i, 3, str);


            UINT64 uLeft = info.totalFileSize - uDone;
            UINT uSpeed = info.downloadSpeed;

            if (uLeft == _UI64_MAX || uSpeed == 0)
                SetItemText (i, 4, _T (""));
            else
                SetItemText (i, 4, TimeInSecondToStr (UINT (uLeft / uSpeed)));
        }

        {
            UINT uSpeed = 0;
            uSpeed = info.downloadSpeed;

            str.Format (_T ("%s/s"), BytesToString (uSpeed));
            SetItemText (i, 5, str);

            uSpeed = info.uploadSpeed;
            str.Format (_T ("%s/s"), BytesToString (uSpeed));
            SetItemText (i, 6, str);            
        }
    }
}

// 右键点击时，触发消息，显示右键菜单（通过主窗口显示）
void CDownloaderListCtrl::OnRButtonDown(CPoint point, int nItem)
{
    ASSERT(nItem >= -1);
    if (nItem == -1)
        return;
    
    ClientToScreen(&point);
    ::PostMessage (AfxGetApp ()->GetMainWnd ()->m_hWnd, WM_SHOW_CONTEXT_MENU, point.x, point.y);
}

// 右键点击时首先获取当前选中的行
void CDownloaderListCtrl::OnRButtonDown(UINT nFlags, CPoint point)
{
    int     iItem       =   -1;

    CRect rect;
    int i = 0;
    for (i = 0; i < GetItemCount (); i++)
    {
        GetSubItemRect (i, 0, LVIR_LABEL, rect);
        if (rect.bottom > point.y)
            break;
    }

    if (i != GetItemCount ())
        iItem = i;

    OnRButtonDown(point, iItem);

    CListCtrl::OnRButtonDown(nFlags, point);
}

// 点了停止菜单，停止并删除一个或者多个任务
void CDownloaderListCtrl::OnStopMenu()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    while (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE)GetItemData (nSelItem);

        ASSERT (hDownloader != NULL);
        if (hDownloader != NULL)
        {
            DLBT_Downloader_Release (hDownloader);
        }

        this->DeleteItem (nSelItem);
        RemoveDownloaderSetting (hDownloader);
    }
}

// 点了暂停菜单，暂停一个或者多个任务
void CDownloaderListCtrl::OnPauseMenu()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    while (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE) GetItemData (nSelItem);

        ASSERT (hDownloader != NULL);
        if (hDownloader != NULL)
        {
            if (!DLBT_Downloader_IsPaused (hDownloader))
                DLBT_Downloader_Pause (hDownloader);
        }
    }
}

// 点了继续菜单，继续一个或多个暂停状态的任务
void CDownloaderListCtrl::OnResumeMenu()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    while (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE)GetItemData (nSelItem);

        ASSERT (hDownloader != NULL);
        if (hDownloader != NULL)
        {
            if (DLBT_Downloader_IsPaused (hDownloader))
                DLBT_Downloader_Resume (hDownloader);
        }
    }
}

// 返回需要在主界面下面列出详细信息的一个Downloader，如果有选中的下载任务，默认显示第一个被选中的。如无选择，则返回第一个下载任务
HANDLE CDownloaderListCtrl::GetDisplayDownloader ()
{
    if (GetItemCount () <= 0)
        return NULL;
    
    HANDLE hDownloader = NULL;

    POSITION pos = this->GetFirstSelectedItemPosition();      
    if (pos)   
    {
        int nSelItem = this->GetNextSelectedItem(pos);   
        hDownloader = (HANDLE)GetItemData (nSelItem);
    }

    if (hDownloader == NULL)
        hDownloader = (HANDLE)GetItemData (0);
    return hDownloader;
}

// 点了设置菜单，需要找到和当前选择的任务相关联的设置信息，弹出设置对话框，对所选任务应用设置
// 多选的情况下，只对第一个任务应用设置
void CDownloaderListCtrl::OnSettingMenu()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    if (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE)GetItemData (nSelItem);
        DOWNLOADER_SETTING * ds = FindDownloaderSetting (hDownloader);

        ASSERT (hDownloader != NULL && ds != NULL);

        CDownloaderSetting dsDlg;        
        dsDlg.SetDownloaderSetting (ds);
        if (dsDlg.DoModal () == IDOK)
        {
            DLBT_Downloader_SetDownloadLimit (hDownloader, ds->dsLimit >= 0 ? ds->dsLimit * 1024 : -1);
            DLBT_Downloader_SetUploadLimit (hDownloader, ds->usLimit >= 0 ? ds->usLimit * 1024 : -1);
            DLBT_Downloader_SetMaxUploadConnections (hDownloader, ds->ucLimit >= 0 ? ds->ucLimit * 1024 : -1);
            DLBT_Downloader_SetMaxTotalConnections (hDownloader, ds->dcLimit >= 0 ? ds->dcLimit * 1024 : -1);
            DLBT_Downloader_SetShareRateLimit (hDownloader, ds->shareRate);
        }
    }
}

// 点了顺序下载的菜单，开始顺序下载
void CDownloaderListCtrl::OnSequenceDownload()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    while (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE)GetItemData (nSelItem);

        ASSERT (hDownloader != NULL);
        if (hDownloader != NULL)
        {
            DLBT_Downloader_SetDownloadSequence (hDownloader, TRUE);
        }
    }
}

// 点中了“打开所在文件夹”菜单，打开所在文件夹并选中第一个文件
void CDownloaderListCtrl::OnOpenFolderMenu()
{
    POSITION pos = this->GetFirstSelectedItemPosition();      
    if (pos)   
    {   
        int nSelItem = this->GetNextSelectedItem(pos);   
        HANDLE hDownloader = (HANDLE)GetItemData (nSelItem);

        ASSERT (hDownloader != NULL);
        if (hDownloader != NULL)
        {
            USES_CONVERSION; 

            WCHAR pathName [MAX_PATH];
            int len = MAX_PATH;
            if (DLBT_Downloader_GetFilePathName (hDownloader, 0, pathName, &len, true) == S_OK
                && GetFileAttributesW (pathName) != 0xFFFFFFFF)
            {
                CString param = CW2T(pathName);
                param = CString (_T("/n,/select,")) + _T ("\"") + param + _T ("\"");
                ShellExecute (NULL, _T("open"), _T("explorer.exe"), param, NULL, SW_SHOW);
            }
        }
    }
}
