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
#include "InfoTabCtrl.h"
#include ".\infotabctrl.h"

int g_listColumnWidth1 [] = {180, 450};
int g_listColumnWidth2 [] = {180, 120, 120, 100, 100};
int g_listColumnWidth3 [] = {320, 60, 60, 260};

LPCTSTR g_listColumnText1 [] = {_T("名称"), _T("信息")};
LPCTSTR g_listColumnText2 [] = {_T("IP"), _T("客户端"), _T("类型"), _T ("已下载"), _T ("已上传")};
LPCTSTR g_listColumnText3 [] = {_T("文件名"), _T("文件大小"), _T ("进度"), _T("Hash")};


IMPLEMENT_DYNAMIC(CInfoTabCtrl, CTabCtrl)
CInfoTabCtrl::CInfoTabCtrl()
{
    m_tabCurrent = 0;
}

CInfoTabCtrl::~CInfoTabCtrl()
{
}


BEGIN_MESSAGE_MAP(CInfoTabCtrl, CTabCtrl)    
    ON_WM_LBUTTONDOWN()
END_MESSAGE_MAP()

// 初始化InfoTab控件的界面
BOOL CInfoTabCtrl::Init ()
{
    InsertItem (0, _T ("基本信息"));
    InsertItem (1, _T ("连接情况"));
    InsertItem (2, _T ("文件信息"));

    //for (int i = 0; i < sizeof (m_infoList) / sizeof (m_infoList[0]); i++)
    //{
    m_infoList[0].Init (this, g_listColumnWidth1, g_listColumnText1, sizeof (g_listColumnWidth1) / sizeof (int));
    m_infoList[1].Init (this, g_listColumnWidth2, g_listColumnText2, sizeof (g_listColumnWidth2) / sizeof (int));
    m_infoList[2].Init (this, g_listColumnWidth3, g_listColumnText3, sizeof (g_listColumnWidth3) / sizeof (int));

    m_infoList[0].ShowWindow (SW_SHOW);
    m_infoList[1].ShowWindow (SW_HIDE);
    m_infoList[2].ShowWindow (SW_HIDE);
    //}


    CRect tabRect, itemRect;
	int nX, nY, nXc, nYc;

	GetClientRect(&tabRect);
	GetItemRect(0, &itemRect);

	nX = itemRect.left;
	nY = itemRect.bottom+1;
	nXc = tabRect.right-itemRect.left-1;
	nYc = tabRect.bottom-nY-1;

    m_infoList[0].SetWindowPos (&wndTop, nX, nY, nXc, nYc, SWP_SHOWWINDOW);
    for (int i = 1; i < sizeof (m_infoList) / sizeof (m_infoList[0]); i++)
    {
        m_infoList[i].SetWindowPos (&wndTop, nX, nY, nXc, nYc, SWP_HIDEWINDOW);
    }

    return TRUE;
}

// 点击时，切换tab页
void CInfoTabCtrl::OnLButtonDown(UINT nFlags, CPoint point) 
{
    CTabCtrl::OnLButtonDown(nFlags, point);
    if (m_tabCurrent != GetCurSel())
    {
            HideCurrent ();
            m_tabCurrent = GetCurSel();            
            ShowCurrent ();
    }
}

// 隐藏上一个窗口的显示
void CInfoTabCtrl::HideCurrent ()
{
    m_infoList [m_tabCurrent].EnableWindow (FALSE);
    m_infoList [m_tabCurrent].ShowWindow (SW_HIDE);
}

// 显示被点中的当前窗口
void CInfoTabCtrl::ShowCurrent ()
{
    m_infoList [m_tabCurrent].EnableWindow (TRUE);
    m_infoList [m_tabCurrent].ShowWindow (SW_SHOW);
}

// 定时刷新详细信息的显示
void CInfoTabCtrl::Refresh (HANDLE hDownloader)
{
    if (hDownloader == NULL)
    {
        for (int i = 0; i < 3; i++)
        {
            m_infoList[0].DeleteAllItems ();
        }
    }
    else
    {
        m_infoList [m_tabCurrent].Refresh (hDownloader, m_tabCurrent);
    }
}

