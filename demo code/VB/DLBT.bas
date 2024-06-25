Attribute VB_Name = "DLBT"
' =======================================================================================
'                  点量BT（DLBT）－－ 致力于最专业的BT内核DLL库
'                                   节省您的开发时间
'
'   Copyright:  Copyright (c) 点量软件有限公司
'   版权所有：  点量软件有限公司 (QQ:52401692   <support at dolit.cn>)
'
'               如果您是个人作为非商业目的使用，您可以自由、免费的使用点量BT内核库和演示程序，
'               也期待收到您反馈的意见和建议，共同改进点量BT
'               如果您是商业使用，那么您需要联系作者申请产品的商业授权。
'               点量BT内核库所有演示程序的代码对外公开，内核库的代码只限付费用户个人使用。
'
'   官方网站：  http://www.dolit.cn      http://blog.dolit.cn
'
'   本VB示例的一些注释,建议对照文档和VC版的DLBT.h中的注释
'
' =======================================================================================


'声明一下UINT64，在VB中没有这个类型
Type UINT64
    LowLong As Long
    HighLong As Long
End Type


' ***************************  以下是内核整体相关的接口 ********************************

' 内核启动时的基本参数（是否启动DHT以及启动端口等）
Type DLBT_KERNEL_START_PARAM
    bStartLocalDiscovery    As Long             ' 1代表是，0代表否。是否启动局域网内的自动发现（不通过DHT、Tracker，只要在一个局域网也能立即发现，局域网速度快，可以加速优先发现同一个局域网的人）
    bStartUPnP              As Long             ' 1代表是，0代表否。是否自动UPnP映射点量BT内核所需的端口
    bStartDHT               As Long             ' 1代表是，0代表否。是否启动DHT，如果默认不启动，可以后面调用接口来启动
    bLanUser                As Long             ' 1代表是，0代表否。是否纯局域网用户（不希望用户进行外网连接和外网通讯，纯局域网下载模式---不占用外网带宽，只通过内网的用户间下载）
    bVODMode                As Long             ' 1代表是，0代表否。设置内核的下载模式是否严格的VOD模式，严格的VOD模式下载时，一个文件的分块是严格按比较顺序的方式下载，从前向后下载；或者从中间某处拖动的位置向后下载
                                                ' 该模式比较适合边下载边播放,针对这个模式做了很多优化。但由于不是随机下载，所以不大适合纯下载的方案，只建议在边下载边播放时使用。默认是普通模式下载
                                                ' 仅VOD以上版本中有效
    startPort               As Integer             ' 内核监听的端口，如果startPort和endPort均为0 或者startPort > endPort || endPort > 32765 这种参数非法，则内核随机监听一个端口。 如果startPort和endPort合法
    endPort                 As Integer             ' 内核则自动从startPort ---- endPort之间监听一个可用的端口。这个端口可以从DLBT_GetListenPort获得
End Type


' =======================================================================================
'   内核的启动和关闭函数，商业授权版才有私有协议功能，演示版只能用标准BT方式
' =======================================================================================
Declare Function DLBT_Startup Lib "DLBT.dll" (ByRef param As DLBT_KERNEL_START_PARAM, ByVal protocol As String, ByVal bSeedServerMode As Boolean, ByVal productNum As String) As Long

' 获得内核监听的端口
Declare Function DLBT_GetListenPort Lib "DLBT.dll" () As Integer

' 最后关闭点量BT内核
Declare Function DLBT_Shutdown Lib "DLBT.dll" () As Long

' 由于关闭的速度可能会比较慢(需要通知Tracker Stop), 所以可以调用该函数提前通知,提高下线速度
' 然后最后在程序最后退出时调用DLBT_Shutdown等待真正的结束
Declare Sub DLBT_PreShutdown Lib "DLBT.dll" ()


' =======================================================================================
'   内核的上传下载速度、最大连接用户数的设置
' =======================================================================================
' 速度限制，单位是字节(BYTE)，如果需要限速1M，请输入 1024*1024
Declare Sub DLBT_SetDownloadSpeedLimit Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetUploadSpeedLimit Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetMaxUploadConnection Lib "DLBT.dll" (ByVal limit As Long)
Declare Sub DLBT_SetMaxTotalConnection Lib "DLBT.dll" (ByVal limit As Long)

' 最多发起的半开连接数（很多连接可能是发起了，但还没连上）
Declare Sub DLBT_SetMaxHalfOpenConnection Lib "DLBT.dll" (ByVal limit As Long)

' 用于设置是否对跟自己在同一个局域网的用户限速，limit如果为true，则使用后面参数中的限速数值进行限速，否则不限。默认不对同一个局域网下的用户应用限速。
Declare Sub DLBT_SetLocalNetworkLimit Lib "DLBT.dll" ( _
                ByVal bLimit As Boolean, _
                ByVal downSpeedLimit As Long, _
                ByVal uploadSpeedLimit As Long)

' 设置文件扫描校验时的休息参数，circleCount代表循环多少次做一次休息。默认是0（也就是不休息） sleepMs代表休息多久，默认是1ms
Declare Sub DLBT_SetFileScanDelay Lib "DLBT.dll" (ByVal circleCount As Long, ByVal sleepMs As Long)

' 设置文件下载完成后，是否修改为原始修改时间（制作种子时每个文件的修改时间状态）。调用该函数后，制作的torrent中会包含有每个文件此时的修改时间信息
' 用户在下载时，发现有这个信息，并且调用了该函数后，则会在每个文件完成时，自动将文件的修改时间设置为torrent种子中记录的时间
' 如果只是下载的机器上启用了该函数，但制作种子的机器上没有使用该函数（种子中没有每个文件的时间信息），则也无法进行时间修改
Declare Sub DLBT_UseServerModifyTime Lib "DLBT.dll" (ByVal bUseServerTime As Boolean)

' 是否启用UDP穿透传输功能，默认是自动适应，如果对方支持，在tcp无法到达时，自动切换为udp通讯
Declare Sub DLBT_EnableUDPTransfer Lib "DLBT.dll" (ByVal bEnabled As Boolean)

' 是否启用伪装Http传输，某些地区（比如马来西亚、巴西的一些网络）对Http不限速，但对P2P限速在20K左右，这种网络环境下，可以启用Http传输
'  默认是允许伪装Http的传输进入（可以接受他们的通讯），但自己发起的连接不主动伪装。 如果客户群中有这类用户，可以考虑都设置：主动伪装。
' 但这种伪装也有副作用，国内有些地区机房（一般是网通）设置了Http必须使用域名，而不能使用IP，而BT传输中，对方没有合法域名，反而会被这种限制截杀
' 如果有这种限制，反而主动伪装后会没有速度。所以请根据实际使用选择。
Declare Sub DLBT_SetP2PTransferAsHttp Lib "DLBT.dll" (ByVal bHttpOut As Boolean, ByVal bAllowedIn As Boolean)

