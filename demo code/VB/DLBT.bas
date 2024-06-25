Attribute VB_Name = "DLBT"
' =======================================================================================
'                  ����BT��DLBT������ ��������רҵ��BT�ں�DLL��
'                                   ��ʡ���Ŀ���ʱ��
'
'   Copyright:  Copyright (c) ����������޹�˾
'   ��Ȩ���У�  ����������޹�˾ (QQ:52401692   <support at dolit.cn>)
'
'               ������Ǹ�����Ϊ����ҵĿ��ʹ�ã����������ɡ���ѵ�ʹ�õ���BT�ں˿����ʾ����
'               Ҳ�ڴ��յ�������������ͽ��飬��ͬ�Ľ�����BT
'               ���������ҵʹ�ã���ô����Ҫ��ϵ���������Ʒ����ҵ��Ȩ��
'               ����BT�ں˿�������ʾ����Ĵ�����⹫�����ں˿�Ĵ���ֻ�޸����û�����ʹ�á�
'
'   �ٷ���վ��  http://www.dolit.cn      http://blog.dolit.cn
'
'   ��VBʾ����һЩע��,��������ĵ���VC���DLBT.h�е�ע��
'
' =======================================================================================


'����һ��UINT64����VB��û���������
Type UINT64
    LowLong As Long
    HighLong As Long
End Type


' ***************************  �������ں�������صĽӿ� ********************************

' �ں�����ʱ�Ļ����������Ƿ�����DHT�Լ������˿ڵȣ�
Type DLBT_KERNEL_START_PARAM
    bStartLocalDiscovery    As Long             ' 1�����ǣ�0������Ƿ������������ڵ��Զ����֣���ͨ��DHT��Tracker��ֻҪ��һ��������Ҳ���������֣��������ٶȿ죬���Լ������ȷ���ͬһ�����������ˣ�
    bStartUPnP              As Long             ' 1�����ǣ�0������Ƿ��Զ�UPnPӳ�����BT�ں�����Ķ˿�
    bStartDHT               As Long             ' 1�����ǣ�0������Ƿ�����DHT�����Ĭ�ϲ����������Ժ�����ýӿ�������
    bLanUser                As Long             ' 1�����ǣ�0������Ƿ񴿾������û�����ϣ���û������������Ӻ�����ͨѶ��������������ģʽ---��ռ����������ֻͨ���������û������أ�
    bVODMode                As Long             ' 1�����ǣ�0����������ں˵�����ģʽ�Ƿ��ϸ��VODģʽ���ϸ��VODģʽ����ʱ��һ���ļ��ķֿ����ϸ񰴱Ƚ�˳��ķ�ʽ���أ���ǰ������أ����ߴ��м�ĳ���϶���λ���������
                                                ' ��ģʽ�Ƚ��ʺϱ����ر߲���,������ģʽ���˺ܶ��Ż��������ڲ���������أ����Բ����ʺϴ����صķ�����ֻ�����ڱ����ر߲���ʱʹ�á�Ĭ������ͨģʽ����
                                                ' ��VOD���ϰ汾����Ч
    startPort               As Integer             ' �ں˼����Ķ˿ڣ����startPort��endPort��Ϊ0 ����startPort > endPort || endPort > 32765 ���ֲ����Ƿ������ں��������һ���˿ڡ� ���startPort��endPort�Ϸ�
    endPort                 As Integer             ' �ں����Զ���startPort ---- endPort֮�����һ�����õĶ˿ڡ�����˿ڿ��Դ�DLBT_GetListenPort���
End Type


' =======================================================================================
'   �ں˵������͹رպ�������ҵ��Ȩ�����˽��Э�鹦�ܣ���ʾ��ֻ���ñ�׼BT��ʽ
' =======================================================================================
Declare Function DLBT_Startup Lib "DLBT.dll" (ByRef param As DLBT_KERNEL_START_PARAM, ByVal protocol As String, ByVal bSeedServerMode As Boolean, ByVal productNum As String) As Long

' ����ں˼����Ķ˿�
Declare Function DLBT_GetListenPort Lib "DLBT.dll" () As Integer

' ���رյ���BT�ں�
Declare Function DLBT_Shutdown Lib "DLBT.dll" () As Long

' ���ڹرյ��ٶȿ��ܻ�Ƚ���(��Ҫ֪ͨTracker Stop), ���Կ��Ե��øú�����ǰ֪ͨ,��������ٶ�
' Ȼ������ڳ�������˳�ʱ����DLBT_Shutdown�ȴ������Ľ���
Declare Sub DLBT_PreShutdown Lib "DLBT.dll" ()


' =======================================================================================
'   �ں˵��ϴ������ٶȡ���������û���������
' =======================================================================================
' �ٶ����ƣ���λ���ֽ�(BYTE)�������Ҫ����1M�������� 1024*1024
Declare Sub DLBT_SetDownloadSpeedLimit Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetUploadSpeedLimit Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetMaxUploadConnection Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetMaxTotalConnection Lib "DLBT.dll" (ByVal limit As Long)

' ��෢��İ뿪���������ܶ����ӿ����Ƿ����ˣ�����û���ϣ�
Declare Sub DLBT_SetMaxHalfOpenConnection Lib "DLBT.dll" (ByVal limit As Long)

' ���������Ƿ�Ը��Լ���ͬһ�����������û����٣�limit���Ϊtrue����ʹ�ú�������е�������ֵ�������٣������ޡ�Ĭ�ϲ���ͬһ���������µ��û�Ӧ�����١�
Declare Sub DLBT_SetLocalNetworkLimit Lib "DLBT.dll" ( _
                ByVal bLimit As Boolean, _
                ByVal downSpeedLimit As Long, _
                ByVal uploadSpeedLimit As Long)

' �����ļ�ɨ��У��ʱ����Ϣ������circleCount����ѭ�����ٴ���һ����Ϣ��Ĭ����0��Ҳ���ǲ���Ϣ�� sleepMs������Ϣ��ã�Ĭ����1ms
Declare Sub DLBT_SetFileScanDelay Lib "DLBT.dll" (ByVal circleCount As Long, ByVal sleepMs As Long)

' �����ļ�������ɺ��Ƿ��޸�Ϊԭʼ�޸�ʱ�䣨��������ʱÿ���ļ����޸�ʱ��״̬�������øú�����������torrent�л������ÿ���ļ���ʱ���޸�ʱ����Ϣ
' �û�������ʱ�������������Ϣ�����ҵ����˸ú����������ÿ���ļ����ʱ���Զ����ļ����޸�ʱ������Ϊtorrent�����м�¼��ʱ��
' ���ֻ�����صĻ����������˸ú��������������ӵĻ�����û��ʹ�øú�����������û��ÿ���ļ���ʱ����Ϣ������Ҳ�޷�����ʱ���޸�
Declare Sub DLBT_UseServerModifyTime Lib "DLBT.dll" (ByVal bUseServerTime As Boolean)

' �Ƿ�����UDP��͸���书�ܣ�Ĭ�����Զ���Ӧ������Է�֧�֣���tcp�޷�����ʱ���Զ��л�ΪudpͨѶ
Declare Sub DLBT_EnableUDPTransfer Lib "DLBT.dll" (ByVal bEnabled As Boolean)

