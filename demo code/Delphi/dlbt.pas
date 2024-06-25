unit DLBT;

interface

uses
  windows, SysUtils;

const
   DLBT_Library = 'dlbt.dll';

//=======================================================================================
//  ��ʶ����Ӧ������Щ���ӣ�Tracker�����ء�DHT��http��Э�����صȣ�
//=======================================================================================
DLBT_PROXY_TO_TRACKER       = 1;  // ��������Trackerʹ�ô���
DLBT_PROXY_TO_DOWNLOAD      = 2;  // ��������ʱͬ�û���Peer������ʹ�ô���
DLBT_PROXY_TO_DHT           = 4;  // ����DHTͨѶʹ�ô���DHTʹ��udpͨѶ����Ҫ������֧��udp��
DLBT_PROXY_TO_HTTP_DOWNLOAD = 8;  // ����HTTP����ʹ�ô�����������http��Э������ʱ��Ч��������Tracker��

// �����о�ʹ�ô���

type
  QWORD = int64;
  USHORT = word;
  int = integer;
  LPBYTE = array of Ansichar;
  handle = HWND;
  PLPSTR=^LPSTR;
  PPLPSTR=^PLPSTR;

  
  //���������
   DLBT_PROXY_TYPE = (
                          DLBT_PROXY_NONE,            // ��ʹ�ô���
                          DLBT_PROXY_SOCKS4,          // ʹ��SOCKS4����
                          DLBT_PROXY_SOCKS5,          // ʹ��SOCKS5����
                          DLBT_PROXY_SOCKS5A,         // ʹ����Ҫ������֤��SOCKS5����
                          DLBT_PROXY_HTTP,            // ʹ��HTTP����
                          DLBT_PROXY_HTTPA            // ʹ����Ҫ������֤��HTTP����
                          );

  // �������ص�״̬
   DLBT_DOWNLOAD_STATE = (
                            	BTDS_QUEUED,	                // �����
	                            BTDS_CHECKING_FILES,	        // ���ڼ��У���ļ�
	                            BTDS_DOWNLOADING_TORRENT,	    // ������ģʽ�£����ڻ�ȡ���ӵ���Ϣ
	                            BTDS_DOWNLOADING,	            // ����������
                              BTDS_PAUSED,                  // ��ͣ
	                            BTDS_FINISHED,	              // �������
	                            BTDS_SEEDING,	                // ������
	                            BTDS_ALLOCATING,              // ����Ԥ������̿ռ� -- Ԥ����ռ䣬���ٴ�����Ƭ����
                                                            // ����ѡ���йأ�����ʱ���ѡ��Ԥ������̷�ʽ�����ܽ����״̬
                              BTDS_ERROR                    // ����������д���̳����ԭ����ϸԭ�����ͨ������DLBT_Downloader_GetLastError��֪
                              );

  // �ļ��ķ���ģʽ,���ʹ��˵���ĵ�
   DLBT_FILE_ALLOCATE_TYPE = (
                                  FILE_ALLOCATE_REVERSED = 0,    // Ԥ����ģʽ,Ԥ�ȴ����ļ�,����ÿһ���ŵ���ȷ��λ��.
                                  FILE_ALLOCATE_SPARSE =1 ,      // Default mode, more effient and less disk space. http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
                                  FILE_ALLOCATE_COMPACT = 2      // �ļ���С�������ز�������,ÿ����һ�����ݰ������������һ��,���������ǵ�����λ��,�����в��ϵ���λ��,����ļ�λ�÷���ȷ��

                                  );
  //���ӵ�����
   DLBT_TORRENT_TYPE = (
                            USE_PUBLIC_DHT_NODE   = 0,      // ʹ�ù�����DHT������Դ
                            NO_USE_PUBLIC_DHT_NODE,         // ��ʹ�ù�����DHT����ڵ�
                            ONLY_USE_TRACKER               // ��ʹ��Tracker����ֹDHT������û���Դ������˽�����ӣ�
                            );

  // �˿ڵ�����
   PORT_TYPE = (
                    TCP_PORT        = 1,            // TCP �˿�
                    UDP_PORT                        // UDP �˿�
                    );
          
//=======================================================================================
//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
//  ������Ӫ�̵ķ�������ͬ�������£�������Ҫ��ͬ���á����αװHttpʹ�ã���ĳЩ������Ч������
//=======================================================================================
  DLBT_ENCRYPT_OPTION = (
    DLBT_ENCRYPT_NONE,                  // ��֧���κμ��ܵ����ݣ��������ܵ�ͨѶ��Ͽ�
    DLBT_ENCRYPT_COMPATIBLE,            // ����ģʽ���Լ���������Ӳ�ʹ�ü��ܣ���������˵ļ������ӽ��룬�������ܵ���ͬ�Է��ü���ģʽ�Ự��
    DLBT_ENCRYPT_FULL,                  // �������ܣ��Լ����������Ĭ��ʹ�ü��ܣ�ͬʱ������ͨ�ͼ��ܵ��������롣�����������ü���ģʽ�Ự�������Ǽ�����������ģʽ�Ự��
                                        // Ĭ������������
    DLBT_ENCRYPT_FORCED                // ǿ�Ƽ��ܣ���֧�ּ���ͨѶ����������ͨ���ӣ����������ܵ���Ͽ�
  );

  // ���ܲ㼶�� ���ܲ㼶�ߣ������ϻ��˷�һ��CPU�������ݴ��䰲ȫ��ͻ�Ʒ�����������������
  DLBT_ENCRYPT_LEVEL = (
    DLBT_ENCRYPT_PROTOCOL,          // ������BT��ͨѶ����Э��  ����һ�����ڷ�ֹ��Ӫ�̵���ֹ
    DLBT_ENCRYPT_DATA,              // ���������������������ݣ����� ���ڱ�����ǿ���ļ�����
    DLBT_ENCRYPT_PROTOCOL_MIX,      // �������������ʹ�ü���Э��ģʽ��������Է�ʹ�������ݼ��ܣ�Ҳ֧��ͬ��ʹ�����ݼ���ģʽͨѶ
    DLBT_ENCRYPT_ALL                // Э������ݾ��������� 
  );

  DLBT_RELEASE_FLAG = (
    DLBT_RELEASE_NO_WAIT = 0,           // Ĭ�Ϸ�ʽRelease��ֱ���ͷţ����ȴ��ͷ����
    DLBT_RELEASE_WAIT = 1,              // �ȴ������ļ����ͷ����
    DLBT_RELEASE_DELETE_STATUS = 2,     // ɾ��״̬�ļ�
    DLBT_RELEASE_DELETE_ALL = 4         // ɾ�������ļ�
    );


  DLBT_FILE_PRIORITIZE = (
                          DLBT_FILE_PRIORITY_CANCEL        =   0,
                          DLBT_FILE_PRIORITY_NORMAL,
                          DLBT_FILE_PRIORITY_ABOVE_NORMAL,
                          DLBT_FILE_PRIORITY_MAX
                          );

// �ں�����ʱ�Ļ����������Ƿ�����DHT�Լ������˿ڵȣ�
 PDLBT_KERNEL_START_PARAM = ^DLBT_KERNEL_START_PARAM ;
  DLBT_KERNEL_START_PARAM = record
    bStartLocalDiscovery:          BOOL;     // �Ƿ������������ڵ��Զ����֣���ͨ��DHT��Tracker��ֻҪ��һ��������Ҳ���������֣��������ٶȿ죬���Լ������ȷ���ͬһ�����������ˣ�
    bStartUPnP:                    BOOL;     // �Ƿ��Զ�UPnPӳ�����BT�ں�����Ķ˿�
    bStartDHT:                     BOOL;     // Ĭ���Ƿ�����DHT�����Ĭ�ϲ����������Ժ�����ýӿ�������
    bLanUser:                      BOOL;     // �Ƿ񴿾������û�����ϣ���û������������Ӻ�����ͨѶ��������������ģʽ---��ռ����������ֻͨ���������û������أ�
    bVODMode:                      BOOL;     // �����ں˵�����ģʽ�Ƿ��ϸ��VODģʽ���ϸ��VODģʽ����ʱ��һ���ļ��ķֿ����ϸ񰴱Ƚ�˳��ķ�ʽ���أ���ǰ������أ����ߴ��м�ĳ���϶���λ���������
                                             // ��ģʽ�Ƚ��ʺϱ����ر߲���,������ģʽ���˺ܶ��Ż��������ڲ���������أ����Բ����ʺϴ����صķ�����ֻ�����ڱ����ر߲���ʱʹ�á�Ĭ������ͨģʽ����
                                             // ��VOD���ϰ汾����Ч
    startPort:                     USHORT;   // �ں˼����Ķ˿ڣ����startPort��endPort��Ϊ0 ����startPort > endPort || endPort > 32765 ���ֲ����Ƿ������ں��������һ���˿ڡ� ���startPort��endPort�Ϸ�
    endPort:                       USHORT;   // �ں����Զ���startPort ---- endPort֮�����һ�����õĶ˿ڡ�����˿ڿ��Դ�DLBT_GetListenPort���
  end;

//=======================================================================================
//  ���ô�����غ���,��ҵ��Ȩ����д˹��ܣ���ʾ���ݲ��ṩ
//=======================================================================================
PDLBT_PROXY_SETTING = ^DLBT_PROXY_SETTING ;
DLBT_PROXY_SETTING = record
    proxyHost: array[1..256] of Ansichar;    // �����������ַ
    nPort:int;                          // ����������Ķ˿�
    proxyUser: array[1..256] of Ansichar;    // �������Ҫ��֤�Ĵ���,�����û���
    proxyPass: array[1..256] of Ansichar;    // �������Ҫ��֤�Ĵ���,��������
    proxyType:DLBT_PROXY_TYPE;      // ָ�����������
