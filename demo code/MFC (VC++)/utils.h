//=======================================================================================
//  ���ܣ�      ���ߺ���
// 
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

#pragma once

CString IntToStr (int i);
CString FloatToStr (float f);

void BytesToDisplayBytes (UINT64 uBytes, float* fBytes, LPTSTR displayStr);
CString BytesToStr (UINT64 uBytes);
CString BytesToString (UINT64 size);

CString TimeInSecondToStr (DWORD seconds);
CString GetFilePath(LPCTSTR lpszFilePath);