' �Ƿ�����αװHttp���䣬ĳЩ�����������������ǡ�������һЩ���磩��Http�����٣�����P2P������20K���ң��������绷���£���������Http����
'  Ĭ��������αװHttp�Ĵ�����루���Խ������ǵ�ͨѶ�������Լ���������Ӳ�����αװ�� ����ͻ�Ⱥ���������û������Կ��Ƕ����ã�����αװ��
' ������αװҲ�и����ã�������Щ����������һ������ͨ��������Http����ʹ��������������ʹ��IP����BT�����У��Է�û�кϷ������������ᱻ�������ƽ�ɱ
' ������������ƣ���������αװ���û���ٶȡ����������ʵ��ʹ��ѡ��
Declare Sub DLBT_SetP2PTransferAsHttp Lib "DLBT.dll" (ByVal bHttpOut As Boolean, ByVal bAllowedIn As Boolean)

' �Ƿ�ʹ�õ����Ĵ�͸�������������ʹ�õ�������������͸��Э������ĳ��˫���������ϵĵ�����p2p�ڵ㸨�����
Declare Function DLBT_AddHoleServer Lib "DLBT.dll" (ByVal ip As String, ByVal port As Integer) As Long

' ���÷�������IP�����Զ�ε������ö�������ڱ����ЩIP�Ƿ��������Ա�ͳ�ƴӷ��������ص������ݵ���Ϣ�������ٶȵ���һ���̶ȿ��ԶϿ����������ӣ���ʡ����������
Declare Sub DLBT_AddServerIP Lib "DLBT.dll" (ByVal ip As String)
' ��ȥ�������p2sp��url�������ظ�����. Ŀ���ǣ�����Ƿ������ϣ����p2sp��url���ڱ�������û��Ҫȥ�������url��
Declare Sub DLBT_AddBanServerUrl Lib "DLBT.dll" (ByVal url As String)

' ����һ��״̬�ļ����������ڲ�Ĭ��ȫ��������ɺ󱣴�һ�Ρ����Ե���Ϊ�Լ���Ҫ��ʱ�����������Ŀ������ÿ5���ӱ���һ�Σ���������100�����ݺ󱣴�һ��
Declare Function DLBT_SetStatusFileSavePeriod Lib "DLBT.dll" ( _
    ByVal iPeriod As Long, _
    ByVal iPieceCount As Long) As Long


'//=======================================================================================
'//  ���ñ���Tracker�ı���IP���������غ͹���ʱ�����Լ�NAT�Ĺ���IP��Ƚ���Ч����ϸ�ο�
'//  ����BT��ʹ��˵���ĵ�
'//=======================================================================================
Declare Sub DLBT_SetReportIP Lib "DLBT.dll" (ByVal reportIP As String)

Declare Function DLBT_GetReportIP Lib "DLBT.dll" () As Long
'DLBT_API void WINAPI DLBT_SetUserAgent (LPCSTR agent);

'//=======================================================================================
'//  ���ô��̻��棬3.3�汾���Ѷ��⿪�ţ�3.3�汾��ϵͳ�ڲ��Զ�����8M���棬���������ʹ�ø�
'//  �������е�������λ��K������Ҫ����1M�Ļ��棬��Ҫ����1024
'//=======================================================================================
Declare Sub DLBT_SetMaxCacheSize Lib "DLBT.dll" (ByVal size As Long)

' һЩ���ܲ������ã�Ĭ������£�����BT��Ϊ����ͨ���绷���µ��ϴ����������ã��������ǧM��������
' ���Ҵ����������ã�����50M/s����100M/s�ĵ����ļ������ٶȣ�����Ҫ������Щ�������������Լ�ڴ棬Ҳ����������Щ����
' ������������ý��飬����ѯ���������ȡ
Declare Sub DLBT_SetPerformanceFactor Lib "DLBT.dll" ( _
    ByVal socketRecvBufferSize As Long, _
    ByVal socketSendBufferSize As Long, _
    ByVal maxRecvDiskQueueSize As Long, _
    ByVal maxSendDiskQueueSize As Long)


' =======================================================================================
'   DHT��غ���,port��DHT�����Ķ˿ڣ�udp�˿ڣ������Ϊ0��ʹ���ں˼�����TCP�˿ںż���
' =======================================================================================
Declare Sub DLBT_DHT_Start Lib "DLBT.dll" (ByVal port As Integer)
Declare Sub DLBT_DHT_Stop Lib "DLBT.dll" ()
Declare Function DLBT_DHT_IsStarted Lib "DLBT.dll" () As Boolean


'' ��ʱû�з��������صĺ���
''//=======================================================================================
''//  ���ô�����غ���,��ҵ��Ȩ����д˹��ܣ���ʾ���ݲ��ṩ
''//=======================================================================================
''
''struct DLBT_PROXY_SETTING
''{
''    char    proxyHost [256];    // �����������ַ
''    int     nPort;              // ����������Ķ˿�
''    char    proxyUser [256];    // �������Ҫ��֤�Ĵ���,�����û���
''    char    proxyPass [256];    // �������Ҫ��֤�Ĵ���,��������
''
''    Enum DLBT_PROXY_TYPE
''    {
''        DLBT_PROXY_NONE,            // ��ʹ�ô���
''        DLBT_PROXY_SOCKS4,          // ʹ��SOCKS4������Ҫ�û���
''        DLBT_PROXY_SOCKS5,          // ʹ��SOCKS5���������û���������
''        DLBT_PROXY_SOCKS5A,         // ʹ����Ҫ������֤��SOCKS5������Ҫ�û���������
''        DLBT_PROXY_HTTP,            // ʹ��HTTP�����������ʣ��������ڱ�׼��HTTP���ʣ�Tracker��Http��Э�鴫�䣬�����򲻿���
''        DLBT_PROXY_HTTPA            // ʹ����Ҫ������֤��HTTP����
''    };
''
''    DLBT_PROXY_TYPE proxyType;      // ָ�����������
''};
''
''
''//=======================================================================================
''//  ��ʶ����Ӧ������Щ���ӣ�Tracker�����ء�DHT��http��Э�����صȣ�
''//=======================================================================================
''#define DLBT_PROXY_TO_TRACKER       1  // ��������Trackerʹ�ô���
''#define DLBT_PROXY_TO_DOWNLOAD      2  // ��������ʱͬ�û���Peer������ʹ�ô���
''#define DLBT_PROXY_TO_DHT           4  // ����DHTͨѶʹ�ô���DHTʹ��udpͨѶ����Ҫ������֧��udp��
''#define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  // ����HTTP����ʹ�ô�����������http��Э������ʱ��Ч��������Tracker��
''
''// �����о�ʹ�ô���
''#define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)
''
''DLBT_API void WINAPI DLBT_SetProxy (
''    DLBT_PROXY_SETTING  proxySetting,   // �������ã�����IP�˿ڵ�
''    int                 proxyTo         // ����Ӧ������Щ���ӣ���������궨��ļ������ͣ�����DLBT_PROXY_TO_ALL
''    );
''
''//=======================================================================================
''//  ��ȡ��������ã�proxyTo��ʶ������һ�����ӵĴ�����Ϣ����proxyToֻ�ܵ�����ȡĳ������
''//  �Ĵ������ã�����ʹ��DLBT_PROXY_TO_ALL���ֶ�����ѡ��
''//=======================================================================================
''DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, int proxyTo);
''
''//=======================================================================================
''//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
''//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
''//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
''//  ������Ӫ�̵ķ���
''//=======================================================================================
Public Enum DLBT_ENCRYPT_OPTION
    DLBT_ENCRYPT_NONE = 0             ' // ��֧���κμ��ܵ����ݣ��������ܵ�ͨѶ��Ͽ�
    DLBT_ENCRYPT_COMPATIBLE = 1       ' // ����ģʽ���Լ���������Ӳ�ʹ�ü��ܣ���������˵ļ������ӽ��룬�������ܵ���ͬ�Է��ü���ģʽ�Ự��
    DLBT_ENCRYPT_FULL = 2             ' // �������ܣ��Լ����������Ĭ��ʹ�ü��ܣ�ͬʱ������ͨ�ͼ��ܵ��������롣�����������ü���ģʽ�Ự�������Ǽ�����������ģʽ�Ự��Ĭ������������
    DLBT_ENCRYPT_FORCED = 3           ' // ǿ�Ƽ��ܣ���֧�ּ���ͨѶ����������ͨ���ӣ����������ܵ���Ͽ�
