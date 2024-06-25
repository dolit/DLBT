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