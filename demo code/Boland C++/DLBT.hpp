//=======================================================================================
//                 ����BT��DLBT������ ��������רҵ��BT�ں�DLL��
//                                  ��ʡ���Ŀ���ʱ��
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


#ifndef DlbtHPP
#define DlbtHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dlbt
{
//-- type declarations -------------------------------------------------------
typedef System::Word 		USHORT;
typedef DynamicArray<System::WideChar> LPBYTE;

#define DLBT_API extern "C"  __declspec(dllimport)
#define WINAPI __stdcall
#define NULL ((void *)(0x0))

#pragma option push -b-
enum DLBT_PROXY_TYPE
{
	DLBT_PROXY_NONE,            // ��ʹ�ô���
	DLBT_PROXY_SOCKS4,          // ʹ��SOCKS4������Ҫ�û���
	DLBT_PROXY_SOCKS5,          // ʹ��SOCKS5���������û���������
	DLBT_PROXY_SOCKS5A,         // ʹ����Ҫ������֤��SOCKS5������Ҫ�û���������
	DLBT_PROXY_HTTP,            // ʹ��HTTP�����������ʣ��������ڱ�׼��HTTP���ʣ�Tracker��Http��Э�鴫�䣬�����򲻿���
	DLBT_PROXY_HTTPA            // ʹ����Ҫ������֤��HTTP����
};
#pragma option pop

#pragma option push -b-
// �������ص�״̬
enum DLBT_DOWNLOAD_STATE
{
	BTDS_QUEUED,	                // �����
	BTDS_CHECKING_FILES,	        // ���ڼ��У���ļ�
	BTDS_DOWNLOADING_TORRENT,	    // ������ģʽ�£����ڻ�ȡ���ӵ���Ϣ
	BTDS_DOWNLOADING,	            // ����������
	BTDS_PAUSED,                    // ��ͣ
	BTDS_FINISHED,	                // ָ�����ļ��������
	BTDS_SEEDING,	                // �����У������е������ļ�������ɣ�
	BTDS_ALLOCATING,                // ����Ԥ������̿ռ� -- Ԥ����ռ䣬���ٴ�����Ƭ����
									// ����ѡ���йأ�����ʱ���ѡ��Ԥ������̷�ʽ�����ܽ����״̬
	BTDS_ERROR,                     // ����������д���̳����ԭ����ϸԭ�����ͨ������DLBT_Downloader_GetLastError��֪
};
#pragma option pop

#pragma option push -b-
// �ļ��ķ���ģʽ,���ʹ��˵���ĵ�
enum DLBT_FILE_ALLOCATE_TYPE
{
	FILE_ALLOCATE_REVERSED  = 0,   // Ԥ����ģʽ,Ԥ�ȴ����ļ�,����ÿһ���ŵ���ȷ��λ��
	FILE_ALLOCATE_SPARSE,          // Default mode, more effient and less disk space.NTFS����Ч http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
	FILE_ALLOCATE_COMPACT          // �ļ���С�������ز�������,ÿ����һ�����ݰ������������һ��,���������ǵ�����λ��,�����в��ϵ���λ��,����ļ�λ�÷���ȷ��         .
};

#pragma option pop

#pragma option push -b-
enum DLBT_RELEASE_FLAG
{
    DLBT_RELEASE_NO_WAIT = 0,           // Ĭ�Ϸ�ʽRelease��ֱ���ͷţ����ȴ��ͷ����
    DLBT_RELEASE_WAIT = 1,              // �ȴ������ļ����ͷ����
    DLBT_RELEASE_DELETE_STATUS = 2,     // ɾ��״̬�ļ�
    DLBT_RELEASE_DELETE_ALL = 4         // ɾ�������ļ�
};
#pragma option pop

#pragma option push -b-
enum DLBT_TORRENT_TYPE
{
    USE_PUBLIC_DHT_NODE     = 0,    // ʹ�ù�����DHT������Դ
    NO_USE_PUBLIC_DHT_NODE,         // ��ʹ�ù�����DHT����ڵ�
    ONLY_USE_TRACKER,               // ��ʹ��Tracker����ֹDHT������û���Դ������˽�����ӣ�
};
#pragma option pop

#pragma option push -b-
// �˿ڵ�����
enum PORT_TYPE
{
    TCP_PORT        = 1,            // TCP �˿�
    UDP_PORT                        // UDP �˿�
};
#pragma option pop

#pragma option push -b-
//=======================================================================================
//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
//  ������Ӫ�̵ķ�������ͬ�������£�������Ҫ��ͬ���á����αװHttpʹ�ã���ĳЩ������Ч������
//=======================================================================================
enum DLBT_ENCRYPT_OPTION
{
    DLBT_ENCRYPT_NONE,                  // ��֧���κμ��ܵ����ݣ��������ܵ�ͨѶ��Ͽ�
    DLBT_ENCRYPT_COMPATIBLE,            // ����ģʽ���Լ���������Ӳ�ʹ�ü��ܣ���������˵ļ������ӽ��룬�������ܵ���ͬ�Է��ü���ģʽ�Ự��
    DLBT_ENCRYPT_FULL,                  // �������ܣ��Լ����������Ĭ��ʹ�ü��ܣ�ͬʱ������ͨ�ͼ��ܵ��������롣�����������ü���ģʽ�Ự�������Ǽ�����������ģʽ�Ự��
                                        // Ĭ������������
    DLBT_ENCRYPT_FORCED,                // ǿ�Ƽ��ܣ���֧�ּ���ͨѶ����������ͨ���ӣ����������ܵ���Ͽ�
};
#pragma option pop

#pragma option push -b-
// ���ܲ㼶�ߣ������ϻ��˷�һ��CPU�������ݴ��䰲ȫ��ͻ�Ʒ�����������������
enum DLBT_ENCRYPT_LEVEL
{
    DLBT_ENCRYPT_PROTOCOL,          // ������BT��ͨѶ����Э��  ����һ�����ڷ�ֹ��Ӫ�̵���ֹ
    DLBT_ENCRYPT_DATA,              // ���������������������ݣ����� ���ڱ�����ǿ���ļ�����
    DLBT_ENCRYPT_PROTOCOL_MIX,      // �������������ʹ�ü���Э��ģʽ��������Է�ʹ�������ݼ��ܣ�Ҳ֧��ͬ��ʹ�����ݼ���ģʽͨѶ
    DLBT_ENCRYPT_ALL                // Э������ݾ��������� 
};
#pragma option pop

#pragma option push -b-
enum DLBT_FILE_PRIORITIZE
{
	DLBT_FILE_PRIORITY_CANCEL        =   0,     // ȡ�����ļ�������
	DLBT_FILE_PRIORITY_NORMAL,                  // �������ȼ�
	DLBT_FILE_PRIORITY_ABOVE_NORMAL,            // �����ȼ�
	DLBT_FILE_PRIORITY_MAX                      // ������ȼ�������и����ȼ����ļ���δ���꣬�������ص����ȼ����ļ���
};
#pragma option pop

struct DLBT_KERNEL_START_PARAM
{
    BOOL bStartLocalDiscovery;		// �Ƿ������������ڵ��Զ����֣���ͨ��DHT��Tracker��ֻҪ��һ��������Ҳ���������֣��������ٶȿ죬���Լ������ȷ���ͬһ�����������ˣ�
    BOOL bStartUPnP;				// �Ƿ��Զ�UPnPӳ�����BT�ں�����Ķ˿�
    BOOL bStartDHT;					// Ĭ���Ƿ�����DHT�����Ĭ�ϲ����������Ժ�����ýӿ�������
    BOOL bLanUser;                  // �Ƿ񴿾������û�����ϣ���û������������Ӻ�����ͨѶ��������������ģʽ---��ռ����������ֻͨ���������û������أ�
    BOOL bVODMode;                  // �����ں˵�����ģʽ�Ƿ��ϸ��VODģʽ���ϸ��VODģʽ����ʱ��һ���ļ��ķֿ����ϸ񰴱Ƚ�˳��ķ�ʽ���أ���ǰ������أ����ߴ��м�ĳ���϶���λ���������
                                    // ��ģʽ�Ƚ��ʺϱ����ر߲���,������ģʽ���˺ܶ��Ż��������ڲ���������أ����Բ����ʺϴ����صķ�����ֻ�����ڱ����ر߲���ʱʹ�á�Ĭ������ͨģʽ����
                                    // ��VOD���ϰ汾����Ч

    USHORT  startPort;	            // �ں˼����Ķ˿ڣ����startPort��endPort��Ϊ0 ����startPort > endPort || endPort > 32765 ���ֲ����Ƿ������ں��������һ���˿ڡ� ���startPort��endPort�Ϸ�
    USHORT  endPort;				// �ں����Զ���startPort ---- endPort֮�����һ�����õĶ˿ڡ�����˿ڿ��Դ�DLBT_GetListenPort���

    // �������ں��ڲ���Ĭ�����ã�Ĭ��ʹ������˿ڣ�������DHT�ȣ�
    DLBT_KERNEL_START_PARAM ()
    {
        bStartLocalDiscovery = TRUE;
        bStartUPnP = TRUE;
        bStartDHT = TRUE;
        bLanUser = FALSE;
        bVODMode = FALSE;

        startPort = 0;
        endPort = 0;
    }
};

// �ں˵Ļ�����Ϣ
struct KERNEL_INFO
{
public:
    USHORT                      port;                           // �����˿�
    BOOL                        dhtStarted;                     // DHT�Ƿ�����
    int                         totalDownloadConnectionCount;   // �ܵ�����������
    int                         downloadCount;                  // ��������ĸ���
    int                         totalDownloadSpeed;             // �������ٶ�
    int                         totalUploadSpeed;               // ���ϴ��ٶ�
    UINT64                      totalDownloadedByteCount;       // �����ص��ֽ���
    UINT64                      totalUploadedByteCount;         // ���ϴ����ֽ���

    int                         peersNum;                       // ��ǰ�����ϵĽڵ�����
    int                         dhtConnectedNodeNum;            // dht�����ϵĻ�Ծ�ڵ���
    int                         dhtCachedNodeNum;               // dht��֪�Ľڵ���
    int                         dhtTorrentNum;                  // dht����֪��torrent�ļ���
};


// ������������Ļ�����Ϣ
struct DOWNLOADER_INFO
{
    DLBT_DOWNLOAD_STATE          state;                         // ���ص�״̬
    float                       percentDone;                    // �Ѿ����ص����ݣ��������torrent�����ݵĴ�С �����ֻѡ����һ�����ļ����أ���ô�ý��Ȳ��ᵽ100%��
    int                         downConnectionCount;            // ���ؽ�����������
    int                         downloadLimit;                  // ���������������
    int                         connectionCount;                // �ܽ������������������ϴ���
    int                         totalCompletedSeeds;            // Tracker������������������ɵ����������Tracker��֧��scrap���򷵻�-1
    int                         inCompleteNum;                  // �ܵ�δ��ɵ����������Tracker��֧��scrap���򷵻�-1
    int                         seedConnected;                  // ���ϵ�������ɵ�����
    int                         totalCurrentSeedCount;          // ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
    int                         totalCurrentPeerCount;          // ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
    float                       currentTaskProgress;            // ��ǰ����Ľ��� ��100.0%������ɣ�
    BOOL                        bReleasingFiles;                // �Ƿ������ͷ��ļ������һ��������ɺ���Ȼ��������ˣ����ļ�����ͻ����ڲ���������Ҫһ��ʱ�����ͷš�
    UINT                        downloadSpeed;                  // ���ص��ٶ�
    UINT                        uploadSpeed;                    // �ϴ����ٶ�
    UINT                        serverPayloadSpeed;             // �ӷ��������ص�����Ч�ٶȣ�������������Ϣ�ȷ������Դ��䣩
    UINT                        serverTotalSpeed;               // �ӷ��������ص����ٶ�(����������Ϣ������ͨѶ�����ģ�

    UINT64                      wastedByteCount;                // �����ݵ��ֽ�����������Ϣ�ȣ�
    UINT64                      totalDownloadedBytes;           // ���ص����ݵ��ֽ���
    UINT64                      totalUploadedBytes;             // �ϴ������ݵ��ֽ���
    UINT64                      totalWantedBytes;               // ѡ��������ݴ�С
    UINT64                      totalWantedDoneBytes;           // ѡ����������У���������ɵ����ݴ�С

    UINT64                      totalServerPayloadBytes;        // �ӷ��������ص��������������������������ļ����ݣ�Ҳ����������յ���������ݣ���ʹ���������� -- ����һ����������û���⣬���ᶪ�����ݵģ�
    UINT64                      totalServerBytes;               // �ӷ��������ص��������ݵ�����������totalServerPayloadBytes���Լ��������ݡ��շ���Ϣ�ȣ�
    UINT64                      totalPayloadBytesDown;          // �����������ܵ����ص����ݿ����͵��������������˷����������ݣ��Լ����ܶ��������ݣ�
    UINT64                      totalBytesDown;                 // �����������ܵ��������ݵ������������������˷������Լ����пͻ������ݡ�����ͨѶ�������ȣ������������Ϊ�кܶ�Э�����ݣ��ļ�������ɺ󣬸������ϴ�ʱ��һЩ����ͨѶҲ���¼����
								// �������������������ʱ�䣬�᲻ͣ����


    // Torrent��Ϣ
    BOOL                        bHaveTorrent;                   // ��������������ģʽ���ж��Ƿ��Ѿ���ȡ����torrent�ļ�
    UINT64                      totalFileSize;                  // �ļ����ܴ�С
    UINT64                      totalFileSizeExcludePadding;    // ʵ���ļ��Ĵ�С������padding�ļ�, �����������padding�ļ������totalFileSize���
    UINT64                      totalPaddingSize;               // ����padding���ݵĴ�С�������������ʱû����padding�ļ�����Ϊ0
    int                         pieceCount;                     // �ֿ���
    int                         pieceSize;                      // ÿ����Ĵ�С
    char                        infoHash [256];                 // �ļ���Hashֵ
};

// ÿ�������ϵĽڵ㣨�û�������Ϣ   
struct PEER_INFO_ENTRY
{
	int							connectionType;					// �������� 0����׼BT(tcp); 1: P2SP��http�� 2: udp��������ֱ�����ӻ��ߴ�͸��
    int                         downloadSpeed;                  // �����ٶ�
    int                         uploadSpeed;                    // �ϴ��ٶ�
    UINT64                      downloadedBytes;                // ���ص��ֽ���
    UINT64                      uploadedBytes;                  // �ϴ����ֽ���

    int                         uploadLimit;                    // �����ӵ��ϴ����٣���������Է�������IP�����ˣ�����ط����Կ������IP���������
    int                         downloadLimit;                  // �����ӵ��������٣���������Է�������IP�����ˣ�����ط����Կ������IP���������

    char                        ip [64];                        // �Է�IP
    char                        client [64];                    // �Է�ʹ�õĿͻ���

};

// ���������ϵĽڵ㣨�û�������Ϣ
struct PEER_INFO
{
	
public:
	int count;
	PEER_INFO_ENTRY             entries [1];                    // �ڵ���Ϣ������
};


//-- var, const, procedure ---------------------------------------------------
#define DLBT_Library L"dlbt.dll"


// ***************************  �������ں�������صĽӿ� ********************************

//=======================================================================================
//  �ں˵������͹رպ�������ҵ��Ȩ�����˽��Э�鹦�ܣ���ʾ��ֻ���ñ�׼BT��ʽ
//=======================================================================================
DLBT_API BOOL WINAPI DLBT_Startup (
    DLBT_KERNEL_START_PARAM * param = NULL, // �ں��������ã��ο�DLBT_KERNEL_START_PARAM�����ΪNULL����ʹ���ڲ�Ĭ������
    LPCSTR  privateProtocolIDs = NULL,  // �����Զ���˽��Э�飬ͻ����Ӫ�����ơ����ΪNULL������Ϊ��׼��BT�ͻ�������
                                        // ����BT��˽��Э����3.4�汾�н�����ȫ�¸Ľ������Դ�͸�󲿷���Ӫ�̶�Э��ķ���
    bool    seedServerMode = false,     // �Ƿ��ϴ�ģʽ���ϴ�ģʽ�ڲ���Щ�����������Ż����ʺϴ󲢷��ϴ�������������ͨ�ͻ������ã�ֻ�����ϴ�������ʹ��
                                        // רҵ�ϴ�������ģʽ������ҵ������Ч����ʾ���ݲ�֧�ָù��ܡ����ʹ��˵���ĵ�
    LPCSTR  productNum = NULL           // ��ҵ���û�������ID���ڹ�������߻��ṩһ����Ʒ��Կ��������ҵ�湦�ܣ����ð��û���ʹ��NULL��    
    );

//=======================================================================================
//  ���þ������Զ����ֵ�һЩ����, interval_seconds�鲥�������������鲻Ҫ����10s�� bUseBroadcast: �Ƿ�ʹ�ù㲥ģʽ
//  Ĭ���ڲ�ʹ���鲥�����ʹ�ù㲥�����ܾ���������������̫�࣬һ�㲻����
//=======================================================================================
DLBT_API void WINAPI DLBT_SetLsdSetting (int interval_seconds, bool bUseBroadcast);

// ����ں˼����Ķ˿�
DLBT_API USHORT WINAPI DLBT_GetListenPort ();

// ���رյ���BT�ں�
DLBT_API void WINAPI DLBT_Shutdown ();

// ���ڹرյ��ٶȿ��ܻ�Ƚ���(��Ҫ֪ͨTracker Stop), ���Կ��Ե��øú�����ǰ֪ͨ,��������ٶ�
// Ȼ������ڳ�������˳�ʱ����DLBT_Shutdown�ȴ������Ľ���
DLBT_API void WINAPI DLBT_PreShutdown ();

//=======================================================================================
//  �ں˵��ϴ������ٶȡ���������û���������
//=======================================================================================
// �ٶ����ƣ���λ���ֽ�(BYTE)�������Ҫ����1M�������� 1024*1024
DLBT_API void WINAPI DLBT_SetUploadSpeedLimit (int limit);
DLBT_API void WINAPI DLBT_SetDownloadSpeedLimit (int limit);

// ���������������������ӵ���������
DLBT_API void WINAPI DLBT_SetMaxUploadConnection (int limit);
DLBT_API void WINAPI DLBT_SetMaxTotalConnection (int limit);

// ��෢������������ܶ����ӿ����Ƿ����ˣ�����û���ϣ�
DLBT_API void WINAPI DLBT_SetMaxHalfOpenConnection (int limit);

// ���������Ƿ�Ը��Լ���ͬһ�����������û����٣�limit���Ϊtrue����ʹ�ú�������е�������ֵ�������٣������ޡ�Ĭ�ϲ���ͬһ���������µ��û�Ӧ�����١�
DLBT_API void WINAPI DLBT_SetLocalNetworkLimit (    
	bool    limit,              // �Ƿ����þ���������
    int     downSpeedLimit,     // ������þ��������٣��������ٵĴ�С����λ�ֽ�/��
    int     uploadSpeedLimit    // ������þ��������٣������ϴ��ٶȴ�С����λ�ֽ�/��
    );  

// �����ļ�ɨ��У��ʱ����Ϣ������circleCount����ѭ�����ٴ���һ����Ϣ��Ĭ����0��Ҳ���ǲ���Ϣ��
// sleepMs������Ϣ��ã�Ĭ����1ms
DLBT_API void WINAPI DLBT_SetFileScanDelay (DWORD circleCount, DWORD sleepMs);

// �����ļ�������ɺ��Ƿ��޸�Ϊԭʼ�޸�ʱ�䣨��������ʱÿ���ļ����޸�ʱ��״̬�������øú�����������torrent�л������ÿ���ļ���ʱ���޸�ʱ����Ϣ
// �û�������ʱ�������������Ϣ�����ҵ����˸ú����������ÿ���ļ����ʱ���Զ����ļ����޸�ʱ������Ϊtorrent�����м�¼��ʱ��
// ���ֻ�����صĻ����������˸ú��������������ӵĻ�����û��ʹ�øú�����������û��ÿ���ļ���ʱ����Ϣ������Ҳ�޷�����ʱ���޸�
DLBT_API void WINAPI DLBT_UseServerModifyTime(BOOL bUseServerTime);

// �Ƿ�����UDP��͸���书�ܣ�Ĭ�����Զ���Ӧ������Է�֧�֣���tcp�޷�����ʱ���Զ��л�ΪudpͨѶ
DLBT_API void WINAPI DLBT_EnableUDPTransfer(BOOL bEnabled);

// �Ƿ�����αװHttp���䣬ĳЩ�����������������ǡ�������һЩ���磩��Http�����٣�����P2P������20K���ң��������绷���£���������Http����
//  Ĭ��������αװHttp�Ĵ�����루���Խ������ǵ�ͨѶ�������Լ���������Ӳ�����αװ�� ����ͻ�Ⱥ���������û������Կ��Ƕ����ã�����αװ��
// ������αװҲ�и����ã�������Щ����������һ������ͨ��������Http����ʹ��������������ʹ��IP����BT�����У��Է�û�кϷ������������ᱻ�������ƽ�ɱ
// ������������ƣ���������αװ���û���ٶȡ����������ʵ��ʹ��ѡ��
DLBT_API void WINAPI DLBT_SetP2PTransferAsHttp (bool bHttpOut, bool bAllowedIn = true);

// �Ƿ�ʹ�õ����Ĵ�͸�������������ʹ�õ�������������͸��Э������ĳ��˫���������ϵĵ�����p2p�ڵ㸨�����
DLBT_API BOOL WINAPI DLBT_AddHoleServer(LPCSTR ip, short port);

// ���÷�������IP�����Զ�ε������ö�������ڱ����ЩIP�Ƿ��������Ա�ͳ�ƴӷ��������ص������ݵ���Ϣ�������ٶȵ���һ���̶ȿ��ԶϿ����������ӣ���ʡ����������
// P2SP���������Զ��ᱻ���Ϊ������������Ҫ�ٵ�������
DLBT_API void WINAPI DLBT_AddServerIP (LPCSTR ip);
// ��ȥ�������p2sp��url�������ظ�����. Ŀ���ǣ�����Ƿ������ϣ����p2sp��url���ڱ�������û��Ҫȥ�������url��
DLBT_API void WINAPI DLBT_AddBanServerUrl (LPCSTR url);

// ����һ��״̬�ļ����������ڲ�Ĭ��ȫ��������ɺ󱣴�һ�Ρ����Ե���Ϊ�Լ���Ҫ��ʱ�����������Ŀ������ÿ5���ӱ���һ�Σ���������100�����ݺ󱣴�һ��
DLBT_API BOOL WINAPI DLBT_SetStatusFileSavePeriod (
    int             iPeriod,               //����������λ���롣Ĭ����0���������������ɣ�������������
    int             iPieceCount            //�ֿ���Ŀ��Ĭ��0���������������ɣ�������������
    );

//=======================================================================================
//  ���ñ���Tracker�ı���IP���������غ͹���ʱ�����Լ�NAT�Ĺ���IP��Ƚ���Ч����ϸ�ο�
//  ����BT��ʹ��˵���ĵ�
//=======================================================================================
DLBT_API void WINAPI DLBT_SetReportIP (LPCSTR ip);
DLBT_API LPCSTR WINAPI DLBT_GetReportIP ();

DLBT_API void WINAPI DLBT_SetUserAgent (LPCSTR agent);

//=======================================================================================
//  ���ô��̻��棬3.3�汾���Ѷ��⿪�ţ�3.3�汾��ϵͳ�ڲ��Զ�����8M���棬���������ʹ�ø�
//  �������е�������λ��K������Ҫ����1M�Ļ��棬��Ҫ����1024
//=======================================================================================
DLBT_API void WINAPI DLBT_SetMaxCacheSize (DWORD size);

// һЩ���ܲ������ã�Ĭ������£�����BT��Ϊ����ͨ���绷���µ��ϴ����������ã��������ǧM��������
// ���Ҵ����������ã�����50M/s����100M/s�ĵ����ļ������ٶȣ�����Ҫ������Щ�������������Լ�ڴ棬Ҳ����������Щ����
// ������������ý��飬����ѯ���������ȡ

DLBT_API void WINAPI DLBT_SetPerformanceFactor(
    int             socketRecvBufferSize,      // ����Ľ��ջ�������Ĭ�����ò���ϵͳĬ�ϵĻ����С
    int             socketSendBufferSize,      // ����ķ��ͻ�������Ĭ���ò���ϵͳ��Ĭ�ϴ�С
    int             maxRecvDiskQueueSize,      // ���������δд�꣬������������󣬽���ͣ���գ��ȴ������ݶ���С�ڸò���
    int             maxSendDiskQueueSize       // ���С�ڸò����������߳̽�Ϊ���͵������������ݣ������󣬽���ͣ���̶�ȡ
    );

//���ip������(���������һ����Χ�ڵ�ip,���ֻ��һ��ip�ڶ�����������ΪNULL),�ɹ�����0��ʧ�ܷ���<0
DLBT_API int WINAPI DLBT_AddIpBlackList(const char*ipRangeStart,const char*ipRangeEnd);
//��յ�ǰip�������б�
DLBT_API void WINAPI DLBT_RemoveAllBlackList();

//=======================================================================================
//  DHT��غ���,port��DHT�����Ķ˿ڣ�udp�˿ڣ������Ϊ0��ʹ���ں˼�����TCP�˿ںż���
//=======================================================================================
DLBT_API void WINAPI DLBT_DHT_Start (USHORT port = 0);
DLBT_API void WINAPI DLBT_DHT_Stop ();
DLBT_API BOOL WINAPI DLBT_DHT_IsStarted ();

//=======================================================================================
//  ���ô�����غ���,��ҵ��Ȩ����д˹��ܣ���ʾ���ݲ��ṩ
//=======================================================================================

struct DLBT_PROXY_SETTING
{
    char    proxyHost [256];    // �����������ַ
    int     nPort;              // ����������Ķ˿�
    char    proxyUser [256];    // �������Ҫ��֤�Ĵ���,�����û���
    char    proxyPass [256];    // �������Ҫ��֤�Ĵ���,��������

    DLBT_PROXY_TYPE proxyType;      // ָ�����������
};


//=======================================================================================
//  ��ʶ����Ӧ������Щ���ӣ�Tracker�����ء�DHT��http��Э�����صȣ�
//=======================================================================================
#define DLBT_PROXY_TO_TRACKER       1  // ��������Trackerʹ�ô���
#define DLBT_PROXY_TO_DOWNLOAD      2  // ��������ʱͬ�û���Peer������ʹ�ô���
#define DLBT_PROXY_TO_DHT           4  // ����DHTͨѶʹ�ô���DHTʹ��udpͨѶ����Ҫ������֧��udp��
#define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  // ����HTTP����ʹ�ô�����������http��Э������ʱ��Ч��������Tracker��

// �����о�ʹ�ô���
#define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)

DLBT_API void WINAPI DLBT_SetProxy (
    DLBT_PROXY_SETTING  proxySetting,   // �������ã�����IP�˿ڵ�
    int                 proxyTo         // ����Ӧ������Щ���ӣ���������궨��ļ������ͣ�����DLBT_PROXY_TO_ALL
    );

//=======================================================================================
//  ��ȡ��������ã�proxyTo��ʶ������һ�����ӵĴ�����Ϣ����proxyToֻ�ܵ�����ȡĳ������
//  �Ĵ������ã�����ʹ��DLBT_PROXY_TO_ALL���ֶ�����ѡ��
//=======================================================================================
DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, int proxyTo);