End Enum
''
'���ܼ���. ���ܲ㼶�ߣ������ϻ��˷�һ��CPU�������ݴ��䰲ȫ��ͻ�Ʒ�����������������
Public Enum DLBT_ENCRYPT_LEVEL
    DLBT_ENCRYPT_PROTOCOL = 0         ' // ������BT��ͨѶ����Э��  ����һ�����ڷ�ֹ��Ӫ�̵���ֹ
    DLBT_ENCRYPT_DATA = 1             ' // ���������������������ݣ����� ���ڱ�����ǿ���ļ�����
    DLBT_ENCRYPT_PROTOCOL_MIX = 2     ' // �������������ʹ�ü���Э��ģʽ��������Է�ʹ�������ݼ��ܣ�Ҳ֧��ͬ��ʹ�����ݼ���ģʽͨѶ
    DLBT_ENCRYPT_ALL = 3              ' // Э������ݾ���������
End Enum
''// �ڲ�Ĭ��ʹ�ü����Լ��ܣ���Э������ݾ����ݼ��ܣ���û���������󣬽��鲻��Ҫ����
Declare Sub DLBT_SetEncryptSetting Lib "DLBT.dll" (ByVal encryptOption As DLBT_ENCRYPT_OPTION, ByVal encryptLevel As DLBT_ENCRYPT_LEVEL)


' ***************************  �����ǵ���������صĽӿ� ********************************

' �������ص�״̬
Public Enum DLBT_DOWNLOAD_STATE
    BTDS_QUEUED = 0                    ' �����
    BTDS_CHECKING_FILES = 1            ' ���ڼ��У���ļ�
    BTDS_DOWNLOADING_TORRENT = 2       ' ������ģʽ�£����ڻ�ȡ���ӵ���Ϣ
    BTDS_DOWNLOADING = 3               ' ����������
    BTDS_PAUSED = 4                    ' ��ͣ
    BTDS_FINISHED = 5                ' ָ�����ļ��������
    BTDS_SEEDING = 6                   ' �����У������е������ļ�������ɣ�
    BTDS_ALLOCATING = 7                ' ����Ԥ������̿ռ� -- Ԥ����ռ䣬���ٴ�����Ƭ����
                                    ' ����ѡ���йأ�����ʱ���ѡ��Ԥ������̷�ʽ�����ܽ����״̬
    BTDS_ERROR = 8                  ' ����������д���̳����ԭ����ϸԭ�����ͨ������DLBT_Downloader_GetLastError��֪
End Enum

' �ļ��ķ���ģʽ,���ʹ��˵���ĵ�
Public Enum DLBT_FILE_ALLOCATE_TYPE
    FILE_ALLOCATE_REVERSED = 0    ' Ԥ����ģʽ,Ԥ�ȴ����ļ�,����ÿһ���ŵ���ȷ��λ��
    FILE_ALLOCATE_SPARSE = 1      ' Default mode, more effient and less disk space.NTFS����Ч http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
    FILE_ALLOCATE_COMPACT = 2     ' �ļ���С�������ز�������,ÿ����һ�����ݰ������������һ��,���������ǵ�����λ��,�����в��ϵ���λ��,����ļ�λ�÷���ȷ��         .
End Enum


' =======================================================================================
'   ����һ���ļ������أ�����������صľ�����Ժ�Ը�������������в�������Ҫ���ݾ��������
' =======================================================================================
                               
Declare Function DLBT_Downloader_Initialize Lib "DLBT.dll" (ByVal torrentFile As String, _
                               ByVal outPath As String, _
                               ByVal statusFile As String, _
                               ByVal fileAllocateType As DLBT_FILE_ALLOCATE_TYPE, _
                               ByVal bPaused As Boolean, _
                               ByVal bQuickSeed As Boolean, _
                               ByVal password As String, _
                               ByVal rootPathName As String, _
                               ByVal bPrivateProtocol As Boolean, _
                               ByVal bZipTransfer As Boolean) As Long