end;

  // �ں˵Ļ�����Ϣ
 PKERNEL_INFO = ^KERNEL_INFO ;
  KERNEL_INFO = record
    port:                          USHORT;      // �����˿�
    dhtStarted:                    BOOL;     // DHT�Ƿ�����
    totalDownloadConnectionCount:  int;         // �ܵ�����������
    downloadCount:                 int;         // ��������ĸ���
    totalDownloadSpeed:            int;         // �������ٶ�
    totalUploadSpeed:              int;         // ���ϴ��ٶ�
    totalDownloadedByteCount:      UINT64;      // �����ص��ֽ���
    totalUploadedByteCount:        UINT64;      // ���ϴ����ֽ���
    peersNum:                      int;         // ��ǰ�����ϵĽڵ�����
    dhtConnectedNodeNum:           int;         // dht�����ϵĻ�Ծ�ڵ���
    dhtCachedNodeNum:              int;         // dht��֪�Ľڵ���
    dhtTorrentNum:                 int;         // dht����֪��torrent�ļ���
  end;

  // ������������Ļ�����Ϣ
  PDOWNLOADER_INFO = ^DOWNLOADER_INFO;
  DOWNLOADER_INFO = record
    state:                 DLBT_DOWNLOAD_STATE ;      // ���ص�״̬
    percentDone:           single;                    // �Ѿ����ص����ݣ��������torrent�����ݵĴ�С �����ֻѡ����һ�����ļ����أ���ô�ý��Ȳ��ᵽ100%��
    downConnectionCount:   int;                       // ���ؽ�����������
    downloadLimit:         int;                       // ���������������
    connectionCount:       int;                       // �ܽ������������������ϴ���
    totalCompletedSeeds:   int;                       // �����������������������Tracker��֧��scrap���򷵻�-1
    inCompleteNum:         int;                       // �ܵ�δ��ɵ����������Tracker��֧��scrap���򷵻�-1
    seedConnected:         int;                       // ���ϵ�������ɵ�����
    totalCurrentSeedCount: Int;                       // ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
    totalCurrentPeerCount: int;                       // ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
    currentTaskProgress:   single;                    // ��ǰ����Ľ��� (100%������ɣ�
    bReleasingFiles:       BOOL;                      // �Ƿ������ͷ��ļ������һ��������ɺ���Ȼ��������ˣ����ļ�����ͻ����ڲ���������Ҫһ��ʱ�����ͷš�
    
    downloadSpeed:         DWORD;                     // ���ص��ٶ�
    uploadSpeed:           DWORD;                     // �ϴ����ٶ�
    serverPayloadSpeed:    DWORD;                     // �ӷ��������ص�����Ч�ٶȣ�������������Ϣ�ȷ������Դ��䣩
    serverTotalSpeed:      DWORD;                     // �ӷ��������ص����ٶ�(����������Ϣ������ͨѶ�����ģ�

    wastedByteCount:       UINT64;                    // �����ݵ��ֽ�����������Ϣ�ȣ�
    totalDownloadedBytes:  UINT64;                    // ���ص����ݵ��ֽ���
    totalUploadedBytes:    UINT64;                    // �ϴ������ݵ��ֽ���
    totalWantedBytes:      UINT64;                    // ѡ��������ݴ�С
    totalWantedDoneBytes:  UINT64;                    // ѡ����������У���������ɵ����ݴ�С

    totalServerPayloadBytes: UINT64;                  // �ӷ��������ص��������������������������ļ����ݣ�Ҳ����������յ���������ݣ���ʹ���������� -- ����һ����������û���⣬���ᶪ�����ݵģ�
    totalServerBytes:      UINT64;                    // �ӷ��������ص��������ݵ�����������totalServerPayloadBytes���Լ��������ݡ��շ���Ϣ�ȣ�
    totalPayloadBytesDown: UINT64;                    // �����������ܵ����ص����ݿ����͵��������������˷����������ݣ��Լ����ܶ��������ݣ�
    totalBytesDown:        UINT64;                    // �����������ܵ��������ݵ������������������˷������Լ����пͻ������ݡ�����ͨѶ�������ȣ�


    // Torrent��Ϣ
    bHaveTorrent:          BOOL;                      // ��������������ģʽ���ж��Ƿ��Ѿ���ȡ����torrent�ļ�
    totalFileSize:         UINT64;                    // �ļ����ܴ�С
    totalFileSizeExcludePadding: UINT64;              // ʵ���ļ��Ĵ�С������padding�ļ�, �����������padding�ļ������totalFileSize���
    totalPaddingSize:      UINT64;                    // ����padding���ݵĴ�С�������������ʱû����padding�ļ�����Ϊ0
    pieceCount:            int;                       // �ֿ���
    pieceSize:             int;                       // ÿ����Ĵ�С
    infoHash:              array[1..256] of Ansichar;     // �ļ���Hashֵ
  end;

  // ÿ�������ϵĽڵ㣨�û�������Ϣ
  PPEER_INFO_ENTRY = ^PEER_INFO_ENTRY;
  PEER_INFO_ENTRY = record
    connectionType:       int;                  //  �������� 0����׼BT(tcp); 1: P2SP��http�� 2: udp��������ֱ�����ӻ��ߴ�͸��
    downloadSpeed:        int;                  // �����ٶ�
    uploadSpeed:          int;                  // �ϴ��ٶ�
    downloadedBytes:      UINT64;               // ���ص��ֽ���
    uploadedBytes:        UINT64;               // �ϴ����ֽ���
    uploadLimit:          int;                  // �����ӵ��ϴ����٣���������Է�������IP�����ˣ�����ط����Կ������IP���������
    downloadLimit:        int;                  // �����ӵ��������٣���������Է�������IP�����ˣ�����ط����Կ������IP���������

    ip:                   array[0..63] of Ansichar; // �Է�IP
    client:               array[0..63] of Ansichar; // �Է�ʹ�õĿͻ���
  end;

  // ���������ϵĽڵ㣨�û�������Ϣ
  PPEER_INFO = ^PEER_INFO;
  PPPEER_INFO = ^PPEER_INFO;
  PEER_INFO  = record
    count: int;                                  // �ܵĽڵ㣨�û�����
    entries: array[0..0] of PEER_INFO_ENTRY ;       // �ڵ���Ϣ������
  end;


// ***************************  �������ں�������صĽӿ� ********************************

//=======================================================================================
//  �ں˵������͹رպ�������ҵ��Ȩ�����˽��Э�鹦�ܣ���ʾ��͸�����Ѱ�ֻ���ñ�׼BT��ʽ
//=======================================================================================
function DLBT_Startup(
         port: PDLBT_KERNEL_START_PARAM = nil;      // �ں��������ã��ο�DLBT_KERNEL_START_PARAM�����Ϊnil����ʹ���ڲ�Ĭ������
         privateProtocolIDs: LPCSTR = nil;          // �����Զ���˽��Э�飬ͻ����Ӫ�����ơ����ΪNULL������Ϊ��׼��BT�ͻ�������
                                                    // ����BT��˽��Э����3.4�汾�н�����ȫ�¸Ľ������Դ�͸�󲿷���Ӫ�̶�Э��ķ���
         seedServerMode: boolean = False;           // �Ƿ��ϴ�ģʽ���ϴ�ģʽ�ڲ���Щ�����������Ż����ʺϴ󲢷��ϴ�������������ͨ�ͻ������ã�ֻ�����ϴ�������ʹ��
                                                    // רҵ�ϴ�������ģʽ������ҵ������Ч����ʾ���ݲ�֧�ָù��ܡ����ʹ��˵���ĵ�
         ProductNum: LPCSTR = nil
         ): boolean; stdcall;                       // רҵ�ϴ�������ģʽ������ҵ������Ч����ʾ��͸�����Ѱ��ݲ�֧�ָù��ܡ����ʹ��˵���ĵ�


// ����ں˼����Ķ˿�
function DLBT_GetListenPort():USHORT; stdcall;

// ���رյ���BT�ں�
procedure DLBT_Shutdown(); stdcall;

// ���ڹرյ��ٶȿ��ܻ�Ƚ���(��Ҫ֪ͨTracker Stop), ���Կ��Ե��øú�����ǰ֪ͨ,��������ٶ�
// Ȼ������ڳ�������˳�ʱ����DLBT_Shutdown�ȴ������Ľ���
procedure DLBT_PreShutdown(); stdcall;

//=======================================================================================
//  �ں˵��ϴ������ٶȡ���������û���������
//=======================================================================================
// �ٶ����ƣ���λ���ֽ�(BYTE)�������Ҫ����1M�������� 1024*1024
procedure DLBT_SetUploadSpeedLimit(limit: int); stdcall;
procedure DLBT_SetDownloadSpeedLimit(limit: int); stdcall;
// ���������������������ӵ���������
procedure DLBT_SetMaxUploadConnection(limit: int); stdcall;
procedure DLBT_SetMaxTotalConnection(limit: int); stdcall;

// ��෢��İ뿪���������ܶ����ӿ����Ƿ����ˣ�����û���ϣ�
procedure DLBT_SetMaxHalfOpenConnection(limit: int); stdcall;

//=======================================================================================
//  ���þ������Զ����ֵ�һЩ����, interval_seconds�鲥�������������鲻Ҫ����10s�� bUseBroadcast: �Ƿ�ʹ�ù㲥ģʽ
//  Ĭ���ڲ�ʹ���鲥�����ʹ�ù㲥�����ܾ���������������̫�࣬һ�㲻����
//=======================================================================================
procedure DLBT_SetLsdSetting (interval_seconds: int; bUseBroadcast: bool); stdcall;

// ����P2SPʱ��Ҫ����չ�����Ƿ����һ���������Լ��������������ļ���·���ı���
//��չ�������ڷ�ֹһЩ��Ӫ�̶�http���������ڻ��棬���Ե������ص��ǻ�����ϰ汾���ļ������Կ���ʹ��һ��.php������չ������ֹ�����û���
//����Ҫ���������ý�.php��׺���ԣ������������ļ�������ͨ��nginx��rewrite�ȹ���ʵ��
//�Ƿ����һ��?a=b���ֲ�����Ҳ�Ƿ�ֹ����ģ������Ƕ�������Ӫ�̶���Ч
//bUtf8���Ƿ�ʹ��utf8��·�����룬Ĭ����true����������false�������Щ����·����ȡ������
// �ú���Ϊȫ�ֵģ��������ĳ����������
procedure DLBT_SetP2SPExtName (extName: LPCSTR; bUseRandParam: bool; bUtf8: bool); stdcall;

// ���������Ƿ�Ը��Լ���ͬһ�����������û����٣�limit���Ϊtrue����ʹ�ú�������е�������ֵ�������٣������ޡ�Ĭ�ϲ���ͬһ���������µ��û�Ӧ�����١�
procedure DLBT_SetLocalNetworkLimit(
	   Limit: bool;		 // �Ƿ����þ���������
	   downSpeedLimit: int;	// ������þ��������٣��������ٵĴ�С����λ�ֽ�/��
	   uploadSpeedLimit:int  // ������þ��������٣������ϴ��ٶȴ�С����λ�ֽ�/��
	  ); stdcall;