//=======================================================================================
//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
//  ������Ӫ�̵ķ���
//=======================================================================================


// �ڲ�Ĭ��ʹ�ü����Լ��ܣ���Э������ݾ����ݼ��ܣ���û���������󣬽��鲻��Ҫ����
DLBT_API void WINAPI DLBT_SetEncryptSetting (
    DLBT_ENCRYPT_OPTION     encryptOption,      // ����ѡ������������ͻ��߲�����
    DLBT_ENCRYPT_LEVEL      encryptLevel        // ���ܵĳ̶ȣ������ݻ���Э����ܣ�
    );

// ***************************  �����ǵ���������صĽӿ� ********************************

// ***************************  ���¼�����������һ��BT���صĺ��������������������� ********************************
//=======================================================================================
//  ����һ���ļ������أ�����������صľ�����Ժ�Ը�������������в�������Ҫ���ݾ��������
//=======================================================================================
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize (
        LPCWSTR             torrentFile,                    // �����ļ���·�������嵽�ļ�����
        LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
        LPCWSTR             statusFile = L"",           // ״̬�ļ���·��
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
        BOOL                bPaused = FALSE,                // �Ƿ����������������񣬴򿪾������ͣ���������
        BOOL                bQuickSeed = FALSE,             // �Ƿ���ٹ��֣�����ҵ���ṩ��
        LPCSTR              password = NULL,                // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
        LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
        BOOL                bPrivateProtocol = FALSE,        // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
		BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
        );

