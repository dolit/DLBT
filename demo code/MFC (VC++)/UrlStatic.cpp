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


// ��굥��ʱ������ַ
void CUrlStatic::OnLButtonDown(UINT nFlags, CPoint point)
{
    ShellExecute (::GetDesktopWindow (), _T ("open"), m_url, NULL, NULL, SW_SHOW);
}

// ������ַ���������
void CUrlStatic::Init ()
{
    SetClassLong (m_hWnd, GCL_HCURSOR, (LONG)(LONG_PTR)LoadCursor (AfxGetInstanceHandle (), MAKEINTRESOURCE (IDC_CURSOR1)));
    GetWindowText (m_url);
}