' 是否使用单独的穿透服务器，如果不使用单独服务器，穿透的协助将由某个双方都能连上的第三方p2p节点辅助完成
Declare Function DLBT_AddHoleServer Lib "DLBT.dll" (ByVal ip As String, ByVal port As Integer) As Long

' 设置服务器的IP，可以多次调用设置多个，用于标记哪些IP是服务器，以便统计从服务器下载到的数据等信息，甚至速度到了一定程度可以断开服务器连接，节省服务器带宽
Declare Sub DLBT_AddServerIP Lib "DLBT.dll" (ByVal ip As String)
' 不去连接这个p2sp的url，可以重复调用. 目的是，如果是服务器上，这个p2sp的url就在本机，就没必要去连接这个url了
Declare Sub DLBT_AddBanServerUrl Lib "DLBT.dll" (ByVal url As String)

' 保存一次状态文件的条件，内部默认全部下载完成后保存一次。可以调整为自己需要的时间或者上限数目，比如每5分钟保存一次，或者下载100块数据后保存一次
Declare Function DLBT_SetStatusFileSavePeriod Lib "DLBT.dll" ( _
    ByVal iPeriod As Long, _
    ByVal iPieceCount As Long) As Long


'//=======================================================================================
'//  设置报告Tracker的本机IP，内网下载和供种时设置自己NAT的公网IP会比较有效，详细参考
'//  点量BT的使用说明文档
'//=======================================================================================
Declare Sub DLBT_SetReportIP Lib "DLBT.dll" (ByVal reportIP As String)

Declare Function DLBT_GetReportIP Lib "DLBT.dll" () As Long
'DLBT_API void WINAPI DLBT_SetUserAgent (LPCSTR agent);

'//=======================================================================================
'//  设置磁盘缓存，3.3版本后已对外开放，3.3版本后系统内部自动设置8M缓存，如需调整可使用该
'//  函数进行调整，单位是K，比如要设置1M的缓存，需要传入1024
'//=======================================================================================
Declare Sub DLBT_SetMaxCacheSize Lib "DLBT.dll" (ByVal size As Long)

' 一些性能参数设置，默认情况下，点量BT是为了普通网络环境下的上传和下载所用，如果是在千M局域网下
' 并且磁盘性能良好，想获得50M/s甚至100M/s的单个文件传输速度，则需要设置这些参数。或者想节约内存，也可以设置这些参数
' 具体参数的设置建议，请咨询点量软件获取
Declare Sub DLBT_SetPerformanceFactor Lib "DLBT.dll" ( _
    ByVal socketRecvBufferSize As Long, _
    ByVal socketSendBufferSize As Long, _
    ByVal maxRecvDiskQueueSize As Long, _
    ByVal maxSendDiskQueueSize As Long)


' =======================================================================================
'   DHT相关函数,port是DHT监听的端口（udp端口），如果为0则使用内核监听的TCP端口号监听
' =======================================================================================
Declare Sub DLBT_DHT_Start Lib "DLBT.dll" (ByVal port As Integer)
Declare Sub DLBT_DHT_Stop Lib "DLBT.dll" ()
Declare Function DLBT_DHT_IsStarted Lib "DLBT.dll" () As Boolean


'' 暂时没有翻译代理相关的函数
''//=======================================================================================
''//  设置代理相关函数,商业授权版才有此功能，演示版暂不提供
''//=======================================================================================
''
''struct DLBT_PROXY_SETTING
''{
''    char    proxyHost [256];    // 代理服务器地址
''    int     nPort;              // 代理服务器的端口
''    char    proxyUser [256];    // 如果是需要验证的代理,输入用户名
''    char    proxyPass [256];    // 如果是需要验证的代理,输入密码
''
''    Enum DLBT_PROXY_TYPE
''    {
''        DLBT_PROXY_NONE,            // 不使用代理
''        DLBT_PROXY_SOCKS4,          // 使用SOCKS4代理，需要用户名
''        DLBT_PROXY_SOCKS5,          // 使用SOCKS5代理，无需用户名和密码
''        DLBT_PROXY_SOCKS5A,         // 使用需要密码验证的SOCKS5代理，需要用户名和密码
''        DLBT_PROXY_HTTP,            // 使用HTTP代理，匿名访问，仅适用于标准的HTTP访问，Tracker和Http跨协议传输，下载则不可以
''        DLBT_PROXY_HTTPA            // 使用需要密码验证的HTTP代理
''    };
''
''    DLBT_PROXY_TYPE proxyType;      // 指定代理的类型
''};
''
''
''//=======================================================================================
''//  标识代理将应用于哪些连接（Tracker、下载、DHT和http跨协议下载等）
''//=======================================================================================
''#define DLBT_PROXY_TO_TRACKER       1  // 仅对连接Tracker使用代理
''#define DLBT_PROXY_TO_DOWNLOAD      2  // 仅对下载时同用户（Peer）交流使用代理
''#define DLBT_PROXY_TO_DHT           4  // 仅对DHT通讯使用代理，DHT使用udp通讯，需要代理是支持udp的
''#define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  // 仅对HTTP下载使用代理，当任务有http跨协议下载时有效（不包括Tracker）
''
''// 对所有均使用代理
''#define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)
''
''DLBT_API void WINAPI DLBT_SetProxy (
''    DLBT_PROXY_SETTING  proxySetting,   // 代理设置，包括IP端口等
''    int                 proxyTo         // 代理应用于哪些连接，就是上面宏定义的几种类型，比如DLBT_PROXY_TO_ALL
''    );
''
''//=======================================================================================
''//  获取代理的设置，proxyTo标识想获得哪一类连接的代理信息，但proxyTo只能单个获取某类连接
''//  的代理设置，不能使用DLBT_PROXY_TO_ALL这种多个混合选择
''//=======================================================================================
''DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, int proxyTo);
''
''//=======================================================================================
''//  设置加密相关函数,将协议字符串或者所有数据均加密，实现保密传输，在兼容BT协议上突破
''//  绝大部分运营商的封锁。和前面提到的私有协议不同的是，私有协议后将形成自己
''//  的P2P网络，不能同其它BT客户端兼容；但私有协议完全不是BT协议了，没有BT的痕迹，可以穿透
''//  更多运营商的封锁
''//=======================================================================================
Public Enum DLBT_ENCRYPT_OPTION
    DLBT_ENCRYPT_NONE = 0             ' // 不支持任何加密的数据，遇到加密的通讯则断开
    DLBT_ENCRYPT_COMPATIBLE = 1       ' // 兼容模式：自己发起的连接不使用加密，但允许别人的加密连接进入，遇到加密的则同对方用加密模式会话；
    DLBT_ENCRYPT_FULL = 2             ' // 完整加密：自己发起的连接默认使用加密，同时允许普通和加密的连接连入。遇到加密则用加密模式会话；遇到非加密则用明文模式会话。默认是完整加密
    DLBT_ENCRYPT_FORCED = 3           ' // 强制加密，仅支持加密通讯，不接受普通连接，遇到不加密的则断开
