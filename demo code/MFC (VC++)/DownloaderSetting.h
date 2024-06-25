//=======================================================================================
//  ���ܣ�      ��ʾĳ�������������Ϣ���ṩ�Ե���������ý���
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

struct DOWNLOADER_SETTING
{
    HANDLE  hDownloader;    // downloader handle
    int dsLimit;            // download speed limit
    int usLimit;            // upload speed limit
    int dcLimit;            // download connection limit
    int ucLimit;            // upload connection limit
    float shareRate;        // downloader's share rate

    DOWNLOADER_SETTING ()
    {
        hDownloader = NULL;
        dsLimit = usLimit = dcLimit = ucLimit = -1;
        shareRate = 0.0f;
    }
};

class CDownloaderSetting : public CDialog
{
	DECLARE_DYNAMIC(CDownloaderSetting)

public:
	CDownloaderSetting(CWnd* pParent = NULL);   // ��׼���캯��
	virtual ~CDownloaderSetting();

// �Ի�������
	enum { IDD = IDD_DOWNLOADERSETTING };

    void SetDownloaderSetting (DOWNLOADER_SETTING * ds) { m_ds = ds; }

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV ֧��

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedOk();

public:
    DOWNLOADER_SETTING * m_ds;
};