// ����һ���ڴ��е������ļ����ݣ������������ļ����Ƕ����洢���߰�ĳ�����ܷ�ʽ�������ӵ���������Խ����ܺ�����ݴ���BT�ں�
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromBuffer (
        LPBYTE              torrentFile,                    // �ڴ��е������ļ�����
        DWORD               dwTorrentFileSize,              // �������ݵĴ�С
        LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
        LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
        BOOL                bPaused = FALSE,
        BOOL                bQuickSeed = FALSE,             // �Ƿ���ٹ��֣�����ҵ���ṩ��
        LPCSTR              password = NULL,                // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
        LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
        );

// ��һ��Torrent�������һ������
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromTorrentHandle (
        HANDLE              torrentHandle,                    // Torrent���
        LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
        LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
        BOOL                bPaused = FALSE,
        BOOL                bQuickSeed = FALSE,              // �Ƿ���ٹ��֣�����ҵ���ṩ��
        LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
    );

//��������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
        LPCSTR              trackerURL,                     // tracker�ĵ�ַ
        LPCSTR              infoHash,                       // �ļ���infoHashֵ
        LPCWSTR             outPath,
        LPCWSTR             name = NULL,                    // �����ص�����֮ǰ����û�а취֪�����ֵģ���˿��Դ���һ����ʱ������
        LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
        BOOL                bPaused = FALSE,
        LPCWSTR             rootPathName = NULL,            // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
        );