'
'// ����һ���ڴ��е������ļ����ݣ������������ļ����Ƕ����洢���߰�ĳ�����ܷ�ʽ�������ӵ���������Խ����ܺ�����ݴ���BT�ں�
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromBuffer (
'        LPBYTE              torrentFile,                    // �ڴ��е������ļ�����
'        DWORD               dwTorrentFileSize,              // �������ݵĴ�С
'        LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
'        LPCWSTR             statusFile = NULL,              // ״̬�ļ���·��
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
'        BOOL                bPaused = FALSE,
'        BOOL                bQuickSeed = FALSE,             // �Ƿ���ٹ��֣�רҵ������ģʽ����Ч������ҵ���ṩ��������Ѱ����ʾ���ݲ��ṩ��
'        LPCSTR              password = NULL,                // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
'        LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
'                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
'        BOOL                bPrivateProtocol = FALSE,        // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
'        BOOL                bZipTransfer = FALSE            // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
'        );
'
'// ��һ��Torrent�������һ������
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromTorrentHandle (
'        HANDLE              torrentHandle,                    // Torrent���
'        LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
'        LPCWSTR             statusFile = NULL,              // ״̬�ļ���·��
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
'        BOOL                bPaused = FALSE,
'        BOOL                bQuickSeed = FALSE,              // �Ƿ���ٹ��֣�רҵ������ģʽ����Ч������ҵ���ṩ��������Ѱ����ʾ���ݲ��ṩ��
'        LPCWSTR             rootPathName = NULL             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
'                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
'        BOOL                bPrivateProtocol = FALSE,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
'        BOOL                bZipTransfer = FALSE            // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
'    );
'
'//��������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
'        LPCSTR              trackerURL,                     // tracker�ĵ�ַ
'        LPCSTR              infoHash,                       // �ļ���infoHashֵ
'        LPCTSTR             outPath,
'        LPCTSTR             name = NULL,                    // �����ص�����֮ǰ����û�а취֪�����ֵģ���˿��Դ���һ����ʱ������
'        LPCWSTR             statusFile = NULL,              // ״̬�ļ���·��
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
'        BOOL bPaused = False,
'        LPCWSTR             rootPathName = NULL             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
'                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
'        BOOL                bPrivateProtocol = FALSE,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
'        BOOL                bZipTransfer = FALSE            // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
'        );
'
'// ������ģʽ����һ���ӿڣ�����ֱ��ͨ����ַ���أ���ַ��ʽΪ�� DLBT://xt=urn:btih: Base32 �������info-hash [ &dn= ���� ] [ &tr= tracker�ĵ�ַ ]  ([]Ϊ��ѡ����)
'// ��ȫ��ѭuTorrent�Ĺٷ�BT��չЭ��
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromUrl (
'    LPCSTR              url,                            // ��ַ
'    LPCTSTR             outPath,                        // ����Ŀ¼
'    LPCWSTR             statusFile = NULL,              // ״̬�ļ���·��
'    DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,
'    BOOL bPaused = False,
'        LPCWSTR             rootPathName = NULL             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
'                                                            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
'        BOOL                bPrivateProtocol = FALSE,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
'        BOOL                bZipTransfer = FALSE            // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
'    );

'// רҵ�ļ����½ӿڣ����������������ļ�Ϊ�����������������ļ�����������ļ��仯�������ݿ顣����ҵ�����ṩ
'DLBT_API HANDLE WINAPI DLBT_Downloader_InitializeAsUpdater (
'    LPCWSTR             curTorrentFile,    //��ǰ�汾�������ļ�
'    LPCWSTR             newTorrentFile,   //  �°������ļ�
'    LPCWSTR             curPath,    //  ��ǰ�ļ���·��
'    LPCWSTR             statusFile = L"", // ״̬�ļ���·��
'    DLBT_FILE_ALLOCATE_TYPE    type = FILE_ALLOCATE_SPARSE, //  �ļ����䷽ʽ������͵�ǰ�汾һ�£��°汾Ҳ��ʹ�ø÷��䷽ʽ��
'    BOOL                bPaused = FALSE,     // �Ƿ���ͣ��ʽ����
'    LPCSTR              curTorrentPassword = NULL,
'    LPCSTR              newTorrentFilePassword = NULL,
'    LPCWSTR             rootPathName = NULL,
'    BOOL                bPrivateProtocol = FALSE,
'    float       *       fProgress = NULL,        //�����ΪNULL���򴫳���DLBT_Downloader_GetOldTorrentProgressһ����һ������
'    BOOL                bZipTransfer = FALSE            // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
'   );

'// רҵ�ļ�����ʱ�������������ӣ�Ȼ��ֱ�Ӵ��������Ӻ������ӵĲ�����������ȣ������������99%������ζ��ֻ��1%��������Ҫ���ء�
'DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
'    LPCWSTR             curTorrentFile,    //��ǰ�汾�������ļ�
'    LPCWSTR             newTorrentFile,   //  �°������ļ�
'    LPCWSTR             curPath,    //  ��ǰ�ļ���·��
'    LPCWSTR             statusFile = L"", // ״̬�ļ���·��
'    LPCSTR              curTorrentPassword = NULL,
'    LPCSTR newTorrentFilePassword = Null
'    );

' // ��ȡ���������е�Http���ӣ��ڴ�������DLBT_Downloader_FreeConnections�ͷ�
' DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
' // �ͷ�DLBT_Downloader_GetHttpConnections�������ڴ�
' DLBT_API void WINAPI DLBT_Downloader_FreeConnections(LPSTR * urls, int urlCount);

'// ����һ��http�ĵ�ַ�����������ļ���ĳ��Web����������http����ʱ����ʹ�ã�web�������ı��뷽ʽ���ΪUTF-8�������������ʽ������ϵ������������޸�
Declare Sub DLBT_Downloader_AddHttpDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal url As String)

'// �Ƴ�һ��P2SP�ĵ�ַ��������������У�����жϿ����ҴӺ�ѡ���б����Ƴ������ٽ�������
Declare Sub DLBT_Downloader_RemoveHttpDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal url As String)
'// ����һ��Http��ַ�������Խ������ٸ����ӣ�Ĭ����1������. ������������ܺã������������ã���������10�������Ƕ�һ��Http��ַ�����Խ���10�����ӡ�
'// ����֮ǰ����Ѿ�һ��Http��ַ�������˶�����ӣ����ٶϿ����������ú����½�����ʱ��Ч
Declare Sub DLBT_Downloader_SetMaxSessionPerHttp Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)

'����Tracker
Declare Function DLBT_Downloader_AddTracker Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal TrackerURL As String, ByVal tier As Long) As Long
Declare Sub DLBT_Downloader_RemoveAllTracker Lib "DLBT.dll" (ByVal hDownloader As Long)
Declare Sub DLBT_Downloader_AddHttpTrackerExtraParams Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal extraParams As String)
                            
' �ر�����֮ǰ�����Ե��øú���ͣ��IO�̶߳Ը�����Ĳ������첽�ģ���Ҫ����DLBT_Downloader_IsReleasingFiles��������ȡ�Ƿ����ͷ��У���
' �ú������ú���ֱ�ӵ���_Release�����ɶԸþ���ٵ�������DLBT_Dwonloader�������������ڲ�������ͣ�����������أ�Ȼ���ͷŵ��ļ����
Declare Sub DLBT_Downloader_ReleaseAllFiles Lib "DLBT.dll" (ByVal hDownloader As Long)
' �Ƿ����ͷž���Ĺ�����
Declare Function DLBT_Downloader_IsReleasingFiles Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean


Public Enum DLBT_RELEASE_FLAG
    DLBT_RELEASE_NO_WAIT = 0            ' Ĭ�Ϸ�ʽRelease��ֱ���ͷţ����ȴ��ͷ����
    DLBT_RELEASE_WAIT = 1               ' �ȴ������ļ����ͷ����
    DLBT_RELEASE_DELETE_STATUS = 2      ' ɾ��״̬�ļ�
    DLBT_RELEASE_DELETE_ALL = 4         ' ɾ�������ļ�
End Enum

' �ر�hDownloader����ǵ���������,�����Ҫɾ���ļ�,���Խ���2��������ΪTrue
Declare Function DLBT_Downloader_Release Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal nFlag As DLBT_RELEASE_FLAG) As Long


' ���õ����������󻺴棬������ҵ��Ȩ�����иù���
Declare Sub DLBT_Downloader_SetDiskCacheSize Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal size As Long)

' �������������Ƿ�˳������,Ĭ���Ƿ�˳������(���������,һ����ѭϡ��������,���ַ�ʽ�ٶȿ�),��˳�����������ڱ��±߲���
Declare Sub DLBT_Downloader_SetDownloadSequence Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal ifSeq As Boolean)

' ���ص�״̬ �Լ� ��ͣ�ͼ����Ľӿ�
Declare Function DLBT_Downloader_GetState Lib "DLBT.dll" (ByVal hDownloader As Long) As DLBT_DOWNLOAD_STATE '��ȡ���������״̬
Declare Function DLBT_Downloader_IsPaused Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean   '�ж��Ƿ���ͣ״̬
Declare Sub DLBT_Downloader_Pause Lib "DLBT.dll" (ByVal hDownloader As Long)       '��ͣ
Declare Sub DLBT_Downloader_Resume Lib "DLBT.dll" (ByVal hDownloader As Long)       '����

' ����״̬�µ������ӿ� ��һ��ֻ���ڼ�������������ļ��޷�д��ʱ�Ż��������������ˣ�
Declare Function DLBT_Downloader_GetLastError Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal pBuffer As String, ByRef pBufferSize As Long) As Long ' ��������״̬ΪBTDS_ERROR��ͨ���ýӿڻ�ȡ��ϸ������Ϣ
Declare Sub DLBT_Downloader_ResumeInError Lib "DLBT.dll" (ByVal hDownloader As Long)   ' ���������󣬳������¿�ʼ����

' ���������ص���ؽӿڣ�������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
Declare Function DLBT_Downloader_IsHaveTorrentInfo Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean ' ����������ʱ�������ж��Ƿ�ɹ���ȡ����������Ϣ
Declare Function DLBT_Downloader_MakeURL Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                         ByVal pBuffer As String, _
                                                         ByRef pBufferSize As Long) As Long


' ���ص����ٺ��������ӵĽӿ�
Declare Sub DLBT_Downloader_SetDownloadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetUploadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetMaxUploadConnections Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetMaxTotalConnections Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)

' ȷ������ֻ�ϴ���������
Declare Sub DLBT_Downloader_SetOnlyUpload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal bUpload As Boolean)

' ���öԷ�����IP�����������٣���λ��BYTE(�ֽڣ��������Ҫ����1M��������1024*1024
Declare Sub DLBT_Downloader_SetServerDownloadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
' ���ñ�������ȥ�����еķ�����IP�������ӣ����ڶԷ������������ӣ���ҪBTЭ������ͨ����֪���Ƕ�Ӧ�������������hDownloader�ĺ���ٶϿ�����
Declare Sub DLBT_Downloader_BanServerDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Boolean)

' ���ط����� (�ϴ�/���صı������Ľӿ�
Declare Sub DLBT_Downloader_SetShareRateLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal fRate As Single)
Declare Function DLBT_Downloader_GetShareRate Lib "DLBT.dll" (ByVal hDownloader As Long) As Double


' �������ص��ļ������ԣ��ļ���С������������ȵȣ�
Declare Function DLBT_Downloader_GetTorrentName Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                                ByVal pBuffer As String, _
                                                                ByRef pBufferSize As Long) As Long
                                                                
Declare Function DLBT_Downloader_GetTotalFileSize Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetTotalWanted Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64      ' ����ѡ���˶������������������������ص��ļ�
Declare Function DLBT_Downloader_GetTotalWantedDone Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64   ' ��ѡ�����ļ��У������˶���
Declare Function DLBT_Downloader_GetProgress Lib "DLBT.dll" (ByVal hDownloader As Long) As Single

Declare Function DLBT_Downloader_GetDownloadedBytes Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetUploadedBytes Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetDownloadSpeed Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetUploadSpeed Lib "DLBT.dll" (ByVal hDownloader As Long) As Long

' ��ø�����Ľڵ����Ŀ����Ŀ�Ĳ���Ϊint��ָ�룬�������Ҫĳ��ֵ����NULL
Declare Sub DLBT_Downloader_GetPeerNums Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                    ByRef connectedCount As Long, _
                                                    ByRef totalSeedCount As Long, _
                                                    ByRef seedsConnected As Long, _
                                                    ByRef inCompleteCount As Long, _
                                                    ByRef totalCurrentSeedCount As Long, _
                                                    ByRef totalCurrentPeerCount As Long)


' ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
Declare Function DLBT_Downloader_GetFileCount Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetFileSize Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As UINT64
Declare Function DLBT_Downloader_GetFileOffset Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As UINT64
Declare Function DLBT_Downloader_IsPadFile Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As Boolean
' ��ȡָ����ŵ��ļ�����
Declare Function DLBT_Downloader_GetFilePathName Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                                ByVal Index As Long, _
                                                                ByVal pBuffer As Long, _
                                                                ByRef pBufferSize As Long, _
                                                                ByVal needFullPath As Boolean) As Long
                                                                
' �ú����Ὣ����Ŀ¼�´��ڣ���torrent��¼�в����ڵ��ļ�ȫ��ɾ�����Ե����ļ���������Ч��������ʹ�á�
Declare Function DLBT_Downloader_DeleteUnRelatedFiles Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
                                                                
                                                                
' ��ȡÿ���ļ���Hashֵ��ֻ����������ʱʹ��bUpdateExt���ܻ�ȡ��
Declare Function DLBT_Downloader_GetFileHash Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                             ByVal Index As Long, _
                                                             ByVal pBuffer As String, _
                                                             ByRef pBufferSize As Long) As Long

                                                                
' // ȡ�ļ������ؽ��ȣ��ò�����Ҫ���н϶������������ڱ�Ҫʱʹ��
Declare Function DLBT_Downloader_GetFileProgress Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As Single

Public Enum DLBT_FILE_PRIORITIZE
    DLBT_FILE_PRIORITY_CANCEL = 0               ' ȡ�����ļ�������
    DLBT_FILE_PRIORITY_NORMAL = 1               ' �������ȼ�
    DLBT_FILE_PRIORITY_ABOVE_NORMAL = 2         ' �����ȼ�
    DLBT_FILE_PRIORITY_MAX = 3                  ' ������ȼ�������и����ȼ����ļ���δ���꣬�������ص����ȼ����ļ���
End Enum

' �����ļ����������ȼ��������������ȡ��ĳ��ָ���ļ�������,index��ʾ�ļ������
Declare Function DLBT_Downloader_SetFilePrioritize Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                            ByVal Index As Long, _
                                                            ByVal prioritize As DLBT_FILE_PRIORITIZE, _
                                                            ByVal bDoPriority As Boolean) As Long

' ����Ӧ�����ȼ�������
Declare Sub DLBT_Downloader_ApplyPrioritize Lib "DLBT.dll" (ByVal hDownloader As Long)

' ��ȡ��ǰÿ���ֿ��״̬��������������ж��Ƿ���Ҫȥ���£��Ƿ��Ѿ�ӵ���˸ÿ飩��
Declare Function DLBT_Downloader_GetPiecesStatus Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByRef pieceArray As Byte, _
                                                ByVal arrayLength As Long, _
                                                ByRef pieceDownloaded As Long) As Long

' ����Piece���ֿ飩���������ȼ��������������ȡ��ĳЩ�ֿ�����أ���ָ��λ�ÿ�ʼ���صȡ�index��ʾ�ֿ�����
Declare Function DLBT_Downloader_SetPiecePrioritize Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByVal Index As Long, _
                                                ByVal prioritize As DLBT_FILE_PRIORITIZE, _
                                                ByVal bDoPriority As Boolean) As Long

' �����ֹ�ָ����Peer��Ϣ
Declare Sub DLBT_Downloader_AddPeerSource Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal ip As String, ByVal port As Integer)


' ��ÿ���ʾ���ļ�Hashֵ
Declare Function DLBT_Downloader_GetInfoHash Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long

Declare Function DLBT_Downloader_GetPieceCount Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetPieceSize Lib "DLBT.dll" (ByVal hDownloader As Long) As Long

' ��������һ��״̬�ļ���֪ͨ�ڲ��������̺߳��������أ����첽���������ܻ���һ���ӳٲŻ�д
Declare Sub DLBT_Downloader_SaveStatusFile Lib "DLBT.dll" (ByVal hDownloader As Long)

' bOnlyPieceStatus�� �Ƿ�ֻ����һЩ�ļ��ֿ���Ϣ�����ڷ����������ɺ󷢸�ÿ���ͻ������ͻ����Ͳ����ٱȽ��ˣ�ֱ�ӿ�������. Ĭ����FALSE��Ҳ����ȫ����Ϣ������
Declare Sub DLBT_Downloader_SetStatusFileMode Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal bOnlyPieceStatus As Boolean)

' �鿴����״̬�ļ��Ƿ����
Declare Function DLBT_Downloader_IsSavingStatus Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean

' // ��BTϵͳ��д��ͨ��������ʽ�����������ݿ顣offsetΪ�����ݿ��������ļ����ļ��У��е�ƫ������sizeΪ���ݿ��С��dataΪ���ݻ�����
' // �ɹ�����S_OK��ʧ��Ϊ������ʧ��ԭ������Ǹÿ鲻��Ҫ�ٴδ����ˡ� ��������VOD��ǿ������Ч
' DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);

' // �ֹ����һ�����������ݽ��� ��������VOD��ǿ������Ч
' DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
'     HANDLE                  hDownloader,
'     int                     piece,          //�ֿ����
'     char            *       data,           //���ݱ���
'     bool                    bOverWrite      //����Ѿ����ˣ��Ƿ񸲸�
'     );


' // ÿ��Ҫ�滻һ�����ݿ�ʱ����һ������ص����ⲿ���Ը�������ص���ʾ�滻�Ľ��ȣ��Լ��Ƿ���ֹ�����滻�����������൱�ڣ�DLBT_Downloader_CancelReplace)
' // ����FALSE����ϣ��������ֹ��TRUE���������
' // һ���ֿ���ܻ�������С�ļ������ߴ��ļ���β�������ļ�ճ���ĵط��������һ���ֿ�pieceIndex���ܻ��Ӧ�˶���ļ�Ƭ�Ρ����ص����滻һ���ļ�Ƭ��ʱ����һ��
' typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
'       IN void * pContext,                   // �ص��������ģ�ͨ��DLBT_Downloader_ReplacePieceData��pContext�������룩�����ﴫ��ȥ���������洦��
'                                             // ���磬�ⲿ����һ��thisָ�룬�ص���ʱ����ͨ�����ָ��֪���Ƕ�Ӧ�ĸ�����
'       IN int pieceIndex,                    //����Ҫ�滻������λ���ĸ��ֿ飨�ֿ���torrent�е�������
'       IN int replacedPieceCount,            //�Ѿ�����˶��ٸ�piece���滻
'       IN int totalNeedReplacePieceCount,    //�ܹ��ж��ٸ�Ҫ�滻��piece�ֿ�
'       IN int fileIndex,                     //����Ҫ�滻������λ���ĸ��ļ�
'       IN UINT64 offset,                     //������ļ��У�������ݵ�ƫ����
'       IN UINT64 size,                       //������ݵ��ܴ�С������ƫ������
'       IN int replacedFileSliceCount,        //�Ѿ�����˶��ٸ��ļ�Ƭ�ε��滻
'       IN int totalFileSliceCount            //�ܹ��ж��ٸ���Ҫ�滻���ļ�Ƭ��
'       );

' // �滻���ݿ�Ľӿڣ���ĳ������ֱ���滻��Ŀ���ļ�����ͬλ�ã�һ�����ڣ�����ʱ����Ҫ���صķֿ��Զ����ص�һ����ʱĿ¼����ɺ����滻��ԭʼ�ļ�
' // �������ع�����ԭʼ�ļ���������ʹ�ã���������ֻ���ز������ݵ��ŵ㡣
' // �ú������������أ����HRESULT���صĲ���S_OK��˵��������Ҫ�鿴����ֵ��
' // �������S_OK�����ڲ��������߳��������滻���м�Ľ����ʱͨ��DLBT_Downloader_GetReplaceResult�����в鿴�������ʱ���Ե��ã�DLBT_Downloader_CancelReplace����ȡ���̲߳���
' DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
'     HANDLE          hDownloader,        //����������
'     int   *         pieceArray,         // ��Ҫ����Щ�ֿ��滻����һ��int����
'     int             arrayLength,        // �ֿ�����ĳ���
'     LPCSTR          destFilePath,       // ��Ҫ�滻���ļ����ļ��У���Ŀ¼�����磺E:\Test\1.rar����E:\Test\Game\�����˲� �ȡ�
'     LPCSTR          tempRootPathName = NULL,    // ��ʱĿ¼����ʱ�����ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У��¶�ȡ���ݿ�
'     LPCSTR          destRootPathName = NULL,    // ��Ҫ�滻���Ǹ������������ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У������滻
'     LPVOID          pContext = NULL,
'     DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  //���ս��ȣ���������ʱȡ���Ļص�
'     );

' // ReplacePieceData��һЩ״̬������ͨ��DLBT_Downloader_GetReplaceResult�����в鿴
' Enum DLBT_REPLACE_RESULT
' {
'     DLBT_RPL_IDLE  = 0,     //��δ��ʼ�滻
'     DLBT_RPL_RUNNING,       //����������
'     DLBT_RPL_SUCCESS,       //�滻�ɹ�
'     DLBT_RPL_USER_CANCELED, //�滻��һ�룬�û�ȡ������
'     DLBT_RPL_ERROR,         //��������ͨ��hrDetail����ȡ��ϸ��Ϣ���ο���DLBT_Downloader_GetReplaceResult
' };

' // ��ȡ�滻���ݵĽ��
' DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
'     HANDLE          hDownloader,        //����������
'     HRESULT  *      hrDetail,           //������г���������ϸ�ĳ���ԭ��
'     BOOL     *      bThreadRunning      //Replace�����������Ƿ�����ˣ�����Ҳ�����������ģ�
'     );

' // �м���ʱȡ���滻���ݵĲ�����������ȡ������Ϊ�п��ܻ��滻��һ�룬������Щ�ļ��ǲ������ģ�
' DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);

    
    
' ***************************  ������������صĽӿ� ********************************

Public Enum DLBT_TORRENT_TYPE
    USE_PUBLIC_DHT_NODE = 0
    NO_USE_PUBLIC_DHT_NODE = 1
    ONLY_USE_TRACKER = 2
End Enum

' ����һ��Torrent�ľ���������ڴ������ӵľ��
Declare Function DLBT_CreateTorrent Lib "DLBT.dll" (ByVal pieceSize As Long, _
                                                ByVal file As String, _
                                                ByVal publisher As String, _
                                                ByVal publisherUrl As String, _
                                                ByVal comment As String, _
                                                ByVal TorrentType As DLBT_TORRENT_TYPE, _
                                                ByRef nPercent As Long, _
                                                ByRef bCancel As Boolean, _
                                                ByVal minPadFileSize As Long, _
                                                ByVal bUpdateExt As Boolean) As Long
                               
                        
' ָ�����Ӱ�����Tracker
Declare Function DLBT_Torrent_AddTracker Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal TrackerURL As String, _
                                                ByVal tier As Long) As Long
' �Ƴ������е�����Tracker
Declare Sub DLBT_Torrent_RemoveAllTracker Lib "DLBT.dll" (ByVal hTorrent As Long)

' ָ�����ӿ���ʹ�õ�httpԴ��������صĿͻ���֧��http��Э�����أ�����Զ��Ӹõ�ַ��������
Declare Sub DLBT_Torrent_AddHttpUrl Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal httpUrl As String)

' ����Ϊtorrent�ļ�,filePathΪ·���������ļ�����, ���password��Ϊ�գ��������Ҫ�����ӽ��м���
Declare Function DLBT_SaveTorrentFile Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal filePath As String, ByVal password As String, ByVal bUseHashName As Long, ByVal exeName As String) As Long
    
' �ͷ�torrent�ļ��ľ��
Declare Sub DLBT_ReleaseTorrent Lib "DLBT.dll" (ByVal hTorrent As Long)