// �����ļ�ɨ��У��ʱ����Ϣ������circleCount����ѭ�����ٴ���һ����Ϣ��Ĭ����0��Ҳ���ǲ���Ϣ��
// sleepMs������Ϣ��ã�Ĭ����1ms
procedure DLBT_SetFileScanDelay (circleCount:DWORD; sleepMs:DWORD); stdcall;

// �����ļ�������ɺ��Ƿ��޸�Ϊԭʼ�޸�ʱ�䣨��������ʱÿ���ļ����޸�ʱ��״̬�������øú�����������torrent�л������ÿ���ļ���ʱ���޸�ʱ����Ϣ
// �û�������ʱ�������������Ϣ�����ҵ����˸ú����������ÿ���ļ����ʱ���Զ����ļ����޸�ʱ������Ϊtorrent�����м�¼��ʱ��
// ���ֻ�����صĻ����������˸ú��������������ӵĻ�����û��ʹ�øú�����������û��ÿ���ļ���ʱ����Ϣ������Ҳ�޷�����ʱ���޸�
procedure DLBT_UseServerModifyTime(bUseServerTime:BOOL); stdcall;

// �Ƿ�����UDP��͸���书�ܣ�Ĭ�����Զ���Ӧ������Է�֧�֣���tcp�޷�����ʱ���Զ��л�ΪudpͨѶ
procedure DLBT_EnableUDPTransfer(bEnabled:BOOL);stdcall;

// �Ƿ�����αװHttp���䣬ĳЩ�����������������ǡ�������һЩ���磩��Http�����٣�����P2P������20K���ң��������绷���£���������Http����
//  Ĭ��������αװHttp�Ĵ�����루���Խ������ǵ�ͨѶ�������Լ���������Ӳ�����αװ�� ����ͻ�Ⱥ���������û������Կ��Ƕ����ã�����αװ��
// ������αװҲ�и����ã�������Щ����������һ������ͨ��������Http����ʹ��������������ʹ��IP����BT�����У��Է�û�кϷ������������ᱻ�������ƽ�ɱ
// ������������ƣ���������αװ���û���ٶȡ����������ʵ��ʹ��ѡ��
procedure DLBT_SetP2PTransferAsHttp (bHttpOut:bool; bAllowedIn:bool); stdcall;

// �Ƿ�ʹ�õ����Ĵ�͸�������������ʹ�õ�������������͸��Э������ĳ��˫���������ϵĵ�����p2p�ڵ㸨�����
function DLBT_AddHoleServer(ip:LPCSTR; port:USHORT): BOOL; stdcall;

// ���÷�������IP�����Զ�ε������ö�������ڱ����ЩIP�Ƿ��������Ա�ͳ�ƴӷ��������ص������ݵ���Ϣ�������ٶȵ���һ���̶ȿ��ԶϿ����������ӣ���ʡ����������
procedure DLBT_AddServerIP (ip:LPCSTR); stdcall;
// ��ȥ�������p2sp��url�������ظ�����. Ŀ���ǣ�����Ƿ������ϣ����p2sp��url���ڱ�������û��Ҫȥ�������url��
procedure DLBT_AddBanServerUrl (ip:LPCSTR); stdcall;

// ����һ��״̬�ļ����������ڲ�Ĭ��ȫ��������ɺ󱣴�һ�Ρ����Ե���Ϊ�Լ���Ҫ��ʱ�����������Ŀ������ÿ5���ӱ���һ�Σ���������100�����ݺ󱣴�һ��
function DLBT_SetStatusFileSavePeriod (
    iPeriod:int;              //����������λ���롣Ĭ����0���������������ɣ�������������
    iPieceCount:int            //�ֿ���Ŀ��Ĭ��0���������������ɣ�������������
    ):BOOL; stdcall;


//=======================================================================================
//  ���ñ���Tracker�ı���IP���������غ͹���ʱ�����Լ�NAT�Ĺ���IP��Ƚ���Ч����ϸ�ο�
//  ����BT��ʹ��˵���ĵ�
//=======================================================================================
procedure DLBT_SetReportIP(ip: LPCSTR); stdcall;
function  DLBT_GetReportIP(): LPCSTR; stdcall;
procedure DLBT_SetUserAgent(agent: LPCSTR); stdcall;

//=======================================================================================
//  ���ô��̻��棬3.3�汾���Ѷ��⿪�ţ�3.3�汾��ϵͳ�ڲ��Զ�����8M���棬���������ʹ�ø�
//  �������е�������λ��K������Ҫ����1M�Ļ��棬��Ҫ����1024
//=======================================================================================
procedure DLBT_SetMaxCacheSize(size: DWORD); stdcall;

// һЩ���ܲ������ã�Ĭ������£�����BT��Ϊ����ͨ���绷���µ��ϴ����������ã��������ǧM��������
// ���Ҵ����������ã�����50M/s����100M/s�ĵ����ļ������ٶȣ�����Ҫ������Щ�������������Լ�ڴ棬Ҳ����������Щ����
// ������������ý��飬����ѯ���������ȡ

procedure DLBT_SetPerformanceFactor(
                                    socketRecvBufferSize: int;      // ����Ľ��ջ�������Ĭ�����ò���ϵͳĬ�ϵĻ����С
                                    socketSendBufferSize: int;      // ����ķ��ͻ�������Ĭ���ò���ϵͳ��Ĭ�ϴ�С
                                    maxRecvDiskQueueSize: int;      // ���������δд�꣬������������󣬽���ͣ���գ��ȴ������ݶ���С�ڸò���
                                    maxSendDiskQueueSize: int       // ���С�ڸò����������߳̽�Ϊ���͵������������ݣ������󣬽���ͣ���̶�ȡ
                                    ); stdcall;


//=======================================================================================
//  DHT��غ���,port��DHT�����Ķ˿ڣ�udp�˿ڣ������Ϊ0��ʹ���ں˼�����TCP�˿ںż���
//=======================================================================================
procedure DLBT_DHT_Start(port: USHORT = 0); stdcall;
procedure DLBT_DHT_Stop(); stdcall;
function DLBT_DHT_IsStarted(): boolean; stdcall;

//=======================================================================================
//  ���ô�����غ���,��ҵ��Ȩ����д˹��ܣ���ʾ��͸�����Ѱ��ݲ��ṩ
//=======================================================================================

procedure DLBT_SetProxy(
                        proxySetting: DLBT_PROXY_SETTING;   // �������ã�����IP�˿ڵ�
                        proxyTo: int                          // ����Ӧ������Щ���ӣ���������궨��ļ������ͣ�����DLBT_PROXY_TO_ALL
                        ); stdcall;

//=======================================================================================
//  ��ȡ��������ã�proxyTo��ʶ������һ�����ӵĴ�����Ϣ����proxyToֻ�ܵ�����ȡĳ������
//  �Ĵ������ã�����ʹ��DLBT_PROXY_TO_ALL���ֶ�����ѡ��
//=======================================================================================
procedure DLBT_GetProxySetting (proxySetting : PDLBT_PROXY_SETTING; proxyTo:int); stdcall;

//=======================================================================================
//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
//  ������Ӫ�̵ķ�������ͬ�������£�������Ҫ��ͬ���á����αװHttpʹ�ã���ĳЩ������Ч������
//=======================================================================================
procedure DLBT_SetEncryptSetting(
      encryptOption: DLBT_ENCRYPT_OPTION;           // ����ѡ������������ͻ��߲�����
      encryptLevel: DLBT_ENCRYPT_LEVEL); stdcall;   // ���ܵĳ̶ȣ������ݻ���Э����ܣ�


// ***************************  �����ǵ���������صĽӿ� ********************************
//=======================================================================================
//  ����һ���ļ������أ�����������صľ�����Ժ�Ը�������������в�������Ҫ���ݾ��������
//=======================================================================================
function  DLBT_Downloader_Initialize(
                                    torrentFile: LPCWSTR;                                               // �����ļ���·�������嵽�ļ�����
                                    outPath: LPCWSTR;                                                   // ���غ�ı���·����ֻ��Ŀ¼��
                                    statusFile: LPCWSTR;                                          // ״̬�ļ���·��
                                    fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;  // �ļ�����ģʽ
                                    bPaused: boolean = FALSE;                                          // �Ƿ����������������񣬴򿪾������ͣ���������
                                    bQuickSeed: boolean = FALSE;                                       // �Ƿ���ٹ��֣�����ҵ���ṩ��
                                    password: LPCSTR = nil;                                            // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
                                    rootPathName: LPCWSTR = nil;                                        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                                                                        // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
                                    bPrivateProtocol: Boolean = FALSE;					// �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
                                    bZipTransfer:Boolean = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
                                    ):HANDLE; stdcall;

// ����һ���ڴ��е������ļ����ݣ������������ļ����Լ������˵�����£����������ļ����Ƕ����洢�������
function  DLBT_Downloader_Initialize_FromBuffer(
                                               torrentFile: PBYTE;                                             // �ڴ��е������ļ�����
                                               dwTorrentFileSize: DWORD;                                        // �������ݵĴ�С
                                               outPath: LPCWSTR;                                                 // ���غ�ı���·����ֻ��Ŀ¼��
                                               statusFile: LPCWSTR;                                        // ״̬�ļ���·��
                                               fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;// �ļ�����ģʽ
                                               bPaused: boolean = FALSE;
                                               bQuickSeed: boolean = FALSE;                                     // �Ƿ���ٹ��֣�����ҵ���ṩ��
                                               password: LPCSTR = nil;                                          // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
                                               rootPathName: LPCWSTR = nil;                                     // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                                                                               // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				                               bPrivateProtocol: boolean = FALSE;		              // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
                                               bZipTransfer:Boolean = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
                                              ): HANDLE; stdcall;

function DLBT_Downloader_Initialize_FromTorrentHandle(
                                                  torrentHandle: HANDLE;                                            //���Ӿ��
                                                  outPath: LPCWSTR;                                                  //����Ŀ¼
                                                  statusFile: LPCWSTR;                                         //״̬�ļ�·��
                                                  fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;
                                                  bPaused: BOOL = False;
                                                  bQuickSeed: BOOL = False;
                                                  rootPathName: LPCWSTR = nil;                                        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                                                                                   // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				                                          bPrivateProtocol: boolean = FALSE;					// �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
                                                  bZipTransfer:Boolean = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
                                                  ): HANDLE; stdcall;

//��������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
function DLBT_Downloader_Initialize_FromInfoHash (
						                                    trackerURL: LPCSTR;                                            // tracker�ĵ�ַ
                                                infoHash:LPCSTR;                                                 // �ļ���infoHashֵ
                                                outPath: LPCWSTR;                                                  //����Ŀ¼
					                                     	name:LPCWSTR = nil;                                            // �����ص�����֮ǰ����û�а취֪�����ֵģ���˿��Դ���һ����ʱ������
						                                    statusFile: LPCWSTR = nil;                                         //״̬�ļ���·�������鴫��һ����ַ���Ա�ʹ�ÿ���ɨ��
                                                fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;  // �ļ�����ģʽ
                                                bPaused: BOOL = False;
						                                    rootPathName: LPCWSTR = nil;                                        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                                                                                   // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				                                        bPrivateProtocol: boolean = FALSE;					// �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
                                                bZipTransfer:Boolean = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
						): HANDLE; stdcall;

// ������ģʽ����һ���ӿڣ�����ֱ��ͨ����ַ���أ���ַ��ʽΪ�� DLBT://xt=urn:btih: Base32 �������info-hash [ &dn= Base32������� ] [ &tr= Base32���tracker�ĵ�ַ ]  ([]Ϊ��ѡ����)
// ��ȫ��ѭuTorrent�Ĺٷ�BT��չЭ��
function DLBT_Downloader_Initialize_FromUrl (
						                                    url: LPCSTR;                                           // ��ַ
                                                outPath: LPCWSTR;                                                  //����Ŀ¼
						                                    statusFile: LPCWSTR = nil;                                         //״̬�ļ���·�������鴫��һ����ַ���Ա�ʹ�ÿ���ɨ��
                                                fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;  // �ļ�����ģʽ
                                                bPaused: BOOL = False;
					                                     	rootPathName: LPCWSTR = nil;                                        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                                                                                   // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				                                        bPrivateProtocol: boolean = FALSE;					// �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
                                                bZipTransfer:Boolean = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
						                                ): HANDLE; stdcall;

// רҵ�ļ����½ӿڣ����������������ļ�Ϊ�����������������ļ�����������ļ��仯�������ݿ顣����ҵ�����ṩ
function DLBT_Downloader_InitializeAsUpdater ( 
						curTorrentFile: LPCWSTR;                   //��ǰ�汾�������ļ� 
						newTorrentFile: LPCWSTR;                   //�°������ļ� 
						curPath: LPCWSTR;                          //��ǰ�ļ���·�� 
						statusFile: LPCWSTR = nil;                 //״̬�ļ���·�������鴫��һ����ַ���Ա�ʹ�ÿ���ɨ��
						fileAllocateType: DLBT_FILE_ALLOCATE_TYPE = FILE_ALLOCATE_SPARSE;  // �ļ�����ģʽ
						bPaused: BOOL = False;
						curTorrentPassword: LPCSTR = nil;           // ��ǰ�汾���ӵ����루��������˲���Ҫ���룩
						newTorrentFilePassword: LPCSTR = nil;           // �����ӵ�����
						rootPathName: LPCWSTR = nil;             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
						bPrivateProtocol: boolean = FALSE;	// �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
						fProgress:PDouble = nil;                 //�����ΪNULL���򴫳���DLBT_Downloader_GetOldTorrentProgressһ����һ������
            bZipTransfer:Boolean = FALSE		// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
						): HANDLE; stdcall;

// רҵ�ļ�����ʱ�������������ӣ�Ȼ��ֱ�Ӵ��������Ӻ������ӵĲ�����������ȣ������������99%������ζ��ֻ��1%��������Ҫ���ء�
function DLBT_Downloader_GetOldTorrentProgress (
						curTorrentFile: LPCWSTR;                   //��ǰ�汾�������ļ� 
						newTorrentFile: LPCWSTR;                   //�°������ļ� 
						curPath: LPCWSTR;                          //��ǰ�ļ���·�� 
						statusFile: LPCWSTR = nil;                 //״̬�ļ���·�������鴫��һ����ַ���Ա�ʹ�ÿ���ɨ��
						curTorrentPassword: LPCSTR = nil;           // ��ǰ�汾���ӵ����루��������˲���Ҫ���룩
						newTorrentFilePassword: LPCSTR = nil           // �����ӵ�����
						):Double; stdcall;


// �ر�����֮ǰ�����Ե��øú���ͣ��IO�̶߳Ը�����Ĳ������첽�ģ���Ҫ����DLBT_Downloader_IsReleasingFiles��������ȡ�Ƿ����ͷ��У���
// �ú������ú���ֱ�ӵ���_Release�����ɶԸþ���ٵ�������DLBT_Dwonloader�������������ڲ�������ͣ�����������أ�Ȼ���ͷŵ��ļ����
procedure DLBT_Downloader_ReleaseAllFiles(hDownloader: HANDLE); stdcall;
// �Ƿ����ͷž���Ĺ�����
function DLBT_Downloader_IsReleasingFiles(hDownloader: HANDLE): BOOL; stdcall;

// �ر�hDownloader����ǵ���������,�����Ҫɾ���ļ�,���Խ���2��������ΪTrue
function  DLBT_Downloader_Release(hDownloader: HANDLE; nFlag:DLBT_RELEASE_FLAG = DLBT_RELEASE_NO_WAIT): HRESULT; stdcall;

// ����һ��http�ĵ�ַ�����������ļ���ĳ��Web����������http����ʱ����ʹ�ã�web�������ı��뷽ʽ���ΪUTF-8�������������ʽ������ϵ������������޸�
procedure DLBT_Downloader_AddHttpDownload(hDownloader: HANDLE; url: LPSTR ); stdcall;

// �Ƴ�һ��P2SP�ĵ�ַ��������������У�����жϿ����ҴӺ�ѡ���б����Ƴ������ٽ�������
procedure DLBT_Downloader_RemoveHttpDownload (hDownloader: HANDLE; url: LPSTR); stdcall;

// ����һ��Http��ַ�������Խ������ٸ����ӣ�Ĭ����1������. ������������ܺã������������ã���������10�������Ƕ�һ��Http��ַ�����Խ���10�����ӡ�
// ����֮ǰ����Ѿ�һ��Http��ַ�������˶�����ӣ����ٶϿ����������ú����½�����ʱ��Ч
procedure  DLBT_Downloader_SetMaxSessionPerHttp (hDownloader: HANDLE; limit: int); stdcall;

// ��ȡ���������е�Http���ӣ��ڴ�������DLBT_Downloader_FreeConnections�ͷ�
procedure DLBT_Downloader_GetHttpConnections(hDownloader:HANDLE; urls:PPLPSTR; urlCount:pinteger); stdcall;
// �ͷ�DLBT_Downloader_GetHttpConnections�������ڴ�
procedure DLBT_Downloader_FreeConnections(urls:PLPSTR; urlCount:int); stdcall;

procedure DLBT_Downloader_AddTracker (hDownloader:HANDLE; url:LPCSTR; tier:int); stdcall;
procedure DLBT_Downloader_RemoveAllTracker (hDownloader:HANDLE); stdcall;
procedure DLBT_Downloader_AddHttpTrackerExtraParams (hDownloader:HANDLE; extraParams:LPCSTR); stdcall;

// �������������Ƿ�˳������,Ĭ���Ƿ�˳������(���������,һ����ѭϡ��������,���ַ�ʽ�ٶȿ�),��˳�����������ڱ��±߲���
procedure DLBT_Downloader_SetDownloadSequence(hDownloader: HANDLE; ifSeq: boolean = FALSE); stdcall;

// ���ص�״̬ �Լ� ��ͣ�ͼ����Ľӿ�
function  DLBT_Downloader_GetState(hDownloader: HANDLE): DLBT_DOWNLOAD_STATE; stdcall;
function  DLBT_Downloader_IsPaused(hDownloader: HANDLE): boolean; stdcall;
procedure DLBT_Downloader_Pause(hDownloader: HANDLE); stdcall;                //��ͣ
procedure DLBT_Downloader_Resume(hDownloader: HANDLE); stdcall;               //����

//����״̬�µ������ӿ� ��һ��ֻ���ڼ�������������ļ��޷�д��ʱ�Ż��������������ˣ�
//��������״̬ΪBTDS_ERROR��ͨ���ýӿڻ�ȡ��ϸ������Ϣ
function DLBT_Downloader_GetLastError (
		      hDownloader:HANDLE;  // ������
		      pBuffer:LPSTR;      // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
		      pBufferSize: pinteger // ����buffer���ڴ��С���������ֵ�ʵ�ʴ�С
		   ): HRESULT; stdcall;
   
//���������󣬳������¿�ʼ����
procedure DLBT_Downloader_ResumeInError (hDownloader:HANDLE); stdcall; 

// ���������ص���ؽӿڣ�������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
function DLBT_Downloader_IsHaveTorrentInfo (hDownloader:HANDLE): boolean; stdcall; // ����������ʱ�������ж��Ƿ�ɹ���ȡ����������Ϣ
function DLBT_Downloader_MakeURL (  // ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
		      hDownloader:HANDLE;  // ������
		      pBuffer:LPSTR;      // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
		      pBufferSize: pinteger // ����buffer���ڴ��С������URL��ʵ�ʴ�С    
		      ): HRESULT; stdcall;
// ���������أ�����Ѿ����ص������ӣ���������������������ӱ����������Ժ����ʹ����
function DLBT_Downloader_SaveTorrentFile (hDownloader:HANDLE; filePath:LPCWSTR; password:LPCSTR = nil): HRESULT; stdcall;

// ���ص����ٺ��������ӵĽӿ�
procedure DLBT_Downloader_SetDownloadLimit(hDownloader: HANDLE; limit: int); stdcall;
procedure DLBT_Downloader_SetUploadLimit(hDownloader: HANDLE; limit: int); stdcall;
procedure DLBT_Downloader_SetMaxUploadConnections(hDownloader: HANDLE; limit: int); stdcall;
procedure DLBT_Downloader_SetMaxTotalConnections( limit: int); stdcall;