End Enum
''
'加密级别. 加密层级高，理论上会浪费一点CPU，但数据传输安全和突破封锁的能力会有提升
Public Enum DLBT_ENCRYPT_LEVEL
    DLBT_ENCRYPT_PROTOCOL = 0         ' // 仅加密BT的通讯握手协议  －－一般用于防止运营商的阻止
    DLBT_ENCRYPT_DATA = 1             ' // 仅加密数据流（数据内容）－－ 用于保密性强的文件传输
    DLBT_ENCRYPT_PROTOCOL_MIX = 2     ' // 主动发起的连接使用加密协议模式，但如果对方使用了数据加密，也支持同他使用数据加密模式通讯
    DLBT_ENCRYPT_ALL = 3              ' // 协议和数据均主动加密
End Enum
''// 内部默认使用兼容性加密（对协议和数据均兼容加密），没有特殊需求，建议不需要调用
Declare Sub DLBT_SetEncryptSetting Lib "DLBT.dll" (ByVal encryptOption As DLBT_ENCRYPT_OPTION, ByVal encryptLevel As DLBT_ENCRYPT_LEVEL)


' ***************************  以下是单个下载相关的接口 ********************************

' 单个下载的状态
Public Enum DLBT_DOWNLOAD_STATE
    BTDS_QUEUED = 0                    ' 已添加
    BTDS_CHECKING_FILES = 1            ' 正在检查校验文件
    BTDS_DOWNLOADING_TORRENT = 2       ' 无种子模式下，正在获取种子的信息
    BTDS_DOWNLOADING = 3               ' 正在下载中
    BTDS_PAUSED = 4                    ' 暂停
    BTDS_FINISHED = 5                ' 指定的文件下载完成
    BTDS_SEEDING = 6                   ' 供种中（种子中的所有文件下载完成）
    BTDS_ALLOCATING = 7                ' 正在预分配磁盘空间 -- 预分配空间，减少磁盘碎片，和
                                    ' 启动选项有关，启动时如果选择预分配磁盘方式，可能进入该状态
    BTDS_ERROR = 8                  ' 出错，可能是写磁盘出错等原因，详细原因可以通过调用DLBT_Downloader_GetLastError获知
End Enum

' 文件的分配模式,详见使用说明文档
Public Enum DLBT_FILE_ALLOCATE_TYPE
    FILE_ALLOCATE_REVERSED = 0    ' 预分配模式,预先创建文件,下载每一块后放到正确的位置
    FILE_ALLOCATE_SPARSE = 1      ' Default mode, more effient and less disk space.NTFS下有效 http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
    FILE_ALLOCATE_COMPACT = 2     ' 文件大小随着下载不断增长,每下载一块数据按次序紧密排在一起,但不是他们的最终位置,下载中不断调整位置,最后文件位置方能确定         .
End Enum


' =======================================================================================
'   启动一个文件的下载，返回这个下载的句柄，以后对该下载任务的所有操作，需要根据句柄来进行
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
'// 启动一个内存中的种子文件内容，可用于种子文件不是独立存储或者按某个加密方式加密种子的情况，可以将解密后的内容传入BT内核
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromBuffer (
'        LPBYTE              torrentFile,                    // 内存中的种子文件内容
'        DWORD               dwTorrentFileSize,              // 种子内容的大小
'        LPCWSTR             outPath,                        // 下载后的保存路径（只是目录）
'        LPCWSTR             statusFile = NULL,              // 状态文件的路径
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
'        BOOL                bPaused = FALSE,
'        BOOL                bQuickSeed = FALSE,             // 是否快速供种（专业服务器模式下有效，仅商业版提供，个人免费版和演示版暂不提供）
'        LPCSTR              password = NULL,                // 是否加密种子，如果为Null，则是普通种子，否则是种子的密码，试用版不支持，该参数会被忽略
'        LPCWSTR             rootPathName = NULL,             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
'                                                            // 对单个文件则直接进行改名为指定的这个名字
'        BOOL                bPrivateProtocol = FALSE,        // 该种子是否私有协议（可以对不同种子采用不同的下载方式）
'        BOOL                bZipTransfer = FALSE            // 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
'        );
'
'// 从一个Torrent句柄启动一个任务
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromTorrentHandle (
'        HANDLE              torrentHandle,                    // Torrent句柄
'        LPCWSTR             outPath,                        // 下载后的保存路径（只是目录）
'        LPCWSTR             statusFile = NULL,              // 状态文件的路径
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
'        BOOL                bPaused = FALSE,
'        BOOL                bQuickSeed = FALSE,              // 是否快速供种（专业服务器模式下有效，仅商业版提供，个人免费版和演示版暂不提供）
'        LPCWSTR             rootPathName = NULL             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
'                                                            // 对单个文件则直接进行改名为指定的这个名字
'        BOOL                bPrivateProtocol = FALSE,       // 该种子是否私有协议（可以对不同种子采用不同的下载方式）
'        BOOL                bZipTransfer = FALSE            // 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
'    );
'
'//（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
'        LPCSTR              trackerURL,                     // tracker的地址
'        LPCSTR              infoHash,                       // 文件的infoHash值
'        LPCTSTR             outPath,
'        LPCTSTR             name = NULL,                    // 在下载到种子之前，是没有办法知道名字的，因此可以传入一个临时的名字
'        LPCWSTR             statusFile = NULL,              // 状态文件的路径
'        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
'        BOOL bPaused = False,
'        LPCWSTR             rootPathName = NULL             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
'                                                            // 对单个文件则直接进行改名为指定的这个名字
'        BOOL                bPrivateProtocol = FALSE,       // 该种子是否私有协议（可以对不同种子采用不同的下载方式）
'        BOOL                bZipTransfer = FALSE            // 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
'        );
'
'// 无种子模式的另一个接口，可以直接通过地址下载，地址格式为： DLBT://xt=urn:btih: Base32 编码过的info-hash [ &dn= 名字 ] [ &tr= tracker的地址 ]  ([]为可选参数)
'// 完全遵循uTorrent的官方BT扩展协议
'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromUrl (
'    LPCSTR              url,                            // 网址
'    LPCTSTR             outPath,                        // 保存目录
'    LPCWSTR             statusFile = NULL,              // 状态文件的路径
'    DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,
'    BOOL bPaused = False,
'        LPCWSTR             rootPathName = NULL             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
'                                                            // 对单个文件则直接进行改名为指定的这个名字
'        BOOL                bPrivateProtocol = FALSE,       // 该种子是否私有协议（可以对不同种子采用不同的下载方式）
'        BOOL                bZipTransfer = FALSE            // 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
'    );

'// 专业文件更新接口，任务以新老种子文件为基础，更新新种子文件相对老种子文件变化过的数据块。仅商业版中提供
'DLBT_API HANDLE WINAPI DLBT_Downloader_InitializeAsUpdater (
'    LPCWSTR             curTorrentFile,    //当前版本的种子文件
'    LPCWSTR             newTorrentFile,   //  新版种子文件
'    LPCWSTR             curPath,    //  当前文件的路径
'    LPCWSTR             statusFile = L"", // 状态文件的路径
'    DLBT_FILE_ALLOCATE_TYPE    type = FILE_ALLOCATE_SPARSE, //  文件分配方式，必须和当前版本一致，新版本也将使用该分配方式。
'    BOOL                bPaused = FALSE,     // 是否暂停方式启动
'    LPCSTR              curTorrentPassword = NULL,
'    LPCSTR              newTorrentFilePassword = NULL,
'    LPCWSTR             rootPathName = NULL,
'    BOOL                bPrivateProtocol = FALSE,
'    float       *       fProgress = NULL,        //如果不为NULL，则传出和DLBT_Downloader_GetOldTorrentProgress一样的一个进度
'    BOOL                bZipTransfer = FALSE            // 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
'   );

'// 专业文件更新时，传入新老种子，然后直接传出老种子和新种子的差异情况（进度），如果进度是99%，则意味着只有1%的数据需要下载。
'DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
'    LPCWSTR             curTorrentFile,    //当前版本的种子文件
'    LPCWSTR             newTorrentFile,   //  新版种子文件
'    LPCWSTR             curPath,    //  当前文件的路径
'    LPCWSTR             statusFile = L"", // 状态文件的路径
'    LPCSTR              curTorrentPassword = NULL,
'    LPCSTR newTorrentFilePassword = Null
'    );

' // 获取本任务所有的Http连接，内存必须调用DLBT_Downloader_FreeConnections释放
' DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
' // 释放DLBT_Downloader_GetHttpConnections传出的内存
' DLBT_API void WINAPI DLBT_Downloader_FreeConnections(LPSTR * urls, int urlCount);

'// 增加一个http的地址，当该下载文件在某个Web服务器上有http下载时可以使用，web服务器的编码方式最好为UTF-8，如果是其它格式可以联系点量软件进行修改
Declare Sub DLBT_Downloader_AddHttpDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal url As String)

'// 移除一个P2SP的地址，如果正在下载中，会进行断开并且从候选者列表中移除，不再进行重试
Declare Sub DLBT_Downloader_RemoveHttpDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal url As String)
'// 设置一个Http地址，最多可以建立多少个连接，默认是1个连接. 如果服务器性能好，可以酌情设置，比如设置10个，则是对一个Http地址，可以建立10个连接。
'// 设置之前如果已经一个Http地址建立好了多个连接，则不再断开，仅对设置后再新建连接时生效
Declare Sub DLBT_Downloader_SetMaxSessionPerHttp Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)