' ��һ�����Ӿ���������޸Ļ��߶�ȡ��Ϣ���в������������Ҫ����DLBT_ReleaseTorrent�ͷ�torrent�ļ��ľ��
' password ����Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬�Դ�������н���
Declare Function DLBT_OpenTorrent Lib "DLBT.dll" (ByVal torrentFile As String, _
                                                  ByVal password As String) As Long

Declare Function DLBT_OpenTorrentFromBuffer Lib "DLBT.dll" (ByVal torrentFile As Byte, _
                                                ByVal dwTorrentFileSize As Long, _
                                                ByVal password As String) As Long
Declare Function DLBT_Torrent_GetComment Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long
' ���ش����������Ϣ
Declare Function DLBT_Torrent_GetCreator Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long
' ���ط�������Ϣ
Declare Function DLBT_Torrent_GetPublisher Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long

' ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
Declare Function DLBT_Torrent_MakeURL Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                      ByVal pBuffer As String, _
                                                      ByRef pBufferSize As Long) As Long
    
Declare Function DLBT_Torrent_GetTrackerCount Lib "DLBT.dll" (ByVal hTorrent As Long) As Long

Declare Function DLBT_Torrent_GetTrackerUrl Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As String

'ȡ�������ļ��ڵ��ܼ��ļ���С
Declare Function DLBT_Torrent_GetTotalFileSize Lib "DLBT.dll" (ByVal hTorrent As Long) As UINT64

' ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
Declare Function DLBT_Torrent_GetPieceCount Lib "DLBT.dll" (ByVal hTorrent As Long) As Long

Declare Function DLBT_Torrent_IsPadFile Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As Boolean
Declare Function DLBT_Torrent_GetFileSize Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As UINT64
'ͨ�����Ӿ��,����ָ����ŵ��ļ���
Declare Function DLBT_Torrent_GetFilePathName Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long, ByVal pBuffer As Long, ByRef pBufferSize As Long) As Long


' ��ʱû�з������¼�������
'//////////////////////   Move����ؽӿ�   /////////////
'// Move�Ľ��
'Enum DOWNLOADER_MOVE_RESULT
'{
'    DLBT_MOVED  = 0,    //�ƶ��ɹ�
'    DLBT_MOVE_FAILED,   //�ƶ�ʧ��
'    DLBT_MOVING         //�����ƶ�
'};
'
'//�ƶ����ĸ�Ŀ¼�������ͬһ���̷������Ǽ��У�����ǲ�ͬ�������Ǹ��ƺ�ɾ��ԭʼ�ļ������ڲ������첽������������������
'//���ʹ��DLBT_Downloader_GetMoveResultȥ��ȡ
'DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCSTR savePath);
'//�鿴�ƶ������Ľ��
'DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
'    HANDLE          hDownloader,   // ��������ľ��
'    LPSTR           errorMsg,      // ���ڷ��س�����Ϣ���ڴ棬��DLBT_MOVE_FAILED״̬�����ﷵ�س�������顣�������NULL���򲻷��ش�����Ϣ
'    int             msgSize        // ������Ϣ�ڴ�Ĵ�С
'    );
   

' ��ʱû�з������¼�������
'// **************************** �����������г��йصĽӿ� *****************************
'// �����г�������ҵ�汾���ṩ��������ð�����ʱ���ṩ�ù���
'struct DLBT_TM_ITEM   //��������г��е�һ�������ļ�
'{
'    DLBT_TM_ITEM(): fileSize (0) {}
'
'    UINT64  fileSize;      // the size of this file
'    char    name[256];     // ����
'    LPCSTR  url;           // �������ص�url
'    LPCSTR  comment;       // ��������
'};
'
'struct DLBT_TM_LIST       //��������г��е�һ�������ļ��������
'{
'    int             count;      //��Ŀ
'    DLBT_TM_ITEM    items[1];   //�����б�
'};
'
'// �ڱ����������г������һ�������ļ�
'DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCSTR torrentFile, LPCSTR password = NULL);
'// �ڱ����������г����Ƴ�һ�������ļ�
'DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCSTR torrentFile, LPCSTR password = NULL);

'// ��ȡ���������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
'DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
'// ��ȡ�����������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
'DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);

'// �ͷ�DLBT_TM_GetSelfTorrentList����DLBT_TM_GetRemoteTorrentList��ȡ���������б���ڴ�
'DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);
'
'// ������л�ȡ���������˵������б�
'DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList ();
'// ��������Լ������г��е������б�
'DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList ();
'
'// ����һ���Ƿ����������г���Ĭ�ϲ����á�
'DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);

' *********************  �����Ƿ���ǽ��UPnP��͸��P2P�����Խӿ� **********************

' �˿ڵ�����
Public Enum PORT_TYPE
    TCP_PORT = 1                    ' TCP �˿�
    UDP_PORT = 2                    ' UDP �˿�
End Enum

'  ��ĳ��Ӧ�ó�����ӵ�ICF����ǽ��������ȥ���ɶ������ں�Ӧ�ã��������ں���Ȼ����ʹ�øú���
Declare Function DLBT_AddAppToWindowsXPFirewall Lib "DLBT.dll" (ByVal appFilePath As String, ByVal ruleName As String) As Boolean
'  ��ĳ���˿ڼ���UPnPӳ�䣬����BT�ڲ������ж˿��Ѿ��Զ����룬����Ҫ�ٴμ��룬�����ṩ�����ǹ��ⲿ��������Լ�����˿�
Declare Function DLBT_AddUPnPPortMapping Lib "DLBT.dll" (ByVal nExternPort As Integer, _
                          ByVal nLocalPort As Integer, _
                          ByVal nPortType As PORT_TYPE, _
                          ByVal appName As String) As Boolean
                          
' ��õ���ϵͳ�Ĳ������������ƣ��������0���ʾϵͳ���ܲ������޵�XPϵͳ�������޸�����������
' �ɶ������ں�ʹ�ã������ں�ǰ����ʹ��
Declare Function DLBT_GetCurrentXPLimit Lib "DLBT.dll" () As Long

' �޸�XP�Ĳ������������ƣ�����BOOL��־�Ƿ�ɹ�
Declare Function DLBT_ChangeXPConnectionLimit Lib "DLBT.dll" (ByVal num As Long) As Boolean


' ***************************  ������������ȡ��Ϣ�Ľӿ� ********************************

' �ں˵Ļ�����Ϣ
Type KERNEL_INFO
    port                            As Long             ' �����˿�
    dhtStarted                      As Long             ' DHT�Ƿ�����
    totalDownloadConnectionCount    As Long             ' �ܵ�����������
    downloadCount                   As Long             ' ��������ĸ���
    totalDownloadSpeed              As Long             ' �������ٶ�
    totalUploadSpeed                As Long             ' ���ϴ��ٶ�
    totalDownloadedByteCount        As UINT64           ' �����ص��ֽ���
    totalUploadedByteCount          As UINT64           ' ���ϴ����ֽ���
'
    peersNum                        As Long             ' ��ǰ�����ϵĽڵ�����
    dhtConnectedNodeNum             As Long             ' dht�����ϵĻ�Ծ�ڵ���
    dhtCachedNodeNum                As Long             ' dht��֪�Ľڵ���
    dhtTorrentNum                   As Long             ' dht����֪��torrent�ļ���
End Type

