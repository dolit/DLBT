//=======================================================================================
//  ���ܣ�      ��ʾ������ϸ��Ϣ�Ŀؼ���Ƕ��InfoTabCtrl���ӽ��棬��ʾ���������Ϣ
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

class CDetailInfoCtrl : public CListCtrl
{
	DECLARE_DYNAMIC(CDetailInfoCtrl)

public:
	CDetailInfoCtrl();
	virtual ~CDetailInfoCtrl();

    BOOL Init (CWnd * pParent, int [], LPCTSTR [], int count);

    void Refresh (HANDLE hDownloader, int index);

protected:
	DECLARE_MESSAGE_MAP()
};