// ������ģʽ����һ���ӿڣ�����ֱ��ͨ����ַ���أ���ַ��ʽΪ�� DLBT://xt=urn:btih: Base32 �������info-hash [ &dn= Base32������� ] [ &tr= Base32���tracker�ĵ�ַ ]  ([]Ϊ��ѡ����)
// ��ȫ��ѭuTorrent�Ĺٷ�BT��չЭ��
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromUrl (
    LPCSTR              url,                            // ��ַ
    LPCWSTR             outPath,                        // ����Ŀ¼
    LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
    DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,
    BOOL                bPaused = FALSE,
    LPCWSTR             rootPathName = NULL,            // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                        // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
    BOOL                bPrivateProtocol = FALSE,
	BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
    );

// רҵ�ļ����½ӿڣ����������������ļ�Ϊ�����������������ļ�����������ļ��仯�������ݿ顣����ҵ�����ṩ
DLBT_API HANDLE WINAPI DLBT_Downloader_InitializeAsUpdater (
    LPCWSTR             curTorrentFile,    //��ǰ�汾�������ļ�
    LPCWSTR             newTorrentFile,   //  �°������ļ�
 	LPCWSTR             curPath,    //  ��ǰ�ļ���·��
    LPCWSTR             statusFile = L"", // ״̬�ļ���·��
 	DLBT_FILE_ALLOCATE_TYPE    type = FILE_ALLOCATE_SPARSE, //  �ļ����䷽ʽ������͵�ǰ�汾һ�£��°汾Ҳ��ʹ�ø÷��䷽ʽ��
 	BOOL                bPaused = FALSE,     // �Ƿ���ͣ��ʽ����
  	LPCSTR              curTorrentPassword = NULL,   // ��ǰ�汾���ӵ����루��������˲���Ҫ���룩
 	LPCSTR              newTorrentFilePassword = NULL, //�����ӵ�����
 	LPCWSTR             rootPathName = NULL,
	BOOL				bPrivateProtocol = FALSE,
	float		*       fProgress = NULL,         //�����ΪNULL���򴫳���DLBT_Downloader_GetOldTorrentProgressһ����һ������
	BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
);

// רҵ�ļ�����ʱ�������������ӣ�Ȼ��ֱ�Ӵ��������Ӻ������ӵĲ�����������ȣ������������99%������ζ��ֻ��1%��������Ҫ���ء�
DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
	LPCWSTR             curTorrentFile,    //��ǰ�汾�������ļ�
	LPCWSTR             newTorrentFile,   //  �°������ļ�
	LPCWSTR             curPath,    //  ��ǰ�ļ���·��
	LPCWSTR             statusFile = L"", // ״̬�ļ���·��
	LPCSTR              curTorrentPassword = NULL,
	LPCSTR              newTorrentFilePassword = NULL
	);

//-------------------------------------------------------------------------------------------------------------------------------
// �ر�����֮ǰ�����Ե��øú���ͣ��IO�̶߳Ը�����Ĳ������첽�ģ���Ҫ����DLBT_Downloader_IsReleasingFiles��������ȡ�Ƿ����ͷ��У���
// �ú������ú���ֱ�ӵ���_Release�����ɶԸþ���ٵ�������DLBT_Dwonloader�������������ڲ�������ͣ�����������أ�Ȼ���ͷŵ��ļ����
DLBT_API void WINAPI DLBT_Downloader_ReleaseAllFiles(HANDLE hDownloader);
// �Ƿ����ͷž���Ĺ�����
DLBT_API BOOL WINAPI DLBT_Downloader_IsReleasingFiles(HANDLE hDownloader);


// �ر�hDownloader����ǵ��������� nFlag ����ο���DLBT_RELEASE_FLAG
DLBT_API HRESULT WINAPI DLBT_Downloader_Release (HANDLE hDownloader, int nFlag = DLBT_RELEASE_NO_WAIT);

// ����һ��http�ĵ�ַ�����������ļ���ĳ��Web����������http����ʱ����ʹ�ã�web�������ı��뷽ʽ���ΪUTF-8�������������ʽ������ϵ������������޸�
DLBT_API void WINAPI DLBT_Downloader_AddHttpDownload (HANDLE hDownloader, LPSTR url);
// �Ƴ�һ��P2SP�ĵ�ַ��������������У�����жϿ����ҴӺ�ѡ���б����Ƴ������ٽ�������
DLBT_API void WINAPI DLBT_Downloader_RemoveHttpDownload (HANDLE hDownloader, LPSTR url);
// ����һ��Http��ַ�������Խ������ٸ����ӣ�Ĭ����1������. ������������ܺã������������ã���������10�������Ƕ�һ��Http��ַ�����Խ���10�����ӡ�
// ����֮ǰ����Ѿ�һ��Http��ַ�������˶�����ӣ����ٶϿ����������ú����½�����ʱ��Ч
DLBT_API void WINAPI DLBT_Downloader_SetMaxSessionPerHttp (HANDLE hDownloader, int limit);

