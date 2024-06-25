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
#include "UrlStatic.h"
#include ".\urlstatic.h"


IMPLEMENT_DYNAMIC(CUrlStatic, CStatic)
CUrlStatic::CUrlStatic()
{
}

CUrlStatic::~CUrlStatic()
{
}


BEGIN_MESSAGE_MAP(CUrlStatic, CStatic)
ON_WM_LBUTTONDOWN()
END_MESSAGE_MAP()


// 鼠标单击时，打开网址
void CUrlStatic::OnLButtonDown(UINT nFlags, CPoint point)
{
    ShellExecute (::GetDesktopWindow (), _T ("open"), m_url, NULL, NULL, SW_SHOW);
}

// 设置网址和手型鼠标
void CUrlStatic::Init ()
{
    SetClassLong (m_hWnd, GCL_HCURSOR, (LONG)(LONG_PTR)LoadCursor (AfxGetInstanceHandle (), MAKEINTRESOURCE (IDC_CURSOR1)));
    GetWindowText (m_url);
}