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
#include "DetailInfoCtrl.h"
#include "Utils.h"


IMPLEMENT_DYNAMIC(CDetailInfoCtrl, CListCtrl)
CDetailInfoCtrl::CDetailInfoCtrl()
{
}

CDetailInfoCtrl::~CDetailInfoCtrl()
{
}


BEGIN_MESSAGE_MAP(CDetailInfoCtrl, CListCtrl)
END_MESSAGE_MAP()

// 界面初始化
BOOL CDetailInfoCtrl::Init (CWnd * pParent, int widths [], LPCTSTR texts [], int count)
{
    RECT  rect  = { 0, 0, 0, 0 };
    DWORD dwStyle = LVS_REPORT | LVS_SINGLESEL | WS_CHILD | WS_VISIBLE | LVS_ALIGNLEFT | WS_TABSTOP | WS_BORDER;

    if (!CListCtrl::Create (dwStyle, rect, pParent, 110))
        return FALSE;

    SetExtendedStyle (GetExtendedStyle () | LVS_EX_FULLROWSELECT | LVS_EX_GRIDLINES);
    int nFormat = LVCFMT_CENTER | DT_CENTER | DT_SINGLELINE | DT_VCENTER;

    for (int i = 0; i < count; i ++)
    {
        InsertColumn (i, texts[i], nFormat, widths [i]);
    }
    return TRUE;
}