// ����P2SPʱ��Ҫ����չ�����Ƿ����һ���������Լ��������������ļ���·���ı���
//��չ�������ڷ�ֹһЩ��Ӫ�̶�http���������ڻ��棬���Ե������ص��ǻ�����ϰ汾���ļ������Կ���ʹ��һ��.php������չ������ֹ�����û���
//����Ҫ���������ý�.php��׺���ԣ������������ļ�������ͨ��nginx��rewrite�ȹ���ʵ��
//�Ƿ����һ��?a=b���ֲ�����Ҳ�Ƿ�ֹ����ģ������Ƕ�������Ӫ�̶���Ч
//bUtf8���Ƿ�ʹ��utf8��·�����룬Ĭ����true����������false�������Щ����·����ȡ������
// �ú���Ϊȫ�ֵģ��������ĳ����������
DLBT_API void WINAPI DLBT_SetP2SPExtName (LPCSTR extName, bool bUseRandParam, bool bUtf8);

// ��ȡ���������е�Http���ӣ��ڴ�������DLBT_Downloader_FreeConnections�ͷ�
DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
// �ͷ�DLBT_Downloader_GetHttpConnections�������ڴ�
DLBT_API void WINAPI DLBT_Downloader_FreeConnections(LPSTR * urls, int urlCount);

DLBT_API void WINAPI DLBT_Downloader_AddTracker (HANDLE hDownloader, LPCSTR url, int tier);
DLBT_API void WINAPI DLBT_Downloader_RemoveAllTracker (HANDLE hDownloader);
DLBT_API void WINAPI DLBT_Downloader_AddHttpTrackerExtraParams (HANDLE hDownloader, LPCSTR extraParams);

DLBT_API int WINAPI DLBT_Downloader_GetTrackerCount(HANDLE hDownloader);
DLBT_API HRESULT WINAPI DLBT_Downloader_GetTrackerUrl (HANDLE hDownloader, int index, LPSTR url, int * urlBufferSize);

// �������������Ƿ�˳������,Ĭ���Ƿ�˳������(���������,һ����ѭϡ��������,���ַ�ʽ�ٶȿ�),��˳�����������ڱ��±߲���
DLBT_API void WINAPI DLBT_Downloader_SetDownloadSequence (HANDLE hDownloader, BOOL ifSeq = FALSE);

// ���ص�״̬ �Լ� ��ͣ�ͼ����Ľӿ�
DLBT_API DLBT_DOWNLOAD_STATE WINAPI DLBT_Downloader_GetState (HANDLE hDownloader);
DLBT_API BOOL WINAPI DLBT_Downloader_IsPaused (HANDLE hDownloader);
DLBT_API void WINAPI DLBT_Downloader_Pause (HANDLE hDownloader);        //��ͣ
DLBT_API void WINAPI DLBT_Downloader_Resume (HANDLE hDownloader);       //����
//����״̬�µ������ӿ� ��һ��ֻ���ڼ�������������ļ��޷�д��ʱ�Ż��������������ˣ�
//��������״̬ΪBTDS_ERROR��ͨ���ýӿڻ�ȡ��ϸ������Ϣ
DLBT_API HRESULT WINAPI DLBT_Downloader_GetLastError (
    HANDLE  hDownloader,  // ������
    LPSTR   pBuffer,      // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
    int *   pBufferSize  // ����buffer���ڴ��С���������ֵ�ʵ�ʴ�С
    ); 

DLBT_API void WINAPI DLBT_Downloader_ResumeInError (HANDLE hDownloader); //���������󣬳������¿�ʼ����

// ���������ص���ؽӿڣ�������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
DLBT_API BOOL WINAPI DLBT_Downloader_IsHaveTorrentInfo (HANDLE hDownloader); // ����������ʱ�������ж��Ƿ�ɹ���ȡ����������Ϣ
DLBT_API HRESULT WINAPI DLBT_Downloader_MakeURL (  // ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
    HANDLE      hDownloader,
    LPSTR       pBuffer,                // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
    int  *      pBufferSize             // ����buffer���ڴ��С������URL��ʵ�ʴ�С
    ); 
// ���������أ�����Ѿ����ص������ӣ���������������������ӱ����������Ժ����ʹ����
DLBT_API HRESULT WINAPI DLBT_Downloader_SaveTorrentFile (HANDLE hDownloader, LPCWSTR filePath, LPCSTR password = NULL);

// ���ص����ٺ��������ӵĽӿ�
DLBT_API void WINAPI DLBT_Downloader_SetDownloadLimit (HANDLE hDownloader, int limit);
DLBT_API void WINAPI DLBT_Downloader_SetUploadLimit (HANDLE hDownloader, int limit);
DLBT_API void WINAPI DLBT_Downloader_SetMaxUploadConnections (HANDLE hDownloader, int limit);
DLBT_API void WINAPI DLBT_Downloader_SetMaxTotalConnections (HANDLE hDownloader, int limit);

// ȷ������ֻ�ϴ���������
DLBT_API void WINAPI DLBT_Downloader_SetOnlyUpload (HANDLE hDownloader, bool bUpload);

// ���öԷ�����IP�����������٣���λ��BYTE(�ֽڣ��������Ҫ����1M��������1024*1024
DLBT_API void WINAPI DLBT_Downloader_SetServerDownloadLimit(HANDLE hDownloader, int limit);
// ���ñ�������ȥ�����еķ�����IP�������ӣ����ڶԷ������������ӣ���ҪBTЭ������ͨ����֪���Ƕ�Ӧ�������������hDownloader�ĺ���ٶϿ�����
DLBT_API void WINAPI DLBT_Downloader_BanServerDownload(HANDLE hDownloader, bool bBan);

// ���ط����� (�ϴ�/���صı������Ľӿ�
DLBT_API void WINAPI DLBT_Downloader_SetShareRateLimit (HANDLE hDownloader, float fRate);
DLBT_API double WINAPI DLBT_Downloader_GetShareRate (HANDLE hDownloader);

// �������ص��ļ������ԣ��ļ���С������������ȵȣ�
DLBT_API HRESULT WINAPI DLBT_Downloader_GetTorrentName (
    HANDLE      hDownloader,
    LPWSTR      pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
    int     *   pBufferSize     // ����buffer���ڴ��С���������ֵ�ʵ�ʴ�С
    );
DLBT_API UINT64 WINAPI DLBT_Downloader_GetTotalFileSize (HANDLE hDownloader);
DLBT_API UINT64 WINAPI DLBT_Downloader_GetTotalWanted (HANDLE hDownloader);     // ����ѡ���˶������������������������ص��ļ�
DLBT_API UINT64 WINAPI DLBT_Downloader_GetTotalWantedDone (HANDLE hDownloader); // ��ѡ�����ļ��У������˶���
DLBT_API float WINAPI DLBT_Downloader_GetProgress (HANDLE hDownloader);

DLBT_API UINT64 WINAPI DLBT_Downloader_GetDownloadedBytes (HANDLE hDownloader);
DLBT_API UINT64 WINAPI DLBT_Downloader_GetUploadedBytes (HANDLE hDownloader);
DLBT_API UINT WINAPI DLBT_Downloader_GetDownloadSpeed (HANDLE hDownloader);
DLBT_API UINT WINAPI DLBT_Downloader_GetUploadSpeed (HANDLE hDownloader);

// ��ø�����Ľڵ����Ŀ����Ŀ�Ĳ���Ϊint��ָ�룬�������Ҫĳ��ֵ����NULL
DLBT_API void WINAPI DLBT_Downloader_GetPeerNums (
    HANDLE      hDownloader,        // ��������ľ��
    int     *   connectedCount,     // �����������ϵĽڵ������û�����
    int     *   totalSeedCount,     // �ܵ�������Ŀ�����Tracker��֧��scrap���򷵻�-1
    int     *   seedsConnected,     // �Լ����ϵ�������
    int     *   inCompleteCount,    // δ��������������Tracker��֧��scrap���򷵻�-1
    int     *   totalCurrentSeedCount, // ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
    int     *   totalCurrentPeerCount  // ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
    );

// ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
DLBT_API int WINAPI DLBT_Downloader_GetFileCount (HANDLE hDownloader);
DLBT_API UINT64 WINAPI DLBT_Downloader_GetFileSize (HANDLE hDownloader, int index);
// ��ȡ�ļ���torrent�е���ʼλ��
DLBT_API UINT64 WINAPI DLBT_Downloader_GetFileOffset (HANDLE hDownloader, int index);
DLBT_API BOOL WINAPI DLBT_Downloader_IsPadFile (HANDLE hDownloader, int index);
DLBT_API HRESULT WINAPI DLBT_Downloader_GetFilePathName (
    HANDLE      hDownloader,        // ��������ľ��
    int         index,              // �ļ������
    LPWSTR      pBuffer,            // �����ļ���
    int     *   pBufferSize,        // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ���
    bool        needFullPath = false// �Ƿ���Ҫȫ����·������ֻ��Ҫ�ļ��������е����·��    
    );

