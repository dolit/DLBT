Imports System.Runtime.InteropServices
Imports System.Text

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
'   官方网站：  http:'www.dolit.cn      http:'blog.dolit.cn
'
'   本VB示例的一些注释,建议对照文档和VC版的DLBT.h中的注释
'
' =======================================================================================

Public Class DLBT

    '' ***************************  以下是内核整体相关的接口 ********************************

    '=======================================================================================
    '  内核的启动和关闭函数
    '=======================================================================================
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Startup", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Startup(ByRef param As DLBT_KERNEL_START_PARAM, ByVal protocol As String, ByVal seedServerMode As Boolean, ByVal productNum As String) As Boolean

    End Function

    ' 获得内核监听的端口
    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetListenPort", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_GetListenPort() As UInt16

    End Function

    ' 最后关闭点量BT内核
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Shutdown", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Shutdown()

    End Sub

    ' 由于关闭的速度可能会比较慢(需要通知Tracker Stop), 所以可以调用该函数提前通知,提高下线速度
    ' 然后最后在程序最后退出时调用DLBT_Shutdown等待真正的结束
    <DllImport("DLBT.dll", EntryPoint:="DLBT_PreShutdown", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_PreShutdown()

    End Sub

    '=======================================================================================
    '  内核的上传下载速度、最大连接用户数的设置
    '=======================================================================================
    ' 速度限制，单位是字节(BYTE)，如果需要限速1M，请输入 1024*1024
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetUploadSpeedLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetUploadSpeedLimit(ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetDownloadSpeedLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetDownloadSpeedLimit(ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetMaxUploadConnection", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetMaxUploadConnection(ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetMaxTotalConnection", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetMaxTotalConnection(ByVal limit As Integer)

    End Sub

    ' 最多发起的连接数（很多连接可能是发起了，但还没连上）；xp系统默认是最多10个，DLBT_ChangeXPConnectionLimit接口后可以突破这个限制。
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetMaxHalfOpenConnection", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetMaxHalfOpenConnection(ByVal limit As Integer)

    End Sub


    ' :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
    ' 用于设置是否对跟自己在同一个局域网的用户限速，limit如果为true，则使用后面参数中的限速数值进行限速，否则不限。默认不对同一个局域网下的用户应用限速。
    ' limit            是否启用局域网限速
    ' downSpeedLimit   如果启用局域网限速，限制上传速度大小，单位字节/秒
    ' uploadSpeedLimit 如果启用局域网限速，限制上传速度大小，单位字节/秒
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetLocalNetworkLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetLocalNetworkLimit(
            ByVal limit As Boolean,
            ByVal downSpeedLimit As Integer,
            ByVal uploadSpeedLimit As Integer
            )

    End Sub

    ' 设置文件扫描校验时的休息参数，circleCount代表循环多少次做一次休息。默认是0（也就是不休息）
    ' sleepMs代表休息多久，默认是1ms
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetFileScanDelay", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetFileScanDelay(ByVal circleCount As Integer, ByVal sleepMs As Integer)

    End Sub

    ' 设置文件下载完成后，是否修改为原始修改时间（制作种子时每个文件的修改时间状态）。调用该函数后，制作的torrent中会包含有每个文件此时的修改时间信息
    ' 用户在下载时，发现有这个信息，并且调用了该函数后，则会在每个文件完成时，自动将文件的修改时间设置为torrent种子中记录的时间
    ' 如果只是下载的机器上启用了该函数，但制作种子的机器上没有使用该函数（种子中没有每个文件的时间信息），则也无法进行时间修改
    <DllImport("DLBT.dll", EntryPoint:="DLBT_UseServerModifyTime", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_UseServerModifyTime(ByVal bUseServerTime As Boolean)

    End Sub


    ' 是否启用UDP穿透传输功能，默认是自动适应，如果对方支持，在tcp无法到达时，自动切换为udp通讯
    <DllImport("DLBT.dll", EntryPoint:="DLBT_EnableUDPTransfer", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_EnableUDPTransfer(ByVal bEnabled As Boolean)

    End Sub

    ' 是否启用伪装Http传输，某些地区（比如马来西亚、巴西的一些网络）对Http不限速，但对P2P限速在20K左右，这种网络环境下，可以启用Http传输
    '  默认是允许伪装Http的传输进入（可以接受他们的通讯），但自己发起的连接不主动伪装。 如果客户群中有这类用户，可以考虑都设置：主动伪装。
    ' 但这种伪装也有副作用，国内有些地区机房（一般是网通）设置了Http必须使用域名，而不能使用IP，而BT传输中，对方没有合法域名，反而会被这种限制截杀
    ' 如果有这种限制，反而主动伪装后会没有速度。所以请根据实际使用选择。
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetP2PTransferAsHttp", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetP2PTransferAsHttp(ByVal bHttpOut As Boolean, ByVal bAllowedIn As Boolean)

    End Sub

    ' 是否使用单独的穿透服务器，如果不使用单独服务器，穿透的协助将由某个双方都能连上的第三方p2p节点辅助完成
    '
    <DllImport("DLBT.dll", EntryPoint:="DLBT_AddHoleServer", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_AddHoleServer(ByVal ip As Boolean, ByVal port As Short) As Boolean

    End Function

    ' 设置服务器的IP，可以多次调用设置多个，用于标记哪些IP是服务器，以便统计从服务器下载到的数据等信息，甚至速度到了一定程度可以断开服务器连接，节省服务器带宽
    <DllImport("DLBT.dll", EntryPoint:="DLBT_AddServerIP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_AddServerIP(ByVal ip As String)

    End Sub
    ' 不去连接这个p2sp的url，可以重复调用. 目的是，如果是服务器上，这个p2sp的url就在本机，就没必要去连接这个url了
    <DllImport("DLBT.dll", EntryPoint:="DLBT_AddBanServerUrl", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_AddBanServerUrl(ByVal url As String)

    End Sub

    ' 保存一次状态文件的条件，内部默认全部下载完成后保存一次。可以调整为自己需要的时间或者上限数目，比如每5分钟保存一次，或者下载100块数据后保存一次
    ' iPeriod 保存间隔，单位是秒。默认是0，代表除非下载完成，否则永不保存
    ' iPieceCount 分块数目，默认0，代表除非下载完成，否则永不保存
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetStatusFileSavePeriod", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_SetStatusFileSavePeriod(ByVal iPeriod As Integer, ByVal iPieceCount As Integer) As Boolean

    End Function

    '=======================================================================================
    '  设置报告Tracker的本机IP，内网下载和供种时设置自己NAT的公网IP会比较有效，详细参考
    '  点量BT的使用说明文档
    '=======================================================================================
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetReportIP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetReportIP(ByVal ip As String)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetReportIP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_GetReportIP(ByVal ip As String) As String

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetUserAgent", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetUserAgent(ByVal agent As String)

    End Sub

    '=======================================================================================
    '  设置磁盘缓存，3.3版本后已对外开放，3.3版本后系统内部自动设置8M缓存，如需调整可使用该
    '  函数进行调整，单位是K，比如要设置1M的缓存，需要传入1024
    '=======================================================================================
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetMaxCacheSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetMaxCacheSize(ByVal size As UInt32)

    End Sub

    ' 一些性能参数设置，默认情况下，点量BT是为了普通网络环境下的下载所用，如果是在千M局域网下
    ' 并且磁盘性能良好，想获得50M/s甚至100M/s的单个文件传输速度，则需要设置这些参数
    ' 具体参数的设置建议，请咨询点量软件获取
    '   socketRecvBufferSize 网络的接收缓冲区，默认是用操作系统默认的缓冲大小
    '   socketSendBufferSize 网络的发送缓冲区，默认用操作系统的默认大小
    '   maxRecvDiskQueueSize 磁盘如果还未写完，超过这个参数后，将暂停接收，等磁盘数据队列小于该参数
    '   maxSendDiskQueueSize 如果小于该参数，磁盘线程将为发送的连接塞入数据，超过后，将暂停磁盘读取

    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetPerformanceFactor", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetPerformanceFactor(
         ByVal socketRecvBufferSize As Integer,
         ByVal socketSendBufferSize As Integer,
         ByVal maxRecvDiskQueueSize As Integer,
         ByVal maxSendDiskQueueSize As Integer)

    End Sub


    '=======================================================================================
    '  DHT相关函数,port是DHT监听的端口（udp端口），如果为0则使用内核监听的TCP端口号监听
    '=======================================================================================
    <DllImport("DLBT.dll", EntryPoint:="DLBT_DHT_Start", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_DHT_Start(ByVal port As UInt16)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_DHT_Stop", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_DHT_Stop()

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_DHT_IsStarted", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_DHT_IsStarted() As Boolean
    End Function


    '=======================================================================================
    ' 时间关系，暂时没有翻译以下部分到VB.Net声明，请仿照其它地方实现，如有困难，请联系作者！
    ' 
    ''=======================================================================================
    ''  设置代理相关函数,商业授权版才有此功能，演示版暂不提供
    ''=======================================================================================
    '    struct(DLBT_PROXY_SETTING)
    '        {
    '            char    proxyHost [256];    ' 代理服务器地址 
    '            Integer     nPort;              ' 代理服务器的端口
    '            char    proxyUser [256];    ' 如果是需要验证的代理,输入用户名
    '            char    proxyPass [256];    ' 如果是需要验证的代理,输入密码

    'Enum DLBT_PROXY_TYPE
    '            {
    '                DLBT_PROXY_NONE,            ' 不使用代理
    '                DLBT_PROXY_SOCKS4,          ' 使用SOCKS4代理，需要用户名
    '                DLBT_PROXY_SOCKS5,          ' 使用SOCKS5代理，无需用户名和密码
    '                DLBT_PROXY_SOCKS5A,         ' 使用需要密码验证的SOCKS5代理，需要用户名和密码
    '                DLBT_PROXY_HTTP,            ' 使用HTTP代理，匿名访问，仅适用于标准的HTTP访问，Tracker和Http跨协议传输，下载则不可以
    '                DLBT_PROXY_HTTPA            ' 使用需要密码验证的HTTP代理
    '            };

    '            DLBT_PROXY_TYPE proxyType;      ' 指定代理的类型
    '        };

    ''=======================================================================================
    ''  标识代理将应用于哪些连接（Tracker、下载、DHT和http跨协议下载等）
    ''=======================================================================================
    '        #define DLBT_PROXY_TO_TRACKER       1  ' 仅对连接Tracker使用代理
    '        #define DLBT_PROXY_TO_DOWNLOAD      2  ' 仅对下载时同用户（Peer）交流使用代理
    '        #define DLBT_PROXY_TO_DHT           4  ' 仅对DHT通讯使用代理，DHT使用udp通讯，需要代理是支持udp的
    '        #define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  ' 仅对HTTP下载使用代理，当任务有http跨协议下载时有效（不包括Tracker）

    '' 对所有均使用代理
    '        #define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)

    '        DLBT_API void WINAPI DLBT_SetProxy (
    '            DLBT_PROXY_SETTING  proxySetting,   ' 代理设置，包括IP端口等 
    '            Integer                 proxyTo         ' 代理应用于哪些连接，就是上面宏定义的几种类型，比如DLBT_PROXY_TO_ALL
    '            ); 

    ''=======================================================================================
    ''  获取代理的设置，proxyTo标识想获得哪一类连接的代理信息，但proxyTo只能单个获取某类连接
    ''  的代理设置，不能使用DLBT_PROXY_TO_ALL这种多个混合选择
    ''=======================================================================================
    '        DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, Integer proxyTo);


    '=======================================================================================
    '  设置加密相关函数,将协议字符串或者所有数据均加密，实现保密传输，在兼容BT协议上突破
    '  绝大部分运营商的封锁。和前面提到的私有协议不同的是，私有协议后将形成自己
    '  的P2P网络，不能同其它BT客户端兼容；但私有协议完全不是BT协议了，没有BT的痕迹，可以穿透
    '  更多运营商的封锁。不同的网络下，可能需要不同设置。配合伪装Http使用，在某些网络下效果更佳
    '=======================================================================================


    Public Enum DLBT_ENCRYPT_OPTION
        DLBT_ENCRYPT_NONE                  ' 不支持任何加密的数据，遇到加密的通讯则断开
        DLBT_ENCRYPT_COMPATIBLE            ' 兼容模式：自己发起的连接不使用加密，但允许别人的加密连接进入，遇到加密的则同对方用加密模式会话； 
        DLBT_ENCRYPT_FULL                  ' 默认值，完整加密：自己发起的连接默认使用加密，同时允许普通和加密的连接连入。遇到加密则用加密模式会话；遇到非加密则用明文模式会话。
        DLBT_ENCRYPT_FORCED                ' 强制加密，仅支持加密通讯，不接受普通连接，遇到不加密的则断开
    End Enum


    ' 加密层级高，理论上会浪费一点CPU，但数据传输安全和突破封锁的能力会有提升
    Public Enum DLBT_ENCRYPT_LEVEL
        DLBT_ENCRYPT_PROTOCOL           ' 仅加密BT的通讯握手协议  －－一般用于防止运营商的阻止
        DLBT_ENCRYPT_DATA               ' 仅加密数据流（数据内容）－－ 用于保密性强的文件传输
        DLBT_ENCRYPT_PROTOCOL_MIX       ' 主动发起的连接使用加密协议模式，但如果对方使用了数据加密，也支持同他使用数据加密模式通讯
        DLBT_ENCRYPT_ALL                ' 协议和数据均主动加密 
    End Enum

    '  encryptOption 加密选项，加密哪种类型或者不加密
    ' encryptLevel 加密的程度，对数据还是协议加密？
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetEncryptSetting", CharSet:=CharSet.Unicode, SetLastError:=True, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_SetEncryptSetting(ByVal encryptOption As DLBT_ENCRYPT_OPTION, ByVal encryptLevel As DLBT_ENCRYPT_LEVEL)

    End Sub

    ' ***************************  以下是单个下载相关的接口 ********************************

    ' 单个下载的状态
    Public Enum DLBT_DOWNLOAD_STATE
        BTDS_QUEUED                 ' 已添加	
        BTDS_CHECKING_FILES         ' 正在检查校验文件
        BTDS_DOWNLOADING_TORRENT        ' 无种子模式下，正在获取种子的信息	
        BTDS_DOWNLOADING                ' 正在下载中
        BTDS_PAUSED                    ' 暂停
        BTDS_FINISHED                   ' 指定的文件下载完成
        BTDS_SEEDING                    ' 供种中（种子中的所有文件下载完成） 	
        BTDS_ALLOCATING                ' 正在预分配磁盘空间 -- 预分配空间，减少磁盘碎片，和 
        ' 启动选项有关，启动时如果选择预分配磁盘方式，可能进入该状态
        BTDS_ERROR                     ' 出错，可能是写磁盘出错等原因，详细原因可以通过调用DLBT_Downloader_GetLastError获知
    End Enum


    ' 文件的分配模式,详见使用说明文档
    Public Enum DLBT_FILE_ALLOCATE_TYPE

        FILE_ALLOCATE_REVERSED = 0   ' 预分配模式,预先创建文件,下载每一块后放到正确的位置
        FILE_ALLOCATE_SPARSE          ' Default mode, more effient and less disk space.NTFS下有效 http:'msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
        FILE_ALLOCATE_COMPACT          ' 文件大小随着下载不断增长,每下载一块数据按次序紧密排在一起,但不是他们的最终位置,下载中不断调整位置,最后文件位置方能确定         .
    End Enum



    '=======================================================================================
    '  启动一个文件的下载，返回这个下载的句柄，以后对该下载任务的所有操作，需要根据句柄来进行
    '   password,   是否加密种子，如果为Null，则是普通种子，否则是种子的密码，试用版不支持，该参数会被忽略
    '   rootPathName,  种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。对单个文件则直接进行改名为指定的这个名字.
    '   bPrivateProtocol,       该种子是否私有协议（可以对不同种子采用不同的下载方式）
    '   bZipTransfer 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
    '=======================================================================================
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Initialize", CharSet:=CharSet.Unicode, SetLastError:=True, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_Initialize(
            ByVal torrentFile As String,
            ByVal outFile As String,
            ByVal statusFile As String,
            ByVal fileAllocateType As DLBT_FILE_ALLOCATE_TYPE,
            ByVal bPaused As Boolean,
            ByVal bQuickSeed As Boolean,
            ByVal password As Byte(),
            ByVal rootPathName As String,
            ByVal bPrivateProtocol As Boolean,
            ByVal bZipTransfer As Boolean
        ) As IntPtr

    End Function

    ' 启动一个内存中的种子文件内容，可用于种子文件不是独立存储或者按某个加密方式加密种子的情况，可以将解密后的内容传入BT内核
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Initialize_FromBuffer", CharSet:=CharSet.Unicode, SetLastError:=True, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_Initialize_FromBuffer(
            ByVal torrentFile As Byte(),
            ByVal dwTorrentFileSize As UInt32,
            ByVal outFile As String,
            ByVal statusFile As String,
            ByVal fileAllocateType As DLBT_FILE_ALLOCATE_TYPE,
            ByVal bPaused As Boolean,
            ByVal bQuickSeed As Boolean,
            ByVal password As Byte(),
            ByVal rootPathName As String,
            ByVal bPrivateProtocol As Boolean,
            ByVal bZipTransfer As Boolean
      ) As IntPtr
    End Function

    ' 从一个Torrent句柄启动一个任务
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Initialize_FromTorrentHandle", CharSet:=CharSet.Unicode, SetLastError:=True, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_Initialize_FromTorrentHandle(
            ByVal torrentHandle As IntPtr,
            ByVal outFile As String,
            ByVal statusFile As String,
            ByVal fileAllocateType As DLBT_FILE_ALLOCATE_TYPE,
            ByVal bPaused As Boolean,
            ByVal bQuickSeed As Boolean,
            ByVal rootPathName As String,
            ByVal bPrivateProtocol As Boolean,
            ByVal bZipTransfer As Boolean
     ) As IntPtr
    End Function


    '      /*
    '       * 时间关系并且以下接口不常用，暂时没有翻译以下部分到C＃声明，请仿照其它地方实现，如有困难，请联系作者！
    '       * 
    '       * 
    '      '（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
    'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
    '		LPCSTR              trackerURL,                     ' tracker的地址
    '		LPCSTR              infoHash,                       ' 文件的infoHash值
    '		LPCWSTR             outPath,        
    '		LPCWSTR             name = NULL,                    ' 在下载到种子之前，是没有办法知道名字的，因此可以传入一个临时的名字
    '		LPCWSTR             statusFile = L"",              ' 状态文件的路径
    '		DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         ' 文件分配模式
    '		BOOL                bPaused = FALSE,
    '		LPCWSTR             rootPathName = NULL,            ' 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
    '      ' 对单个文件则直接进行改名为指定的这个名字
    '		BOOL                bPrivateProtocol = FALSE,
    '		BOOL				bZipTransfer = FALSE			' 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
    '		);

    '      ' 无种子模式的另一个接口，可以直接通过地址下载，地址格式为： DLBT:'xt=urn:btih: Base32 编码过的info-hash [ &dn= Base32后的名字 ] [ &tr= Base32后的tracker的地址 ]  ([]为可选参数)
    '      ' 完全遵循uTorrent的官方BT扩展协议
    'DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromUrl (
    '	LPCSTR              url,                            ' 网址
    '	LPCWSTR             outPath,                        ' 保存目录
    '	LPCWSTR             statusFile = L"",              ' 状态文件的路径
    '	DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,
    '	BOOL                bPaused = FALSE,
    '	LPCWSTR             rootPathName = NULL,            ' 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
    '      ' 对单个文件则直接进行改名为指定的这个名字
    '	BOOL                bPrivateProtocol = FALSE,
    '	BOOL				bZipTransfer = FALSE			' 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
    '	);

    ' * */



    '      ' 专业文件更新接口，任务以新老种子文件为基础，更新新种子文件相对老种子文件变化过的数据块。仅商业版中提供
    '      '   curTorrentFile,    '当前版本的种子文件 
    '      '	newTorrentFile,   '  新版种子文件 
    '      '	curPath,    '  当前文件的路径 
    '      '	statusFile, ' 状态文件的路径
    '      '	type, '  文件分配方式，必须和当前版本一致，新版本也将使用该分配方式。 
    '      '	bPaused ,     ' 是否暂停方式启动 
    '      '	curTorrentPassword,  char[] 
    '      '	newTorrentFilePassword, 
    '      '	rootPathName,
    '      '	bPrivateProtocol,
    '      '	fProgress,         '如果不为NULL，则传出和DLBT_Downloader_GetOldTorrentProgress一样的一个进度
    '      '	bZipTransfer			' 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量

    '      <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_InitializeAsUpdater",  CharSet:=CharSet.Unicode, SetLastError:=true, CallingConvention:=CallingConvention.StdCall)> _
    'Public Shared Function DLBT_Downloader_InitializeAsUpdater ( 
    '	curTorrentFile As String,
    '	newTorrentFile As String, 
    '		curPath As String,  
    '	statusFile As String, 
    '		type As DLBT_FILE_ALLOCATE_TYPE, 
    '		bPaused As Boolean,
    '			curTorrentPassword As char(),   
    '		char[]              newTorrentFilePassword, 
    '		string              rootPathName,
    '	Boolean				bPrivateProtocol,
    '	ref float		    fProgress,
    '	Boolean				bZipTransfer
    ') As IntPtr
    '  End Function

    '      /*
    '  ' 专业文件更新时，传入新老种子，然后直接传出老种子和新种子的差异情况（进度），如果进度是99%，则意味着只有1%的数据需要下载。
    'DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
    '	LPCWSTR             curTorrentFile,    '当前版本的种子文件 
    '	LPCWSTR             newTorrentFile,   '  新版种子文件 
    '	LPCWSTR             curPath,    '  当前文件的路径 
    '	LPCWSTR             statusFile = L"", ' 状态文件的路径
    '	LPCSTR              curTorrentPassword = NULL,   
    '	LPCSTR              newTorrentFilePassword = NULL
    '	);
    '       * 
    '       * 
    '  ' 获取本任务所有的Http连接，内存必须调用DLBT_Downloader_FreeConnections释放
    '      DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, Integer * urlCount);
    '  ' 释放DLBT_Downloader_GetHttpConnections传出的内存
    '      DLBT_API void WINAPI DLBT_Downloader_FreeConnections(LPSTR * urls, Integer urlCount);
    '       */


    ' 关闭任务之前，可以调用该函数停掉IO线程对该任务的操作（异步的，需要调用DLBT_Downloader_IsReleasingFiles函数来获取是否还在释放中）。
    ' 该函数调用后，请直接调用_Release，不可对该句柄再调用其它DLBT_Dwonloader函数。本函数内部会先暂停所有数据下载，然后释放掉文件句柄
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_ReleaseAllFiles", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_ReleaseAllFiles(ByVal hDownloader As IntPtr)

    End Sub
    ' 是否还在释放句柄的过程中
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_IsReleasingFiles", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_IsReleasingFiles(ByVal hDownloader As IntPtr) As Boolean

    End Function


    ' DLBT_Downloader_Release时的一些选项
    Public Enum DLBT_RELEASE_FLAG
        DLBT_RELEASE_NO_WAIT = 0           ' 默认方式Release，直接释放，不等待释放完成
        DLBT_RELEASE_WAIT = 1            ' 等待所有文件都释放完成
        DLBT_RELEASE_DELETE_STATUS = 2     ' 删除状态文件
        DLBT_RELEASE_DELETE_ALL = 4         ' 删除所有文件
    End Enum


    ' 关闭hDownloader所标记的下载任务,如果需要删除文件,可以将第2个参数置为True
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Release", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_Release(ByVal hDownloader As IntPtr, ByVal nReleaseFlag As DLBT_RELEASE_FLAG) As Integer

    End Function

    ' 增加一个http的地址，当该下载文件在某个Web服务器上有http下载时可以使用，web服务器的编码方式最好为UTF-8，如果是其它格式可以联系点量软件进行修改
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_AddHttpDownload", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_AddHttpDownload(ByVal hDownloader As IntPtr, ByVal url As String)

    End Sub

    ' 移除一个P2SP的地址，如果正在下载中，会进行断开并且从候选者列表中移除，不再进行重试
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_RemoveHttpDownload", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_RemoveHttpDownload(ByVal hDownloader As IntPtr, ByVal url As String)

    End Sub

    ' 设置一个Http地址，最多可以建立多少个连接，默认是1个连接. 如果服务器性能好，可以酌情设置，比如设置10个，则是对一个Http地址，可以建立10个连接。
    ' 设置之前如果已经一个Http地址建立好了多个连接，则不受该限制，仅对设置后生效
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetMaxSessionPerHttp", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetMaxSessionPerHttp(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub

    ' 设置任务下载是否按顺序下载,默认是非顺序下载(随机的下载,一般遵循稀有者优先,这种方式速度快),但顺序下载适用于边下边播放
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetDownloadSequence", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetDownloadSequence(ByVal hDownloader As IntPtr, ByVal ifSeq As Boolean)

    End Sub

    ' 下载的状态 以及 暂停和继续的接口
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetState", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetState(ByVal hDownloader As IntPtr) As DLBT_DOWNLOAD_STATE

    End Function

    ' 是否暂停状态
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_IsPaused", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_IsPaused(ByVal hDownloader As IntPtr) As Boolean

    End Function

    ' 暂停
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Pause", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_Pause(ByVal hDownloader As IntPtr)

    End Sub

    ' 继续
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_Resume", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_Resume(ByVal hDownloader As IntPtr)

    End Sub

    '出错状态下的两个接口 （一般只有在极其特殊情况下文件无法写入时才会出错，比如磁盘满了）
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    '   pBufferSize 传入buffer的内存大小，传出出错信息的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetLastError", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Downloader_GetLastError(
       ByVal hDownloader As IntPtr,
       ByVal pBuffer As StringBuilder,
       ByRef pBufferSize As Integer
       ) As Integer

    End Function

    Public Shared Function DLBT_Downloader_GetLastError(ByVal hDownloader As IntPtr) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(1024)
        Dim len As Integer = 1024

        If (DLBT_Downloader_GetLastError(hDownloader, str, len) = 0) Then
            name = str.ToString()
        ElseIf (len > 1024) Then
            str = New System.Text.StringBuilder(len)
            If (DLBT_Downloader_GetLastError(hDownloader, str, len) = 0) Then
                name = str.ToString()
            End If
        End If
        DLBT_Downloader_GetLastError = name
    End Function

    '清除这个错误，尝试重新开始任务
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_ResumeInError", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_ResumeInError(ByVal hDownloader As IntPtr)

    End Sub

    ' 无种子下载的相关接口（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
    ' 无种子下载时，用于判断是否成功获取到了种子信息
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_IsHaveTorrentInfo", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_IsHaveTorrentInfo(ByVal hDownloader As IntPtr) As Boolean

    End Function

    ' 通过种子，制作一个可以不需要种子即可下载的网址，参考DLBT_Downloader_Initialize_FromUrl
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    '   pBufferSize 传入buffer的内存大小，传出URL的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_MakeURL", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Downloader_MakeURL(
        ByVal hDownloader As IntPtr,
        ByVal pBuffer As StringBuilder,
        ByRef pBufferSize As Integer) As Integer
    End Function



    ' 写一个C#中比较容易使用的MakeURL的接口
    Public Shared Function DLBT_Downloader_MakeURL(ByVal hDownloader As IntPtr) As String
        Dim url As String = ""
        Dim str As StringBuilder = New StringBuilder(1024)
        Dim len As Integer = 1024

        If (DLBT_Downloader_MakeURL(hDownloader, str, len) = 0) Then
            url = str.ToString()
        End If

        DLBT_Downloader_MakeURL = url
    End Function


    ' 下载的限速和限制连接的接口
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetDownloadLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetDownloadLimit(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetUploadLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetUploadLimit(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetMaxUploadConnections", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetMaxUploadConnections(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetMaxTotalConnections", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetMaxTotalConnections(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub

    ' 确保任务只上传，不下载
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetOnlyUpload", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetOnlyUpload(ByVal hDownloader As IntPtr, ByVal bUpload As Boolean)

    End Sub

    ' 设置对服务器IP进行下载限速，单位是BYTE(字节），如果需要限速1M，请输入1024*1024
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetServerDownloadLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetServerDownloadLimit(ByVal hDownloader As IntPtr, ByVal limit As Integer)

    End Sub
    ' 设置本任务不再去跟所有的服务器IP建立连接（对于对方连过来的连接，需要BT协议握手通过后，知道是对应于这个下载任务hDownloader的后才再断开）。
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_BanServerDownload", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_BanServerDownload(ByVal hDownloader As IntPtr, ByVal bBan As Boolean)

    End Sub


    ' 下载分享率 (上传/下载的比例）的接口
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetShareRateLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetShareRateLimit(ByVal hDownloader As IntPtr, ByVal fRate As Double)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetShareRate", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetShareRate(ByVal hDownloader As IntPtr) As Double

    End Function


    ' 正在下载的文件的属性（文件大小、完成数、进度等）
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    '   pBufferSize 传入buffer的内存大小，传出名字的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetTorrentName", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Downloader_GetTorrentName(ByVal hDownloader As IntPtr, ByVal pBuffer As StringBuilder, ByRef pBufferSize As Integer) As Integer

    End Function


    ' 写一个VB.Net中易用的DLBT_Downloader_GetTorrentName的接口
    Public Shared Function DLBT_Downloader_GetTorrentName(ByVal hDownloader As IntPtr) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(1024)
        Dim len As Integer = 1024

        If (DLBT_Downloader_GetTorrentName(hDownloader, str, len) = 0) Then
            name = str.ToString()
        Else
            str = New StringBuilder(len)
            If (DLBT_Downloader_GetTorrentName(hDownloader, str, len) = 0) Then
                name = str.ToString()
            End If
        End If
        DLBT_Downloader_GetTorrentName = name
    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetTotalFileSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetTotalFileSize(ByVal hDownloader As IntPtr) As UInt64

    End Function

    ' 共有选择了多少下载量，不包含不想下载的文件
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetTotalWanted", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetTotalWanted(ByVal hDownloader As IntPtr) As UInt64

    End Function

    ' 在选定的文件中，下载了多少
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetTotalWantedDone", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetTotalWantedDone(ByVal hDownloader As IntPtr) As UInt64

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetProgress", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetProgress(ByVal hDownloader As IntPtr) As Double

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetDownloadedBytes", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetDownloadedBytes(ByVal hDownloader As IntPtr) As UInt64

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetUploadedBytes", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetUploadedBytes(ByVal hDownloader As IntPtr) As UInt64

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetDownloadSpeed", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetDownloadSpeed(ByVal hDownloader As IntPtr) As UInt32

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetUploadSpeed", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetUploadSpeed(ByVal hDownloader As IntPtr) As UInt32

    End Function

    ' 获得该任务的节点的数目，数目的参数为Integer的指针，如果不想要某个值，则传NULL
    '   hDownloader As IntPtr,         ' 下载任务的句柄
    '   out Integer connectedCount,     ' 该任务连接上的节点数（用户数）
    '   out Integer totalSeedCount,     ' 总的种子数目，如果Tracker不支持scrap，则返回-1
    '   out Integer seedsConnected,     ' 自己连上的种子数
    '   out Integer inCompleteCount,    ' 未下完的人数，如果Tracker不支持scrap，则返回-1
    '   out Integer totalCurrentSeedCount, ' 当前在线的总的下载完成的人数（包括连上的和未连上的）
    '   out Integer totalCurrentPeerCount  ' 当前在线的总的下载的人数（包括连上的和未连上的）
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetPeerNums", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_GetPeerNums(
            ByVal hDownloader As IntPtr,
            ByRef connectedCount As Integer,
            ByRef totalSeedCount As Integer,
            ByRef seedsConnected As Integer,
            ByRef inCompleteCount As Integer,
            ByRef totalCurrentSeedCount As Integer,
            ByRef totalCurrentPeerCount As Integer)

    End Sub

    ' 单个种子中包含多个文件时的一些接口,index为文件的序列号，从0开始
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetFileCount", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetFileCount(ByVal hDownloader As IntPtr) As Integer

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetFileSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetFileSize(ByVal hDownloader As IntPtr, ByVal index As Integer) As UInt64

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetFileOffset", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetFileOffset(ByVal hDownloader As IntPtr, ByVal index As Integer) As UInt64
    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_IsPadFile", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_IsPadFile(ByVal hDownloader As IntPtr, ByVal index As Integer) As Boolean

    End Function

    '   hDownloader 下载任务的句柄
    '   index 文件的序号
    '   pBuffer 出文件名指针
    '   pBufferSize 传入buffer的大小，传出文件名的实际长度
    '   needFullPath  是否需要全部的路径还是只需要文件在种子中的相对路径  
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetFilePathName", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetFilePathName(
            ByVal hDownloader As IntPtr,
            ByVal index As Integer,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer,
            ByVal needFullPath As Boolean
            ) As Integer

    End Function

    ' 写一个C#中比较容易使用的DLBT_Downloader_GetFilePathName的接口
    '   hDownloader 下载任务的句柄
    '   index 文件的序号
    '   fileName 传出文件名
    '   needFullPath    是否需要全部的路径还是只需要文件在种子中的相对路径  
    Public Shared Function DLBT_Downloader_GetFilePathName(
        ByVal hDownloader As IntPtr,
        ByVal index As Integer,
        ByRef fileName As String,
        ByVal needFullPath As Boolean
        ) As Integer
        Dim fName As StringBuilder = New System.Text.StringBuilder(1024)
        Dim len As Integer = 1024

        Dim ret As Integer = DLBT_Downloader_GetFilePathName(hDownloader, index, fName, len, needFullPath)
        If (ret = 0) Then
            fileName = fName.ToString()
        Else
            fName = New System.Text.StringBuilder(len)
            ret = DLBT_Downloader_GetFilePathName(hDownloader, index, fName, len, needFullPath)
            If (ret = 0) Then
                fileName = fName.ToString()
            End If
        End If

        DLBT_Downloader_GetFilePathName = ret
    End Function



    ' 取文件的下载进度，该操作需要进行较多操作，建议仅在必要时使用
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetFileProgress", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetFileProgress(ByVal hDownloader As IntPtr, ByVal index As Integer) As Single

    End Function


    '    /*
    '     *  时间关系，暂时没有翻译以下部分到C＃声明，请仿照其它地方实现，如有困难，请联系作者！
    '     * 
    '     * enum DLBT_FILE_PRIORITIZE
    '        {
    '            DLBT_FILE_PRIORITY_CANCEL        =   0,     ' 取消该文件的下载
    '            DLBT_FILE_PRIORITY_NORMAL,                  ' 正常优先级
    '            DLBT_FILE_PRIORITY_ABOVE_NORMAL,            ' 高优先级 
    '    DLBT_FILE_PRIORITY_MAX()                      ' 最高优先级（如果有该优先级的文件还未下完，不会下载低优先级的文件）
    '        };

    '' 设置文件的下载优先级，比如可以用于取消某个指定文件的下载,index表示文件的序号
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_SetFilePrioritize (
    '            HANDLE                  hDownloader, 
    '            Integer                     index,              ' 文件序号
    '            DLBT_FILE_PRIORITIZE    prioritize,         ' 优先级
    '    BOOL(bDoPriority = True)  ' 是否立即应用这个设置（如果有多个文件需要设置，建议暂时不立即应用，让最后一个文件应用设置
    '' 或者可以主动调用DLBT_Downloader_ApplyPrioritize函数来应用，因为每应用一次设置都要对所有Piece
    '' 操作一遍，比较麻烦，所以应该一起应用
    '            );

    '' 立即应用优先级的设置
    '        DLBT_API void WINAPI DLBT_Downloader_ApplyPrioritize (HANDLE hDownloader);

    '' 获取当前每个分块的状态，比如可以用于判断是否需要去更新（是否已经拥有了该块）。
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_GetPiecesStatus (
    '            HANDLE                  hDownloader,    ' 任务句柄
    '            bool                *   pieceArray,     ' 标记每个块是否本地已是最新的数组
    '            Integer                     arrayLength,    ' 数组的长度
    '            Integer                 *   pieceDownloaded ' 已经下载的分块的数目，在显示下载的分块的图形时，该参数比较有用。如果发现该数字和上次获取时没有
    '' 变化，则可以不需要重画当前的分块状态图
    '            );

    '' 设置块的下载优先级，可以用于分块的局部更新（大文件的局部更新等），index表示块的序号
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_SetPiecePrioritize (
    '            HANDLE                  hDownloader, 
    '            Integer                     index,              ' 块序号
    '            DLBT_FILE_PRIORITIZE    prioritize,         ' 优先级
    '    BOOL(bDoPriority = True)  ' 是否立即应用这个设置（如果有多个块需要设置，建议暂时不立即应用，让最后一个块应用设置
    '' 或者可以主动调用DLBT_Downloader_ApplyPrioritize函数来应用，因为每应用一次设置都要对所有Piece
    '' 操作一遍，比较麻烦，所以应该一起应用
    '            );

    '    */

    ' 设置手工指定的Peer信息
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_AddPeerSource", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_AddPeerSource(ByVal hDownloader As IntPtr, ByVal ip As String, ByVal port As Int16)

    End Sub

    ' 该函数会将下载目录下存在，但torrent记录中不存在的文件全部删除，对单个文件的种子无效。请慎重使用。
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_DeleteUnRelatedFiles", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_DeleteUnRelatedFiles(ByVal hDownloader As IntPtr) As Long

    End Function

    '    /*
    '    ' 获取每个文件的Hash值，只有制作种子时使用bUpdateExt才能获取到
    '    DLBT_API HRESULT WINAPI DLBT_Downloader_GetFileHash (
    '     HANDLE      hDownloader,        ' 下载任务的句柄
    '     Integer         index,              ' 要获取的文件的序号，piece的数目可以通过DLBT_Downloader_GetFileCount获得
    '     LPSTR       pBuffer,            ' 传出Hash字符串
    '     Integer     *   pBufferSize         ' 传入pBuffer的大小，pieceInfoHash固定为20个字节，因此此处应该是20的长度。
    '     );

    '    '''''''''''   Move的相关接口   ''''''/
    '    ' Move的结果
    'Enum DOWNLOADER_MOVE_RESULT
    '    {
    '     DLBT_MOVED	= 0,	'移动成功
    '     DLBT_MOVE_FAILED,	'移动失败
    '     DLBT_MOVING         '正在移动
    '    };

    ''移动到哪个目录，如果是同一磁盘分区，是剪切；如果是不同分区，是复制后删除原始文件。由于操作是异步操作，所以立即返回
    ''结果使用DLBT_Downloader_GetMoveResult去获取
    '    DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCWSTR savePath);
    ''查看移动操作的结果
    '    DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
    '     HANDLE			hDownloader,   ' 下载任务的句柄
    '     LPSTR			errorMsg,      ' 用于返回出错信息的内存，在DLBT_MOVE_FAILED状态下这里返回出错的详情。如果传入NULL，则不返回错误信息
    '     Integer				msgSize		   ' 出错信息内存的大小
    '     ); 

    '     * */

    ' 获得可显示的文件Hash值
    '   hDownloader 下载任务的句柄
    '   pBuffer 传出InfoHash的内存缓冲
    '   pBufferSize 传入缓冲的大小，传出实际的InfoHash的长度

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetInfoHash", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Downloader_GetInfoHash(
            ByVal hDownloader As IntPtr,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function


    Public Shared Function DLBT_Downloader_GetInfoHash(ByVal hDownloader As IntPtr) As String
        Dim str As String = ""
        Dim sb As StringBuilder = New StringBuilder(128)
        Dim size As Integer = 128

        Dim ret As Integer = DLBT_Downloader_GetInfoHash(hDownloader, sb, size)
        If (ret = 0) Then
            str = sb.ToString()
        Else
            sb = New StringBuilder(size)
            ret = DLBT_Downloader_GetInfoHash(hDownloader, sb, size)
            If (ret = 0) Then
                str = sb.ToString()
            End If
        End If

        DLBT_Downloader_GetInfoHash = str
    End Function


    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetPieceCount", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetPieceCount(ByVal hDownloader As IntPtr) As Integer

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_GetPieceSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_GetPieceSize(ByVal hDownloader As IntPtr) As Integer

    End Function


    '操作状态文件相关
    ' 内部默认每15分钟保存一次状态文件，可以调整为自己需要的时间，单位是秒
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetStatusFileSavePeriod", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_SetStatusFileSavePeriod(ByVal hDownloader As IntPtr, ByVal dwPeriod As Integer) As Boolean

    End Function

    ' 主动保存一次状态文件，通知内部的下载线程后立即返回，是异步操作，可能会有一点延迟才会写
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SaveStatusFile", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SaveStatusFile(ByVal hDownloader As IntPtr)

    End Sub

    'bOnlyPieceStatus： 是否只保存一些文件分块信息，便于服务器上生成后发给每个客户机；客户机就不用再比较了，直接快速启动. 默认是FALSE，也就是全部信息都保存
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_SetStatusFileMode", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_SetStatusFileMode(ByVal hDownloader As IntPtr, ByVal bOnlyPieceStatus As Boolean)

    End Sub

    ' 查看保存状态文件是否完成
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_IsSavingStatus", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Downloader_IsSavingStatus(ByVal hDownloader As IntPtr) As Boolean

    End Function

    '    /*
    '     * ' 向BT系统中写入通过其它方式接收来的数据块。offset为该数据块在整个文件（文件夹）中的偏移量，size为数据块大小，data为数据缓冲区
    '' 成功返回S_OK，失败为其它，失败原因可能是该块不需要再次传输了。 本函数仅VOD增强版中有效
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);

    '' 手工添加一块完整的数据进来 本函数仅VOD增强版中有效
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
    '            HANDLE                  hDownloader,
    '            Integer                     piece,          '分块序号
    '            char            *       data,           '数据本身
    '    bool(bOverWrite)      '如果已经有了，是否覆盖
    '            );


    '' 每次要替换一个数据块时调用一下这个回调，外部可以根据这个回调显示替换的进度；以及是否终止整个替换工作（功能相当于：DLBT_Downloader_CancelReplace)
    '' 返回FALSE代表希望立即终止，TRUE代表继续。
    '' 一个分块可能会包括多个小文件（或者大文件的尾部，多文件粘连的地方），因此一个分块pieceIndex可能会对应了多个文件片段。本回调是替换一个文件片段时触发一次
    '        typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
    '              IN void * pContext,                   ' 回调的上下文（通过DLBT_Downloader_ReplacePieceData的pContext参数传入），这里传回去，便于外面处理
    '' 比如，外部传入一个this指针，回调的时候再通过这个指针知道是对应哪个对象
    '              IN Integer pieceIndex,                    '本次要替换的数据位于哪个分块（分块在torrent中的索引）
    '              IN Integer replacedPieceCount,            '已经完成了多少个piece的替换
    '              IN Integer totalNeedReplacePieceCount,    '总共有多少个要替换的piece分块
    '              IN Integer fileIndex,                     '本次要替换的数据位于哪个文件
    '              IN UINT64 offset,                     '在这个文件中，这块数据的偏移量
    '              IN UINT64 size,                       '这块数据的总大小（距离偏移量）
    '              IN Integer replacedFileSliceCount,        '已经完成了多少个文件片段的替换                                  
    '              IN Integer totalFileSliceCount            '总共有多少个需要替换的文件片段
    '              );

    '' 替换数据块的接口：将某块数据直接替换到目标文件的相同位置，一般用于：下载时将需要下载的分块自动下载到一个临时目录，完成后再替换回原始文件
    '' 这样下载过程中原始文件可以正常使用，并保留了只下载部分数据的优点。
    '' 该函数是立即返回，如果HRESULT返回的不是S_OK，说明出错，需要查看返回值。
    '' 如果返回S_OK，则内部会启动线程来进行替换，中间的结果随时通过DLBT_Downloader_GetReplaceResult来进行查看结果。随时可以调用：DLBT_Downloader_CancelReplace进行取消线程操作
    '        DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
    '         HANDLE			hDownloader,		'下载任务句柄
    '         Integer   *			pieceArray,			' 需要将哪些分块替换，是一个Integer数组
    '         Integer				arrayLength,		' 分块数组的长度
    '         LPCWSTR			destFilePath,		' 需要替换的文件（文件夹）的目录。比如：E:\Test\1.rar或者E:\Test\Game\天龙八部 等。
    '         LPCWSTR			tempRootPathName = NULL,	' 临时目录下载时，如果使用了rootPathName，则这里也要设置上，以便从这个文件（文件夹）下读取数据块
    '         LPCWSTR			destRootPathName = NULL,	' 需要替换的那个下载任务，如果使用了rootPathName，则这里也要设置上，以便对这个文件（文件夹）进行替换
    '            LPVOID          pContext = NULL,
    '            DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  '接收进度，并可以随时取消的回调
    '         );

    '' ReplacePieceData的一些状态，可以通过DLBT_Downloader_GetReplaceResult来进行查看
    'Enum DLBT_REPLACE_RESULT
    '        {
    '            DLBT_RPL_IDLE  = 0,     '尚未开始替换
    '            DLBT_RPL_RUNNING,       '正在运行中
    '            DLBT_RPL_SUCCESS,       '替换成功
    '            DLBT_RPL_USER_CANCELED, '替换了一半，用户取消掉了
    '            DLBT_RPL_ERROR,         '出错，可以通过hrDetail来获取详细信息，参考：DLBT_Downloader_GetReplaceResult
    '        };

    '' 获取替换数据的结果
    '        DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
    '            HANDLE          hDownloader,        '下载任务句柄
    '            HRESULT  *      hrDetail,           '如果是有出错，返回详细的出错原因
    '            BOOL     *      bThreadRunning      'Replace的整个操作是否结束了（出错也会立即结束的）
    '            );

    '' 中间随时取消替换数据的操作（不建议取消，因为有可能会替换到一半，这样有些文件是不完整的）
    '        DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);
    '     * */


    ' ***************************  以下是种子相关的接口 ********************************
    Public Enum DLBT_TORRENT_TYPE
        USE_PUBLIC_DHT_NODE = 0   ' 使用公共的DHT网络资源
        NO_USE_PUBLIC_DHT_NODE        ' 不使用公共的DHT网络节点
        ONLY_USE_TRACKER              ' 仅使用Tracker，禁止DHT网络和用户来源交换（私有种子）
    End Enum


    '    pieceSize 文件的分块大小
    '    file,           ' 文件名或者目录（目录则将目录下所有文件制作一个种子）
    '    publisher,      ' 发布者信息
    '    publisherUrl,   ' 发布者的网址
    '    comment,        ' 评论和描述    
    '    torrentType,  ' 标记种子的类型
    '    nPercent,       ' 制作种子的进度
    '    bCancel,        ' 用于中间取消种子的制作
    '    minPadFileSize,  ' 文件大于minPadFileSize后就进行补齐优化，传统BT下载时，一个分块可能横跨两个文件，使用这个对齐后
    '       每个文件会单独分块，不和其它文件关联。这样一个文件发生变化后不会影响到其它文件，一般用于文件的更新。-1代表不对齐。0代表对任意大小的文件都对齐
    '       如果专业更新模式（bUpdateExt为TRUE），则强制对齐，如果minPadFileSize设置小于pieceSize（比如-1），那么强制对齐会自动使用pieceSize作为最小对齐标准
    '       也就是说大于一个分块的文件都会自动对齐；小于一个分块的文件会被用于对齐
    '   bUpdateExt  '是否增加用于更新的点量扩展信息，可以用于DLBT_Downloader_InitializeAsUpdater接口。仅商业版有效。bUpdateExt会做一些额外工作，如果只是普通下载
    '       而不是文件的比较更新，可以不使用该参数。该参数使用时，pieceSize不建议为0，否则新老torrent的分块大小有可能不同，导致更新量会增加。


    <DllImport("DLBT.dll", EntryPoint:="DLBT_CreateTorrent", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_CreateTorrent(
            ByVal pieceSize As Integer,
            ByVal file As String,
            ByVal publisher As String,
            ByVal publisherUrl As String,
            ByVal comment As String,
            ByVal torrentType As DLBT_TORRENT_TYPE,
            ByRef nPercent As Integer,
            ByVal bCancel As IntPtr,
            ByVal minPadFileSize As Integer,
            ByVal bUpdateExt As Boolean
            ) As IntPtr

    End Function

    '   hTorrent 种子的句柄
    '   trackerURL  tracker的地址，可以是http Tracker或udp Tracker
    '   tier 优先级和顺序
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_AddTracker", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_AddTracker(
            ByVal hTorrent As IntPtr,
            ByVal trackerURL As String,
            ByVal tier As Integer
    ) As Integer

    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_RemoveAllTracker", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_RemoveAllTracker(ByVal hDownloader As IntPtr)

    End Sub

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Downloader_AddHttpTrackerExtraParams", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Downloader_AddHttpTrackerExtraParams(ByVal hDownloader As IntPtr, ByVal extraParams As String)

    End Sub

    ' 移除种子中的所有Tracker
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_RemoveAllTracker", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Torrent_RemoveAllTracker(ByVal hTorrent As IntPtr)

    End Sub

    ' 指定种子可以使用的http源，如果下载的客户端支持http跨协议下载，则会自动从该地址进行下载
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_AddHttpUrl", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_Torrent_AddHttpUrl(ByVal hTorrent As IntPtr, ByVal httpUrl As String)

    End Sub

    ' 保存为torrent文件,filePath为路径（包括文件名），如果password不为空，则代表需要对种子进行加密
    <DllImport("DLBT.dll", EntryPoint:="DLBT_SaveTorrentFile", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_SaveTorrentFile(ByVal hTorrent As IntPtr, ByVal filePath As String, ByVal password As IntPtr, ByVal bUseHashName As Boolean, ByVal extName As String) As Integer
    End Function


    Public Shared Function DLBT_SaveTorrentFile(ByVal hTorrent As IntPtr, ByVal filePath As String, ByVal password As String, ByVal bUseHashName As Boolean, ByVal extName As String) As Integer
        Dim hPassword As IntPtr = IntPtr.Zero
        If (password <> "" And password.Length > 0) Then
            hPassword = Marshal.StringToHGlobalAnsi(password)
        End If
        Dim result As Integer = DLBT_SaveTorrentFile(hTorrent, filePath, hPassword, bUseHashName, extName)

        ' Always free the unmanaged string.
        If (hPassword <> IntPtr.Zero) Then
            Marshal.FreeHGlobal(hPassword)
        End If

        DLBT_SaveTorrentFile = result
    End Function


    ' 释放torrent文件的句柄
    <DllImport("DLBT.dll", EntryPoint:="DLBT_ReleaseTorrent", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_ReleaseTorrent(ByVal hTorrent As IntPtr)

    End Sub


    ' ***************************  以下是种子相关的接口 ********************************


    ' 打开一个种子句柄，便于修改或者读取信息进行操作；用完后，需要调用DLBT_ReleaseTorrent释放torrent文件的句柄
    '   torrentFile 种子文件全路径
    '   password 是否加密种子，如果为Null，则是普通种子，否则是种子的密码,以此密码进行解密 
    <DllImport("DLBT.dll", EntryPoint:="DLBT_OpenTorrent", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_OpenTorrent(
            ByVal torrentFile As String,
            ByVal password As IntPtr
            ) As IntPtr
    End Function

    '   torrentFile 种子文件全路径
    '   password 是否加密种子，如果为空，则是普通种子，否则是种子的密码,以此密码进行解密 
    Public Shared Function DLBT_OpenTorrent(
        ByVal torrentFile As String,
        ByVal password As String
        ) As IntPtr

        Dim hPassword As IntPtr = IntPtr.Zero
        If (password.Length > 0) Then
            hPassword = Marshal.StringToHGlobalAnsi(password)
        End If

        Dim hTorrent As IntPtr = DLBT_OpenTorrent(torrentFile, hPassword)

        ' Always free the unmanaged string.
        If (hPassword <> IntPtr.Zero) Then
            Marshal.FreeHGlobal(hPassword)
        End If

        Return hTorrent
    End Function

    'torrentFile 可以打开内存中的字符流数据
    '   dwTorrentFileSize 种子内容的大小
    '   password 是否加密种子，如果为Null，则是普通种子，否则是种子的密码,以此密码进行解密
    <DllImport("DLBT.dll", EntryPoint:="DLBT_OpenTorrentFromBuffer", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_OpenTorrentFromBuffer(
            ByVal torrentFile As Byte(),
            ByVal dwTorrentFileSize As Integer,
            ByVal password As IntPtr
            ) As IntPtr

    End Function

    '   hTorrent 种子文件句柄
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回评论的实际大小
    '   pBufferSize 传入评论的内存大小，传出评论的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetComment", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Torrent_GetComment(
            ByVal hTorrent As IntPtr,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function

    ' 写一个C#中易用的DLBT_Torrent_GetComment的接口
    Public Shared Function DLBT_Torrent_GetComment(ByVal hTorrent As IntPtr) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(1024)
        Dim len As Integer = 1024
        If (DLBT_Downloader_GetTorrentName(hTorrent, str, len) = 0) Then
            name = str.ToString()
        End If

        Return name
    End Function



    ' 返回创建软件的信息
    '   hTorrent 种子文件句柄
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回作者信息的实际大小
    '   pBufferSize 传入存放信息的内存大小，传出作者信息的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetCreator", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Torrent_GetCreator(
            ByVal hTorrent As IntPtr,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function

    ' 写一个C#中易用的DLBT_Torrent_GetCreator的接口
    Public Function DLBT_Torrent_GetCreator(ByVal hTorrent As IntPtr) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(1024)
        Dim len As Integer = 1024
        If (DLBT_Torrent_GetCreator(hTorrent, str, len) = 0) Then
            name = str.ToString()
        End If

        Return name
    End Function

    'TODO:
    '' 返回发布者信息
    '    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetPublisher", SetLastError:=true, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    '    Private Shared Function  DLBT_Torrent_GetPublisher (
    '        hTorrent As IntPtr ,       ' 种子文件句柄
    '        pBuffer As StringBuilder,        ' 用于返回信息的内存，可以为空，为空则在pBufferSize中返回作者信息的实际大小
    '        ByRef pBufferSize As Integer     ' 传入存放信息的内存大小，传出作者信息的实际大小
    '        ) As Integer

    '    ' 写一个C#中易用的DLBT_Torrent_GetPublisher的接口
    '    public static string DLBT_Torrent_GetPublisher (hTorrent As IntPtr)
    '    {
    '        string name = "";
    '        System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
    '        Integer len = 1024;
    '        if (DLBT_Torrent_GetPublisher(hTorrent, str, ref len) == 0)
    '            name = str.ToString () End Function
    '        return name;
    '    }

    '        ' 返回发布者网址
    '    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetPublisherUrl", SetLastError:=true, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    '    Private Shared Function Integer DLBT_Torrent_GetPublisherUrl (
    '        hTorrent As IntPtr ,       ' 种子文件句柄
    '        pBuffer As StringBuilder,        ' 用于返回信息的内存，可以为空，为空则在pBufferSize中返回实际大小
    '        ByRef pBufferSize As Integer     ' 传入存放信息的内存大小，传出实际大小
    '        );

    '        ' 写一个C#中易用的DLBT_Torrent_GetPublisherUrl的接口
    '    public static string DLBT_Torrent_GetPublisherUrl (hTorrent As IntPtr)
    '    {
    '        string name = "";
    '        System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
    '        Integer len = 1024;
    '        if (DLBT_Torrent_GetPublisherUrl(hTorrent, str, ref len) == 0)
    '            name = str.ToString () End Function
    '        return name;
    '    }

    '            ' 通过种子，制作一个可以不需要种子即可下载的网址，参考DLBT_Downloader_Initialize_FromUrl
    '    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_MakeURL", SetLastError:=true, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    '    Private Shared Function Integer DLBT_Torrent_MakeURL (
    '        hTorrent As IntPtr ,       ' 种子文件句柄
    '        pBuffer As StringBuilder,        ' 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    '        ByRef pBufferSize As Integer     ' 传入buffer的内存大小，传出URL的实际大小
    '        );

    '            ' 写一个C#中易用的DLBT_Torrent_MakeURL的接口
    '    public static string DLBT_Torrent_MakeURL (hTorrent As IntPtr)
    '    {
    '        string name = "";
    '        System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
    '        Integer len = 1024;
    '        if (DLBT_Torrent_MakeURL(hTorrent, str, ref len) == 0)
    '            name = str.ToString () End Function
    '        return name;
    '    }

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetTrackerCount", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetTrackerCount(ByVal hTorrent As IntPtr) As Integer

    End Function

    '   hTorrent 种子文件句柄
    '   index Tracker的序号，从0开始
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetTrackerUrl", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetTrackerUrl(
            ByVal hTorrent As IntPtr,
            ByVal index As Integer
            ) As String
    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetTotalFileSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetTotalFileSize(ByVal hTorrent As IntPtr) As UInt64

    End Function

    ' 单个种子中包含多个文件时的一些接口,index为文件的序列号，从0开始
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetFileCount", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetFileCount(ByVal hTorrent As IntPtr) As Integer

    End Function
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_IsPadFile", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_IsPadFile(ByVal hTorrent As IntPtr, ByVal index As Integer) As Boolean

    End Function

    '   hTorrent 种子文件句柄
    '   index 要获取大小的文件的序号，文件序号是从0开始的
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetFileSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetFileSize(
            ByVal hTorrent As IntPtr,
            ByVal index As Integer
            ) As UInt64

    End Function

    '   hTorrent 种子文件句柄
    '   index 要获取名字的文件的序号，文件序号是从0开始的
    '   pBuffer 用于传出文件名，可以为空，为空则在pBufferSize中返回实际大小
    '   pBufferSize 传入buffer的大小，传出文件名的实际长度 
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetFilePathName", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Torrent_GetFilePathName(
            ByVal hTorrent As IntPtr,
            ByVal index As Integer,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function

    ' 写一个C#中易用的DLBT_Torrent_GetFilePathName的接口
    Public Shared Function DLBT_Torrent_GetFilePathName(ByVal hTorrent As IntPtr, ByVal index As Integer) As String
        Dim name As String = ""
        Dim str = New StringBuilder(1024)
        Dim len As Integer = 1024
        If (DLBT_Torrent_GetFilePathName(hTorrent, index, str, len) = 0) Then
            name = str.ToString()
        End If

        Return name
    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetPieceCount", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetPieceCount(ByVal hTorrent As IntPtr) As Integer

    End Function
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetPieceSize", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_Torrent_GetPieceSize(ByVal hTorrent As IntPtr) As Integer

    End Function

    ' 获取种子中每个分块的Hash值
    '   hTorrent 种子文件句柄
    '   index 要获取的Piece的序号，piece的数目可以通过DLBT_Torrent_GetPieceCount获得
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回InfoHash的实际大小
    '   pBufferSize 传入buffer的内存大小，传出InfoHash的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetPieceInfoHash", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Torrent_GetPieceInfoHash(
            ByVal hTorrent As IntPtr,
            ByVal index As Integer,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function

    ' 写一个C#中易用的DLBT_Torrent_GetPieceInfoHash的接口
    Public Shared Function DLBT_Torrent_GetPieceInfoHash(ByVal hTorrent As IntPtr, ByVal index As Integer) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(128)
        Dim len As Integer = 128
        If (DLBT_Torrent_GetPieceInfoHash(hTorrent, index, str, len) = 0) Then
            name = str.ToString()
        End If

        Return name
    End Function


    ' 获得种子文件的InfoHash值
    '   hTorrent 种子文件句柄
    '   pBuffer 用于返回信息的内存，可以为空，为空则在pBufferSize中返回InfoHash的实际大小
    '   pBufferSize 传入buffer的内存大小，传出InfoHash的实际大小
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Torrent_GetInfoHash", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_Torrent_GetInfoHash(
            ByVal hTorrent As IntPtr,
            ByVal pBuffer As StringBuilder,
            ByRef pBufferSize As Integer
            ) As Integer

    End Function

    ' 写一个C#中易用的DLBT_Torrent_GetInfoHash的接口
    Public Shared Function DLBT_Torrent_GetInfoHash(ByVal hTorrent As IntPtr) As String
        Dim name As String = ""
        Dim str As StringBuilder = New StringBuilder(128)
        Dim len As Integer = 128
        If (DLBT_Torrent_GetInfoHash(hTorrent, str, len) = 0) Then
            name = str.ToString()
        End If

        Return name
    End Function




    '/****
    '        ' **************************** 以下是种子市场有关的接口 *****************************
    '        ' 种子市场仅在商业版本中提供，免费试用版中暂时不提供该功能
    '        struct(DLBT_TM_ITEM)     '标记种子市场中的一个种子文件
    '{
    ' DLBT_TM_ITEM(): fileSize (0) {}

    ' UINT64  fileSize;      ' the size of this file
    ' char	name[256];     ' 名字
    ' LPCSTR	url;           ' 用于下载的url
    ' LPCSTR  comment;       ' 种子描述
    '};

    '        struct(DLBT_TM_LIST) '标记种子市场中的一批种子文件（多个）
    '{
    ' Integer				count;      '数目
    ' DLBT_TM_ITEM	items[1];   '种子列表
    '};

    '        ' 在本机的种子市场中添加一个种子文件
    'DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);
    '        ' 在本机的种子市场中移除一个种子文件
    'DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);

    '        ' 获取本机种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
    'DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
    '        ' 获取其它人种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
    'DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);

    '        ' 释放DLBT_TM_GetSelfTorrentList或者DLBT_TM_GetRemoteTorrentList获取到的种子列表的内存
    'DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);

    '        ' 清空所有获取到的其它人的种子列表
    'DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList () End Function
    '        ' 清空所有自己种子市场中的种子列表
    'DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList () End Function

    '        ' 设置一下是否启用种子市场，默认不启用。
    'DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);
    ' */


    ' *********************  以下是防火墙和UPnP穿透等P2P辅助性接口 **********************

    ' 端口的类型
    Public Enum PORT_TYPE
        TCP_PORT = 1           ' TCP 端口
        UDP_PORT          ' UDP 端口 TODO:UDP_PORT
    End Enum

    '  将某个应用程序添加到ICF防火墙的例外中去，可独立于内核应用，不启动内核仍然可以使用该函数
    '   appFilePath 程序的路径（包括exe的名字）
    '   ruleName 在防火墙的例外中显示的这条规则的名字
    <DllImport("DLBT.dll", EntryPoint:="DLBT_AddAppToWindowsXPFirewall", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_AddAppToWindowsXPFirewall(
                ByVal appFilePath As String,
                ByVal ruleName As String
                ) As Boolean

    End Function

    ' 将某个端口加入UPnP映射，点量BT内部的所有端口已经自动加入，不需要再次加入，这里提供出来是供外部程序加入自己所需端口
    '   nExternPort NAT要打开的外部端口
    '   nLocalPort 映射的内部端口（局域网端口），一般是程序在监听的端口
    '   nPortType 端口类型（UDP还是TCP）
    '   appName 在NAT上显示的这条规则的名字
    <DllImport("DLBT.dll", EntryPoint:="DLBT_AddUPnPPortMapping", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Sub DLBT_AddUPnPPortMapping(
                                             ByVal nExternPort As UInt16,
                                             ByVal nLocalPort As UInt16,
                                             ByVal nPortType As PORT_TYPE,
                                             ByVal appName As String)
    End Sub


    ' 获得当期系统的并发连接数限制，如果返回0则表示系统可能不是受限的XP系统，无需修改连接数限制
    ' 可独立于内核使用，启动内核前即可使用
    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetCurrentXPLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_GetCurrentXPLimit() As UInt32
    End Function

    ' 修改XP的并发连接数限制，返回BOOL标志是否成功
    <DllImport("DLBT.dll", EntryPoint:="DLBT_ChangeXPConnectionLimit", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Public Shared Function DLBT_ChangeXPConnectionLimit(ByVal num As UInt32) As Boolean

    End Function


    ' [StructLayout(LayoutKind.Sequential)]
    Public Structure KERNEL_INFO
        Public port As UInt16                          ' 监听端口
        Public dhtStarted As Boolean                   ' DHT是否启动
        Public totalDownloadConnectionCount As Int32  ' 总的下载连接数
        Public downloadCount As Int32                ' 下载任务的个数
        Public totalDownloadSpeed As Int32           ' 总下载速度
        Public totalUploadSpeed As Int32           ' 总上传速度
        Public totalDownloadedByteCount As UInt64     ' 总下载的字节数
        Public totalUploadedByteCount As UInt64     ' 总上传的字节数

        Public peersNum As Int32                    ' 当前连接上的节点总数
        Public dhtConnectedNodeNum As Int32           ' dht连接上的活跃节点数
        Public dhtCachedNodeNum As Int32       ' dht已知的节点数
        Public dhtTorrentNum As Int32         ' dht中已知的torrent文件数
    End Structure


    '[StructLayout(LayoutKind.Sequential)]
    Public Structure DOWNLOADER_INFO_FIXED
        ' Downloader信息
        Public state As DLBT_DOWNLOAD_STATE                 ' 下载的状态            
        Public percentDone As Single           ' 已经下载的数据，相比整个torrent总数据的大小 （如果只选择了一部分文件下载，那么该进度不会到100%）
        Public downConnectionCount As Integer    ' 下载建立的连接数
        Public downloadLimit As Integer          ' 该任务的下载限速
        Public connectionCount As Integer     ' 总建立的连接数（包括上传）
        Public totalCompletedSeeds As Integer    ' 该任务下载总任务数，如果Tracker不支持scrap，则返回-1
        Public inCompleteNum As Integer           ' 总的未完成的人数，如果Tracker不支持scrap，则返回-1
        Public seedConnected As Integer        ' 连上的下载完成的人数
        Public totalCurrentSeedCount As Integer  ' 当前在线的总的下载完成的人数（包括连上的和未连上的）
        Public totalCurrentPeerCount As Integer  ' 当前在线的总的下载的人数（包括连上的和未连上的）
        Public currentTaskProgress As Single   ' 当前任务的进度 （100.0%代表完成） TODO:float
        Public bReleasingFiles As Boolean      ' 是否正在释放文件句柄，一般下载完成后，虽然进度完成了，但文件句柄和缓存内部还可能需要一点时间在释放。
        Public downloadSpeed As UInt32         ' 下载的速度
        Public uploadSpeed As UInt32          ' 上传的速度
        Public serverPayloadSpeed As UInt32   ' 从服务器下载的总有效速度（不包括握手消息等非数据性传输）
        Public serverTotalSpeed As UInt32     ' 从服务器下载的总速度(包括握手消息、连接通讯的消耗）

        Public wastedByteCount As UInt64        ' 非数据的字节数（控制信息等）
        Public totalDownloadedBytes As UInt64  ' 下载的数据的字节数
        Public totalUploadedBytes As UInt64   ' 上传的数据的字节数
        Public totalWantedBytes As UInt64    ' 选择的总数据大小
        Public totalWantedDoneBytes As UInt64  ' 选择的已下载的数据大小

        Public totalServerPayloadBytes As UInt64 ' 从服务器下载的数据总量（本次启动以来的文件数据，也包括了如果收到错误的数据，即使后来丢弃的 -- 不过一般服务器如果没问题，不会丢弃数据的）
        Public totalServerBytes As UInt64  ' 从服务器下载的所有数据的总量（包括totalServerPayloadBytes，以及握手数据、收发消息等）
        Public totalPayloadBytesDown As UInt64 ' 本次启动后总的下载的数据块类型的数据量（包括了服务器的数据，以及可能丢弃的数据）
        Public totalBytesDown As UInt64  ' 本次启动后，总的所有数据的下行数据量（包括了服务器以及所有客户的数据、辅助通讯数据量等）

        ' Torrent信息
        Public bHaveTorrent As Boolean       ' 用于无种子下载模式，判断是否已经获取到了torrent文件
        Public totalFileSize As UInt64        ' 文件的总大小
        Public totalFileSizeExcludePadding As UInt64 ' 实际文件的大小，不含padding文件
        Public totalPaddingSize As UInt64      ' 所有padding的大小
        Public pieceCount As Integer             ' 分块数
        Public pieceSize As Integer        ' 每个块的大小
    End Structure


    Public Structure DOWNLOAD_INFO
        Public downloadInfoFiexed As DOWNLOADER_INFO_FIXED
        Public infoHash As String             ' 文件的Hash值
    End Structure


    '[StructLayout(LayoutKind.Sequential)]
    Public Structure PEER_INFO_FIXED
        Public connectionType As Integer     ' 连接类型 0：标准BT(tcp) 1: P2SP（http） 2: udp（可能是直接连接或者穿透）
        Public downloadSpeed As Integer          ' 下载速度
        Public uploadSpeed As Integer          ' 上传速度
        Public downloadedBytes As UInt64      ' 下载的字节数
        Public uploadedBytes As UInt64          ' 上传的字节数
        Public uploadLimit As Integer            ' 该连接的上传限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况
        Public downloadLimit As Integer    ' 该连接的下载限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况

    End Structure

    Public Structure PEER_INFO
        Public peerInfoFixed As PEER_INFO_FIXED
        Public ip As String                ' 对方IP
        Public client As String                  ' 对方使用的客户端
    End Structure


    '[StructLayout(LayoutKind.Sequential)]
    Public Structure DLBT_KERNEL_START_PARAM
        Public bStartLocalDiscovery As Boolean   ' 是否启动局域网内的自动发现（不通过DHT、Tracker，只要在一个局域网也能立即发现，局域网速度快，可以加速优先发现同一个局域网的人）
        Public bStartUPnP As Boolean             ' 是否自动UPnP映射点量BT内核所需的端口
        Public bStartDHT As Boolean             ' 默认是否启动DHT，如果默认不启动，可以后面调用接口来启动
        Public bLanUser As Boolean             ' 是否纯局域网用户（不希望用户进行外网连接和外网通讯，纯局域网下载模式---不占用外网带宽，只通过内网的用户间下载）
        Public bVODMode As Boolean            ' 设置内核的下载模式是否严格的VOD模式，严格的VOD模式下载时，一个文件的分块是严格按比较顺序的方式下载，从前向后下载；或者从中间某处拖动的位置向后下载
        ' 该模式比较适合边下载边播放,针对这个模式做了很多优化。但由于不是随机下载，所以不大适合纯下载的方案，只建议在边下载边播放时使用。默认是普通模式下载
        ' 仅VOD以上版本中有效
        Public startPort As UShort             ' 内核监听的端口，如果startPort和endPort均为0 或者startPort > endPort || endPort > 32765 这种参数非法，则内核随机监听一个端口。 如果startPort和endPort合法
        Public endPort As UShort             ' 内核则自动从startPort ---- endPort之间监听一个可用的端口。这个端口可以从DLBT_GetListenPort获得

        Public Sub Init()
            bStartLocalDiscovery = True
            bStartUPnP = True
            bStartDHT = True
            bLanUser = False
            bVODMode = False
            startPort = 0
            endPort = 0
        End Sub
    End Structure


    ' 获取信息部分
    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetKernelInfo", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)> _
    Private Shared Function DLBT_GetKernelInfo(ByVal info As IntPtr) As Integer
    End Function

    Public Shared Function DLBT_GetKernelInfo(ByRef info As KERNEL_INFO) As Integer
        Dim infoMem As IntPtr = Marshal.AllocCoTaskMem(Marshal.SizeOf(info))
        If (DLBT_GetKernelInfo(infoMem) = 0) Then
            info = Marshal.PtrToStructure(infoMem, GetType(KERNEL_INFO))
        End If
        Marshal.FreeCoTaskMem(infoMem)
        Return 0
    End Function

    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetDownloaderInfo", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Private Shared Function DLBT_GetDownloaderInfo(ByVal hDownloader As IntPtr, ByVal info As IntPtr) As Integer

    End Function

    Public Shared Function DLBT_GetDownloaderInfo(ByVal hDownloader As IntPtr, ByRef info As DOWNLOAD_INFO) As Integer
        Dim infoMem As IntPtr = Marshal.AllocCoTaskMem(1024)
        If (DLBT_GetDownloaderInfo(hDownloader, infoMem) = 0) Then
            info.downloadInfoFiexed = Marshal.PtrToStructure(infoMem, GetType(DOWNLOADER_INFO_FIXED))
            Dim p As IntPtr = (infoMem.ToInt64() + Marshal.SizeOf(info.downloadInfoFiexed))
            info.infoHash = Marshal.PtrToStringAnsi(p)
        End If

        Marshal.FreeCoTaskMem(infoMem)
        Return 0
    End Function


    <DllImport("DLBT.dll", EntryPoint:="DLBT_GetDownloaderPeerInfoList", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Function DLBT_GetDownloaderPeerInfoList(ByVal hDownloader As IntPtr, ByRef info As IntPtr) As Integer

    End Function
    'TODO:
    Public Shared Function DLBT_GetDownloaderPeerInfoList(ByVal hDownloader As IntPtr, ByVal peerArray As ArrayList) As Integer
        Dim info As IntPtr = IntPtr.Zero
        Dim p As IntPtr = IntPtr.Zero
        Dim count As Integer = 0

        peerArray.Clear()
        DLBT_GetDownloaderPeerInfoList(hDownloader, info)
        If (info <> IntPtr.Zero) Then
            Dim i As Integer = 0
            count = Marshal.ReadInt32(info)
            If (count > 0) Then
                For i = 0 To count - 1
                    Dim entry As PEER_INFO
                    Dim offset As Int32 = 8 + (Marshal.SizeOf(entry.peerInfoFixed) + 64 + 64) * i
                    p = info.ToInt64() + offset
                    entry.peerInfoFixed = Marshal.PtrToStructure(p, GetType(PEER_INFO_FIXED))

                    p = (p.ToInt64() + Marshal.SizeOf(GetType(PEER_INFO_FIXED)))
                    entry.ip = Marshal.PtrToStringAnsi(p)
                    p = (p.ToInt64() + 64)
                    entry.client = Marshal.PtrToStringAnsi(p)
                    peerArray.Add(entry)
                Next i
            End If
            DLBT_FreeDownloaderPeerInfoList(info)
        End If

        Return 0
    End Function


    <DllImport("DLBT.dll", EntryPoint:="DLBT_FreeDownloaderPeerInfoList", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Sub DLBT_FreeDownloaderPeerInfoList(ByVal info As IntPtr)
    End Sub


    <DllImport("DLBT.dll", EntryPoint:="DLBT_SetDHTFilePathName", SetLastError:=True, CharSet:=CharSet.Unicode, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Sub DLBT_SetDHTFilePathName(ByVal dhtFile As String)
    End Sub


    '// 可以自定义IO操作的函数（可以将BT里面的读写文件等所有操作外部进行处理，替换内部的读写函数等）
    '// 该功能为高级版功能，请联系点量获取技术支持，默认版本中不开放该功能

    '// 设置IO操作的接管结构体的指针
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Set_IO_OP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Sub DLBT_Set_IO_OP(ByVal op As IntPtr)
    End Sub

    '// 对结构体里面的所有函数先赋值默认的函数指针
    <DllImport("DLBT.dll", EntryPoint:="DLBT_InitDefault_IO_OP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Sub DLBT_InitDefault_IO_OP(ByVal op As IntPtr)
    End Sub

    '// 获取系统内部目前在用的IO对象的指针
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Get_IO_OP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Function DLBT_Get_IO_OP() As IntPtr
    End Function

    '// 获取系统原始IO的指针
    <DllImport("DLBT.dll", EntryPoint:="DLBT_Get_RAW_IO_OP", SetLastError:=True, CharSet:=CharSet.Ansi, CallingConvention:=CallingConvention.StdCall)>
    Public Shared Function DLBT_Get_RAW_IO_OP() As IntPtr
    End Function

End Class