// 定时刷新时，根据自己所处的位置，判断自己需要显示哪些具体信息
void CDetailInfoCtrl::Refresh (HANDLE hDownloader, int index)
{
    ASSERT (IsWindowVisible ());

	SetRedraw(FALSE);
    switch (index)
    {
    case 0:   // 常规信息
		{
			DeleteAllItems ();

            CString str = _T ("Info Hash:"); 
	        InsertItem (0, str);
            char infoHash [256];
            int nLen = sizeof (infoHash) / sizeof (infoHash[0]);
	        if (DLBT_Downloader_GetInfoHash (hDownloader, infoHash, &nLen) == S_OK)
                str = infoHash;

	        str.MakeUpper ();
	        str.Insert (8, ' ');
	        str.Insert (8+8+1, ' ');
	        str.Insert (8+8+8+2, ' ');
	        str.Insert (8+8+8+8+3, ' ');
	        SetItemText (0, 1, str);

            str = _T ("文件分块信息:");
	        InsertItem (1, str);
	        str.Format (_T ("%d x %s"), DLBT_Downloader_GetPieceCount (hDownloader),
		        BytesToString (DLBT_Downloader_GetPieceSize (hDownloader))); 
	        SetItemText (1, 1, str);

	        InsertItem (2, _T (""));
        	
            str = _T ("上传情况:"); 
	        InsertItem (3, str);
            str = _T ("速度：[");
            str += BytesToString (DLBT_Downloader_GetUploadSpeed (hDownloader));
            str += _T ("/s]  共上传：[");
            str += BytesToString (DLBT_Downloader_GetUploadedBytes (hDownloader)) + _T ("]  分享率：[");

            CString str2;
	        str2.Format (_T ("%.*g"), 4, (float)DLBT_Downloader_GetShareRate (hDownloader));
            str += str2 + _T ("]");
	        SetItemText (3, 1, str);

            str = _T ("种子和普通用户情况:");
            InsertItem (4, str);
            
            int connectedPeers = 0, totalSeeds = 0, seedsConnected = 0, inCompleteCount = 0, curTotalSeeds = 0, curTotalPeers = 0;
            DLBT_Downloader_GetPeerNums (hDownloader, &connectedPeers, &totalSeeds, &seedsConnected, &inCompleteCount, &curTotalSeeds, &curTotalPeers);
            if (totalSeeds != -1 && inCompleteCount != -1)
                str.Format (_T ("Tracker记录%d人在线，%d人已完成；P2P网络找到%d节点，%d个种子；已连上%d, 连上 %d 种子"), totalSeeds + inCompleteCount, totalSeeds, curTotalPeers, curTotalSeeds, connectedPeers, seedsConnected);
            else
                str.Format (_T ("P2P网络找到%d节点，%d个种子；已连上%d, 连上 %d 种子"), curTotalPeers, curTotalSeeds, connectedPeers, seedsConnected);
            SetItemText (4, 1, str);

            KERNEL_INFO info;
            DLBT_GetKernelInfo (&info);

            InsertItem (5, _T (""));
            InsertItem (6, _T ("内核整体情况如下："));

            InsertItem (7, _T ("DHT:"));
            CString dhtStr;
            dhtStr.Format (_T ("已启动 （连接上：%d， 缓存： %d）"), info.dhtConnectedNodeNum, info.dhtCachedNodeNum);
            SetItemText (7, 1, info.dhtStarted ? dhtStr : _T ("未启动"));
            InsertItem (8, _T ("端口:"));
            str.Format (_T ("%d"), info.port);
            SetItemText (8, 1, str);

            InsertItem (9, _T ("总下载字节数:"));
            SetItemText (9, 1, BytesToString(info.totalDownloadedByteCount));
            InsertItem (10, _T ("总上传字节数:"));
            SetItemText (10, 1, BytesToString(info.totalUploadedByteCount));
            InsertItem (11, _T ("总下载速度(/s):"));
            SetItemText (11, 1, BytesToString(info.totalDownloadSpeed));
            InsertItem (12, _T ("总上传速度(/s):"));
            SetItemText (12, 1, BytesToString(info.totalUploadSpeed));
        }

        break;

    case 1:     // 详细的连接信息
        {
			DeleteAllItems ();

            PEER_INFO * pInfo = NULL;
            DLBT_GetDownloaderPeerInfoList (hDownloader, &pInfo);
            
            USES_CONVERSION; 

            if (pInfo != NULL)
            {
                for (int i = 0; i < pInfo->count; i++)
                {                 
                    InsertItem (i, A2T(pInfo->entries[i].ip));
                    SetItemText (i, 1, A2T(pInfo->entries[i].client));

                    CString str;

					if (pInfo->entries[i].connectionType == 1)
						SetItemText (i, 2, _T("P2SP"));
					else if (pInfo->entries[i].connectionType == 2)
						SetItemText(i, 2, _T("UDP直连或穿透"));
					else
						SetItemText(i, 2, _T("标准协议"));

                    str.Format (_T ("%s, %s/s"), BytesToString (pInfo->entries[i].downloadedBytes),
                        BytesToString (pInfo->entries[i].downloadSpeed));
		            SetItemText (i, 3, str);

                    str.Format (_T ("%s, %s/s"), BytesToString (pInfo->entries[i].uploadedBytes),
                        BytesToString (pInfo->entries[i].uploadSpeed));
		            SetItemText (i, 4, str);
                }

                DLBT_FreeDownloaderPeerInfoList (pInfo);

                SetColumnWidth (0, LVSCW_AUTOSIZE);
			    SetColumnWidth (1, LVSCW_AUTOSIZE);
			    for (int i = 0; i < 2; i++)
			    {
				    if (GetColumnWidth (i) < 50)
					    SetColumnWidth (i, 50);
			    }
            }
        }
        break;

    case 2:     // 文件信息
        {
            int fileCount = DLBT_Downloader_GetFileCount (hDownloader);
			int itemCount = 0;
            for (int i = 0; i < fileCount; i ++)
            {
				//不显示padding_file 
				if (DLBT_Downloader_IsPadFile (hDownloader, i))
					continue;

				++itemCount;
				// 示例程序只显示最多20个文件
				if (i > 20)
				{
					if (GetItemCount() <= i)
						InsertItem (itemCount - 1, NULL);                

					if (GetItemCount() <= i)
						InsertItem (itemCount - 1, NULL); 
					SetItemText (itemCount - 1, 0, _T("点量BT示例程序只显示最多20个文件......"));
					break;
				}

                WCHAR fileName[MAX_PATH];
                int len = MAX_PATH;
                if (DLBT_Downloader_GetFilePathName (hDownloader, i, fileName, &len) != S_OK)
                    continue;
                
				if (GetItemCount() <= i)
					InsertItem (itemCount - 1, NULL);  

                CString strFileName = CW2T(fileName);
				UINT64 fileSize = DLBT_Downloader_GetFileSize (hDownloader, i);
				SetItemText (itemCount - 1, 0, strFileName);
                SetItemText (itemCount - 1, 1, BytesToString (fileSize));

				// **** 注意： 取文件进度的操作可能会造成系统资源浪费，建议仅在必要时使用 ****
				float  filePercent = DLBT_Downloader_GetFileProgress (hDownloader, i);

                CString str;
                str.Format (_T ("%.2f%%"), filePercent * 100);
                SetItemText (itemCount - 1, 2, str);

				char infoHash [48] = {0};
				str.Empty();
				int nLen = sizeof (infoHash) / sizeof (infoHash[0]);
				if (DLBT_Downloader_GetFileHash (hDownloader, i, infoHash, &nLen) == S_OK)
					str = infoHash;
				SetItemText(itemCount - 1, 3, str);
            }

			for (int i = itemCount; i < GetItemCount(); ++i)
			{
				DeleteItem(i);
			}
        }
        break;
    }

	SetRedraw(TRUE);
}