// �ú����Ὣ����Ŀ¼�´��ڣ���torrent��¼�в����ڵ��ļ�ȫ��ɾ�����Ե����ļ���������Ч��������ʹ�á�
DLBT_API HRESULT WINAPI DLBT_Downloader_DeleteUnRelatedFiles (HANDLE hDownloader);

// ��ȡÿ���ļ���Hashֵ��ֻ����������ʱʹ��bUpdateExt���ܻ�ȡ��
DLBT_API HRESULT WINAPI DLBT_Downloader_GetFileHash (
	HANDLE      hDownloader,        // ��������ľ��
	int         index,              // Ҫ��ȡ���ļ�����ţ�piece����Ŀ����ͨ��DLBT_Downloader_GetFileCount���
	LPSTR       pBuffer,            // ����Hash�ַ���
	int     *   pBufferSize         // ����pBuffer�Ĵ�С��pieceInfoHash�̶�Ϊ20���ֽڣ���˴˴�Ӧ����20�ĳ��ȡ�
	);

// ȡ�ļ������ؽ��ȣ��ò�����Ҫ���н϶������������ڱ�Ҫʱʹ��
DLBT_API float WINAPI DLBT_Downloader_GetFileProgress (HANDLE hDownloader, int index);


// �����ļ����������ȼ��������������ȡ��ĳ��ָ���ļ�������,index��ʾ�ļ������
DLBT_API HRESULT WINAPI DLBT_Downloader_SetFilePrioritize (
    HANDLE                  hDownloader, 
    int                     index,              // �ļ����
    DLBT_FILE_PRIORITIZE    prioritize,         // ���ȼ�
    BOOL                    bDoPriority = TRUE  // �Ƿ�����Ӧ��������ã�����ж���ļ���Ҫ���ã�������ʱ������Ӧ�ã������һ���ļ�Ӧ������
                                                // ���߿�����������DLBT_Downloader_ApplyPrioritize������Ӧ�ã���ΪÿӦ��һ�����ö�Ҫ������Piece
                                                // ����һ�飬�Ƚ��鷳������Ӧ��һ��Ӧ��
    );

// ����Ӧ�����ȼ�������
DLBT_API void WINAPI DLBT_Downloader_ApplyPrioritize (HANDLE hDownloader);

// ��ȡ��ǰÿ���ֿ��״̬��������������ж��Ƿ���Ҫȥ���£��Ƿ��Ѿ�ӵ���˸ÿ飩��
DLBT_API HRESULT WINAPI DLBT_Downloader_GetPiecesStatus (
    HANDLE                  hDownloader,    // ������
    bool                *   pieceArray,     // ���ÿ�����Ƿ񱾵��������µ�����
    int                     arrayLength,    // ����ĳ���
    int                 *   pieceDownloaded // �Ѿ����صķֿ����Ŀ������ʾ���صķֿ��ͼ��ʱ���ò����Ƚ����á�������ָ����ֺ��ϴλ�ȡʱû��
                                            // �仯������Բ���Ҫ�ػ���ǰ�ķֿ�״̬ͼ
    );

// ����Piece���ֿ飩���������ȼ��������������ȡ��ĳЩ�ֿ�����أ���ָ��λ�ÿ�ʼ���صȡ�index��ʾ�ֿ�����
DLBT_API HRESULT WINAPI DLBT_Downloader_SetPiecePrioritize (
    HANDLE                  hDownloader, 
    int                     index,              // ������
    DLBT_FILE_PRIORITIZE    prioritize,         // ���ȼ�
    BOOL                    bDoPriority = TRUE  // �Ƿ�����Ӧ��������ã�����ж���ֿ���Ҫ���ã�������ʱ������Ӧ�ã������һ����Ӧ������
                                                // ���߿�����������DLBT_Downloader_ApplyPrioritize������Ӧ�ã���ΪÿӦ��һ�����ö�Ҫ������Piece
                                                // ����һ�飬�Ƚ��鷳������Ӧ��һ��Ӧ��
    );

// �����ֹ�ָ����Peer��Ϣ
DLBT_API void WINAPI DLBT_Downloader_AddPeerSource (HANDLE hDownloader, char * ip, USHORT port);


// ��ÿ���ʾ���ļ�Hashֵ
DLBT_API HRESULT WINAPI DLBT_Downloader_GetInfoHash (
    HANDLE      hDownloader,        // ��������ľ��
    LPSTR       pBuffer,            // ����InfoHash���ڴ滺��
    int     *   pBufferSize         // ���뻺��Ĵ�С������ʵ�ʵ�InfoHash�ĳ���
    );

DLBT_API int WINAPI DLBT_Downloader_GetPieceCount (HANDLE hDownloader);
DLBT_API int WINAPI DLBT_Downloader_GetPieceSize (HANDLE hDownloader);

// ��������һ��״̬�ļ���֪ͨ�ڲ��������̺߳��������أ����첽���������ܻ���һ���ӳٲŻ�д��
DLBT_API void WINAPI DLBT_Downloader_SaveStatusFile (HANDLE hDownloader);

//bOnlyPieceStatus�� �Ƿ�ֻ����һЩ�ļ��ֿ���Ϣ�����ڷ����������ɺ󷢸�ÿ���ͻ������ͻ����Ͳ����ٱȽ��ˣ�ֱ�ӿ�������. Ĭ����FALSE��Ҳ����ȫ����Ϣ������
DLBT_API void WINAPI DLBT_Downloader_SetStatusFileMode (HANDLE hDownloader, BOOL bOnlyPieceStatus);

// �鿴����״̬�ļ��Ƿ����
DLBT_API BOOL WINAPI DLBT_Downloader_IsSavingStatus (HANDLE hDownloader);

// ��BTϵͳ��д��ͨ��������ʽ�����������ݿ顣offsetΪ�����ݿ��������ļ����ļ��У��е�ƫ������sizeΪ���ݿ��С��dataΪ���ݻ�����
// �ɹ�����S_OK��ʧ��Ϊ������ʧ��ԭ������Ǹÿ鲻��Ҫ�ٴδ����ˡ� ��������VOD��ǿ������Ч
DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);

// �ֹ����һ�����������ݽ��� ��������VOD��ǿ������Ч
DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
    HANDLE                  hDownloader,
    int                     piece,          //�ֿ����
    char            *       data,           //���ݱ���
    bool                    bOverWrite      //����Ѿ����ˣ��Ƿ񸲸�
    );


// ÿ��Ҫ�滻һ�����ݿ�ʱ����һ������ص����ⲿ���Ը�������ص���ʾ�滻�Ľ��ȣ��Լ��Ƿ���ֹ�����滻�����������൱�ڣ�DLBT_Downloader_CancelReplace)
// ����FALSE����ϣ��������ֹ��TRUE���������
// һ���ֿ���ܻ�������С�ļ������ߴ��ļ���β�������ļ�ճ���ĵط��������һ���ֿ�pieceIndex���ܻ��Ӧ�˶���ļ�Ƭ�Ρ����ص����滻һ���ļ�Ƭ��ʱ����һ��
typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
      IN void * pContext,                   // �ص��������ģ�ͨ��DLBT_Downloader_ReplacePieceData��pContext�������룩�����ﴫ��ȥ���������洦��
                                            // ���磬�ⲿ����һ��thisָ�룬�ص���ʱ����ͨ�����ָ��֪���Ƕ�Ӧ�ĸ�����
      IN int pieceIndex,                    //����Ҫ�滻������λ���ĸ��ֿ飨�ֿ���torrent�е�������
      IN int replacedPieceCount,            //�Ѿ�����˶��ٸ�piece���滻
      IN int totalNeedReplacePieceCount,    //�ܹ��ж��ٸ�Ҫ�滻��piece�ֿ�
      IN int fileIndex,                     //����Ҫ�滻������λ���ĸ��ļ�
      IN UINT64 offset,                     //������ļ��У�������ݵ�ƫ����
      IN UINT64 size,                       //������ݵ��ܴ�С������ƫ������
      IN int replacedFileSliceCount,        //�Ѿ�����˶��ٸ��ļ�Ƭ�ε��滻                                  
      IN int totalFileSliceCount            //�ܹ��ж��ٸ���Ҫ�滻���ļ�Ƭ��
      );

