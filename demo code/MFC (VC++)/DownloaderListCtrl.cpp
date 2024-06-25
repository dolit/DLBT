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

#include "stdafx.h"
#include "DLBT_Demo.h"
#include "DownloaderListCtrl.h"
#include "utils.h"
#include ".\downloaderlistctrl.h"
#include "DownloaderSetting.h"


const int g_downloaderListColumnWidth [] = {180, 90, 60, 90, 80, 90, 90};
const LPCTSTR g_downloaderListColumnText [] = {_T("�ļ���"), _T("״̬"), _T("��С"), _T("������"), _T("ʣ��ʱ��"), _T("�����ٶ�"), _T("�ϴ��ٶ�")};


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

// ������ʼ���Ľ���
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

// �ر�ʱ��������
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

// ���һ����������
HANDLE CDownloaderListCtrl::AddDownloader (LPCTSTR torrentFile, LPCTSTR outPath)
{
    USES_CONVERSION; 
    HANDLE hDownloader = DLBT_Downloader_Initialize (CT2W(torrentFile), CT2W(outPath));
 
    if (hDownloader != NULL)
    {
        // ����P2SP���ӣ�����еĻ����Ե�����ַ���ʹ��10������
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
        MessageBox (_T ("�������ʧ�ܣ���������ð棬�����Ѿ��ﵽ�����ð�����ƣ�\r\n���߿����������ļ��𻵻��߸�ʽ���Ϸ����޷�����������ļ���"));
    }
    return hDownloader;
}

// ��ʱˢ�����ص���Ϣ
void CDownloaderListCtrl::Refresh ()
{
    for (int i = 0; i < GetItemCount (); i ++)
    {
        HANDLE hDownloader = (HANDLE)GetItemData (i);
        
        USES_CONVERSION; 

        DOWNLOADER_INFO info;
        DLBT_GetDownloaderInfo (hDownloader, &info);

        //TODO: ʾ�������������д����ʽ��������ж������ֵĳ̶ȣ���̬����ռ�
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
            SetItemText (i, 1, _T ("��ʼ��"));
            break;
        case BTDS_CHECKING_FILES:
            SetItemText (i, 1, _T ("����ļ�"));
            break;
        case BTDS_DOWNLOADING_TORRENT:
            SetItemText (i, 1, _T ("��ȡ����"));
            break;
        case BTDS_DOWNLOADING:
            SetItemText (i, 1, _T ("������"));
            break;
        case BTDS_PAUSED:
            SetItemText (i, 1, _T ("��ͣ"));
            break;
        case BTDS_FINISHED:
            SetItemText (i, 1, _T ("�������"));
            break;
        case BTDS_SEEDING:
            SetItemText (i, 1, _T ("������"));
            break;
        case BTDS_ALLOCATING:
            SetItemText (i, 1, _T ("����洢�ռ�"));
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
            SetItemText (i, 1, CString (_T ("����: ")) + err);
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

// �Ҽ����ʱ��������Ϣ����ʾ�Ҽ��˵���ͨ����������ʾ��
void CDownloaderListCtrl::OnRButtonDown(CPoint point, int nItem)
{
    ASSERT(nItem >= -1);
    if (nItem == -1)
        return;
    
    ClientToScreen(&point);
    ::PostMessage (AfxGetApp ()->GetMainWnd ()->m_hWnd, WM_SHOW_CONTEXT_MENU, point.x, point.y);
}

// �Ҽ����ʱ���Ȼ�ȡ��ǰѡ�е���
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

// ����ֹͣ�˵���ֹͣ��ɾ��һ�����߶������
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

// ������ͣ�˵�����ͣһ�����߶������
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

// ���˼����˵�������һ��������ͣ״̬������
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

// ������Ҫ�������������г���ϸ��Ϣ��һ��Downloader�������ѡ�е���������Ĭ����ʾ��һ����ѡ�еġ�����ѡ���򷵻ص�һ����������
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

// �������ò˵�����Ҫ�ҵ��͵�ǰѡ��������������������Ϣ���������öԻ��򣬶���ѡ����Ӧ������
// ��ѡ������£�ֻ�Ե�һ������Ӧ������
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

// ����˳�����صĲ˵�����ʼ˳������
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

// �����ˡ��������ļ��С��˵����������ļ��в�ѡ�е�һ���ļ�
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
