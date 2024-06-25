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
#include "utils.h"

CString IntToStr (int i)
{
    CString str;
    str.Format (_T ("%d"), i);
    return str;
}

CString FloatToStr (float f)
{
    CString str;
    str.Format (_T ("%.2f"), f);
    return str;
}

void BytesToDisplayBytes (UINT64 uBytes, float* fBytes, LPTSTR displayStr)
{
	LPCTSTR pName [] = {_T ("B"), _T ("KB"), _T ("MB"), _T("GB")};
	int i = 0;
	double dBytes = (double) (INT64)uBytes;

	while (dBytes > 1024)
	{
		dBytes /= 1024;
		i++;
	}
	if (displayStr != NULL)
	{
		if (i > 3)
			_tcscpy (displayStr, _T("?"));
		else
			_tcscpy (displayStr, pName [i]);
	}

	*fBytes = (float) dBytes;
}

CString BytesToString (UINT64 size)
{
    if (size == _UI64_MAX)
        return _T ("?");

	CString str;    
	float f;
	TCHAR ch [10];
	BytesToDisplayBytes (size, &f, ch);
	str.Format (_T ("%.*g %s"), f > 999 ? 4 : 3, f, ch);
	return str;
}

CString TimeInSecondToStr (DWORD seconds)
{
	CString str;

	str.Format (_T ("%02d:%02d:%02d"), (int)(seconds / 3600), (int)((seconds % 3600) / 60), (int)(seconds % 60));	
	return str;
}

CString GetFilePath(LPCTSTR lpszFilePath)
{
    TCHAR szDrive[_MAX_PATH];
    TCHAR szDir[_MAX_PATH];
    _tsplitpath(lpszFilePath, szDrive, szDir, NULL, NULL);
    return CString(szDrive) + CString(szDir);
}