'加入Tracker
Declare Function DLBT_Downloader_AddTracker Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal TrackerURL As String, ByVal tier As Long) As Long
Declare Sub DLBT_Downloader_RemoveAllTracker Lib "DLBT.dll" (ByVal hDownloader As Long)
Declare Sub DLBT_Downloader_AddHttpTrackerExtraParams Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal extraParams As String)
                            
' 关闭任务之前，可以调用该函数停掉IO线程对该任务的操作（异步的，需要调用DLBT_Downloader_IsReleasingFiles函数来获取是否还在释放中）。
' 该函数调用后，请直接调用_Release，不可对该句柄再调用其它DLBT_Dwonloader函数。本函数内部会先暂停所有数据下载，然后释放掉文件句柄
Declare Sub DLBT_Downloader_ReleaseAllFiles Lib "DLBT.dll" (ByVal hDownloader As Long)
' 是否还在释放句柄的过程中
Declare Function DLBT_Downloader_IsReleasingFiles Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean


Public Enum DLBT_RELEASE_FLAG
    DLBT_RELEASE_NO_WAIT = 0            ' 默认方式Release，直接释放，不等待释放完成
    DLBT_RELEASE_WAIT = 1               ' 等待所有文件都释放完成
    DLBT_RELEASE_DELETE_STATUS = 2      ' 删除状态文件
    DLBT_RELEASE_DELETE_ALL = 4         ' 删除所有文件
End Enum

' 关闭hDownloader所标记的下载任务,如果需要删除文件,可以将第2个参数置为True
Declare Function DLBT_Downloader_Release Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal nFlag As DLBT_RELEASE_FLAG) As Long


' 设置单个任务的最大缓存，仅在商业授权版中有该功能
Declare Sub DLBT_Downloader_SetDiskCacheSize Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal size As Long)

' 设置任务下载是否按顺序下载,默认是非顺序下载(随机的下载,一般遵循稀有者优先,这种方式速度快),但顺序下载适用于边下边播放
Declare Sub DLBT_Downloader_SetDownloadSequence Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal ifSeq As Boolean)

' 下载的状态 以及 暂停和继续的接口
Declare Function DLBT_Downloader_GetState Lib "DLBT.dll" (ByVal hDownloader As Long) As DLBT_DOWNLOAD_STATE '获取下载任务的状态
Declare Function DLBT_Downloader_IsPaused Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean   '判断是否暂停状态
Declare Sub DLBT_Downloader_Pause Lib "DLBT.dll" (ByVal hDownloader As Long)       '暂停
Declare Sub DLBT_Downloader_Resume Lib "DLBT.dll" (ByVal hDownloader As Long)       '继续

' 出错状态下的两个接口 （一般只有在极其特殊情况下文件无法写入时才会出错，比如磁盘满了）
Declare Function DLBT_Downloader_GetLastError Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal pBuffer As String, ByRef pBufferSize As Long) As Long ' 如果任务的状态为BTDS_ERROR，通过该接口获取详细错误信息
Declare Sub DLBT_Downloader_ResumeInError Lib "DLBT.dll" (ByVal hDownloader As Long)   ' 清除这个错误，尝试重新开始任务

' 无种子下载的相关接口（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
Declare Function DLBT_Downloader_IsHaveTorrentInfo Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean ' 无种子下载时，用于判断是否成功获取到了种子信息
Declare Function DLBT_Downloader_MakeURL Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                         ByVal pBuffer As String, _
                                                         ByRef pBufferSize As Long) As Long