// �滻���ݿ�Ľӿڣ���ĳ������ֱ���滻��Ŀ���ļ�����ͬλ�ã�һ�����ڣ�����ʱ����Ҫ���صķֿ��Զ����ص�һ����ʱĿ¼����ɺ����滻��ԭʼ�ļ�
// �������ع�����ԭʼ�ļ���������ʹ�ã���������ֻ���ز������ݵ��ŵ㡣
// �ú������������أ����HRESULT���صĲ���S_OK��˵��������Ҫ�鿴����ֵ��
// �������S_OK�����ڲ��������߳��������滻���м�Ľ����ʱͨ��DLBT_Downloader_GetReplaceResult�����в鿴�������ʱ���Ե��ã�DLBT_Downloader_CancelReplace����ȡ���̲߳���
DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
	HANDLE			hDownloader,		//����������
	int   *			pieceArray,			// ��Ҫ����Щ�ֿ��滻����һ��int����
	int				arrayLength,		// �ֿ�����ĳ���
	LPCWSTR			destFilePath,		// ��Ҫ�滻���ļ����ļ��У���Ŀ¼�����磺E:\Test\1.rar����E:\Test\Game\�����˲� �ȡ�
	LPCWSTR			tempRootPathName = NULL,	// ��ʱĿ¼����ʱ�����ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У��¶�ȡ���ݿ�
	LPCWSTR			destRootPathName = NULL,	// ��Ҫ�滻���Ǹ������������ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У������滻
    LPVOID          pContext = NULL,
    DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  //���ս��ȣ���������ʱȡ���Ļص�
	);

// ReplacePieceData��һЩ״̬������ͨ��DLBT_Downloader_GetReplaceResult�����в鿴
enum DLBT_REPLACE_RESULT
{
    DLBT_RPL_IDLE  = 0,     //��δ��ʼ�滻
    DLBT_RPL_RUNNING,       //����������
    DLBT_RPL_SUCCESS,       //�滻�ɹ�
    DLBT_RPL_USER_CANCELED, //�滻��һ�룬�û�ȡ������
    DLBT_RPL_ERROR,         //��������ͨ��hrDetail����ȡ��ϸ��Ϣ���ο���DLBT_Downloader_GetReplaceResult
};

// ��ȡ�滻���ݵĽ��
DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
    HANDLE          hDownloader,        //����������
    HRESULT  *      hrDetail,           //������г���������ϸ�ĳ���ԭ��
    BOOL     *      bThreadRunning      //Replace�����������Ƿ�����ˣ�����Ҳ�����������ģ�
    );

// �м���ʱȡ���滻���ݵĲ�����������ȡ������Ϊ�п��ܻ��滻��һ�룬������Щ�ļ��ǲ������ģ�
DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);

//////////////////////   Move����ؽӿ�   /////////////
// Move�Ľ��
enum DOWNLOADER_MOVE_RESULT
{
	DLBT_MOVED	= 0,	//�ƶ��ɹ�
	DLBT_MOVE_FAILED,	//�ƶ�ʧ��
	DLBT_MOVING         //�����ƶ�
};

//�ƶ����ĸ�Ŀ¼�������ͬһ���̷������Ǽ��У�����ǲ�ͬ�������Ǹ��ƺ�ɾ��ԭʼ�ļ������ڲ������첽������������������
//���ʹ��DLBT_Downloader_GetMoveResultȥ��ȡ
DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCWSTR savePath);
//�鿴�ƶ������Ľ��
DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
	HANDLE			hDownloader,   // ��������ľ��
	LPSTR			errorMsg,      // ���ڷ��س�����Ϣ���ڴ棬��DLBT_MOVE_FAILED״̬�����ﷵ�س�������顣�������NULL���򲻷��ش�����Ϣ
	int				msgSize		   // ������Ϣ�ڴ�Ĵ�С
	); 


// ***************************  ������������صĽӿ� ********************************

// ����һ��Torrent�ľ���������ڴ������ӵľ��
DLBT_API HANDLE WINAPI DLBT_CreateTorrent (    
    int             pieceSize,      // �ļ��ķֿ��С����λ�ֽڣ�0�����ں��Զ�ȷ��
    LPCWSTR         file,           // �ļ�������Ŀ¼��Ŀ¼��Ŀ¼�������ļ�����һ�����ӣ�
    LPCWSTR         publisher = NULL,   // ��������Ϣ
    LPCWSTR         publisherUrl = NULL, // �����ߵ���ַ
    LPCWSTR         comment = NULL,  // ���ۺ�����    
    DLBT_TORRENT_TYPE torrentType = USE_PUBLIC_DHT_NODE,   // ������ӵ�����
    int       *     nPercent = NULL,  // �������ӵĽ���
    BOOL      *     bCancel = NULL,   // �����м�ȡ�����ӵ�����
	int			    minPadFileSize = -1,  // �ļ�����minPadFileSize��ͽ��в����Ż�����ͳBT����ʱ��һ���ֿ���ܺ�������ļ���ʹ����������
								// ÿ���ļ��ᵥ���ֿ飬���������ļ�����������һ���ļ������仯�󲻻�Ӱ�쵽�����ļ���һ�������ļ��ĸ��¡�-1�������롣0����������С���ļ�������
								// ���רҵ����ģʽ��bUpdateExtΪTRUE������ǿ�ƶ��룬���minPadFileSize����С��pieceSize������-1������ôǿ�ƶ�����Զ�ʹ��pieceSize��Ϊ��С�����׼
								// Ҳ����˵����һ���ֿ���ļ������Զ����룻С��һ���ֿ���ļ��ᱻ���ڶ���
    BOOL            bUpdateExt = FALSE  //�Ƿ��������ڸ��µĵ�����չ��Ϣ����������DLBT_Downloader_InitializeAsUpdater�ӿڡ�����ҵ����Ч��bUpdateExt����һЩ���⹤�������ֻ����ͨ����
					//�������ļ��ıȽϸ��£����Բ�ʹ�øò������ò���ʹ��ʱ��pieceSize������Ϊ0����������torrent�ķֿ��С�п��ܲ�ͬ�����¸����������ӡ�
    );

// ָ�����Ӱ�����Tracker
DLBT_API HRESULT WINAPI DLBT_Torrent_AddTracker (
    HANDLE      hTorrent,       // ���ӵľ��
    LPCWSTR     trackerURL,     // tracker�ĵ�ַ��������http Tracker��udp Tracker
    int         tier            // ���ȼ���˳��
    );

// �Ƴ������е�����Tracker
DLBT_API void WINAPI DLBT_Torrent_RemoveAllTracker (HANDLE hTorrent);

// ָ�����ӿ���ʹ�õ�httpԴ��������صĿͻ���֧��http��Э�����أ�����Զ��Ӹõ�ַ��������
DLBT_API void WINAPI DLBT_Torrent_AddHttpUrl (HANDLE hTorrent, LPCWSTR httpUrl);

// ����torrentΪ�����ļ�,filePathΪ·���������ļ�����
DLBT_API HRESULT WINAPI DLBT_SaveTorrentFile (
    HANDLE      hTorrent,               // ���ӵľ��
    LPCWSTR     filePath,               // filePathΪҪ�����torrent���ļ�·����һ���ǰ����ļ������ڵġ������bUseHashName��TRUE��˵��Ҫ��ʹ��hashֵ�ַ�����Ϊtorrent
                                        // ���ļ�������ôfilePath�����Ͳ�����Ҫ�����ļ�������ֻ��·�����ɡ�
    LPCSTR      password = NULL,        // ���password��ΪNULL���������Ҫ�����ӽ��м��ܣ����ܺ�ֻ������ͬ������򿪡�����һ��С���ܣ����password����
                                        // "ZiP-OnLY"(���ִ�Сд)���ڲ������������ܣ�ֻ�Ƕ�torrent����һ��zipѹ�������Լ�Сtorrent��С����������������룬���ܵ�ͬʱҲ���Զ�zipѹ���ġ�
    BOOL        bUseHashName = FALSE,   // �Ƿ�ֱ��ʹ��hashֵ�ַ�����Ψһ�ı���ַ�����Ϊtorrent�����֣�����ǣ���filePath��ֻ��Ҫ�����ļ�·�������������ļ���
    LPCWSTR     extName = NULL          // ��չ�������bUseHashNameʹ�ã�����bUseHashNameΪTRUEʱ��Ч�����ΪNULL���ڲ��Զ�ʹ��.torrent��Ϊ��չ���� ���������д�����չ������".abc"
    );

// �ͷ�torrent�ļ��ľ��
DLBT_API void WINAPI DLBT_ReleaseTorrent (HANDLE hTorrent);


// ��һ�����Ӿ���������޸Ļ��߶�ȡ��Ϣ���в������������Ҫ����DLBT_ReleaseTorrent�ͷ�torrent�ļ��ľ��
DLBT_API HANDLE WINAPI DLBT_OpenTorrent (
    LPCWSTR     torrentFile,    // �����ļ�ȫ·��
    LPCSTR      password = NULL                 // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ�����,�Դ�������н��� 
    );

DLBT_API HANDLE WINAPI DLBT_OpenTorrentFromBuffer (
    LPBYTE      torrentFile,                    // ���Դ��ڴ��е��ַ�������
    DWORD       dwTorrentFileSize,              // �������ݵĴ�С
    LPCSTR      password = NULL                 // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ�����,�Դ�������н���
    );