// ȷ������ֻ�ϴ���������
procedure DLBT_Downloader_SetOnlyUpload (hDownloader: HANDLE; bUpload:boolean); stdcall;

// ���öԷ�����IP�����������٣���λ��BYTE(�ֽڣ��������Ҫ����1M��������1024*1024
procedure DLBT_Downloader_SetServerDownloadLimit(hDownloader: HANDLE; limit: int); stdcall;
// ���ñ�������ȥ�����еķ�����IP�������ӣ����ڶԷ������������ӣ���ҪBTЭ������ͨ����֪���Ƕ�Ӧ�������������hDownloader�ĺ���ٶϿ�����
procedure DLBT_Downloader_BanServerDownload(hDownloader: HANDLE; limit: int); stdcall;

// ���ط����� (�ϴ�/���صı������Ľӿ�
procedure DLBT_Downloader_SetShareRateLimit(hDownloader: HANDLE; fRate: single); stdcall;
function  DLBT_Downloader_GetShareRate(hDownloader: HANDLE): double; stdcall;

// �������ص��ļ������ԣ��ļ���С������������ȵȣ�
function  DLBT_Downloader_GetTorrentName(
                                    hDownloader: HANDLE;
                                    pBuffer:LPCWSTR;
                                    pBufferSize:pinteger
                                    ): HRESULT; stdcall;
function  DLBT_Downloader_GetTotalFileSize(hDownloader: HANDLE): UINT64; stdcall;
function DLBT_Downloader_GetTotalWanted(hDownloader: HANDLE): Int64; stdcall;
function DLBT_Downloader_GetTotalWantedDone(hDownloader: HANDLE): Int64; stdcall;
function  DLBT_Downloader_GetProgress(hDownloader: HANDLE): single; stdcall;

function  DLBT_Downloader_GetDownloadedBytes(hDownloader: HANDLE): UINT64; stdcall;
function  DLBT_Downloader_GetUploadedBytes(hDownloader: HANDLE): UINT64; stdcall;
function  DLBT_Downloader_GetDownloadSpeed(hDownloader: HANDLE): DWORD; stdcall;
function  DLBT_Downloader_GetUploadSpeed(hDownloader: HANDLE): DWORD; stdcall;

// ��ø�����Ľڵ����Ŀ����Ŀ�Ĳ���Ϊint��ָ�룬�������Ҫĳ��ֵ����NULL
procedure DLBT_Downloader_GetPeerNums(
                                      hDownloader: HANDLE;          // ��������ľ��
                                      connectedCount: pinteger;     // �����������ϵĽڵ������û�����
                                      totalSeedCount: pinteger;     // �ܵ�������Ŀ�����Tracker��֧��scrap���򷵻�-1
                                      seedsConnected: pinteger;     // �Լ����ϵ�������
                                      inCompleteCount: pinteger;     // δ��������������Tracker��֧��scrap���򷵻�-1
                                      totalCurrentSeedCount: PInteger;
                                      totalCurrentPeerCount: PInteger
                                      ); stdcall;

// ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
function  DLBT_Downloader_GetFileCount(hDownloader: HANDLE): int; stdcall;
function  DLBT_Downloader_GetFileSize(hDownloader: HANDLE; index: int): UINT64; stdcall;
// ��ȡ�ļ���torrent�е���ʼλ��
function  DLBT_Downloader_GetFileOffset(hDownloader: HANDLE; index: int): UINT64; stdcall;
function  DLBT_Downloader_IsPadFile(hDownloader: HANDLE; index: int): Boolean; stdcall;
function  DLBT_Downloader_GetFilePathName(
                                         hDownloader: HANDLE;           // ��������ľ��
                                         index: int;                    // �ļ������
                                         pBuffer: LPCWSTR;                // �����ļ���
                                         pBufferSize: pinteger;         // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ���
                                         needFullPath: boolean = false  // �Ƿ���Ҫȫ����·������ֻ��Ҫ�ļ��������е����·��
                                         ): HRESULT; stdcall;

// �ú����Ὣ����Ŀ¼�´��ڣ���torrent��¼�в����ڵ��ļ�ȫ��ɾ�����Ե����ļ���������Ч��������ʹ�á�
function DLBT_Downloader_DeleteUnRelatedFiles (hDownloader: HANDLE): HRESULT; stdcall;

// ��ȡÿ���ļ���Hashֵ��ֻ����������ʱʹ��bUpdateExt���ܻ�ȡ��
function DLBT_Downloader_GetFileHash (
           hDownloader: HANDLE;           // ��������ľ��
           index: int;                    // Ҫ��ȡ���ļ�����ţ�piece����Ŀ����ͨ��DLBT_Downloader_GetFileCount���
           pBuffer: LPSTR;                // ����Hash�ַ���
           pBufferSize: pinteger         // ����pBuffer�Ĵ�С��pieceInfoHash�̶�Ϊ20���ֽڣ���˴˴�Ӧ����20�ĳ��ȡ�
           ): HRESULT; stdcall;


// ȡ�ļ������ؽ��ȣ��ò�����Ҫ���н϶������������ڱ�Ҫʱʹ��
function  DLBT_Downloader_GetFileProgress(hDownloader: HANDLE; index: int): single; stdcall;

//�趨�ļ����ȼ�
function DLBT_Downloader_SetFilePrioritize(hDownloader: HANDLE;
                                           index: Int;
                                           prioritize: DLBT_FILE_PRIORITIZE;
                                           bDoPriority: BOOL = True): HRESULT; stdcall;
procedure DLBT_Downloader_ApplyPrioritize(hDownloader: HANDLE); stdcall;

function DLBT_Downloader_GetPiecesStatus(hDownloader: handle;   // ������
                                         pieceArray: PBOOL;     // ���ÿ�����Ƿ񱾵��������µ�����
                                         arrayLength: int;      // ����ĳ���
                                         pieceDownloaded: PINT  // �Ѿ����صķֿ����Ŀ������ʾ���صķֿ��ͼ��ʱ���ò����Ƚ����á�������ָ����ֺ��ϴλ�ȡʱû��
                                                                // �仯������Բ���Ҫ�ػ���ǰ�ķֿ�״̬ͼ

                                         ): HRESULT; stdcall;

function DLBT_Downloader_SetPiecePrioritize(hDownloader: HANDLE;
                                            index: Int;                           // ������
                                            prioritize: DLBT_FILE_PRIORITIZE;     // ���ȼ�
                                            bDoPriority: BOOL = True              // �Ƿ�����Ӧ��������ã�����ж���ֿ���Ҫ���ã�������ʱ������Ӧ�ã������һ����Ӧ������
                                                                                  // ���߿�����������DLBT_Downloader_ApplyPrioritize������Ӧ�ã���ΪÿӦ��һ�����ö�Ҫ������Piece
                                                                                  // ����һ�飬�Ƚ��鷳������Ӧ��һ��Ӧ��

                                            ): HRESULT; stdcall;


//����ָ����Դ
procedure DLBT_Downloader_AddPeerSource(hDownloader: HANDLE; ip: LPCSTR; port: WORD); stdcall;

// ��ÿ���ʾ���ļ�Hashֵ
function DLBT_Downloader_GetInfoHash(
                                      hDownloader: HANDLE;       // ��������ľ��
                                      pBuffer: LPSTR;            // ����InfoHash���ڴ滺��
                                      pBufferSize: pinteger      // ���뻺��Ĵ�С������ʵ�ʵ�InfoHash�ĳ���
                                      ): HRESULT; stdcall;

function  DLBT_Downloader_GetPieceCount(hDownloader: HANDLE): int; stdcall;
function  DLBT_Downloader_GetPieceSize(hDownloader: HANDLE): int; stdcall;

// ��������һ��״̬�ļ���֪ͨ�ڲ��������̺߳��������أ����첽���������ܻ���һ���ӳٲŻ�д��
procedure DLBT_Downloader_SaveStatusFile (hDownloader: HANDLE); stdcall;

//bOnlyPieceStatus�� �Ƿ�ֻ����һЩ�ļ��ֿ���Ϣ�����ڷ����������ɺ󷢸�ÿ���ͻ������ͻ����Ͳ����ٱȽ��ˣ�ֱ�ӿ�������. Ĭ����FALSE��Ҳ����ȫ����Ϣ������
procedure DLBT_Downloader_SetStatusFileMode (hDownloader: HANDLE; bOnlyPieceStatus:BOOL); stdcall;

// �鿴����״̬�ļ��Ƿ����
function DLBT_Downloader_IsSavingStatus (hDownloader: HANDLE): BOOL; stdcall;

// ��BTϵͳ��д��ͨ��������ʽ�����������ݿ顣offsetΪ�����ݿ��������ļ����ļ��У��е�ƫ������sizeΪ���ݿ��С��dataΪ���ݻ�����
// �ɹ�����S_OK��ʧ��Ϊ������ʧ��ԭ������Ǹÿ鲻��Ҫ�ٴδ����ˡ� ��������VOD��ǿ������Ч
function DLBT_Downloader_AddPartPieceData(hDownloader: HANDLE; offset:UINT64; size:UINT64; data:LPBYTE): HRESULT; stdcall;

// �ֹ����һ�����������ݽ��� ��������VOD��ǿ������Ч
function DLBT_Downloader_AddPieceData(
    hDownloader: HANDLE;
    piece:int;             //�ֿ����
    data:LPBYTE;           //���ݱ���
    bOverWrite:bool       //����Ѿ����ˣ��Ƿ񸲸�
    ): HRESULT; stdcall;

{
���½ӿ���ʱû�з��� ��ֻ�ڸ߼��汾-VOD�㲥�汾��������רҵ�汾����Ч���������MFCʾ���е�DLBT/DLBT.h�ļ������������ӿ��Լ�����
        �����ѿ�����ϵ���߽��
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
    DLBT_RPL_IDLE  = 0,     //��δ��ʼ�滻
    DLBT_RPL_RUNNING,       //����������
    DLBT_RPL_SUCCESS,       //�滻�ɹ�
    DLBT_RPL_USER_CANCELED, //�滻��һ�룬�û�ȡ������
    DLBT_RPL_ERROR,         //��������ͨ��hrDetail����ȡ��ϸ��Ϣ���ο���DLBT_Downloader_GetReplaceResult


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
	DLBT_MOVED	= 0,	//�ƶ��ɹ�
	DLBT_MOVE_FAILED,	//�ƶ�ʧ��
	DLBT_MOVING         //�����ƶ�


//�ƶ����ĸ�Ŀ¼�������ͬһ���̷������Ǽ��У�����ǲ�ͬ�������Ǹ��ƺ�ɾ��ԭʼ�ļ������ڲ������첽������������������
//���ʹ��DLBT_Downloader_GetMoveResultȥ��ȡ
DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCWSTR savePath);
//�鿴�ƶ������Ľ��
DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
	HANDLE			hDownloader,   // ��������ľ��
	LPSTR			errorMsg,      // ���ڷ��س�����Ϣ���ڴ棬��DLBT_MOVE_FAILED״̬�����ﷵ�س�������顣�������NULL���򲻷��ش�����Ϣ
	int				msgSize		   // ������Ϣ�ڴ�Ĵ�С
	); 

}