' 下载的限速和限制连接的接口
Declare Sub DLBT_Downloader_SetDownloadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetUploadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetMaxUploadConnections Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
Declare Sub DLBT_Downloader_SetMaxTotalConnections Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)

' 确保任务只上传，不下载
Declare Sub DLBT_Downloader_SetOnlyUpload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal bUpload As Boolean)

' 设置对服务器IP进行下载限速，单位是BYTE(字节），如果需要限速1M，请输入1024*1024
Declare Sub DLBT_Downloader_SetServerDownloadLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Long)
' 设置本任务不再去跟所有的服务器IP建立连接（对于对方连过来的连接，需要BT协议握手通过后，知道是对应于这个下载任务hDownloader的后才再断开）。
Declare Sub DLBT_Downloader_BanServerDownload Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal limit As Boolean)

' 下载分享率 (上传/下载的比例）的接口
Declare Sub DLBT_Downloader_SetShareRateLimit Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal fRate As Single)
Declare Function DLBT_Downloader_GetShareRate Lib "DLBT.dll" (ByVal hDownloader As Long) As Double


' 正在下载的文件的属性（文件大小、完成数、进度等）
Declare Function DLBT_Downloader_GetTorrentName Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                                ByVal pBuffer As String, _
                                                                ByRef pBufferSize As Long) As Long
                                                                
Declare Function DLBT_Downloader_GetTotalFileSize Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetTotalWanted Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64      ' 共有选择了多少下载量，不包含不想下载的文件
Declare Function DLBT_Downloader_GetTotalWantedDone Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64   ' 在选定的文件中，下载了多少
Declare Function DLBT_Downloader_GetProgress Lib "DLBT.dll" (ByVal hDownloader As Long) As Single

Declare Function DLBT_Downloader_GetDownloadedBytes Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetUploadedBytes Lib "DLBT.dll" (ByVal hDownloader As Long) As UINT64
Declare Function DLBT_Downloader_GetDownloadSpeed Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetUploadSpeed Lib "DLBT.dll" (ByVal hDownloader As Long) As Long

' 获得该任务的节点的数目，数目的参数为int的指针，如果不想要某个值，则传NULL
Declare Sub DLBT_Downloader_GetPeerNums Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                    ByRef connectedCount As Long, _
                                                    ByRef totalSeedCount As Long, _
                                                    ByRef seedsConnected As Long, _
                                                    ByRef inCompleteCount As Long, _
                                                    ByRef totalCurrentSeedCount As Long, _
                                                    ByRef totalCurrentPeerCount As Long)


' 单个种子中包含多个文件时的一些接口,index为文件的序列号，从0开始
Declare Function DLBT_Downloader_GetFileCount Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetFileSize Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As UINT64
Declare Function DLBT_Downloader_GetFileOffset Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As UINT64
Declare Function DLBT_Downloader_IsPadFile Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As Boolean
' 获取指定序号的文件名称
Declare Function DLBT_Downloader_GetFilePathName Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                                ByVal Index As Long, _
                                                                ByVal pBuffer As Long, _
                                                                ByRef pBufferSize As Long, _
                                                                ByVal needFullPath As Boolean) As Long
                                                                
' 该函数会将下载目录下存在，但torrent记录中不存在的文件全部删除，对单个文件的种子无效。请慎重使用。
Declare Function DLBT_Downloader_DeleteUnRelatedFiles Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
                                                                
                                                                
' 获取每个文件的Hash值，只有制作种子时使用bUpdateExt才能获取到
Declare Function DLBT_Downloader_GetFileHash Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                             ByVal Index As Long, _
                                                             ByVal pBuffer As String, _
                                                             ByRef pBufferSize As Long) As Long

                                                                
' // 取文件的下载进度，该操作需要进行较多操作，建议仅在必要时使用
Declare Function DLBT_Downloader_GetFileProgress Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long) As Single

Public Enum DLBT_FILE_PRIORITIZE
    DLBT_FILE_PRIORITY_CANCEL = 0               ' 取消该文件的下载
    DLBT_FILE_PRIORITY_NORMAL = 1               ' 正常优先级
    DLBT_FILE_PRIORITY_ABOVE_NORMAL = 2         ' 高优先级
    DLBT_FILE_PRIORITY_MAX = 3                  ' 最高优先级（如果有该优先级的文件还未下完，不会下载低优先级的文件）
End Enum

' 设置文件的下载优先级，比如可以用于取消某个指定文件的下载,index表示文件的序号
Declare Function DLBT_Downloader_SetFilePrioritize Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                            ByVal Index As Long, _
                                                            ByVal prioritize As DLBT_FILE_PRIORITIZE, _
                                                            ByVal bDoPriority As Boolean) As Long

' 立即应用优先级的设置
Declare Sub DLBT_Downloader_ApplyPrioritize Lib "DLBT.dll" (ByVal hDownloader As Long)

' 获取当前每个分块的状态，比如可以用于判断是否需要去更新（是否已经拥有了该块）。
Declare Function DLBT_Downloader_GetPiecesStatus Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByRef pieceArray As Byte, _
                                                ByVal arrayLength As Long, _
                                                ByRef pieceDownloaded As Long) As Long

' 设置Piece（分块）的下载优先级，比如可以用于取消某些分块的下载，从指定位置开始下载等。index表示分块的序号
Declare Function DLBT_Downloader_SetPiecePrioritize Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByVal Index As Long, _
                                                ByVal prioritize As DLBT_FILE_PRIORITIZE, _
                                                ByVal bDoPriority As Boolean) As Long

' 设置手工指定的Peer信息
Declare Sub DLBT_Downloader_AddPeerSource Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal ip As String, ByVal port As Integer)


' 获得可显示的文件Hash值
Declare Function DLBT_Downloader_GetInfoHash Lib "DLBT.dll" (ByVal hDownloader As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long

Declare Function DLBT_Downloader_GetPieceCount Lib "DLBT.dll" (ByVal hDownloader As Long) As Long
Declare Function DLBT_Downloader_GetPieceSize Lib "DLBT.dll" (ByVal hDownloader As Long) As Long

' 主动保存一次状态文件，通知内部的下载线程后立即返回，是异步操作，可能会有一点延迟才会写
Declare Sub DLBT_Downloader_SaveStatusFile Lib "DLBT.dll" (ByVal hDownloader As Long)

' bOnlyPieceStatus： 是否只保存一些文件分块信息，便于服务器上生成后发给每个客户机；客户机就不用再比较了，直接快速启动. 默认是FALSE，也就是全部信息都保存
Declare Sub DLBT_Downloader_SetStatusFileMode Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal bOnlyPieceStatus As Boolean)

