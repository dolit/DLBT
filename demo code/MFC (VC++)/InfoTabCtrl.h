//=======================================================================================
//  ���ܣ�      ��ʾ��ϸ��Ϣ��tab�ؼ����ṩ�Զ����ϸ��Ϣҳ�Ĺ�������һ��Tab��ʽ����ʾ
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

    CDetailInfoCtrl   m_infoList [3]; // Ŀǰ��������ʾ��Ϣ��ҳ��
    int             m_tabCurrent;   // ��¼��ǰѡ�еĻҳ
};