// ***************************  ����������������صĽӿ� ********************************


// ����һ��Torrent�ľ���������ڴ������ӵľ��
function  DLBT_CreateTorrent(
                            pieceSize: int;                 // �ļ��ķֿ��С
                            filename: LPCWSTR;               // �ļ�������Ŀ¼��Ŀ¼��Ŀ¼�������ļ�����һ�����ӣ�
                            publisher: LPCWSTR = nil;       // ��������Ϣ
                            publisherUrl: LPCWSTR = nil;     // �����ߵ���ַ
                            comment: LPCWSTR = nil;          // ���ۺ�����
                            torrentType: DLBT_TORRENT_TYPE = USE_PUBLIC_DHT_NODE;   // ������ӵ�����
                            progress: PInteger = nil;
                            cancel: PBOOL = nil;
                            minPadFileSize: int = -1;
                            bUpdateExt: BOOL = False
                            ): HANDLE; stdcall; //�Ƿ��������ڸ��µĵ�����չ��Ϣ����������DLBT_Downloader_InitializeAsUpdater�ӿڡ�����ҵ����Ч

// ָ�����Ӱ�����Tracker
function  DLBT_Torrent_AddTracker(
                          hTorrent: HANDLE;        // ���ӵľ��
                          trackerURL: LPCWSTR;      // tracker�ĵ�ַ��������http Tracker��udp Tracker
                          tier: int                // ���ȼ���˳��
                          ): HRESULT; stdcall;

// �Ƴ������е�����Tracker
procedure  DLBT_Torrent_RemoveAllTracker(hTorrent: HANDLE); stdcall;

// ָ�����ӿ���ʹ�õ�httpԴ��������صĿͻ���֧��http��Э�����أ�����Զ��Ӹõ�ַ��������
procedure DLBT_Torrent_AddHttpUrl(hTorrent:HANDLE; httpUrl: LPCWSTR); stdcall;

// ����Ϊtorrent�ļ�,filePathΪ·���������ļ�����
function  DLBT_SaveTorrentFile(hTorrent:HANDLE; filePath: LPCWSTR; password: LPSTR = nil; bUseHashName: BOOL = False; extName:LPCWSTR = nil): HRESULT; stdcall;
// �ͷ�torrent�ļ��ľ��
procedure DLBT_ReleaseTorrent(hTorrent:HANDLE); stdcall;


// ***************************  �����Ƕ�ȡ������صĽӿ� ********************************
//                     �����ڲ���Ҫ�������ص�����»�������ڵ���Ϣ

// ��һ�����Ӿ���������޸Ļ��߶�ȡ��Ϣ���в������������Ҫ����DLBT_ReleaseTorrent�ͷ�torrent�ļ��ľ��
function  DLBT_OpenTorrent(
                           torrentFile: LPCWSTR;     // �����ļ�ȫ·��
                           password: LPCSTR          // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ�����,�Դ�������н���
                           ): HANDLE; stdcall;

function  DLBT_OpenTorrentFromBuffer(
                           torrentFile: PByte;  //�����ļ�����
                           dwTorrentFile: DWORD;
                           password: LPCSTR): HANDLE; stdcall;

// �ر�һ�������ļ��ľ��
//procedure DLBT_CloseTorrent(hTorrent: HANDLE); stdcall;

function DLBT_Torrent_GetComment(
                                 hTorrent: HANDLE;         // �����ļ����
                                 pBuffer: LPCWSTR;           // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������۵�ʵ�ʴ�С
                                 pBufferSize: pinteger     // �������۵��ڴ��С���������۵�ʵ�ʴ�С
                                 ): HRESULT; stdcall;

// ���ش����������Ϣ
function DLBT_Torrent_GetCreator(
                                 hTorrent: HANDLE;         // �����ļ����
                                 pBuffer: LPWSTR;          // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
                                 pBufferSize: pinteger     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
                                 ): HRESULT; stdcall;
 
// ���ط�������Ϣ                                
function DLBT_Torrent_GetPublisher(
                                 hTorrent: HANDLE;         // �����ļ����
                                 pBuffer: LPWSTR;           // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
                                 pBufferSize: pinteger     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
                                 ): HRESULT; stdcall;

// ���ط�������ַ
function DLBT_Torrent_GetPublisherUrl (
                                 hTorrent: HANDLE;         // �����ļ����
                                 pBuffer: LPWSTR;           // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з��ط�������ַ��ʵ�ʴ�С
                                 pBufferSize: pinteger     // ��������Ϣ���ڴ��С��������������ַ��ʵ�ʴ�С
                                 ): HRESULT; stdcall;

// ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
function DLBT_Torrent_MakeURL (  
                                 hTorrent: HANDLE;         // �����ļ����
                                 pBuffer: LPSTR ;          // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
                                 pBufferSize: pinteger     // ����buffer���ڴ��С������URL��ʵ�ʴ�С
                                 ): HRESULT; stdcall;

function DLBT_Torrent_GetTrackerCount(hTorrent: HANDLE): int; stdcall;

function DLBT_Torrent_GetTrackerUrl(
                                    hTorrent: HANDLE;       // �����ļ����
                                    index:int               // Tracker����ţ���0��ʼ
                                    ): LPCSTR; stdcall;

// ��ȡ�����а����������ļ����ܴ�С
function DLBT_Torrent_GetTotalFileSize (hTorrent:HANDLE) : UINT64; stdcall;

// ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
function  DLBT_Torrent_GetFileCount (hTorrent:HANDLE): int; stdcall;
function  DLBT_Torrent_IsPadFile (
                                   hTorrent: HANDLE;       // �����ļ����
                                   index:int               // Tracker����ţ���0��ʼ
                                   ): BOOL; stdcall;

// ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
function  DLBT_Torrent_GetFileSize(
     hTorrent: HANDLE;     // �����ļ����
     index:    int        // Ҫ��ȡ��С���ļ�����ţ��ļ�����Ǵ�0��ʼ��
     ): UINT64; stdcall;
// ��ȡ������ÿ���ļ�������
function  DLBT_Torrent_GetFilePathName(
                                         hTorrent: HANDLE;           // �����ļ����
                                         index: int;                    // Ҫ��ȡ���ֵ��ļ�����ţ��ļ�����Ǵ�0��ʼ��
                                         pBuffer: LPCWSTR;               // �����ļ���
                                         pBufferSize: pinteger         // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ���
                                         ): HRESULT; stdcall;


// ��ȡ�ֿ���Ŀ
function DLBT_Torrent_GetPieceCount (hTorrent:HANDLE): int; stdcall;
// ��ȡ�ֿ��С
function DLBT_Torrent_GetPieceSize (hTorrent:HANDLE): int; stdcall;

// ��ȡ������ÿ���ֿ��Hashֵ
function DLBT_Torrent_GetPieceInfoHash (
        hTorrent: HANDLE;           // �����ļ����
        index: int;                 // Ҫ��ȡ��Piece����ţ�piece����Ŀ����ͨ��DLBT_Torrent_GetPieceCount���
        pBuffer: LPSTR;               // ����Hash�ַ���
        pBufferSize: pinteger         // ����pBuffer�Ĵ�С��pieceInfoHash�̶�Ϊ20���ֽڣ���˴˴�Ӧ����20�ĳ��ȡ�
    ): HRESULT; stdcall;

// ��������ļ���InfoHashֵ
function DLBT_Torrent_GetInfoHash (
	      hTorrent: HANDLE;         // �����ļ����
        pBuffer: LPSTR;           // ����InfoHash���ڴ滺��
        pBufferSize: pinteger     //���뻺��Ĵ�С������ʵ�ʵ�InfoHash�ĳ���
    ): HRESULT; stdcall;

{
���½ӿ���ʱû�з��룬�����MFCʾ���е�DLBT/DLBT.h�ļ������������ӿ��Լ�����
        �����ѿ�����ϵ���߽��

// **************************** �����������г��йصĽӿ� *****************************
// �����г�������ҵ�汾���ṩ��������ð�����ʱ���ṩ�ù���
struct DLBT_TM_ITEM     //��������г��е�һ�������ļ�
(
	DLBT_TM_ITEM(): fileSize (0) 
	
	UINT64  fileSize;      // the size of this file
	char	name[256];     // ����
	LPCSTR	url;           // �������ص�url
	LPCSTR  comment;       // ��������
);

struct DLBT_TM_LIST //��������г��е�һ�������ļ��������
(
	int				count;      //��Ŀ
	DLBT_TM_ITEM	items[1];   //�����б�
);

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

}

// *********************  �����Ƿ���ǽ��UPnP��͸��P2P�����Խӿ� **********************


//  ��ĳ��Ӧ�ó�����ӵ�ICF����ǽ��������ȥ���ɶ������ں�Ӧ�ã��������ں���Ȼ����ʹ�øú���
function  DLBT_AddAppToWindowsXPFirewall(
                                         appFilePath: LPCWSTR;        // �����·��������exe�����֣�
                                         ruleName: LPCWSTR            // �ڷ���ǽ����������ʾ���������������
                                         ): boolean; stdcall;
// ��ĳ���˿ڼ���UPnPӳ�䣬����BT�ڲ������ж˿��Ѿ��Զ����룬����Ҫ�ٴμ��룬�����ṩ�����ǹ��ⲿ��������Լ�����˿�
procedure DLBT_AddUPnPPortMapping(
	nExternPort: USHORT;        // NATҪ�򿪵��ⲿ�˿�
	nLocalPort: USHORT;        // ӳ����ڲ��˿ڣ��������˿ڣ���һ���ǳ����ڼ����Ķ˿�
	nPortType: PORT_TYPE;          // �˿����ͣ�UDP����TCP��
        appName: LPCSTR             // ��NAT����ʾ���������������
	); stdcall;