' 查看保存状态文件是否完成
Declare Function DLBT_Downloader_IsSavingStatus Lib "DLBT.dll" (ByVal hDownloader As Long) As Boolean

' // 向BT系统中写入通过其它方式接收来的数据块。offset为该数据块在整个文件（文件夹）中的偏移量，size为数据块大小，data为数据缓冲区
' // 成功返回S_OK，失败为其它，失败原因可能是该块不需要再次传输了。 本函数仅VOD增强版中有效
' DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);

' // 手工添加一块完整的数据进来 本函数仅VOD增强版中有效
' DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
'     HANDLE                  hDownloader,
'     int                     piece,          //分块序号
'     char            *       data,           //数据本身
'     bool                    bOverWrite      //如果已经有了，是否覆盖
'     );


' // 每次要替换一个数据块时调用一下这个回调，外部可以根据这个回调显示替换的进度；以及是否终止整个替换工作（功能相当于：DLBT_Downloader_CancelReplace)
' // 返回FALSE代表希望立即终止，TRUE代表继续。
' // 一个分块可能会包括多个小文件（或者大文件的尾部，多文件粘连的地方），因此一个分块pieceIndex可能会对应了多个文件片段。本回调是替换一个文件片段时触发一次
' typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
'       IN void * pContext,                   // 回调的上下文（通过DLBT_Downloader_ReplacePieceData的pContext参数传入），这里传回去，便于外面处理
'                                             // 比如，外部传入一个this指针，回调的时候再通过这个指针知道是对应哪个对象
'       IN int pieceIndex,                    //本次要替换的数据位于哪个分块（分块在torrent中的索引）
'       IN int replacedPieceCount,            //已经完成了多少个piece的替换
'       IN int totalNeedReplacePieceCount,    //总共有多少个要替换的piece分块
'       IN int fileIndex,                     //本次要替换的数据位于哪个文件
'       IN UINT64 offset,                     //在这个文件中，这块数据的偏移量
'       IN UINT64 size,                       //这块数据的总大小（距离偏移量）
'       IN int replacedFileSliceCount,        //已经完成了多少个文件片段的替换
'       IN int totalFileSliceCount            //总共有多少个需要替换的文件片段
'       );

' // 替换数据块的接口：将某块数据直接替换到目标文件的相同位置，一般用于：下载时将需要下载的分块自动下载到一个临时目录，完成后再替换回原始文件
' // 这样下载过程中原始文件可以正常使用，并保留了只下载部分数据的优点。
' // 该函数是立即返回，如果HRESULT返回的不是S_OK，说明出错，需要查看返回值。
' // 如果返回S_OK，则内部会启动线程来进行替换，中间的结果随时通过DLBT_Downloader_GetReplaceResult来进行查看结果。随时可以调用：DLBT_Downloader_CancelReplace进行取消线程操作
' DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
'     HANDLE          hDownloader,        //下载任务句柄
'     int   *         pieceArray,         // 需要将哪些分块替换，是一个int数组
'     int             arrayLength,        // 分块数组的长度
'     LPCSTR          destFilePath,       // 需要替换的文件（文件夹）的目录。比如：E:\Test\1.rar或者E:\Test\Game\天龙八部 等。
'     LPCSTR          tempRootPathName = NULL,    // 临时目录下载时，如果使用了rootPathName，则这里也要设置上，以便从这个文件（文件夹）下读取数据块
'     LPCSTR          destRootPathName = NULL,    // 需要替换的那个下载任务，如果使用了rootPathName，则这里也要设置上，以便对这个文件（文件夹）进行替换
'     LPVOID          pContext = NULL,
'     DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  //接收进度，并可以随时取消的回调
'     );

' // ReplacePieceData的一些状态，可以通过DLBT_Downloader_GetReplaceResult来进行查看
' Enum DLBT_REPLACE_RESULT
' {
'     DLBT_RPL_IDLE  = 0,     //尚未开始替换
'     DLBT_RPL_RUNNING,       //正在运行中
'     DLBT_RPL_SUCCESS,       //替换成功
'     DLBT_RPL_USER_CANCELED, //替换了一半，用户取消掉了
'     DLBT_RPL_ERROR,         //出错，可以通过hrDetail来获取详细信息，参考：DLBT_Downloader_GetReplaceResult
' };

' // 获取替换数据的结果
' DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
'     HANDLE          hDownloader,        //下载任务句柄
'     HRESULT  *      hrDetail,           //如果是有出错，返回详细的出错原因
'     BOOL     *      bThreadRunning      //Replace的整个操作是否结束了（出错也会立即结束的）
'     );

' // 中间随时取消替换数据的操作（不建议取消，因为有可能会替换到一半，这样有些文件是不完整的）
' DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);

    
    
' ***************************  以下是种子相关的接口 ********************************

Public Enum DLBT_TORRENT_TYPE
    USE_PUBLIC_DHT_NODE = 0
    NO_USE_PUBLIC_DHT_NODE = 1
    ONLY_USE_TRACKER = 2
End Enum

' 创建一个Torrent的句柄，返回内存中种子的句柄
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
                               
                        
' 指定种子包含的Tracker
Declare Function DLBT_Torrent_AddTracker Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal TrackerURL As String, _
                                                ByVal tier As Long) As Long
' 移除种子中的所有Tracker
Declare Sub DLBT_Torrent_RemoveAllTracker Lib "DLBT.dll" (ByVal hTorrent As Long)

' 指定种子可以使用的http源，如果下载的客户端支持http跨协议下载，则会自动从该地址进行下载
Declare Sub DLBT_Torrent_AddHttpUrl Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal httpUrl As String)

' 保存为torrent文件,filePath为路径（包括文件名）, 如果password不为空，则代表需要对种子进行加密
Declare Function DLBT_SaveTorrentFile Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal filePath As String, ByVal password As String, ByVal bUseHashName As Long, ByVal exeName As String) As Long
    
' 释放torrent文件的句柄
Declare Sub DLBT_ReleaseTorrent Lib "DLBT.dll" (ByVal hTorrent As Long)



' 打开一个种子句柄，便于修改或者读取信息进行操作；用完后，需要调用DLBT_ReleaseTorrent释放torrent文件的句柄
' password 标记是否加密种子，如果为Null，则是普通种子，否则是种子的密码，以此密码进行解密
Declare Function DLBT_OpenTorrent Lib "DLBT.dll" (ByVal torrentFile As String, _
                                                  ByVal password As String) As Long

Declare Function DLBT_OpenTorrentFromBuffer Lib "DLBT.dll" (ByVal torrentFile As Byte, _
                                                ByVal dwTorrentFileSize As Long, _
                                                ByVal password As String) As Long
