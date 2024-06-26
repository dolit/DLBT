//=======================================================================================
//  功能：      显示某个任务的设置信息，提供对单任务的设置界面
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
	CDownloaderSetting(CWnd* pParent = NULL);   // 标准构造函数
	virtual ~CDownloaderSetting();

// 对话框数据
	enum { IDD = IDD_DOWNLOADERSETTING };

    void SetDownloaderSetting (DOWNLOADER_SETTING * ds) { m_ds = ds; }

protected:
    virtual BOOL OnInitDialog();
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	DECLARE_MESSAGE_MAP()
public:
    afx_msg void OnBnClickedOk();

public:
    DOWNLOADER_SETTING * m_ds;
};
