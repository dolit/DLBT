//=======================================================================================
//  功能：      显示详细信息的tab控件，提供对多个详细信息页的管理，呈现一个Tab方式的显示
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

#include "DetailInfoCtrl.h"

class CInfoTabCtrl : public CTabCtrl
{
	DECLARE_DYNAMIC(CInfoTabCtrl)

public:
	CInfoTabCtrl();
	virtual ~CInfoTabCtrl();

    BOOL Init ();

    afx_msg void OnLButtonDown(UINT nFlags, CPoint point);

    void Refresh (HANDLE hDownloader);

protected:
	DECLARE_MESSAGE_MAP()

    void ShowCurrent ();
    void HideCurrent ();

private:

    CDetailInfoCtrl   m_infoList [3]; // 目前有三个显示信息的页面
    int             m_tabCurrent;   // 记录当前选中的活动页
};