Declare Function DLBT_Torrent_GetComment Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long
' 返回创建软件的信息
Declare Function DLBT_Torrent_GetCreator Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long
' 返回发布者信息
Declare Function DLBT_Torrent_GetPublisher Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                ByVal pBuffer As String, _
                                                ByRef pBufferSize As Long) As Long

' 通过种子，制作一个可以不需要种子即可下载的网址，参考DLBT_Downloader_Initialize_FromUrl
Declare Function DLBT_Torrent_MakeURL Lib "DLBT.dll" (ByVal hTorrent As Long, _
                                                      ByVal pBuffer As String, _
                                                      ByRef pBufferSize As Long) As Long
    
Declare Function DLBT_Torrent_GetTrackerCount Lib "DLBT.dll" (ByVal hTorrent As Long) As Long

Declare Function DLBT_Torrent_GetTrackerUrl Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As String

'取得种子文件内的总计文件大小
Declare Function DLBT_Torrent_GetTotalFileSize Lib "DLBT.dll" (ByVal hTorrent As Long) As UINT64

' 单个种子中包含多个文件时的一些接口,index为文件的序列号，从0开始
Declare Function DLBT_Torrent_GetPieceCount Lib "DLBT.dll" (ByVal hTorrent As Long) As Long

Declare Function DLBT_Torrent_IsPadFile Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As Boolean
Declare Function DLBT_Torrent_GetFileSize Lib "DLBT.dll" (ByVal hTorrent As Long, ByVal Index As Long) As UINT64
'通过种子句柄,返回指定序号的文件名
Declare Function DLBT_Torrent_GetFilePathName Lib "DLBT.dll" (ByVal hDownloader As Long, ByVal Index As Long, ByVal pBuffer As Long, ByRef pBufferSize As Long) As Long


' 暂时没有翻译以下几个函数
'//////////////////////   Move的相关接口   /////////////
'// Move的结果
'Enum DOWNLOADER_MOVE_RESULT
'{
'    DLBT_MOVED  = 0,    //移动成功
'    DLBT_MOVE_FAILED,   //移动失败
'    DLBT_MOVING         //正在移动
'};
'
'//移动到哪个目录，如果是同一磁盘分区，是剪切；如果是不同分区，是复制后删除原始文件。由于操作是异步操作，所以立即返回
'//结果使用DLBT_Downloader_GetMoveResult去获取
'DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCSTR savePath);
'//查看移动操作的结果
'DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
'    HANDLE          hDownloader,   // 下载任务的句柄
'    LPSTR           errorMsg,      // 用于返回出错信息的内存，在DLBT_MOVE_FAILED状态下这里返回出错的详情。如果传入NULL，则不返回错误信息
'    int             msgSize        // 出错信息内存的大小
'    );
   

' 暂时没有翻译以下几个函数
'// **************************** 以下是种子市场有关的接口 *****************************
'// 种子市场仅在商业版本中提供，免费试用版中暂时不提供该功能
'struct DLBT_TM_ITEM   //标记种子市场中的一个种子文件
'{
'    DLBT_TM_ITEM(): fileSize (0) {}
'
'    UINT64  fileSize;      // the size of this file
'    char    name[256];     // 名字
'    LPCSTR  url;           // 用于下载的url
'    LPCSTR  comment;       // 种子描述
'};
'
'struct DLBT_TM_LIST       //标记种子市场中的一批种子文件（多个）
'{
'    int             count;      //数目
'    DLBT_TM_ITEM    items[1];   //种子列表
'};
'
'// 在本机的种子市场中添加一个种子文件
'DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCSTR torrentFile, LPCSTR password = NULL);
'// 在本机的种子市场中移除一个种子文件
'DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCSTR torrentFile, LPCSTR password = NULL);

'// 获取本机种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
'DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
'// 获取其它人种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
'DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);

'// 释放DLBT_TM_GetSelfTorrentList或者DLBT_TM_GetRemoteTorrentList获取到的种子列表的内存
'DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);
'
'// 清空所有获取到的其它人的种子列表
'DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList ();
'// 清空所有自己种子市场中的种子列表
'DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList ();
'
'// 设置一下是否启用种子市场，默认不启用。
'DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);

' *********************  以下是防火墙和UPnP穿透等P2P辅助性接口 **********************

' 端口的类型
Public Enum PORT_TYPE
    TCP_PORT = 1                    ' TCP 端口
    UDP_PORT = 2                    ' UDP 端口
End Enum

'  将某个应用程序添加到ICF防火墙的例外中去，可独立于内核应用，不启动内核仍然可以使用该函数
Declare Function DLBT_AddAppToWindowsXPFirewall Lib "DLBT.dll" (ByVal appFilePath As String, ByVal ruleName As String) As Boolean
'  将某个端口加入UPnP映射，点量BT内部的所有端口已经自动加入，不需要再次加入，这里提供出来是供外部程序加入自己所需端口
Declare Function DLBT_AddUPnPPortMapping Lib "DLBT.dll" (ByVal nExternPort As Integer, _
                          ByVal nLocalPort As Integer, _
                          ByVal nPortType As PORT_TYPE, _
                          ByVal appName As String) As Boolean
                          
' 获得当期系统的并发连接数限制，如果返回0则表示系统可能不是受限的XP系统，无需修改连接数限制
' 可独立于内核使用，启动内核前即可使用
Declare Function DLBT_GetCurrentXPLimit Lib "DLBT.dll" () As Long

' 修改XP的并发连接数限制，返回BOOL标志是否成功
Declare Function DLBT_ChangeXPConnectionLimit Lib "DLBT.dll" (ByVal num As Long) As Boolean


' ***************************  以下是批量获取信息的接口 ********************************

' 内核的基本信息
Type KERNEL_INFO
    port                            As Long             ' 监听端口
    dhtStarted                      As Long             ' DHT是否启动
    totalDownloadConnectionCount    As Long             ' 总的下载连接数
    downloadCount                   As Long             ' 下载任务的个数
    totalDownloadSpeed              As Long             ' 总下载速度
    totalUploadSpeed                As Long             ' 总上传速度
    totalDownloadedByteCount        As UINT64           ' 总下载的字节数
    totalUploadedByteCount          As UINT64           ' 总上传的字节数
'
    peersNum                        As Long             ' 当前连接上的节点总数
    dhtConnectedNodeNum             As Long             ' dht连接上的活跃节点数
    dhtCachedNodeNum                As Long             ' dht已知的节点数
    dhtTorrentNum                   As Long             ' dht中已知的torrent文件数
End Type