// ��õ���ϵͳ�Ĳ������������ƣ��������0���ʾϵͳ���ܲ������޵�XPϵͳ�������޸�����������
// �ɶ������ں�ʹ�ã������ں�ǰ����ʹ��
function  DLBT_GetCurrentXPLimit(): DWORD; stdcall;

// �޸�XP�Ĳ������������ƣ�����BOOL��־�Ƿ�ɹ�
function  DLBT_ChangeXPConnectionLimit(num: DWORD): boolean; stdcall;

// ��ȡ������Ϣ�Ľӿ�
function  DLBT_GetKernelInfo(info: PKERNEL_INFO): HRESULT; stdcall;
function  DLBT_GetDownloaderInfo(hDownloader: HANDLE; info: PDOWNLOADER_INFO): HRESULT; stdcall;

// �����ɽڵ��б��б���DLL���䣬��ˣ���Ҫ����DLBT_FreeDownloaderPeerInfoList�����ͷŸ��ڴ�
function  DLBT_GetDownloaderPeerInfoList(hDownloader: HANDLE; ppinfo: PPEER_INFO): HRESULT; stdcall;
procedure DLBT_FreeDownloaderPeerInfoList(pinfo: PPEER_INFO); stdcall;
procedure DLBT_SetDHTFilePathName(dhtFile: LPCWSTR); stdcall;

// �����Զ���IO�����ĺ��������Խ�BT����Ķ�д�ļ������в����ⲿ���д����滻�ڲ��Ķ�д�����ȣ�
// �ù���Ϊ�߼��湦�ܣ�����ϵ������ȡ����֧�֣�Ĭ�ϰ汾�в����Ÿù���

// ����IO�����Ľӹܽṹ���ָ��
procedure DLBT_Set_IO_OP(op: Pointer); stdcall;
// �Խṹ����������к����ȸ�ֵĬ�ϵĺ���ָ��
procedure DLBT_InitDefault_IO_OP(op: Pointer); stdcall;
// ��ȡϵͳ�ڲ�Ŀǰ���õ�IO�����ָ��
function DLBT_Get_IO_OP():Pointer; stdcall;

// ��ȡϵͳԭʼIO��ָ��
function DLBT_Get_RAW_IO_OP():Pointer; stdcall;


