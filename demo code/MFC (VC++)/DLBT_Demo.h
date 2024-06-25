//=======================================================================================
//  功能：      演示程序的入口文件，由MFC向导自动生成，没有改动
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

#ifndef __AFXWIN_H__
	#error 在包含用于 PCH 的此文件之前包含“stdafx.h”
#endif

#include "resource.h"		// 主符号


// CDLBT_DemoApp:
// 有关此类的实现，请参阅 DLBT_Demo.cpp
//

class CDLBT_DemoApp : public CWinApp
{
public:
	CDLBT_DemoApp();

// 重写
	public:
	virtual BOOL InitInstance();

// 实现

	DECLARE_MESSAGE_MAP()
};

extern CDLBT_DemoApp theApp;