' 单个下载任务的基本信息
Type DOWNLOADER_INFO
    state                       As DLBT_DOWNLOAD_STATE          ' 下载的状态
    percentDone                 As Single                       ' 已经下载的数据，相比整个torrent总数据的大小 （如果只选择了一部分文件下载，那么该进度不会到100%）
    downConnectionCount         As Long                         ' 下载建立的连接数
    downloadLimit               As Long                         ' 该任务的下载限速
    connectionCount             As Long                         ' 总建立的连接数（包括上传）
    totalCompletedSeeds         As Long                         ' Tracker启动以来，总下载完成的人数，如果Tracker不支持scrap，则返回-1
    inCompleteNum               As Long                         ' 总的未完成的人数，如果Tracker不支持scrap，则返回-1
    seedConnected               As Long                         ' 连上的下载完成的人数
    totalCurrentSeedCount       As Long                         ' 当前在线的总的下载完成的人数（包括连上的和未连上的）
    totalCurrentPeerCount       As Long                         ' 当前在线的总的下载的人数（包括连上的和未连上的）
    currentTaskProgress         As Single                       ' 当前任务的进度(100%代表完成)
    bReleasingFiles             As Long                         ' 是否正在释放文件句柄，一般下载完成后，虽然进度完成了，但文件句柄和缓存内部还可能需要一点时间在释放。大于0代表还在释放，0代表释放完成
    
    downloadSpeed               As Long                         ' 下载的速度
    uploadSpeed                 As Long                         ' 上传的速度
    serverPayloadSpeed          As Long                         ' 从服务器下载的总有效速度（不包括握手消息等非数据性传输）
    serverTotalSpeed            As Long                         ' 从服务器下载的总速度(包括握手消息、连接通讯的消耗）
    
    wastedByteCount             As UINT64                       ' 非数据的字节数（控制信息等）
    totalDownloadedBytes        As UINT64                       ' 下载的数据的字节数
    totalUploadedBytes          As UINT64                       ' 上传的数据的字节数
    totalWantedBytes            As UINT64                       ' 选择的总数据大小
    totalWantedDoneBytes        As UINT64                       ' 选择的总数据中，已下载完成的数据大小
     
    totalServerPayloadBytes     As UINT64                       ' 从服务器下载的数据总量（本次启动以来的文件数据，也包括了如果收到错误的数据，即使后来丢弃的 -- 不过一般服务器如果没问题，不会丢弃数据的）
    totalServerBytes            As UINT64                       ' 从服务器下载的所有数据的总量（包括totalServerPayloadBytes，以及握手数据、收发消息等）
    totalPayloadBytesDown       As UINT64                       ' 本次启动后总的下载的数据块类型的数据量（包括了服务器的数据，以及可能丢弃的数据）
    totalBytesDown              As UINT64                       ' 本次启动后，总的所有数据的下行数据量（包括了服务器以及所有客户的数据、辅助通讯数据量等）


    ' Torrent信息
    bHaveTorrent                As Long                         ' 用于无种子下载模式，判断是否已经获取到了torrent文件，大于0代表已经获取到了，0代表还未获取到
    totalFileSize               As UINT64                       ' 文件的总大小
    totalFileSizeExcludePadding As UINT64                       ' 实际文件的大小，不含padding文件。如果种子中无padding文件，则和totalFileSize相等
    totalPaddingSize            As UINT64                       ' 所有padding数据的大小。如果制作种子时没启用padding文件，则为0
    pieceCount                  As Long                         ' 分块数
    pieceSize                   As Long                         ' 每个块的大小
       
    infoHash(256)               As Byte                         ' 文件的Hash值
End Type

''// 每个连接上的节点（用户）的信息
Type PEER_INFO_ENTRY
    connectionType              As Long                         '连接类型 0：标准BT(tcp); 1: P2SP（http） 2: udp（可能是直接连接或者穿透）
    downloadSpeed               As Long                         '下载速度
    uploadSpeed                 As Long                         '上传速度
    downloadedBytes             As UINT64                       '下载的字节数
    uploadedBytes               As UINT64                       '上传的字节数
    
    uploadLimit                 As Long                         ' 该连接的上传限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况
    downloadLimit               As Long                         ' 该连接的下载限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况

    ip(63)                      As Byte                         '对方IP
    client(63)                  As Byte                         '对方使用的客户端
End Type
    
''
''// 所有连接上的节点（用户）的信息
''struct PEER_INFO
''{
''    int                         count;                          // 总的节点（用户）数
''    PEER_INFO_ENTRY             entries [1];                    // 节点信息的数组
''};
''
''
' 获取批量信息的接口
Declare Function DLBT_GetKernelInfo Lib "DLBT.dll" (ByRef info As KERNEL_INFO) As Long
Declare Function DLBT_GetDownloaderInfo Lib "DLBT.dll" (ByVal hDownloader As Long, ByRef info As DOWNLOADER_INFO) As Long

''// 获得完成节点列表，列表由DLL分配，因此，需要调用DLBT_FreeDownloaderPeerInfoList函数释放该内存
Declare Function DLBT_GetDownloaderPeerInfoList Lib "DLBT.dll" (ByVal hDownloader As Long, ByRef ppInfo As Long) As Long
Declare Function DLBT_FreeDownloaderPeerInfoList Lib "DLBT.dll" (ByVal ppInfo As Long) As Long

Declare Sub DLBT_SetDHTFilePathName Lib "DLBT.dll" (ByVal dhtFile As String)

'// 可以自定义IO操作的函数（可以将BT里面的读写文件等所有操作外部进行处理，替换内部的读写函数等）
'// 该功能为高级版功能，请联系点量获取技术支持，默认版本中不开放该功能

'// 设置IO操作的接管结构体的指针
Declare Sub DLBT_Set_IO_OP Lib "DLBT.dll" (ByVal op As Long)
'// 对结构体里面的所有函数先赋值默认的函数指针
Declare Sub DLBT_InitDefault_IO_OP Lib "DLBT.dll" (ByVal op As Long)
'// 获取系统内部目前在用的IO对象的指针
Declare Function DLBT_Get_IO_OP Lib "DLBT.dll" () As Long

'// 获取系统原始IO的指针
Declare Function LBT_Get_RAW_IO_OP Lib "DLBT.dll" () As Long

' 辅助函数
Public Declare Function lstrcpy Lib "kernel32" Alias "lstrcpyA" (ByVal lpString1 As String, ByVal lpString2 As Long) As Long


' 辅助函数, 将UINT64类型转换为Double类型，以方便使用
Public Function UINT64ToDouble(ByRef uInt As UINT64) As Double
    Dim ret As Double
    ret = IIf(uInt.HighLong < 0, 4294967296# + uInt.HighLong, uInt.HighLong)
    ret = ret * 4294967296#
    ret = ret + IIf(uInt.LowLong < 0, 4294967296# + uInt.LowLong, uInt.LowLong)
    UINT64ToDouble = ret
End Function