implementation

  function  DLBT_Startup; stdcall; external DLBT_Library name 'DLBT_Startup';
  function  DLBT_GetListenPort; stdcall; external DLBT_Library name 'DLBT_GetListenPort';
  procedure DLBT_Shutdown; stdcall; external DLBT_Library name 'DLBT_Shutdown';
  procedure DLBT_PreShutdown; stdcall; external DLBT_Library name 'DLBT_PreShutdown';
  procedure DLBT_SetUploadSpeedLimit; stdcall; external DLBT_Library name 'DLBT_SetUploadSpeedLimit';
  procedure DLBT_SetDownloadSpeedLimit; stdcall; external DLBT_Library name 'DLBT_SetDownloadSpeedLimit';
  procedure DLBT_SetMaxUploadConnection; stdcall; external DLBT_Library name 'DLBT_SetMaxUploadConnection';
  procedure DLBT_SetMaxTotalConnection; stdcall; external DLBT_Library name 'DLBT_SetMaxTotalConnection';
  procedure DLBT_SetMaxHalfOpenConnection; stdcall; external DLBT_Library name 'DLBT_SetMaxHalfOpenConnection';
  procedure DLBT_SetLsdSetting; stdcall; external DLBT_Library name 'DLBT_SetLsdSetting';
  procedure DLBT_SetP2SPExtName; stdcall; external DLBT_Library name 'DLBT_SetP2SPExtName';
  procedure DLBT_SetLocalNetworkLimit; stdcall; external DLBT_Library name 'DLBT_SetLocalNetworkLimit';
  procedure DLBT_SetFileScanDelay; stdcall; external DLBT_Library name 'DLBT_SetFileScanDelay';
  procedure DLBT_UseServerModifyTime; stdcall; external DLBT_Library name 'DLBT_UseServerModifyTime';
  procedure DLBT_EnableUDPTransfer; stdcall; external DLBT_Library name 'DLBT_EnableUDPTransfer'; 
  procedure DLBT_SetP2PTransferAsHttp; stdcall; external DLBT_Library name 'DLBT_SetP2PTransferAsHttp';
  function DLBT_AddHoleServer; stdcall; external DLBT_Library name 'DLBT_AddHoleServer'; 
  procedure DLBT_AddServerIP; stdcall; external DLBT_Library name 'DLBT_AddServerIP';
  procedure DLBT_AddBanServerUrl; stdcall; external DLBT_Library name 'DLBT_AddBanServerUrl';
  function DLBT_SetStatusFileSavePeriod; stdcall; external DLBT_Library name 'DLBT_SetStatusFileSavePeriod';
  procedure DLBT_SetReportIP; stdcall; external DLBT_Library name 'DLBT_SetReportIP';
  function  DLBT_GetReportIP; stdcall; external DLBT_Library name 'DLBT_GetReportIP';
  procedure DLBT_SetUserAgent; stdcall; external DLBT_Library name 'DLBT_SetUserAgent';
  procedure DLBT_SetMaxCacheSize; stdcall; external DLBT_Library name 'DLBT_SetMaxCacheSize';
  procedure DLBT_SetPerformanceFactor; stdcall; external DLBT_Library name 'DLBT_SetPerformanceFactor';
  procedure DLBT_DHT_Start; stdcall; external DLBT_Library name 'DLBT_DHT_Start';
  procedure DLBT_DHT_Stop; stdcall; external DLBT_Library name 'DLBT_DHT_Stop';
  function  DLBT_DHT_IsStarted; stdcall; external DLBT_Library name 'DLBT_DHT_IsStarted';
  procedure DLBT_SetProxy; stdcall; external DLBT_Library name 'DLBT_SetProxy';
  procedure DLBT_GetProxySetting; stdcall; external DLBT_Library name 'DLBT_GetProxySetting';
  procedure DLBT_SetEncryptSetting; stdcall; external DLBT_Library name 'DLBT_SetEncryptSetting';

  function  DLBT_Downloader_Initialize; stdcall; external DLBT_Library name 'DLBT_Downloader_Initialize';
  function  DLBT_Downloader_Initialize_FromBuffer; stdcall; external DLBT_Library name 'DLBT_Downloader_Initialize_FromBuffer';
  function DLBT_Downloader_Initialize_FromTorrentHandle; stdcall external DLBT_Library name 'DLBT_Downloader_Initialize_FromTorrentHandle';
  function DLBT_Downloader_Initialize_FromInfoHash; stdcall external DLBT_Library name 'DLBT_Downloader_Initialize_FromInfoHash';
  function DLBT_Downloader_Initialize_FromUrl; stdcall external DLBT_Library name 'DLBT_Downloader_Initialize_FromUrl';
  function DLBT_Downloader_InitializeAsUpdater; stdcall external DLBT_Library name 'DLBT_Downloader_InitializeAsUpdater';
  function DLBT_Downloader_GetOldTorrentProgress; stdcall external DLBT_Library name 'DLBT_Downloader_GetOldTorrentProgress';  
  procedure DLBT_Downloader_ReleaseAllFiles; stdcall; external DLBT_Library name 'DLBT_Downloader_ReleaseAllFiles';
  function DLBT_Downloader_IsReleasingFiles; stdcall; external DLBT_Library name 'DLBT_Downloader_IsReleasingFiles';
  function  DLBT_Downloader_Release; stdcall; external DLBT_Library name 'DLBT_Downloader_Release';

  procedure DLBT_Downloader_AddHttpDownload; stdcall; external DLBT_Library name 'DLBT_Downloader_AddHttpDownload';
  procedure DLBT_Downloader_RemoveHttpDownload; stdcall; external DLBT_Library name 'DLBT_Downloader_RemoveHttpDownload';
  procedure DLBT_Downloader_SetMaxSessionPerHttp; stdcall; external DLBT_Library name 'DLBT_Downloader_SetMaxSessionPerHttp';
  procedure DLBT_Downloader_GetHttpConnections; stdcall; external DLBT_Library name 'DLBT_Downloader_GetHttpConnections';
  procedure DLBT_Downloader_FreeConnections; stdcall; external DLBT_Library name 'DLBT_Downloader_FreeConnections';
  procedure DLBT_Downloader_AddTracker; stdcall; external DLBT_Library name 'DLBT_Downloader_AddTracker';
  procedure DLBT_Downloader_RemoveAllTracker; stdcall; external DLBT_Library name 'DLBT_Downloader_RemoveAllTracker';
  procedure DLBT_Downloader_AddHttpTrackerExtraParams; stdcall; external DLBT_Library name 'DLBT_Downloader_AddHttpTrackerExtraParams';
  procedure DLBT_Downloader_SetDownloadSequence; stdcall; external DLBT_Library name 'DLBT_Downloader_SetDownloadSequence';
  function  DLBT_Downloader_GetState; stdcall; external DLBT_Library name 'DLBT_Downloader_GetState';
  function  DLBT_Downloader_IsPaused; stdcall; external DLBT_Library name 'DLBT_Downloader_IsPaused';
  procedure DLBT_Downloader_Pause; stdcall; external DLBT_Library name 'DLBT_Downloader_Pause';
  procedure DLBT_Downloader_Resume; stdcall; external DLBT_Library name 'DLBT_Downloader_Resume';
  function  DLBT_Downloader_GetLastError; stdcall; external DLBT_Library name 'DLBT_Downloader_GetLastError';
  procedure DLBT_Downloader_ResumeInError; stdcall; external DLBT_Library name 'DLBT_Downloader_ResumeInError';
  function  DLBT_Downloader_IsHaveTorrentInfo; stdcall; external DLBT_Library name 'DLBT_Downloader_IsHaveTorrentInfo';
  function  DLBT_Downloader_MakeURL; stdcall; external DLBT_Library name 'DLBT_Downloader_MakeURL';
  function  DLBT_Downloader_SaveTorrentFile; stdcall; external DLBT_Library name 'DLBT_Downloader_SaveTorrentFile';
  procedure DLBT_Downloader_SetDownloadLimit; stdcall; external DLBT_Library name 'DLBT_Downloader_SetDownloadLimit';
  procedure DLBT_Downloader_SetUploadLimit; stdcall; external DLBT_Library name 'DLBT_Downloader_SetUploadLimit';
  procedure DLBT_Downloader_SetMaxUploadConnections; stdcall; external DLBT_Library name 'DLBT_Downloader_SetMaxUploadConnections';
  procedure DLBT_Downloader_SetMaxTotalConnections; stdcall; external DLBT_Library name 'DLBT_Downloader_SetMaxTotalConnections';
  procedure DLBT_Downloader_SetOnlyUpload; stdcall; external DLBT_Library name 'DLBT_Downloader_SetOnlyUpload';  
  procedure DLBT_Downloader_SetServerDownloadLimit; stdcall; external DLBT_Library name 'DLBT_Downloader_SetServerDownloadLimit';
  procedure DLBT_Downloader_BanServerDownload; stdcall; external DLBT_Library name 'DLBT_Downloader_BanServerDownload';
  procedure DLBT_Downloader_SetShareRateLimit; stdcall; external DLBT_Library name 'DLBT_Downloader_SetShareRateLimit';
  function  DLBT_Downloader_GetShareRate; stdcall; external DLBT_Library name 'DLBT_Downloader_GetShareRate';
  function  DLBT_Downloader_GetTorrentName; stdcall; external DLBT_Library name 'DLBT_Downloader_GetTorrentName';
  function  DLBT_Downloader_GetTotalFileSize; stdcall; external DLBT_Library name 'DLBT_Downloader_GetTotalFileSize';  
  function DLBT_Downloader_GetTotalWanted; stdcall; external DLBT_Library name 'DLBT_Downloader_GetTotalWanted';
  function DLBT_Downloader_GetTotalWantedDone; stdcall; external DLBT_Library name 'DLBT_Downloader_GetTotalWantedDone';
  function  DLBT_Downloader_GetProgress; stdcall; external DLBT_Library name 'DLBT_Downloader_GetProgress';
  function  DLBT_Downloader_GetDownloadedBytes; stdcall; external DLBT_Library name 'DLBT_Downloader_GetDownloadedBytes';
  function  DLBT_Downloader_GetUploadedBytes; stdcall; external DLBT_Library name 'DLBT_Downloader_GetUploadedBytes';
  function  DLBT_Downloader_GetDownloadSpeed; stdcall; external DLBT_Library name 'DLBT_Downloader_GetDownloadSpeed';
  function  DLBT_Downloader_GetUploadSpeed; stdcall; external DLBT_Library name 'DLBT_Downloader_GetUploadSpeed';
  procedure DLBT_Downloader_GetPeerNums; stdcall; external DLBT_Library name 'DLBT_Downloader_GetPeerNums';
  function  DLBT_Downloader_GetFileCount; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFileCount';
  function  DLBT_Downloader_GetFileSize; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFileSize';
  function  DLBT_Downloader_GetFileOffset; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFileOffset';
  function  DLBT_Downloader_IsPadFile; stdcall; external DLBT_Library name 'DLBT_Downloader_IsPadFile';
  function  DLBT_Downloader_GetFilePathName; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFilePathName';
  function DLBT_Downloader_DeleteUnRelatedFiles; stdcall; external DLBT_Library name 'DLBT_Downloader_DeleteUnRelatedFiles';
  function DLBT_Downloader_GetFileHash; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFileHash';
  function  DLBT_Downloader_GetFileProgress; stdcall; external DLBT_Library name 'DLBT_Downloader_GetFileProgress';
  function DLBT_Downloader_SetFilePrioritize; stdcall; external DLBT_Library name 'DLBT_Downloader_SetFilePrioritize';
  procedure DLBT_Downloader_ApplyPrioritize; stdcall; external DLBT_Library name 'DLBT_Downloader_ApplyPrioritize';
  function DLBT_Downloader_GetPiecesStatus; stdcall; external DLBT_Library name 'DLBT_Downloader_GetPiecesStatus';
  function DLBT_Downloader_SetPiecePrioritize; stdcall; external DLBT_Library name 'DLBT_Downloader_SetPiecePrioritize';
  procedure DLBT_Downloader_AddPeerSource; stdcall; external DLBT_Library name 'DLBT_Downloader_AddPeerSource';
  function  DLBT_Downloader_GetInfoHash; stdcall; external DLBT_Library name 'DLBT_Downloader_GetInfoHash';
  function  DLBT_Downloader_GetPieceCount; stdcall; external DLBT_Library name 'DLBT_Downloader_GetPieceCount';
  function  DLBT_Downloader_GetPieceSize; stdcall; external DLBT_Library name 'DLBT_Downloader_GetPieceSize';
  procedure DLBT_Downloader_SaveStatusFile; stdcall; external DLBT_Library name 'DLBT_Downloader_SaveStatusFile';
  procedure DLBT_Downloader_SetStatusFileMode; stdcall; external DLBT_Library name 'DLBT_Downloader_SetStatusFileMode';
  function DLBT_Downloader_IsSavingStatus; stdcall; external DLBT_Library name 'DLBT_Downloader_IsSavingStatus';
  function DLBT_Downloader_AddPartPieceData; stdcall; external DLBT_Library name 'DLBT_Downloader_AddPartPieceData';
  function DLBT_Downloader_AddPieceData; stdcall; external DLBT_Library name 'DLBT_Downloader_AddPieceData';

  function  DLBT_CreateTorrent; stdcall; external DLBT_Library name 'DLBT_CreateTorrent';
  function  DLBT_Torrent_AddTracker; stdcall; external DLBT_Library name 'DLBT_Torrent_AddTracker';
  procedure DLBT_Torrent_RemoveAllTracker; stdcall; external DLBT_Library name 'DLBT_Torrent_RemoveAllTracker';
  procedure DLBT_Torrent_AddHttpUrl; stdcall; external DLBT_Library name 'DLBT_Torrent_AddHttpUrl';
  function  DLBT_SaveTorrentFile; stdcall; external DLBT_Library name 'DLBT_SaveTorrentFile';
  procedure DLBT_ReleaseTorrent; stdcall; external DLBT_Library name 'DLBT_ReleaseTorrent';

  function  DLBT_OpenTorrent; stdcall; external DLBT_Library name 'DLBT_OpenTorrent';
  function  DLBT_OpenTorrentFromBuffer; stdcall; external DLBT_Library name 'DLBT_OpenTorrentFromBuffer';
  function  DLBT_Torrent_GetComment; stdcall; external DLBT_Library name 'DLBT_Torrent_GetComment';
  function  DLBT_Torrent_GetCreator; stdcall; external DLBT_Library name 'DLBT_Torrent_GetCreator';
  function  DLBT_Torrent_GetPublisher; stdcall; external DLBT_Library name 'DLBT_Torrent_GetPublisher';
  function  DLBT_Torrent_GetPublisherUrl; stdcall; external DLBT_Library name 'DLBT_Torrent_GetPublisherUrl';
  function  DLBT_Torrent_MakeURL; stdcall; external DLBT_Library name 'DLBT_Torrent_MakeURL';
  function  DLBT_Torrent_GetTrackerCount; stdcall; external DLBT_Library name 'DLBT_Torrent_GetTrackerCount';
  function  DLBT_Torrent_GetTrackerUrl; stdcall; external DLBT_Library name 'DLBT_Torrent_GetTrackerUrl';
  function  DLBT_Torrent_GetTotalFileSize; stdcall; external DLBT_Library name 'DLBT_Torrent_GetTotalFileSize';
  function  DLBT_Torrent_GetFileCount; stdcall; external DLBT_Library name 'DLBT_Torrent_GetFileCount';
  function  DLBT_Torrent_IsPadFile; stdcall; external DLBT_Library name 'DLBT_Torrent_IsPadFile';
  function  DLBT_Torrent_GetFileSize; stdcall; external DLBT_Library name 'DLBT_Torrent_GetFileSize';
  function  DLBT_Torrent_GetFilePathName; stdcall; external DLBT_Library name 'DLBT_Torrent_GetFilePathName';
  function  DLBT_Torrent_GetPieceCount; stdcall; external DLBT_Library name 'DLBT_Torrent_GetPieceCount';
  function  DLBT_Torrent_GetPieceSize; stdcall; external DLBT_Library name 'DLBT_Torrent_GetPieceSize';
  function  DLBT_Torrent_GetPieceInfoHash; stdcall; external DLBT_Library name 'DLBT_Torrent_GetPieceInfoHash';
  function  DLBT_Torrent_GetInfoHash; stdcall; external DLBT_Library name 'DLBT_Torrent_GetInfoHash';

  function  DLBT_AddAppToWindowsXPFirewall; stdcall; external DLBT_Library name 'DLBT_AddAppToWindowsXPFirewall';
  procedure DLBT_AddUPnPPortMapping; stdcall; external DLBT_Library name 'DLBT_AddUPnPPortMapping';
  function  DLBT_GetCurrentXPLimit; stdcall; external DLBT_Library name 'DLBT_GetCurrentXPLimit';
  function  DLBT_ChangeXPConnectionLimit; stdcall; external DLBT_Library name 'DLBT_ChangeXPConnectionLimit';
  function  DLBT_GetKernelInfo; stdcall; external DLBT_Library name 'DLBT_GetKernelInfo';
  function  DLBT_GetDownloaderInfo; stdcall; external DLBT_Library name 'DLBT_GetDownloaderInfo';
  function  DLBT_GetDownloaderPeerInfoList; stdcall; external DLBT_Library name 'DLBT_GetDownloaderPeerInfoList';
  procedure DLBT_FreeDownloaderPeerInfoList; stdcall; external DLBT_Library name 'DLBT_FreeDownloaderPeerInfoList';

  procedure  DLBT_SetDHTFilePathName; stdcall; external DLBT_Library name 'DLBT_SetDHTFilePathName';

  procedure  DLBT_Set_IO_OP; stdcall; external DLBT_Library name 'DLBT_Set_IO_OP';
  procedure  DLBT_InitDefault_IO_OP; stdcall; external DLBT_Library name 'DLBT_InitDefault_IO_OP';
  function   DLBT_Get_IO_OP; stdcall; external DLBT_Library name 'DLBT_Get_IO_OP';
  function   DLBT_Get_RAW_IO_OP; stdcall; external DLBT_Library name 'DLBT_Get_RAW_IO_OP';

  
end.