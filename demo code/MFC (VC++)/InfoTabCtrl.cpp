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
#include "InfoTabCtrl.h"
#include ".\infotabctrl.h"

int g_listColumnWidth1 [] = {180, 450};
int g_listColumnWidth2 [] = {180, 120, 120, 100, 100};
int g_listColumnWidth3 [] = {320, 60, 60, 260};

LPCTSTR g_listColumnText1 [] = {_T("����"), _T("��Ϣ")};
LPCTSTR g_listColumnText2 [] = {_T("IP"), _T("�ͻ���"), _T("����"), _T ("������"), _T ("���ϴ�")};
LPCTSTR g_listColumnText3 [] = {_T("�ļ���"), _T("�ļ���С"), _T ("����"), _T("Hash")};


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

// ��ʼ��InfoTab�ؼ��Ľ���
BOOL CInfoTabCtrl::Init ()
{
    InsertItem (0, _T ("������Ϣ"));
    InsertItem (1, _T ("�������"));
    InsertItem (2, _T ("�ļ���Ϣ"));

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

// ���ʱ���л�tabҳ
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

// ������һ�����ڵ���ʾ
void CInfoTabCtrl::HideCurrent ()
{
    m_infoList [m_tabCurrent].EnableWindow (FALSE);
    m_infoList [m_tabCurrent].ShowWindow (SW_HIDE);
}

// ��ʾ�����еĵ�ǰ����
void CInfoTabCtrl::ShowCurrent ()
{
    m_infoList [m_tabCurrent].EnableWindow (TRUE);
    m_infoList [m_tabCurrent].ShowWindow (SW_SHOW);
}

// ��ʱˢ����ϸ��Ϣ����ʾ
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