DLBT_API HRESULT WINAPI DLBT_Torrent_GetComment (
    HANDLE      hTorrent,       // �����ļ����
    LPWSTR      pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������۵�ʵ�ʴ�С
    int     *   pBufferSize     // �������۵��ڴ��С���������۵�ʵ�ʴ�С
    );

// ���ش����������Ϣ
DLBT_API HRESULT WINAPI DLBT_Torrent_GetCreator (
    HANDLE      hTorrent,       // �����ļ����
    LPWSTR      pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
    int     *   pBufferSize     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
    );

// ���ط�������Ϣ
DLBT_API HRESULT WINAPI DLBT_Torrent_GetPublisher (
    HANDLE      hTorrent,       // �����ļ����
    LPWSTR      pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
    int     *   pBufferSize     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
    );
// ���ط�������ַ
DLBT_API HRESULT WINAPI DLBT_Torrent_GetPublisherUrl (
    HANDLE      hTorrent,       // �����ļ����
    LPWSTR      pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���ʵ�ʴ�С
    int     *   pBufferSize     // ��������Ϣ���ڴ��С������ʵ�ʴ�С
    );

DLBT_API HRESULT WINAPI DLBT_Torrent_MakeURL (  // ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
    HANDLE      hTorrent,
    LPSTR       pBuffer,                // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
    int  *      pBufferSize             // ����buffer���ڴ��С������URL��ʵ�ʴ�С
    );  

DLBT_API int WINAPI DLBT_Torrent_GetTrackerCount (HANDLE hTorrent);

DLBT_API LPCSTR WINAPI DLBT_Torrent_GetTrackerUrl (
    HANDLE      hTorrent,       // �����ļ����
    int         index           // Tracker����ţ���0��ʼ
    );

DLBT_API UINT64 WINAPI DLBT_Torrent_GetTotalFileSize (HANDLE hTorrent);

// ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
DLBT_API int WINAPI DLBT_Torrent_GetFileCount (HANDLE hTorrent);
DLBT_API BOOL WINAPI DLBT_Torrent_IsPadFile (HANDLE hTorrent, int index);
DLBT_API UINT64 WINAPI DLBT_Torrent_GetFileSize (
    HANDLE      hTorrent,           // �����ļ����
    int         index               // Ҫ��ȡ��С���ļ�����ţ��ļ�����Ǵ�0��ʼ��
    );
DLBT_API HRESULT WINAPI DLBT_Torrent_GetFilePathName (
    HANDLE      hTorrent,           // �����ļ����
    int         index,              // Ҫ��ȡ���ֵ��ļ�����ţ��ļ�����Ǵ�0��ʼ��
    LPWSTR      pBuffer,            // �����ļ���
    int     *   pBufferSize        // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ��� 
    );

DLBT_API int WINAPI DLBT_Torrent_GetPieceCount (HANDLE hTorrent);
DLBT_API int WINAPI DLBT_Torrent_GetPieceSize (HANDLE hTorrent);

// ��ȡ������ÿ���ֿ��Hashֵ
DLBT_API HRESULT WINAPI DLBT_Torrent_GetPieceInfoHash (
    HANDLE      hTorrent,           // �����ļ����
    int         index,              // Ҫ��ȡ��Piece����ţ�piece����Ŀ����ͨ��DLBT_Torrent_GetPieceCount���
    LPSTR       pBuffer,            // ����Hash�ַ���
    int     *   pBufferSize         // ����pBuffer�Ĵ�С��pieceInfoHash�̶�Ϊ20���ֽڣ���˴˴�Ӧ����20�ĳ��ȡ�
    );

// ��������ļ���InfoHashֵ
DLBT_API HRESULT WINAPI DLBT_Torrent_GetInfoHash (
    HANDLE      hTorrent,           // �����ļ��ľ��
    LPSTR       pBuffer,            // ����InfoHash���ڴ滺��
    int     *   pBufferSize         // ���뻺��Ĵ�С������ʵ�ʵ�InfoHash�ĳ���
    );

// **************************** �����������г��йصĽӿ� *****************************
// �����г�������ҵ�汾���ṩ��������ð�����ʱ���ṩ�ù���
struct DLBT_TM_ITEM     //��������г��е�һ�������ļ�
{
	DLBT_TM_ITEM(): fileSize (0) {}
	
	UINT64  fileSize;      // the size of this file
	char	name[256];     // ����
	LPCSTR	url;           // �������ص�url
	LPCSTR  comment;       // ��������
};

struct DLBT_TM_LIST //��������г��е�һ�������ļ��������
{
	int				count;      //��Ŀ
	DLBT_TM_ITEM	items[1];   //�����б�
};

// �ڱ����������г������һ�������ļ�
DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);
// �ڱ����������г����Ƴ�һ�������ļ�
DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);

// ��ȡ���������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
// ��ȡ�����������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);

// �ͷ�DLBT_TM_GetSelfTorrentList����DLBT_TM_GetRemoteTorrentList��ȡ���������б���ڴ�
DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);

// ������л�ȡ���������˵������б�
DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList ();
// ��������Լ������г��е������б�
DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList ();

// ����һ���Ƿ����������г���Ĭ�ϲ����á�
DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);


// *********************  �����Ƿ���ǽ��UPnP��͸��P2P�����Խӿ� **********************

//  ��ĳ��Ӧ�ó�����ӵ�ICF����ǽ��������ȥ���ɶ������ں�Ӧ�ã��������ں���Ȼ����ʹ�øú���
DLBT_API BOOL WINAPI DLBT_AddAppToWindowsXPFirewall (
    LPCWSTR      appFilePath,        // �����·��������exe�����֣�
    LPCWSTR      ruleName            // �ڷ���ǽ����������ʾ���������������
    );
// ��ĳ���˿ڼ���UPnPӳ�䣬����BT�ڲ������ж˿��Ѿ��Զ����룬����Ҫ�ٴμ��룬�����ṩ�����ǹ��ⲿ��������Լ�����˿�
DLBT_API void WINAPI DLBT_AddUPnPPortMapping(
	USHORT      nExternPort,        // NATҪ�򿪵��ⲿ�˿�
	USHORT      nLocalPort,         // ӳ����ڲ��˿ڣ��������˿ڣ���һ���ǳ����ڼ����Ķ˿�
	PORT_TYPE   nPortType,          // �˿����ͣ�UDP����TCP��
	LPCSTR      appName             // ��NAT����ʾ���������������
	);

// ��õ���ϵͳ�Ĳ������������ƣ��������0���ʾϵͳ���ܲ������޵�XPϵͳ�������޸�����������
// �ɶ������ں�ʹ�ã������ں�ǰ����ʹ��
DLBT_API DWORD WINAPI DLBT_GetCurrentXPLimit ();

// �޸�XP�Ĳ������������ƣ�����BOOL��־�Ƿ�ɹ�
DLBT_API BOOL WINAPI DLBT_ChangeXPConnectionLimit (DWORD num);



// ***************************  ������������ȡ��Ϣ�Ľӿ� ********************************

// ��ȡ������Ϣ�Ľӿ�
DLBT_API HRESULT WINAPI DLBT_GetKernelInfo (KERNEL_INFO * info);
DLBT_API HRESULT WINAPI DLBT_GetDownloaderInfo (HANDLE hDownloader, DOWNLOADER_INFO * info);

// �����ɽڵ��б��б���DLL���䣬��ˣ���Ҫ����DLBT_FreeDownloaderPeerInfoList�����ͷŸ��ڴ�
DLBT_API HRESULT WINAPI DLBT_GetDownloaderPeerInfoList (HANDLE hDownloader, PEER_INFO ** ppInfo);
DLBT_API void WINAPI DLBT_FreeDownloaderPeerInfoList (PEER_INFO * pInfo);

DLBT_API void WINAPI DLBT_SetDHTFilePathName (LPCWSTR dhtFile);

// �����Զ���IO�����ĺ��������Խ�BT����Ķ�д�ļ������в����ⲿ���д����滻�ڲ��Ķ�д�����ȣ�
// �ù���Ϊ�߼��湦�ܣ�����ϵ������ȡ����֧�֣�Ĭ�ϰ汾�в����Ÿù���

// ����IO�����Ľӹܽṹ���ָ��
DLBT_API void WINAPI DLBT_Set_IO_OP(void * op);
// �Խṹ����������к����ȸ�ֵĬ�ϵĺ���ָ��
DLBT_API void WINAPI DLBT_InitDefault_IO_OP(void * op);
// ��ȡϵͳ�ڲ�Ŀǰ���õ�IO�����ָ��
DLBT_API void * WINAPI DLBT_Get_IO_OP();

// ��ȡϵͳԭʼIO��ָ��
DLBT_API void * WINAPI DLBT_Get_RAW_IO_OP();

}	/* namespace Dlbt */
using namespace Dlbt;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DlbtHPP