' ������������Ļ�����Ϣ
Type DOWNLOADER_INFO
    state                       As DLBT_DOWNLOAD_STATE          ' ���ص�״̬
    percentDone                 As Single                       ' �Ѿ����ص����ݣ��������torrent�����ݵĴ�С �����ֻѡ����һ�����ļ����أ���ô�ý��Ȳ��ᵽ100%��
    downConnectionCount         As Long                         ' ���ؽ�����������
    downloadLimit               As Long                         ' ���������������
    connectionCount             As Long                         ' �ܽ������������������ϴ���
    totalCompletedSeeds         As Long                         ' Tracker������������������ɵ����������Tracker��֧��scrap���򷵻�-1
    inCompleteNum               As Long                         ' �ܵ�δ��ɵ����������Tracker��֧��scrap���򷵻�-1
    seedConnected               As Long                         ' ���ϵ�������ɵ�����
    totalCurrentSeedCount       As Long                         ' ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
    totalCurrentPeerCount       As Long                         ' ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
    currentTaskProgress         As Single                       ' ��ǰ����Ľ���(100%�������)
    bReleasingFiles             As Long                         ' �Ƿ������ͷ��ļ������һ��������ɺ���Ȼ��������ˣ����ļ�����ͻ����ڲ���������Ҫһ��ʱ�����ͷš�����0�������ͷţ�0�����ͷ����
    
    downloadSpeed               As Long                         ' ���ص��ٶ�
    uploadSpeed                 As Long                         ' �ϴ����ٶ�
    serverPayloadSpeed          As Long                         ' �ӷ��������ص�����Ч�ٶȣ�������������Ϣ�ȷ������Դ��䣩
    serverTotalSpeed            As Long                         ' �ӷ��������ص����ٶ�(����������Ϣ������ͨѶ�����ģ�
    
    wastedByteCount             As UINT64                       ' �����ݵ��ֽ�����������Ϣ�ȣ�
    totalDownloadedBytes        As UINT64                       ' ���ص����ݵ��ֽ���
    totalUploadedBytes          As UINT64                       ' �ϴ������ݵ��ֽ���
    totalWantedBytes            As UINT64                       ' ѡ��������ݴ�С
    totalWantedDoneBytes        As UINT64                       ' ѡ����������У���������ɵ����ݴ�С
     
    totalServerPayloadBytes     As UINT64                       ' �ӷ��������ص��������������������������ļ����ݣ�Ҳ����������յ���������ݣ���ʹ���������� -- ����һ����������û���⣬���ᶪ�����ݵģ�
    totalServerBytes            As UINT64                       ' �ӷ��������ص��������ݵ�����������totalServerPayloadBytes���Լ��������ݡ��շ���Ϣ�ȣ�
    totalPayloadBytesDown       As UINT64                       ' �����������ܵ����ص����ݿ����͵��������������˷����������ݣ��Լ����ܶ��������ݣ�
    totalBytesDown              As UINT64                       ' �����������ܵ��������ݵ������������������˷������Լ����пͻ������ݡ�����ͨѶ�������ȣ�


    ' Torrent��Ϣ
    bHaveTorrent                As Long                         ' ��������������ģʽ���ж��Ƿ��Ѿ���ȡ����torrent�ļ�������0�����Ѿ���ȡ���ˣ�0����δ��ȡ��
    totalFileSize               As UINT64                       ' �ļ����ܴ�С
    totalFileSizeExcludePadding As UINT64                       ' ʵ���ļ��Ĵ�С������padding�ļ��������������padding�ļ������totalFileSize���
    totalPaddingSize            As UINT64                       ' ����padding���ݵĴ�С�������������ʱû����padding�ļ�����Ϊ0
    pieceCount                  As Long                         ' �ֿ���
    pieceSize                   As Long                         ' ÿ����Ĵ�С
       
    infoHash(256)               As Byte                         ' �ļ���Hashֵ
End Type

''// ÿ�������ϵĽڵ㣨�û�������Ϣ
Type PEER_INFO_ENTRY
    connectionType              As Long                         '�������� 0����׼BT(tcp); 1: P2SP��http�� 2: udp��������ֱ�����ӻ��ߴ�͸��
    downloadSpeed               As Long                         '�����ٶ�
    uploadSpeed                 As Long                         '�ϴ��ٶ�
    downloadedBytes             As UINT64                       '���ص��ֽ���
    uploadedBytes               As UINT64                       '�ϴ����ֽ���
    
    uploadLimit                 As Long                         ' �����ӵ��ϴ����٣���������Է�������IP�����ˣ�����ط����Կ������IP���������
    downloadLimit               As Long                         ' �����ӵ��������٣���������Է�������IP�����ˣ�����ط����Կ������IP���������

    ip(63)                      As Byte                         '�Է�IP
    client(63)                  As Byte                         '�Է�ʹ�õĿͻ���
End Type
    
''
''// ���������ϵĽڵ㣨�û�������Ϣ
''struct PEER_INFO
''{
''    int                         count;                          // �ܵĽڵ㣨�û�����
''    PEER_INFO_ENTRY             entries [1];                    // �ڵ���Ϣ������
''};
''
''
' ��ȡ������Ϣ�Ľӿ�
Declare Function DLBT_GetKernelInfo Lib "DLBT.dll" (ByRef info As KERNEL_INFO) As Long
Declare Function DLBT_GetDownloaderInfo Lib "DLBT.dll" (ByVal hDownloader As Long, ByRef info As DOWNLOADER_INFO) As Long

''// �����ɽڵ��б��б���DLL���䣬��ˣ���Ҫ����DLBT_FreeDownloaderPeerInfoList�����ͷŸ��ڴ�
Declare Function DLBT_GetDownloaderPeerInfoList Lib "DLBT.dll" (ByVal hDownloader As Long, ByRef ppInfo As Long) As Long
Declare Function DLBT_FreeDownloaderPeerInfoList Lib "DLBT.dll" (ByVal ppInfo As Long) As Long

Declare Sub DLBT_SetDHTFilePathName Lib "DLBT.dll" (ByVal dhtFile As String)

'// �����Զ���IO�����ĺ��������Խ�BT����Ķ�д�ļ������в����ⲿ���д����滻�ڲ��Ķ�д�����ȣ�
'// �ù���Ϊ�߼��湦�ܣ�����ϵ������ȡ����֧�֣�Ĭ�ϰ汾�в����Ÿù���

'// ����IO�����Ľӹܽṹ���ָ��
Declare Sub DLBT_Set_IO_OP Lib "DLBT.dll" (ByVal op As Long)
'// �Խṹ����������к����ȸ�ֵĬ�ϵĺ���ָ��
Declare Sub DLBT_InitDefault_IO_OP Lib "DLBT.dll" (ByVal op As Long)
'// ��ȡϵͳ�ڲ�Ŀǰ���õ�IO�����ָ��
Declare Function DLBT_Get_IO_OP Lib "DLBT.dll" () As Long

'// ��ȡϵͳԭʼIO��ָ��
Declare Function LBT_Get_RAW_IO_OP Lib "DLBT.dll" () As Long

' ��������
Public Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As String, ByVal lpString2 As Long) As Long


' ��������, ��UINT64����ת��ΪDouble���ͣ��Է���ʹ��
Public Function UINT64ToDouble(ByRef uInt As UINT64) As Double
    Dim ret As Double
    ret = IIf(uInt.HighLong < 0, 4294967296# + uInt.HighLong, uInt.HighLong)
    ret = ret * 4294967296#
    ret = ret + IIf(uInt.LowLong < 0, 4294967296# + uInt.LowLong, uInt.LowLong)
    UINT64ToDouble = ret
End Function


