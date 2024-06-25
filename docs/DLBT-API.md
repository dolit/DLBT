### *DLBT_Startup*

**功能：** 启动DLBT内核，初始化BT的运行环境,返回值表示是否成功

~~~c++
//=======================================================================================
//  内核的启动和关闭函数，商业授权版才有私有协议功能，演示版和只能用标准BT方式
//=======================================================================================

// 内核启动时的基本参数（是否启动DHT以及启动端口等）
struct DLBT_KERNEL_START_PARAM
{
    BOOL bStartLocalDiscovery;		// 是否启动局域网内的自动发现（不通过DHT、Tracker，只要在一个局域网也能立即发现，局域网速度快，可以加速优先发现同一个局域网的人）
    BOOL bStartUPnP;				// 是否自动UPnP映射点量BT内核所需的端口
    BOOL bStartDHT;					// 默认是否启动DHT，如果默认不启动，可以后面调用接口来启动
    BOOL bLanUser;                  // 是否纯局域网用户（不希望用户进行外网连接和外网通讯，纯局域网下载模式---不占用外网带宽，只通过内网的用户间下载）
    BOOL bVODMode;                  // 设置内核的下载模式是否严格的VOD模式，严格的VOD模式下载时，一个文件的分块是严格按比较顺序的方式下载，从前向后下载；或者从中间某处拖动的位置向后下载
                                    // 该模式比较适合边下载边播放,针对这个模式做了很多优化。但由于不是随机下载，所以不大适合纯下载的方案，只建议在边下载边播放时使用。默认是普通模式下载
                                    // 仅VOD以上版本中有效

    USHORT  startPort;	            // 内核监听的端口，如果startPort和endPort均为0 或者startPort > endPort || endPort > 32765 这种参数非法，则内核随机监听一个端口。 如果startPort和endPort合法
    USHORT  endPort;				// 内核则自动从startPort ---- endPort之间监听一个可用的端口。这个端口可以从DLBT_GetListenPort获得

    // 以下是内核内部的默认设置（默认使用随机端口，并启动DHT等）
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

//=======================================================================================
//  设置局域网自动发现的一些设置, interval_seconds组播周期秒数：建议不要低于10s； bUseBroadcast: 是否使用广播模式
//  默认内部使用组播，如果使用广播，可能局域网有无用流量太多，一般不建议
//=======================================================================================
DLBT_API void WINAPI DLBT_SetLsdSetting (int interval_seconds, bool bUseBroadcast);

//=======================================================================================
//  内核的启动和关闭函数，商业授权版才有私有协议功能，演示版只能用标准BT方式
//=======================================================================================
DLBT_API BOOL WINAPI DLBT_Startup (
    DLBT_KERNEL_START_PARAM * param = NULL, // 内核启动设置，参考DLBT_KERNEL_START_PARAM，如果为NULL，则使用内部默认设置
    LPCSTR  privateProtocolIDs = NULL,  // 可以自定义私有协议，突破运营商限制。如果为NULL，则作为标准的BT客户端启动
                                        // 点量BT的私有协议在3.4版本中进行了全新改进，可以穿透大部分运营商对协议的封锁
    bool    seedServerMode = false,     // 是否上传模式，上传模式内部有些参数进行了优化，适合大并发上传，但不建议普通客户端启用，只建议上传服务器使用
                                        // 专业上传服务器模式仅在商业版中有效，演示版暂不支持该功能。详见使用说明文档
    LPCSTR  productNum = NULL           // 商业版用户的数字ID，在购买后作者会提供一个产品密钥，激活商业版功能，试用版用户请使用NULL。
    );
~~~

**参数：**

**param**：内核启动设置的参数指针，参考DLBT_KERNEL_START_PARAM结构体中各项注释的含义。如果传入NULL，则使用内置的默认参数（启动DHT、UPnP以及内网自动发现，并使用随机端口），随机端口可以在监听成功后通过 DLBT_GetListenPort 来获得。如果使用固定端口，则可以将param里面的startPort和endPort设置完全相同，比如都是9010，内部则会使用9010作为启动端口，一旦9010被其他程序使用，则会返回失败。

**privateProtocolIDs：** 自定义的私有协议串，可以突破运营商对标准BT协议的限制，或者用于构建自己专属的保密数据传输。如果为NULL（默认），则作为标准的BT客户端启动。DLBT的私有协议在3.3版本中进行了全新改进，私有模式下去除了BT的痕迹，可以穿透运营商对协议的封锁。建议字符串的长度为6到16个字符，比如“DLBT Protocol”

如果使用标准协议，则是完全兼容uTorrent、Bitcomet、迅雷等BT软件的；如果使用私有协议，则是完全私有化的网络，下载的用户只能是相同私有协议串的DLBT内核，好处是可以穿透任意的协议封锁。当然，标准协议下，如果使用了BT扩展协议中的加密传输（详见DLBT_SetEncryptSetting的说明）方式，也可以穿透大部分运营商的封锁，同时可以和uTorrent、Bitcomet、比特精灵等兼容。

**seedServerMode：** 是否以上传为主，适合上传要求大于下载要求时使用。--- DLBT内核3.1版本以后，已经正式推出了独立的专业上传服务器，因此如果需要几万文件的使用，可以参考了解DLBT专业上传服务器的介绍。 该参数为保留参数，暂时不对外开放，商业用户请在点量官方客服的指导下使用该参数。

**productNum：** 商业版用户的数字ID，在购买后作者会提供一个产品密钥，激活商业版功能，试用版用户请使用NULL。

**说明：**

DLBT_Startup 函数必须作为第一个被调用的BT函数，如果传入了Port并且Port已经被占用,则返回失败,如果没有指定端口,一般情况下会成功,因为内核会尝试多个端口找一个可用的,这种情况下，可以调用DLBT_GetListenPort函数获得。建议第一次运行时使用一个随机端口（或者端口固定某个端口范围，一旦监听成功后下次就使用该固定端口，并可以浮动一个范围，以免端口被占用（可以记录到外部程序的配置文件中）。

### *DLBT_SetLsdSetting*

**功能：** 设置局域网自动发现的一些设置

```c++
DLBT_API void WINAPI DLBT_SetLsdSetting (int interval_seconds, bool bUseBroadcast);	
```

**interval_seconds:** 组播周期秒数：建议不要低于10s。内部默认是5分钟一次。

**bUseBroadcast：** 是否使用广播模式，默认内部使用组播，如果使用广播，可能局域网有无用流量太多，一般不建议。

### *DLBT_SetP2SPExtName*

**功能：** 设置P2SP时需要的扩展名、是否随机一个参数，以及服务器对中文文件名路径的编码

```c++
DLBT_API void WINAPI DLBT_SetP2SPExtName (LPCSTR extName, bool bUseRandParam, bool bUtf8);
```

**extName：** 用于防止一些运营商对http有他们网内缓存，所以导致下载的是缓存的老版本的文件。可以考虑使用一个.php这种扩展名，防止他们用缓存。但需要服务器配置将.php后缀忽略，返回真正的文件，可以通过nginx的rewrite等规则实现。

**bUseRandParam：** 是否随机一个?a=b这种参数，也是防止缓存的，但不是对所有运营商都有效

**bUtf8：** 是否使用utf8的路径编码，默认是true。可以设置false（如果有些中文路径获取不到）

**说明：**

该函数为全局的，不是针对某个任务设置，设置后对所有任务均生效。

### *DLBT_GetListenPort*

**功能：** 获得当前内核监听的端口。

```c++
DLBT_API USHORT WINAPI DLBT_GetListenPort ();
```

### *DLBT_Shutdown*

**功能：** 关闭点量BT内核，释放所有内核资源，返回值为void型。该函数必须作为最后一个调用的BT内核函数，调用该函数前请调用下载任务的接口将所有的下载任务先停止。

**说明：**

DLBT_Shutdown会等待所有资源都正确释放并报告Tracker后退出,所以可能比较慢。建议调用DLBT_Shutdown之前调用一次DLBT_PreShutdown, DLBT_PreShutdown将提前启动对Tracker的报告和部分资源的释放,这样保证了下线的速度. 一般的调用时机可以是,用户点击程序的关闭时,立即先调用一次DLBT_PreShutdown,然后继续执行应用程序的其它释放工作,程序退出前最后执行DLBT_Shutdown函数。

### *DLBT_PreShutdown*

**功能：** 提前执行一些关闭操作，由于报告Tracker下线需要一个网络通讯的过程，因此提前执行有助于提高下线的速度。

```c++
// 由于关闭的速度可能会比较慢(需要通知Tracker Stop), 所以可以调用该函数提前通知,提高下线速度
// 然后最后在程序最后退出时调用DLBT_Shutdown等待真正的结束
DLBT_API void WINAPI DLBT_PreShutdown ();
```

### *DLBT_SetUploadSpeedLimit*和*DLBT_SetDownloadSpeedLimit*

**功能：** 设置整个BT内核的总体上传 / 下载的最大速度限制。

```c++
// 速度限制，单位是字节(BYTE)，如果需要限速1M，请输入 1024*1024
DLBT_API void WINAPI DLBT_SetUploadSpeedLimit (int limit);
DLBT_API void WINAPI DLBT_SetDownloadSpeedLimit (int limit);
```

**参数：**

**limit：** 最大的上传 / 下载速度，系统内部默认是最大值（即不做任何限制），如果limit小于等于0，则同样表示不做任何限制，所以，如果要限速，请将limit设置为某个正数。单位是Byte，比如如果要设置限制为1MB，则需要传入1024*1024。

### *DLBT_SetMaxUploadConnection*和*DLBT_SetMaxTotalConnection*

**功能：** 设置整个BT内核的总体上传 / 总的最大连接数限制

```c++
// 最大连接数（真正完成连接的连接数）
DLBT_API void WINAPI DLBT_SetMaxUploadConnection (int limit);
DLBT_API void WINAPI DLBT_SetMaxTotalConnection (int limit);
```

**参数：**

**limit:** 最大的上传 / 总连接限制，系统内部默认是-1，-1表示不做任何限制。连接数限制绝大多数情况下等同于人数，一般情况下，最大上传/下载连接数限制，也就是最多同时和多少人进行上传/下载。

### *DLBT_SetMaxHalfOpenConnection*

**功能：** 设置最多发起的连接数（很多连接可能是发起了，但还没连上）。

```c++
// 最多发起的连接数（很多连接可能是发起了，但还没连上）
DLBT_API void WINAPI DLBT_SetMaxHalfOpenConnection (int limit);
```

**参数：**

**limit:** 最大半开连接数限制，系统内部默认是没有限制。Xp操作系统默认限制是10个，所以，即使这里设置的很高，但如果系统本身的限制没有使用其它工具修改，也没有使用DLBT_ChangeXPConnectionLimit修改过的话，那么这里的这个limit也不会有效。

### *DLBT_SetLocalNetworkLimit*

**功能：** 用于设置是否对跟自己在同一个局域网的用户进行限速，limit参数如果为true，则使用后面参数中的限速数值进行限速，否则不限。系统默认是不对同一个局域网下的用户应用限速的。因为局域网不占用用户的对外带宽，也可以设置为限制局域网上传。

```c++
// 用于设置是否对跟自己在同一个局域网的用户限速，limit如果为true，则使用后面参数中的限速数值进行限速，否则不限。默认不对同一个局域网下的用户应用限速。
DLBT_API void WINAPI DLBT_SetLocalNetworkLimit (
    bool    limit,              // 是否启用局域网限速
    int     downSpeedLimit,     // 如果启用局域网限速，下载限速的大小，单位字节/秒
    int     uploadSpeedLimit    // 如果启用局域网限速，限制上传速度大小，单位字节/秒
    );
```

**参数：**

**limit**是否对和自己在同一个局域网的用户也限速。

**downSpeedLimit：** 如果启用局域网限速，下载限速的大小，单位字节/秒。

**uploadSpeedLimit：** 如果启用局域网限速，下载限速的大小，单位字节/秒。

### *DLBT_SetFileScanDelay*

**功能：** 设置文件扫描校验时的休息参数，防止特大文件扫描时磁盘占用太严重，影响客户机器正常使用。

```c++
// 设置文件扫描校验时的休息参数，circleCount代表循环多少次做一次休息。默认是0（也就是不休息）
// sleepMs代表休息多久，默认是1ms
DLBT_API void WINAPI DLBT_SetFileScanDelay (DWORD circleCount, DWORD sleepMs);
```

**参数：**

**circleCount：** 代表循环多少次休息一次，0代表不休息。

**sleepMs：** 代表每次休息的时间，单位是毫秒(ms)。

### *DLBT_UseServerModifyTime*

**功能：** 设置文件下载完成后，是否修改为原始修改时间（制作种子时每个文件的修改时间状态）。

```c++
// 设置文件下载完成后，是否修改为原始修改时间（制作种子时每个文件的修改时间状态）。调用该函数后，制作的torrent中会包含有每个文件此时的修改时间信息
// 用户在下载时，发现有这个信息，并且调用了该函数后，则会在每个文件完成时，自动将文件的修改时间设置为torrent种子中记录的时间
// 如果只是下载的机器上启用了该函数，但制作种子的机器上没有使用该函数（种子中没有每个文件的时间信息），则也无法进行时间修改
DLBT_API void WINAPI DLBT_UseServerModifyTime(BOOL bUseServerTime);
```

**参数：**

**bUseServerTime：** 是否启用，TRUE（1）代表启用，FALSE（0）代表不启用。

**说明：**

调用该函数后，以后制作的torrent中会包含有每个文件此时的修改时间信息。

用户在下载时，发现种子中有这个信息，并且启用了修改后（本函数设置了TRUE），则会在每个文件完成时，自动将文件的修改时间设置为torrent种子中记录的时间。

如果只是下载的机器上启用了该函数，但制作种子的机器上在制作种子时没有使用该函数（种子中没有每个文件的时间信息），则也无法进行时间修改；同样的，如果种子中有了文件的时间信息，但如果下载的用户机器上没启用该函数，同样无法进行文件的时间修改。

### *DLBT_EnableUDPTransfer*

**功能：** 用于设置是否启用UDP传输和UDP穿透传输功能，默认是自动适应，如果对方支持，在tcp无法到达时，自动切换为udp通讯。可以通过这个函数，设置永不使用UDP传输。

**参数：** **bEnabled：**是否启用UDP传输。

```C++
DLBT_API void WINAPI DLBT_EnableUDPTransfer(BOOL bEnabled);
```

### *DLBT_SetP2PTransferAsHttp*

**功能：** 是否启用伪装Http传输，某些地区（比如马来西亚、巴西的一些网络）对Http不限速，但对P2P限速在20K左右，这种网络环境下，可以启用Http传输，默认是允许伪装Http的传输进入（可以接受他们的通讯），但自己发起的连接不主动伪装。如果网络中明确侦测出对Http不限速，可以考虑都设置：主动Http伪装。 但这种伪装也有副作用，国内有些地区机房（一般是网通）设置了Http必须使用域名，而不能使用IP，而BT传输中，对方没有合法域名，反而会被这种限制截杀，如果有这种限制，反而主动伪装后会没有速度。所以请根据实际使用选择。

```c++
DLBT_API void WINAPI DLBT_SetP2PTransferAsHttp (bool bHttpOut, bool bAllowedIn = true);
```

**参数：**

**bHttpOut：** 是否对发出的请求伪装Http，默认不主动发出伪装，除非有明确设置。

**bAllowedIn：** 是否接受别人发来的伪装过的Http数据请求，默认是兼容别人的Http伪装。

### *DLBT_AddHoleServer*

**功能：** 是否使用单独的穿透服务器，如果不使用单独服务器，穿透的协助将由某个双方都能连上的第三方p2p节点辅助完成。穿透服务器程序需要联系点量软件申请获取。

```c++
// 是否使用单独的穿透服务器，如果不使用单独服务器，穿透的协助将由某个双方都能连上的第三方p2p节点辅助完成
DLBT_API BOOL WINAPI DLBT_AddHoleServer(LPCSTR ip, short port);
```

**参数：**

**ip：** UDP穿透服务器的IP地址。

**port****:**UDP穿透服务器的监听端口。

### *DLBT_AddServerIP*

**功能：** 设置服务器的IP，可以多次调用设置多个，用于标记哪些IP是服务器，以便统计从服务器下载到的数据等信息，甚至速度到了一定程度可以断开服务器连接，节省服务器带宽。2022版本后的P2SP服务器，自动会被标记为服务器，不需要再单独设置

```c++
DLBT_API void WINAPI DLBT_AddServerIP (LPCSTR ip);
```

 **参数：**

**ip：** 服务器的IP地址，如果有多个服务器IP，请多次调用本函数。

### *DLBT_AddBanServerUrl*

**功能：** 不去连接这个p2sp的url，可以重复调用. 目的是，如果是服务器上，这个p2sp的url就在本机，就没必要去连接这个url了。

```c++
DLBT_API void WINAPI DLBT_AddBanServerUrl (LPCSTR url);
```

**参数：**

**url：** 希望不去连接的p2sp地址。关于p2sp的更多信息可以参考: DLBT_Downloader_AddHttpDownload 函数。

### *DLBT_SetStatusFileSavePeriod*

**功能：** 保存一次状态文件的条件，内部默认全部下载完成后保存一次。可以调整为自己需要的时间或者上限数目，比如每5分钟保存一次，或者下载100块数据后保存一次。

```c++
DLBT_API BOOL WINAPI DLBT_SetStatusFileSavePeriod (
    int             iPeriod,               //保存间隔，单位是秒。默认是0，代表除非下载完成，否则永不保存
    int             iPieceCount            //分块数目，默认0，代表除非下载完成，否则永不保存
    );
```

**参数：**

**iPeriod：** 保存间隔，单位是秒，表示每多少秒保存一次，默认是0，代表除非下载完成，否则永不保存。

**port:** 分块数目，表示下载多少个分块数据(Piece)保存一次，默认0，代表除非下载完成，否则永不保存。

=======================================================================================

### *DLBT_SetReportIP和DLBT_GetReportIP*

**功能：** 设置和获取报告Tracker时的IP地址

```c++
DLBT_API void WINAPI DLBT_SetReportIP (LPCSTR ip); // 设置IP 
DLBT_API LPCSTR WINAPI DLBT_GetReportIP ();        // 获取当前设置，返回当前的IP，如果未设则为NULL
```

**参数：**

**ip** 需要报告给Tracker的IP地址。

**说明：**

如果是要专门对外部提供上传，并且该机器（可以称作上传的服务器）同Tracker服务器在同一个局域网，那么建议设置报告Tracker的IP为外网地址，否则，Tracker通知别人的上传服务器的IP可能是一个局域网地址，外人无法同服务器通讯。一般地，如果是客户机器，同Tracker一般都不会在同一个网段，这时候需要看Tracker的配置，如果Tracker自动将每个客户的外网地址记录（这是目前大多数Tracker在做的），那么就无需设置这个IP地址，使用Tracker自动获得到的即可。如果为了防止Tracker使用每个用户的内网地址（这个比较少见），那么也可以使用该设置将IP设为外网地址。

还有一种情况下可能会使用该函数：如果某个下载都集中在局域网内，这种情况下，防止Tracker记录自己的外部IP，可以设置每个人的内网IP，可以实现很好的互连。

注意：不是所有的Tracker都支持这个扩展协议，需要使用支持报告IP协议的tracker服务器。

### *DLBT_SetUserAgent*

**功能：** 设置报告Tracker时的客户端标记。

```c++
DLBT_API void WINAPI DLBT_SetUserAgent (LPCSTR agent);
```

**参数：**

**agent：** 客户端的标记字符串。

**说明：**

报告Http Tracker是标准的HTTP协议通讯，agent标记串就放到了HTTP协议Header中的user-agent域中。可以使用自定义的agent串，结合对Tracker的少量修改，实现一个简单的下载限制，限制非自己的客户端不能下载自己Tracker中提供的文件 ―― 这种限制只能是限制特定的客户端可以使用自己的Tracker，但无法突破某些运营商对BT协议的限制。

### *DLBT_SetMaxCacheSize*

**功能：** 设置点量BT下载和上传文件最大可用的缓存。

```c++
/=======================================================================================
//  设置磁盘缓存，3.3版本后已对外开放，3.3版本后系统内部自动设置8M缓存，如需调整可使用该
//  函数进行调整，单位是K，比如要设置1M的缓存，需要传入1024
//=======================================================================================
DLBT_API void WINAPI DLBT_SetMaxCacheSize (DWORD size);
```

**参数：**

**size：** 缓存的最大值，以KB为单位。比如需要设置1M缓存，则传入1024。

**说明：**

缓存的最大值不能超过2.5G或者机器的物理内存。这个限制是由于目前点量BT仅测试过32位操作系统，（32位操作系统下，每个程序的地址空间最大为4G，但默认操作系统需要占用2G的空间，这样每个程序自己可用的内存地址空间就是2G。通过修改操作系统的配置，可以使得每个程序可以使用3G的地址空间，考虑到程序本身运行所需的地址空间等，安全起见，缓存最大可以设置到2.5G。  如果设置的最大值大于机器的物理内存，则默认使用90％的物理内存。

不过一般地，需要设置大量缓存的情况是在专业提供大量下载或者上传的服务器上才会可能用到，比如有些服务器为了提升IO的效率，可以设置大量的缓存，将经常用到的文件块进行缓存，减少对磁盘的访问压力。

点量BT内核3.4版本后内部默认设置了8M的缓存，普通用户的机器基本不需要修改和设置这个缓存，除非下载和上传的数据量很多，建议可以在 8 – 128M之间。

### *DLBT_SetPerformanceFactor*

**功能：**一些性能参数设置，默认情况下，点量BT是为了普通网络环境下的下载所用，如果是在千M局域网下并且磁盘性能良好，想获得50M/s甚至100M/s的文件传输速度，则需要设置这些参数，具体参数的设置建议，请咨询点量软件获取。

```c++
DLBT_API void WINAPI DLBT_SetPerformanceFactor(
    int             socketRecvBufferSize,      // 网络的接收缓冲区，默认是用操作系统默认的缓冲大小
    int             socketSendBufferSize,      // 网络的发送缓冲区，默认用操作系统的默认大小
    int             maxRecvDiskQueueSize,      // 磁盘如果还未写完，超过这个参数后，将暂停接收，等磁盘数据队列小于该参数
    int             maxSendDiskQueueSize       // 如果小于该参数，磁盘线程将为发送的连接塞入数据，超过后，将暂停磁盘读取
    );
```

**参数：**

参数的具体含义以及合适的设置，请联系点量软件咨询。

### *DLBT_AddIpBlackList*

**功能：** 添加ip黑名单(可批量添加一个范围内的ip,如果只有一个ip第二个参数允许为NULL),成功返回0，失败返回 小于0

```c++
DLBT_API int WINAPI DLBT_AddIpBlackList(const char*ipRangeStart,const char*ipRangeEnd);
```

**参数：**

IP传入190.120.1.1这类字符串，会将起始到结束的全部给禁用。ipRangeEnd可传入NULL，代表只禁用单个的IP，用ipRangeStart标记。

### *DLBT_RemoveAllBlackList*

**功能：清空当前ip黑名单列表**

```c++
DLBT_API void WINAPI DLBT_RemoveAllBlackList();
```

### *DLBT_DHT_Start*

**功能：** 启动DHT网络功能，DHT网络在点量BT内核中默认不启动，需要调用该函数启动。

```c++
DLBT_API void WINAPI DLBT_DHT_Start (USHORT port = 0);
```

**参数：**

**port：**DHT网络监听的端口。

**说明：**

建议不设置参数，将端口设为0，在端口为0时，系统将自动使用内核监听成功的TCP端口号用于DHT网络监听，由于DHT网络是基于UDP方式，因此可以共同使用同一个端口不冲突。DHT启动后，内核会自动试着进行UPnP映射，不需要应用程序再次调用UPnP接口设置DHT的映射。

DHT网络的功能主要是：可以通过用户之间信息的交流，获得更多的下载者的信息，在连接不上Tracker时比较有效，同时一定程度上可以起到突破运营商封锁的效果。

### *DLBT_DHT_Stop*

**功能：** 停止DHT网络功能。

```c++
DLBT_API void WINAPI DLBT_DHT_Stop ();
```

### *DLBT_DHT_IsStarted*

**功能：** 判断DHT网络是否已启动，TRUE为已经启动，FALSE为尚未启动。

```c++
DLBT_API BOOL WINAPI DLBT_DHT_IsStarted ();
```

### *DLBT_PROXY_SETTING*

**功能：** 当用户的机器需要使用代理才能上网时，使用该结构体来指定代理的设置。

```c++
//=======================================================================================
//  设置代理相关函数,商业授权版才有此功能，演示版暂不提供
//=======================================================================================

struct DLBT_PROXY_SETTING
{
    char    proxyHost [256];    // 代理服务器地址
    int     nPort;              // 代理服务器的端口
    char    proxyUser [256];    // 如果是需要验证的代理,输入用户名
    char    proxyPass [256];    // 如果是需要验证的代理,输入密码

    enum DLBT_PROXY_TYPE
    {
        DLBT_PROXY_NONE,            // 不使用代理
        DLBT_PROXY_SOCKS4,          // 使用SOCKS4代理，需要用户名
        DLBT_PROXY_SOCKS5,          // 使用SOCKS5代理，无需用户名和密码
        DLBT_PROXY_SOCKS5A,         // 使用需要密码验证的SOCKS5代理，需要用户名和密码
        DLBT_PROXY_HTTP,            // 使用HTTP代理，匿名访问，仅适用于标准的HTTP访问，Tracker和Http跨协议传输，下载则不可以
        DLBT_PROXY_HTTPA            // 使用需要密码验证的HTTP代理
    };

    DLBT_PROXY_TYPE proxyType;      // 指定代理的类型
};

```

### *标记代理的应用范围*

**功能：** 当用户的机器需要使用代理才能上网时，使用该结构体来指定代理的设置。

```c++
//=======================================================================================
//  标识代理将应用于哪些连接（Tracker、下载、DHT和http跨协议下载等）
//=======================================================================================
#define DLBT_PROXY_TO_TRACKER       1  // 仅对连接Tracker使用代理
#define DLBT_PROXY_TO_DOWNLOAD      2  // 仅对下载时同用户（Peer）交流使用代理
#define DLBT_PROXY_TO_DHT           4  // 仅对DHT通讯使用代理，DHT使用udp通讯，需要代理是支持udp的
#define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  // 仅对HTTP下载使用代理，当任务有http跨协议下载时有效（不包括Tracker）

// 对所有均使用代理
#define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)

```

### ***DLBT_SetProxy和DLBT_GetProxySetting***

**功能：** DLBT_SetProxy用于设置代理参数，DLBT_GetProxySetting用于获取当前的代理设置。

```c++
DLBT_API void WINAPI DLBT_SetProxy (
    DLBT_PROXY_SETTING  proxySetting,   // 代理设置，包括IP端口等
    int                 proxyTo         // 代理应用于哪些连接，就是上面宏定义的几种类型，比如DLBT_PROXY_TO_ALL
    );

//=======================================================================================
//  获取代理的设置，proxyTo标识想获得哪一类连接的代理信息，但proxyTo只能单个获取某类连接
//  的代理设置，不能使用DLBT_PROXY_TO_ALL这种多个混合选择
//=======================================================================================
DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, int proxyTo);

```

### *DLBT_SetEncryptSetting加密协议和加密数据*

**说明：** 点量BT除了可以使用私有协议来突破运营商的限制，同时可以使用协议加密来突破。私有协议的优点是简单有效,但缺点是私有协议后，就形成了自己的私有P2P网络，而不是BT网络。意味着同其它BT客户端无法兼容（当然，如果您想自己的文件只有自己的客户端能够下载，那么点量BT的私有协议是一个不错的选择）。而加密协议不会破坏同Bitcomet等支持加密协议的BT客户端的兼容性。 同样的，如果为了传输高安全的数据，也可以选择加密数据。不同的网络下，可能需要不同设置。配合伪装Http使用，在某些网络下效果更佳。具体的设置建议，商业用户建议直接咨询点量软件售后服务人员。
   如果不需要和其他客户端兼容，并且为了最为可靠的突破封锁，可以使用点量BT 3.3以后的版本，在私有协议下实现脱离BT的痕迹，经严格测试可突破国内大部分运营商的协议封锁，也无需担心运营商的协议限制。

```c++
/=======================================================================================
//  设置加密相关函数,将协议字符串或者所有数据均加密，实现保密传输，在兼容BT协议上突破
//  绝大部分运营商的封锁。和前面提到的私有协议不同的是，私有协议后将形成自己
//  的P2P网络，不能同其它BT客户端兼容；但私有协议完全不是BT协议了，没有BT的痕迹，可以穿透
//  更多运营商的封锁。不同的网络下，可能需要不同设置。配合伪装Http使用，在某些网络下效果更佳
//=======================================================================================
enum DLBT_ENCRYPT_OPTION
{
    DLBT_ENCRYPT_NONE,                  // 不支持任何加密的数据，遇到加密的通讯则断开
    DLBT_ENCRYPT_COMPATIBLE,            // 兼容模式：自己发起的连接不使用加密，但允许别人的加密连接进入，遇到加密的则同对方用加密模式会话；
    DLBT_ENCRYPT_FULL,                  // 完整加密：自己发起的连接默认使用加密，同时允许普通和加密的连接连入。遇到加密则用加密模式会话；遇到非加密则用明文模式会话。
                                        // 默认是完整加密
    DLBT_ENCRYPT_FORCED,                // 强制加密，仅支持加密通讯，不接受普通连接，遇到不加密的则断开
};

// 加密层级高，理论上会浪费一点CPU，但数据传输安全和突破封锁的能力会有提升
enum DLBT_ENCRYPT_LEVEL
{
    DLBT_ENCRYPT_PROTOCOL,          // 仅加密BT的通讯握手协议  －－一般用于防止运营商的阻止
    DLBT_ENCRYPT_DATA,              // 仅加密数据流（数据内容）－－ 用于保密性强的文件传输
    DLBT_ENCRYPT_PROTOCOL_MIX,      // 主动发起的连接使用加密协议模式，但如果对方使用了数据加密，也支持同他使用数据加密模式通讯
    DLBT_ENCRYPT_ALL                // 协议和数据均主动加密
};

// 内部默认使用兼容性加密（对协议和数据均兼容加密），没有特殊需求，建议不需要调用
DLBT_API void WINAPI DLBT_SetEncryptSetting (
    DLBT_ENCRYPT_OPTION     encryptOption,      // 加密选项，加密哪种类型或者不加密
    DLBT_ENCRYPT_LEVEL      encryptLevel        // 加密的程度，对数据还是协议加密？
    );
```

## 3.3 下载任务的相关接口

### *enumDLBT_DOWNLOAD_STATE*

**功能：** 标记下载任务当前状态。

```c++
// 单个下载的状态
enum DLBT_DOWNLOAD_STATE
{
	BTDS_QUEUED,	                // 已添加
	BTDS_CHECKING_FILES,	        // 正在检查校验文件
	BTDS_DOWNLOADING_TORRENT,	    // 无种子模式下，正在获取种子的信息
	BTDS_DOWNLOADING,	            // 正在下载中
    BTDS_PAUSED,                    // 暂停
	BTDS_FINISHED,	                // 指定的文件下载完成
	BTDS_SEEDING,	                // 供种中（种子中的所有文件下载完成）
	BTDS_ALLOCATING,                // 正在预分配磁盘空间 -- 预分配空间，减少磁盘碎片，和
                                    // 启动选项有关，启动时如果选择预分配磁盘方式，可能进入该状态
    BTDS_ERROR,                     // 出错，可能是写磁盘出错等原因，详细原因可以通过调用DLBT_Downloader_GetLastError获知
};
```

### *enum DLBT_FILE_ALLOCATE_TYPE*

**功能：** 标记文件的磁盘分配方式。

```c++
// 文件的分配模式,详见使用说明文档
enum DLBT_FILE_ALLOCATE_TYPE
{
    FILE_ALLOCATE_REVERSED  = 0,   // 预分配模式,预先创建文件,下载每一块后放到正确的位置
    FILE_ALLOCATE_SPARSE,          // Default mode, more effient and less disk space.NTFS下有效 http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
    FILE_ALLOCATE_COMPACT          // 文件大小随着下载不断增长,每下载一块数据按次序紧密排在一起,但不是他们的最终位置,下载中不断调整位置,最后文件位置方能确定         .
};
```

**说明：**

FILE_ALLOCATE_SPARSE（稀疏文件）分配方式，在NTFS文件系统下有效，FAT32下设置可以成功，但其实没有真正使用Sparse文件分配方式，关于Sparse分配的具体介绍，请参考：http://msdn.microsoft.com/en-us/library/aa365566(VS.85).aspx ；

FILE_ALLOCATE_COMPACT（紧凑文件）分配方式，这种方式下，数据下载过程中是没有空位的紧挨着排列，比如当前下载了第3、9、27这三块数据，那么它们在磁盘上是紧挨着放的，直到文件全部下载完成，所有的数据才会被全部放到属于它的位置上，在下载过程中是按相对顺序来存放的。

FILE_ALLOCATE_REVERSED（预分配）方式，这种方式是在下载前将文件一次性分配好，将所有的位进行置零。这种方式的好处是不需要考虑下载过程中磁盘可能不够了的情况，因为空间提前已经分配好了。但缺点是大文件可能会在下载前就占用了大量的空间。预分配模式可以减少磁盘碎片，但也有个缺点：如果一个很大的文件（比如1G以上的文件），如果第一块要写入的文件是文件尾部的，则可能操作系统在写第一块时需要耗时很久（系统API WriteFile会需要用时很久）。所以预分配模式比较适合对磁盘碎片要求较高，或者每个文件不会很大、或者顺序下载等应用模式下。

### *DLBT_Downloader_Initialize*

**功能：** 启动一个种子文件的下载，返回该下载任务的句柄

```c++
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize (
        LPCWSTR             torrentFile,                    // 种子文件的路径（具体到文件名）
        LPCWSTR             outPath,                        // 下载后的保存路径（只是目录）
        LPCWSTR             statusFile = L"",           // 状态文件的路径
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
        BOOL                bPaused = FALSE,                // 是否不立即运行下载任务，打开句柄后暂停任务的启动
        BOOL                bQuickSeed = FALSE,             // 是否快速供种（仅商业版提供）
        LPCSTR              password = NULL,                // 是否加密种子，如果为Null，则是普通种子，否则是种子的密码，试用版不支持，该参数会被忽略
        LPCWSTR             rootPathName = NULL,             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
                                                            // 对单个文件则直接进行改名为指定的这个名字
        BOOL                bPrivateProtocol = FALSE,        // 该种子是否私有协议（可以对不同种子采用不同的下载方式）
		BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
        );
```

**参数：**

**torrentFile：** 种子文件的路径。

**outPath：** 下载后文件的保存路径。

**statusFile：** 状态文件的路径（具体到文件名）。状态文件是用于记录上次下载的信息的文件，比如上次下载的文件块数、找到的节点信息等，以便下次启动时可以迅速恢复到上次的状态，快速下载。默认为” ”，表示系统会自动选择种子文件的目录下建立一个状态文件。如果是NULL则表示不使用状态文件（不建议，因为没有状态文件，下次启动时会需要扫描上次下载的数据信息、连上的节点信息也会丢失）。

**fileAllocateType：** 文件的分配方式，详见DLBT_FILE_ALLOCATE_TYPE。

**bPaused：** 不立即运行下载任务，暂停的方式启动。一般用于只是为了读取一些信息的情况，或者需要完成某些设置后再启动的情况。

**bQuickSeed:** 是否快速供种，仅对商业版的专业上传服务器模式下有效，快速供种可以避开启动时对文件的检查，立即启动上传。

**password** ：是否加密种子，如果为Null，则是普通种子，否则是种子的密码。另外，如果输入了密码，但无法成功解密，内核也会试着再把它作为一个普通未加密种子来进行尝试直接启动。加密种子只对有需要的商业版用户开放，试用版中会自动忽略该参数。

**rootPathName**：种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。比如制作种子时，文件夹名字可能是D:\netGame\天龙八部，在有些客户机上下载时，可能用户想把这个文件夹改名为D:\netGame\新天龙八部，则使用该参数传入”新天龙八部”。如果为NULL，默认使用制作种子时的文件夹名。 对单个文件如果传入了该参数则直接进行改名为指定的这个参数。

**bPrivateProtocol**：是否使用私有协议，私有协议下，Bitcomet等标准BT软件就无法从用户这里获取数据。此参数必须配合DLBT_Startup中的privateProtocolIDs共同使用，如果privateProtocolIDs为NULL，那么即使这里使用了bPrivateProtocol也是无效果的； bPrivateProtocol为TRUE时内核将自动使用DLBT_Startup中传入的私有串作为私有协议。

**bZipTransfer：** 是否启用Zip传输，在传输的双方都是点量BT3.6.3以后版本时才可以生效，否则会忽略该参数。一般用于传输一些没有进行过压缩的文本型文件，比如一些网游的更新，为了实现数据块对比，无法将整个网游压缩为一个压缩包，而一般都是文件夹的模式。此时里面有很多数据可以进一步压缩，就可以采用Zip传输模式，压缩前动态压缩，可以减少大量网络流量，提升实际的传输速度。

**说明：**

DLBT_Downloader_Initialize返回下载句柄，对该下载的其它所有操作均需要根据该句柄来进行。不需要该任务时或者退出程序时，需要主动调用DLBT_Downloader_Release函数释放句柄。如果返回的句柄为NULL，则说明启动失败，请检查是否任务重复添加或者种子路径、格式不正确。

一个Downloader句柄对应于一个Torrent文件的下载，由于一个Torrent文件可能会包含多个文件的下载，因此一个Downloader任务中可能在同时下载一个种子内的多个文件。

### *Downloader_Initialize_FromBuffer*

**功能：** 启动一个内容位于内存中的种子的下载，返回该下载任务的句柄

```c++
// 启动一个内存中的种子文件内容，可用于种子文件不是独立存储或者按某个加密方式加密种子的情况，可以将解密后的内容传入BT内核
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromBuffer (
        LPBYTE              torrentFile,                    // 内存中的种子文件内容
        DWORD               dwTorrentFileSize,              // 种子内容的大小
        LPCWSTR             outPath,                        // 下载后的保存路径（只是目录）
        LPCWSTR             statusFile = L"",              // 状态文件的路径
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
        BOOL                bPaused = FALSE,
        BOOL                bQuickSeed = FALSE,             // 是否快速供种（仅商业版提供）
        LPCSTR              password = NULL,                // 是否加密种子，如果为Null，则是普通种子，否则是种子的密码，试用版不支持，该参数会被忽略
        LPCWSTR             rootPathName = NULL,             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
                                                            // 对单个文件则直接进行改名为指定的这个名字
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
        );

```

**参数：**

**torrentFile：** 种子文件在内存中的内容。

**dwTorrentFileSize：** 种子内容的大小。

其它参数的含义详见DLBT_Downloader_Initialize的说明

**说明：**

除了种子文件的路径不同外，其它相同于DLBT_Downloader_Initialize函数。

该函数可以应用于自定义加密算法的种子的情况，如果你希望你的种子文件不能被别的客户端下载，或者需要输入正确的授权密码后才能下载，你可以利用各种熟悉的加密方式，将种子文件加密。然后在调用DLBT_Downloader_Initialize_FromBuffer前解密种子，传入种子的内容。  另一种常见应用是，种子文件不是独立存储的，而是附属于其它文件的一部分，或者通过调用WebService等方式获得，这种情况下也比较适合使用该函数。

### *DLBT_Downloader_Initialize_FromTorrentHandle*

**功能：** 启动一个内容位于内存中的种子的下载，返回该下载任务的句柄

```c++
// 从一个Torrent句柄启动一个任务
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromTorrentHandle (
        HANDLE              torrentHandle,                    // Torrent句柄
        LPCWSTR             outPath,                        // 下载后的保存路径（只是目录）
        LPCWSTR             statusFile = L"",              // 状态文件的路径
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
        BOOL                bPaused = FALSE,
        BOOL                bQuickSeed = FALSE,              // 是否快速供种（仅商业版提供）
        LPCWSTR             rootPathName = NULL,             // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
                                                            // 对单个文件则直接进行改名为指定的这个名字
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
    );
```

**参数：**

**torrentHandle：** 内核返回的种子文件Torrent对象的句柄，请参考：DLBT_OpenTorrent接口。

其它参数的含义详见DLBT_Downloader_Initialize的说明。

### *DLBT_Downloader_Initialize_FromInfoHash*

**功能：** 无种子模式下载，只需要一个种子文件的Hash值和tracker的地址（或者一个上传者的地址），返回该下载任务的句柄

```c++
//（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
        LPCSTR              trackerURL,                     // tracker的地址
        LPCSTR              infoHash,                       // 文件的infoHash值
        LPCWSTR             outPath,
        LPCWSTR             name = NULL,                    // 在下载到种子之前，是没有办法知道名字的，因此可以传入一个临时的名字
        LPCWSTR             statusFile = L"",              // 状态文件的路径
        DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // 文件分配模式
        BOOL                bPaused = FALSE,
        LPCWSTR             rootPathName = NULL,            // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
                                                            // 对单个文件则直接进行改名为指定的这个名字
        BOOL                bPrivateProtocol = FALSE,
		BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
        );
```

**参数：**

**trackerURL：** 提供该文件追踪的Tracker服务器的地址。

**infoHash：** 该任务的infoHash值。

**outPath：** 下载后文件的保存路径。

**name：** 在下载到种子之前，是没有办法知道名字的，因此可以传入一个临时的名字

其它参数的含义详见DLBT_Downloader_Initialize的说明。

**说明：**

无种子模式：BT下载需要基于种子文件，一般传统的做法是通过网页先下载一个种子，然后再启动下载。这样的做法有几个问题：

1）如果下载的人很多，或者种子文件很多，通过传统Http的方式下载，肯定对网站服务器造成较大的压力，不能实现整个系统完整的P2P； 

2）种子文件比较容易被其它人获得；

3）不方便，用户需要先点一个“种子下载”的链接，然后再通过打开种子进行下载。

针对上述问题，点量BT提供了无种子模式下载。只需要提供一个文件的InfoHash值，再提供tracker的地址或者一个上传这个文件的用户的信息，或者只需要提供一个URL （DLBT_Downloader_Initialize_FromUrl方式）系统内部将自动通过P2P的方式自动完成种子信息的获取，以及后面的自动下载。**无种子模式只对需要的商业版用户开放，在试用版中该接口无效。联系我们可以获取更详细的构建无种子网络环境的设计和构建方案。**

### *DLBT_Downloader_Initialize_FromUrl*

**功能：** 无种子模式下载，只需要一个网址（网页的链接地址形式），返回该下载任务的句柄。地址格式为：地址格式为： DLBT://xt=urn:btih: Base32 编码过的info-hash [ &dn= 名字 ] [ &tr= tracker的地址 ]  ([]为可选参数)

```c++
// 无种子模式的另一个接口，可以直接通过地址下载，地址格式为： DLBT://xt=urn:btih: Base32 编码过的info-hash [ &dn= Base32后的名字 ] [ &tr= Base32后的tracker的地址 ]  ([]为可选参数)
// 完全遵循uTorrent的官方BT扩展协议
DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromUrl (
    LPCSTR              url,                            // 网址
    LPCWSTR             outPath,                        // 保存目录
    LPCWSTR             statusFile = L"",              // 状态文件的路径
    DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,
    BOOL                bPaused = FALSE,
    LPCWSTR             rootPathName = NULL,            // 种子内部目录的名字，如果为NULL，则用种子中的名字，否则改为指定的这个名字。
                                                        // 对单个文件则直接进行改名为指定的这个名字
    BOOL                bPrivateProtocol = FALSE,
	BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
    );
```

**参数：**

**url：** 一个包含BT种子信息的网址，格式：DLBT://xt=urn:btih: Base32 编码过的info-hash [ &dn= Base32 编码过的名字 ] [ &tr=Base32 编码过的tracker的地址 ]  ([]为可选参数)。 这个地址可以在通过DLBT_Downloader_MakeURL函数生成，也可以用户自己根据上述规则生成。

其它参数的含义详见DLBT_Downloader_Initialize的说明。

**说明：**

无种子模式：BT下载需要基于种子文件，一般传统的做法是通过网页先下载一个种子，然后再启动下载。这样的做法有几个问题：1）如果下载的人很多，或者种子文件很多，通过传统Http的方式下载，肯定对网站服务器造成较大的压力，不能实现整个系统完整的P2P； 2）种子文件比较容易被其它人获得；3）不方便，用户需要先点一个“种子下载”的链接，然后再通过打开种子进行下载。

针对上述问题，点量BT提供了无种子模式下载。只需要提供一个文件的InfoHash值，再提供tracker的地址或者一个上传这个文件的用户的信息（DLBT_Downloader_Initialize_FromInfoHash方式）；或者只需要提供一个URL，系统内部将自动通过P2P的方式自动完成种子信息的获取，以及后面的自动下载。

**无种子模式只对需要的商业版用户开放，在试用版中该接口无效。联系作者可以获取更详细的构建无种子网络环境的设计和构建方案。**

### *DLBT_Downloader_InitializeAsUpdater*

**功能：** 专业文件更新接口，点量BT的专业更新功能无需对老文件进行任何扫描校验，直接对比新老种子文件的差异，几毫秒内快速启动更新变化过的数据块。传统的BT软件在有新种子文件替换老种子时，需要先扫描原始文件才能获知需要去下载哪些数据块，如果一个几G的文件夹，扫描一次需要很久，并且扫描期间机器磁盘占用严重。所以点量BT提供的这个接口，在有大量文件需要频繁更新时极其有效。

```c++
// 专业文件更新接口，任务以新老种子文件为基础，更新新种子文件相对老种子文件变化过的数据块。仅商业版中提供
DLBT_API HANDLE WINAPI DLBT_Downloader_InitializeAsUpdater (
    LPCWSTR             curTorrentFile,    //当前版本的种子文件
    LPCWSTR             newTorrentFile,   //  新版种子文件
 	LPCWSTR             curPath,    //  当前文件的路径
    LPCWSTR             statusFile = L"", // 状态文件的路径
 	DLBT_FILE_ALLOCATE_TYPE    type = FILE_ALLOCATE_SPARSE, //  文件分配方式，必须和当前版本一致，新版本也将使用该分配方式。
 	BOOL                bPaused = FALSE,     // 是否暂停方式启动
  	LPCSTR              curTorrentPassword = NULL,   // 当前版本种子的密码（如果加密了才需要传入）
 	LPCSTR              newTorrentFilePassword = NULL, //新种子的密码
 	LPCWSTR             rootPathName = NULL,
	BOOL				bPrivateProtocol = FALSE,
	float		*       fProgress = NULL,         //如果不为NULL，则传出和DLBT_Downloader_GetOldTorrentProgress一样的一个进度
	BOOL				bZipTransfer = FALSE			// 是否压缩传输，一般用于文本文件的下载，如果对方是支持这个功能的dlbt用户，则可以互相压缩传输，减少流量
);
```

**参数：**

**curTorrentFile：** 现在这些文件对应的老的种子文件的路径。如果要支持专业更新，新老种子制作时，均应在DLBT_CreateTorrent函数中传入bUpdateExt参数。

**newTorrentFile：** 需要更新的新的种子文件的路径。

**curPath：** 这些文件当前所在的路径（更新时也直接写到这个文件夹里面）。

**curTorrentPassword**和**newTorrentFilePassword**：分别对应新老种子文件的密码，是否加密了种子文件，如果为Null，则是普通种子，否则是种子的密码。另外，如果输入了密码，但无法成功解密，内核也会试着再把它作为一个普通未加密种子来进行尝试直接启动。加密种子只对有需要的商业版用户开放，试用版中会自动忽略该参数。

**fProgress**：可选参数。如果传入一个float的指针，则传出一个进度，标记新老种子有多少文件是没有发生变化的，只需要更新百分多少的数据量。

其它参数的含义详见DLBT_Downloader_Initialize的说明。

**说明：**

该函数只下载新老种子的差异，如果老的种子当时就没把文件下载完成，那么这次更新也不会去下载原来未完成的部分，只是下载两者之间的差异。如果老种子没有下载完成当时的文件，建议先用老种子启动一次，下载完成后再使用更新。

如果老任务比新任务多了一些文件（也就是新种子中删除了一些文件），这些多余的文件不会被删除，还会留着。原因是出于安全目的，点量BT一般不会删除文件（以免有客户很看重的东西被删除）

**专业文件更新接口只对需要的商业版用户开放，在试用版中该接口无效。联系作者可以申请该功能的试用程序。**

### *DLBT_Downloader_GetOldTorrentProgress*

**功能：** 详见DLBT_Downloader_InitializeAsUpdater，该函数用于获取新老种子有多少文件发生了改变，需要更新多少文件。只有制作种子时，传入了bUpdateExt参数的torrent才可以支持。

```c++
// 专业文件更新时，传入新老种子，然后直接传出老种子和新种子的差异情况（进度），如果进度是99%，则意味着只有1%的数据需要下载。
DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
	LPCWSTR             curTorrentFile,    //当前版本的种子文件
	LPCWSTR             newTorrentFile,   //  新版种子文件
	LPCWSTR             curPath,    //  当前文件的路径
	LPCWSTR             statusFile = L"", // 状态文件的路径
	LPCSTR              curTorrentPassword = NULL,
	LPCSTR              newTorrentFilePassword = NULL
	);
```

**参数：**

**curTorrentFile：** 现在这些文件对应的老的种子文件的路径。如果要支持专业更新，新老种子制作时，均应在DLBT_CreateTorrent函数中传入bUpdateExt参数。

**newTorrentFile：** 需要更新的新的种子文件的路径。

**curPath：** 这些文件当前所在的路径（更新时也直接写到这个文件夹里面）。

**statusFile：** 状态文件的路径（具体到文件名）。状态文件是用于记录上次下载的信息的文件，比如上次下载的文件块数、找到的节点信息等，以便下次启动时可以迅速恢复到上次的状态，快速下载。默认为” ”，表示系统会自动选择种子文件的目录下建立一个状态文件。如果是NULL则表示不使用状态文件（不建议，因为没有状态文件，下次启动时会需要扫描上次下载的数据信息、连上的节点信息也会丢失）。

**curTorrentPassword和newTorrentFilePassword：** 分别对应新老种子文件的密码，是否加密了种子文件，如果为Null，则是普通种子，否则是种子的密码。另外，如果输入了密码，但无法成功解密，内核也会试着再把它作为一个普通未加密种子来进行尝试直接启动。加密种子只对有需要的商业版用户开放，试用版中会自动忽略该参数。

**说明：**

该函数用于不启动下载，只是看一下需要多少更新量，一般配合专业更新接口使用。

**专业文件更新接口只对需要的商业版用户开放，在试用版中该接口无效。联系作者可以申请该功能的试用程序。**

-------------------------------------------------------------------------------------------------------------------------------`

### *DLBT_Downloader_ReleaseAllFiles*

**功能：** 关闭任务之前，可以调用该函数停掉IO线程对该任务的操作

```c++
// 关闭任务之前，可以调用该函数停掉IO线程对该任务的操作（异步的，需要调用DLBT_Downloader_IsReleasingFiles函数来获取是否还在释放中）。
// 该函数调用后，请直接调用_Release，不可对该句柄再调用其它DLBT_Dwonloader函数。本函数内部会先暂停所有数据下载，然后释放掉文件句柄
DLBT_API void WINAPI DLBT_Downloader_ReleaseAllFiles(HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**说明：**

本函数内部执行是异步的，如果希望知道是否释放完成，需要调用DLBT_Downloader_IsReleasingFiles函数或者通过DLBT_GetDownloaderInfo中的bReleasingFiles变量来轮询获取是否还在释放中。如果有些torrent是几千个文件或者更大的文件量，有可能会需要1-2s的时间才能释放完成。该函数调用后，请直接调用DLBT_Downloader_Release函数，不可对该句柄再调用除DLBT_Downloader_IsReleasingFiles和DLBT_GetDownloaderInfo外的其它DLBT_Dwonloader函数。本函数内部会先停止所有数据下载，然后释放掉文件句柄。一般用于任务完成后，外部希望DLBT停止所有文件占用，可以立即剪切或者使用文件时，使用本函数来确保文件不被占用。否则DLBT_Downloader_Release时，内部也会是异步释放，可能需要一些时间，提前释放成功后再去DLBT_Downloader_Release，就可以确保文件真正已经不再占用。

### *DLBT_Downloader_IsReleasingFiles*

**功能：** 是否还在释放句柄的过程中，配合DLBT_Downloader_ReleaseAllFiles查询释放文件的结果

```c++
DLBT_API BOOL WINAPI DLBT_Downloader_IsReleasingFiles(HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_Release*

**功能：** 停止一个下载任务

```c++
enum DLBT_RELEASE_FLAG
{
    DLBT_RELEASE_NO_WAIT = 0,           // 默认方式Release，直接释放，不等待释放完成
    DLBT_RELEASE_WAIT = 1,              // 等待所有文件都释放完成
    DLBT_RELEASE_DELETE_STATUS = 2,     // 删除状态文件
    DLBT_RELEASE_DELETE_ALL = 4         // 删除所有文件
};

// 关闭hDownloader所标记的下载任务 nFlag 具体参考：DLBT_RELEASE_FLAG
DLBT_API HRESULT WINAPI DLBT_Downloader_Release (HANDLE hDownloader, int nFlag = DLBT_RELEASE_NO_WAIT);

```

**参数：**

**hDownloader：** 下载任务的句柄。

**nFlag：** 删除的选项，具体请参考：DLBT_RELEASE_FLAG的各项可选设置，可以用 或 运算的方式组合各个选项，比如 DLBT_RELEASE_WAIT | DLBT_RELEASE_DELETE_STATUS

**说明：**

bDeleteAllFiles设置后，并不一定能保证肯定可以删除文件，因为可能文件会被其它程序占用等，所以建议调用完成DLBT_Downloader_Release后，应用层程序还可以在后面再次调用一下DeleteFile等操作，确保文件被删除成功。

### *DLBT_Downloader_AddHttpDownload*

**功能：** 增加一个Http的下载地址，在从其它P2P节点下载的同时从该http下载源进行下载。

```c++
// 增加一个http的地址，当该下载文件在某个Web服务器上有http下载时可以使用，web服务器的编码方式最好为UTF-8，如果是其它格式可以联系点量软件进行修改
DLBT_API void WINAPI DLBT_Downloader_AddHttpDownload (HANDLE hDownloader, LPSTR url);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**url：** Http源的地址。

**说明：**

Http跨协议(P2SP)，遵循Bittorrent的扩展协议：http://www.getright.com/seedtorrent.html ，需要url网站的文件目录同torrent中的文件目录有相对应的关系。比如，如果种子是一个文件夹：天龙八部，放到一个网址：http://www.yoursite.com/files/天龙八部 目录下面，这里只需要传入http://www.yoursite.com/files/ （注意结尾有/）。 但如果是单个文件，天龙八部.rar，则建议传入 http://www.yoursite.com/files/天龙八部.rar ，文件夹和单个文件的规则不同。

如果通过DLBT_Downloader_SetMaxSessionPerHttp设置了对一个Url可以建立多个连接，每调用一次DLBT_Downloader_AddHttpDownload，如果连接数未满，则新建一个连接；如果满了则忽略此次调用；因此如果希望多个连接，可以考虑周期性经常调用DLBT_Downloader_AddHttpDownload；这样，即使万一连接由于网络原因临时断开，也会在调用DLBT_Downloader_AddHttpDownload时立即补上一条新连接。

### *DLBT_Downloader_RemoveHttpDownload*

**功能：** 移除一个P2SP的地址，如果正在下载中，会进行断开并且从候选者列表中移除，不再进行重试。

```c++
DLBT_API void WINAPI DLBT_Downloader_RemoveHttpDownload (HANDLE hDownloader, LPSTR url);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**url：** Http源(p2sp)的地址。

### *DLBT_Downloader_GetHttpConnections*

**功能：** 获取某下载任务此时在使用的所有P2SP连接信息。 

```c++
DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**urls：** 用于传出一个url的数组（内核中分配内存，需要调用DLBT_Downloader_FreeConnections释放。

**urlCount：** 传出url数组的数目

**说明：**

如果DLBT_Downloader_SetMaxSessionPerHttp设置了对一个p2sp地址可以同时建立多个连接，则本函数返回的URL数组会有重复的url的可能；返回的URL，每个就代表在跟这个地址建立的一个连接。注意：urls是由DLL分配内存，需要调用DLBT_Downloader_FreeConnections释放，否则会有内存泄露。

### *DLBT_Downloader_FreeConnections*

**功能：** 释放DLBT_Downloader_GetHttpConnections传出的Url数组的内存。

```c++
DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
```

 **参数：**

**hDownloader：** 下载任务的句柄。

**urls：** 对应于DLBT_Downloader_GetHttpConnections中的urls变量。

**urlCount：** url数组的数目。

### *DLBT_Downloader_SetMaxSessionPerHttp*

```C++
// 设置一个Http地址，最多可以建立多少个连接，默认是1个连接. 如果服务器性能好，可以酌情设置，比如设置10个，则是对一个Http地址，可以建立10个连接。
// 设置之前如果已经一个Http地址建立好了多个连接，则不再断开，仅对设置后再新建连接时生效
DLBT_API void WINAPI DLBT_Downloader_SetMaxSessionPerHttp (HANDLE hDownloader, int limit);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**limit：** 对该任务的任意一个Http网址，最多建立多少连接

**说明：**

如果新设置的数字比之前的数字小，之前已经建立好的连接不会立即断开；如果新设置的数字比之前内部的限制大，则内部会首先尽可能的将连接在随后的1-2s内逐步建立起来，直到达到本次的设置。不过，如果服务器网络有问题，比如如果该p2sp地址临时下线，遇到彻底无法连上的情况，这些连接还是有可能断开的。如果担心服务器有短暂下线等问题，还可以考虑配合定期调用DLBT_Downloader_AddHttpDownload函数，每调用一次DLBT_Downloader_AddHttpDownload，如果连接数未满，则新建一个连接；如果满了则忽略此次调用；因此如果希望多个连接，可以考虑周期性经常调用DLBT_Downloader_AddHttpDownload；这样，即使万一连接由于网络原因临时断开，也会在调用DLBT_Downloader_AddHttpDownload时立即补上一条新连接。

### *DLBT_Downloader_AddTracker和DLBT_Downloader_RemoveAllTracker*

**功能：** DLBT_Downloader_AddTrakcer可以在现有torrent的基础上再增加一些临时tracker（不保存到torrent中，只供本次下载使用）, DLBT_Downloader_RemoveAllTracker可以清空现有的所有tracker。

```C++
DLBT_API void WINAPI DLBT_Downloader_AddTracker (HANDLE hDownloader, LPCSTR url, int tier);
DLBT_API void WINAPI DLBT_Downloader_RemoveAllTracker (HANDLE hDownloader);
```

 **参数：**

**hDownloader：** 下载任务的句柄。

**url：** tracker的地址，比如[Http://tracker.com:6969/announce](Http://tracker.com:6969/announce) 。

**tier：** tracker的优先级，相同优先级的tracker，连上一个就不再连下一个了。不同优先级的tracker会根据优先级依次连接。所以，如果同一个tracker服务器的不同地址，应该使用相同优先级。

**说明：**

动态加入tracker往往会同DLBT_Downloader_RemoveAllTracker配合使用，先暂停方式启动，然后将现有的所有Tracker都删除，再Add想要增加的tracker，这样torrent中的原有tracker就不再起作用。比如，可以用于局域网中，删除所有外网tracker，只让系统使用局域网的tracker，和连接局域网供种的用户，减少外网流量。

2013年底左右，我们接到用户反馈和测试发现，部分地区运营商启用了tracker协议的封锁，标准的Tracker协议在很多地区获取不到邻居节点，也就无法拥有下载速度。因此，我们3.7.5以后版本加入了私有协议Tracker功能，但需要Tracker服务器支持，目前配合我们自主研发的点量BT高性能Tracker服务器可以解决这一问题，可以联系我们申请点量BT Tracker来解决这一问题。

### *Downloader_AddHttpTrackerExtraParams*

**功能：** 在每个Http tracker地址的后面，增加一个扩展参数。 

```C++
DLBT_API void WINAPI DLBT_Downloader_AddHttpTrackerExtraParams (HANDLE hDownloader, LPCSTR extraParams);
```

 **参数：**

**hDownloader：** 下载任务的句柄。

**extraParams：** 想要增加的特别参数，格式如：?userID=19&macID=999223。可以结合自己修改的tracker服务器，做一些统计使用。

### *DLBT_Downloader_GetTrackerCount*

**功能：** 获取当前BT的某个下载任务中的Tracker数量

```c++
DLBT_API int WINAPI DLBT_Downloader_GetTrackerCount(HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetTrackerUrl*

**功能：** 获取任务中的某个Tracker的URL地址

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetTrackerUrl (HANDLE hDownloader, int index, LPSTR url, int * urlBufferSize);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 从0开始的tracker的序号，范围在0到tracker的总数量之间。

**url：** 要接收返回的字符串的内存地址。

**urlBufferSize：** 传入url的内存大小，传出出错信息的实际大小

### *DLBT_Downloader_SetDownloadSequence*

**功能：** 设置下载任务是否顺序下载（默认使用稀缺块优先的方式下载）

```c++
DLBT_API void WINAPI DLBT_Downloader_SetDownloadSequence (HANDLE hDownloader, BOOL ifSeq = FALSE);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**ifSeq：** 是否顺序下载。

**说明：**

稀缺块优先的下载方式可以有较好的下载速度，但顺序下载比较适合边下载边播放的方式。如果需要做视频点播等应用，还可以有其它策略实现更为严格的顺序下载、拖动后从指定位置立即下载等高级应用，可以联系我们获取更多技术支持。

### *DLBT_Downloader_GetState*

**功能：** 获取下载任务的当前状态。具体的状态，请参考DLBT_DOWNLOAD_STATE

```c++
DLBT_API DLBT_DOWNLOAD_STATE WINAPI DLBT_Downloader_GetState (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_IsPaused*

**功能：** 返回任务是否处于暂停状态，TRUE为已暂停，FALSE为不是暂停状态。

```c++
DLBT_API BOOL WINAPI DLBT_Downloader_IsPaused (HANDLE hDownloader);
```

 **参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_Pause和DLBT_Downloader_Resume*

**功能：** 暂停或者继续一个任务。 

```c++
DLBT_API void WINAPI DLBT_Downloader_Pause (HANDLE hDownloader);        //暂停
DLBT_API void WINAPI DLBT_Downloader_Resume (HANDLE hDownloader);       //继续
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetLastError*

**功能：** 任务状态如果是BTDS_ERROR（出错状态），使用该函数获取出错的详细信息。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetLastError (
    HANDLE  hDownloader,  // 任务句柄
    LPSTR   pBuffer,      // 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    int *   pBufferSize  // 传入buffer的内存大小，传出名字的实际大小
    );
```

 **参数：**

**hDownloader：** 下载任务的句柄。

**pBuffer:** 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小。

**pBufferSize:** 传入buffer的内存大小，传出出错信息的实际大小

**返回值：** S_OK（0）代表成功，其他代表失败。

**说明：**

一般只有在最极端情况下才会出错，比如磁盘空间已满文件无法写入等。出错后，如果错误消除（比如磁盘重新有了空间），则可以调用DLBT_Downloader_ResumeInError函数进行出错恢复。

### *DLBT_Downloader_ResumeInError*

**功能：** 任务状态如果是BTDS_ERROR（出错状态），此时任务已经是暂停了，不再进行下载。在做了一些处理后，可以尝试调用该函数重新启动任务下载。

```c++
DLBT_API void WINAPI DLBT_Downloader_ResumeInError (HANDLE hDownloader); //清除这个错误，尝试重新开始任务
```

**参数：**

**hDownloader：** 下载任务的句柄。

**说明：**

任务一般只有在最极端情况下才会出错，比如磁盘空间已满文件无法写入等。出错后，任务会进入暂停模式。在错误消除后（比如删除了一些文件，磁盘空间又有了），则可以调用该函数进行重新下载，该函数会删除上一个错误信息。

### *DLBT_Downloader_IsHaveTorrentInfo* 

**功能：** 用于无种子模式下载，用来判断在无种子启动模式下，是否已经获得到了该文件的种子信息。

```c++
// 无种子下载的相关接口（无种子模式在试用版中无效，可以调用这些接口，但不会有效果）
DLBT_API BOOL WINAPI DLBT_Downloader_IsHaveTorrentInfo (HANDLE hDownloader); // 无种子下载时，用于判断是否成功获取到了种子信息
```

**参数：**

**hDownloader：** 下载任务的句柄。

**说明：**

无种子的模式详细说明请参考：

DLBT_Downloader_Initialize_FromUrl和DLBT_Downloader_Initialize_FromInfoHash。

无种子模式只对需要的商业版用户开放，在试用版中该接口无效。

DLBT_Downloader_IsHaveTorrentInfo函数用于获取无种子下载时是否有了种子信息。在尚无种子信息时，DLBT_Downloader_GetTotalFileSize等函数都不会有正确的值。这种情况下，最好的办法是：如果尚无种子信息，则显示一个“正在下载种子……”的状态，然后不再显示文件大小等信息。

### *DLBT_Downloader_MakeURL* *和**DLBT_Torrent_MakeURL*

**功能：** 用于无种子模式下载，通过种子或者下载任务，制作一个可以不需要种子即可下载的网址，参考DLBT_Downloader_Initialize_FromUrl。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_MakeURL (// 通过任务，制作一个可以不需要种子即可下载的网址
    HANDLE      hDownloader,
    LPSTR       pBuffer,  // 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    int  *      pBufferSize             // 传入buffer的内存大小，传出URL的实际大小
);  
DLBT_API HRESULT WINAPI DLBT_Torrent_MakeURL (  // 通过种子，制作一个可以不需要种子即可下载的网址
    HANDLE      hTorrent,
    LPSTR       pBuffer,   // 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    int  *      pBufferSize             // 传入buffer的内存大小，传出URL的实际大小
    ); 
```

**参数：**

**hDownloader：** 下载任务的句柄。

**hTorrent:** 种子的句柄

**pBuffer:** 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小。

**password****:** 传入buffer的内存大小，传出URL的实际大小。

**说明：**

无种子的模式详细说明请参考：

DLBT_Downloader_Initialize_FromUrl和DLBT_Downloader_Initialize_FromInfoHash。

无种子模式只对需要的商业版用户开放，在试用版中该接口无效。

### *DLBT_Downloader_SaveTorrentFile*

**功能：** 用于无种子模式下载，在无种子模式下载的时候，内核会先通过P2P网络从其它用户（节点）那里获取到种子信息，一旦获取到了种子信息（可通过DLBT_Downloader_IsHaveTorrentInfo判断），则可以调用该函数将种子信息保存下来。

```c++
// 无种子下载，如果已经下载到了种子，可以利用这个函数将种子保存起来，以后就能使用了
DLBT_API HRESULT WINAPI DLBT_Downloader_SaveTorrentFile (
HANDLE hDownloader, 
LPCWSTR filePath, 
LPCSTR password = NULL
);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**filePath:** 种子文件的保存路径

**password****:** 标记文件是否加密，如果不为NULL，则加密，并且password是加密的密码

**说明：**

需要在调用该函数前调用DLBT_Downloader_IsHaveTorrentInfo进行判断，必须有了Torrent，才能保存该torrent。建议保存后的torrent文件可以在以后启动时直接使用，就不必再使用无种子模式了。因为无种子模式每次都需要下载种子，有了种子则可以节省这个下载种子的时间。

根据BT扩展协议，无种子模式下获取到的种子信息，备注、发布者、发布者网址、tracker这些附加消息将不会获取到，只有文件信息，因此在保存前，建议先调用DLBT_Downloader_AddTracker等接口将这些信息补全。

无种子的模式详细说明请参考：

DLBT_Downloader_Initialize_FromUrl和DLBT_Downloader_Initialize_FromInfoHash。

无种子模式只对需要的商业版用户开放，在试用版中该接口无效。

### *DLBT_Downloader_SetDownloadLimit*和*DLBT_Downloader_SetUploadLimit*

**功能：** 设置下载或上传的最大速度限制。

```c++
DLBT_API void WINAPI DLBT_Downloader_SetDownloadLimit (HANDLE hDownloader, int limit); //下载限速
DLBT_API void WINAPI DLBT_Downloader_SetUploadLimit (HANDLE hDownloader, int limit);   //上传限速
```

**参数：**

**hDownloader：** 下载任务的句柄。

**limit：** 要设置的最大速度限制，-1为无限速度。单位是Byte，比如，如果要设置1M的限制，需要传入1024*1024；1K的限制，则需要传入1024

***\**DLBT_Downloader_SetMaxUploadConnections\**\******\**
\**\******\**DLBT_Downloader_SetMaxTotalConnections\**\***    

**功能：** 设置下载或者上传的最大连接数限制。 

```c++
DLBT_API void WINAPI DLBT_Downloader_SetMaxUploadConnections (HANDLE hDownloader, int limit);
DLBT_API void WINAPI DLBT_Downloader_SetMaxTotalConnections (HANDLE hDownloader, int limit);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**limit：** 要设置的最大连接数限制，-1为无限速度。

### *DLBT_Downloader_SetOnlyUpload*

**功能：** 设置任务只上传，不再下载。

```c++
// 确保任务只上传，不下载
DLBT_API void WINAPI DLBT_Downloader_SetOnlyUpload (HANDLE hDownloader, bool bUpload);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**bUpload：** 是否只上传。

**说明：**

该函数如果在任务已经下载完成时不需要调用，已经下载完成的任务，只要不执行DLBT_Downloader_Release操作，本身就会继续持续上传（供种）的。该函数是在文件还没下载完成，但又不希望他继续下载数据，只希望他上传数据时使用。应用场景比如：VOD模式下，如果一个电影用户上次观看到了一半，但用户已经不需要观看了，此时就不需要再下载。但如果希望在后台继续给其它用户上传，但又不希望占用用户的下载带宽，就可以设置只上传。这种模式下，只会继续上传数据，不会再下载数据。

### *DLBT_Downloader_SetServerDownloadLimit*

**功能：** 设置对服务器IP进行下载限速，单位是BYTE(字节），如果需要限速1M，请输入1024*1024。

```c++
DLBT_API void WINAPI DLBT_Downloader_SetServerDownloadLimit(HANDLE hDownloader, int limit);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**limit：** 要设置的限制，单位是字节BYTE，如果需要限速1M，请输入1024*1024。-1和0代表不做限制。

**说明：**

本函数需要配合DLBT_AddServerIP使用，只要是DLBT_AddServerIP设置的服务器IP，在传输中都会受本函数的限制，内部是通过IP比较进行的限速。一般用于：如果检测发现本任务下载速度很快，并且有大量高速连接时，此时可以考虑不再去使用服务器带宽资源，就可以对服务器进行限速。尽可能使用p2p模式传输。



### *DLBT_Downloader_BanServerDownload*

**功能：** 设置本任务不再去跟所有的服务器IP建立连接。

```c++
DLBT_API void WINAPI DLBT_Downloader_BanServerDownload(HANDLE hDownloader, bool bBan);
```

**参数：**

**hDownloader：** 要操作的下载任务的句柄。

**bBan：** true: 代表不再跟服务器建立连接；false代表取消本限制。

**说明：**

本函数需要配合DLBT_AddServerIP使用，只要是DLBT_AddServerIP设置的服务器IP，在传输中都会受本函数的限制，内部是通过IP比较进行的限制。如果服务器连接已经建立好了，不受本函数的限制，对于已经建立好的连接，建议是通过限速，而不是断开。本函数调用后只对此后建立的连接进行过滤。

### *DLBT_Downloader_SetShareRateLimit和DLBT_Downloader_GetShareRate*

**功能：** 设置最大共享率和获取当前的共享率，共享率是上传同下载的比率，代表自己的贡献程度。

```c++
// 下载分享率 (上传/下载的比例）的接口
DLBT_API void WINAPI DLBT_Downloader_SetShareRateLimit (HANDLE hDownloader, float fRate);//设置
DLBT_API double WINAPI DLBT_Downloader_GetShareRate (HANDLE hDownloader);//获取
```

**参数：**

**hDownloader：** 下载任务的句柄。

**fRate：** 要设置的共享率，0为不限制。

**说明：**

共享率可用于防止无限制的上传，上传到最大共享率限制时则停止上传。

### *DLBT_Downloader_GetTorrentName*

**功能：** 获取种子文件创建时指定的名字。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetTorrentName (
    HANDLE      hDownloader,
    LPWSTR       pBuffer,  // 用于返回信息的内存，可以为空，为空则在pBufferSize中返回名字的实际大小
    int     *   pBufferSize     // 传入buffer的内存大小，传出名字的实际大小
    );
```

**参数：**

**hDownloader：** 下载任务的句柄。

**pBuffer:** 用于返回种子指定的文件（文件夹）的名字。如果为NULL，则在pBufferSize参数中返回名字所需空间的实际大小。

**pBufferSize:** 传入pBuffer分配的空间的大小，传出名字的实际大小。如果pBuffer的空间小于名字的长度，则返回ERROR_INSUFFICIENT_BUFFER错误码。

### *DLBT_Downloader_GetTotalFileSize*

**功能：** 获得种子文件中所有文件的总大小。

```c++
DLBT_API UINT64 WINAPI DLBT_Downloader_GetTotalFileSize (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetProgress*

**功能：** 获得下载任务的当前进度百分比（完成了选定要下载文件中的多少）。

```c++
DLBT_API float WINAPI DLBT_Downloader_GetProgress (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**说明：**

返回值已乘了100，因此外面直接可按百分比显示，使用DLBT_Downloader_GetDownloadedBytes除以DLBT_Downloader_GetTotalFileSize也是一个下载进度，但这个进度是总体的进度，当种子文件中包含的所有文件都要下载时有效；而DLBT_Downloader_GetProgress在只选择了部分文件进行下载时有效。

### *DLBT_Downloader_GetDownloadedBytes和DLBT_Downloader_GetUploadedBytes*

**功能：** 获取已下载或者已上传的总字节数。

```c++
DLBT_API UINT64 WINAPI DLBT_Downloader_GetDownloadedBytes (HANDLE hDownloader);
DLBT_API UINT64 WINAPI DLBT_Downloader_GetUploadedBytes (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetDownloadSpeed和DLBT_Downloader_GetUploadSpeed*

**功能：** 获取当前的下载和上传速度。

```c++
DLBT_API UINT WINAPI DLBT_Downloader_GetDownloadSpeed (HANDLE hDownloader);
DLBT_API UINT WINAPI DLBT_Downloader_GetUploadSpeed (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetPeerNums*

**功能：** 获取各类节点的数目。

```c++
DLBT_API void WINAPI DLBT_Downloader_GetPeerNums (
    HANDLE      hDownloader,        // 下载任务的句柄
    int     *   connectedCount,     // 该任务连接上的节点数（用户数）
    int     *   totalSeedCount,     // 总的种子数目，如果Tracker不支持scrap，则返回-1
    int     *   seedsConnected,     // 自己连上的种子数
    int     *   inCompleteCount,    // 未下完的人数，如果Tracker不支持scrap，则返回-1
    int     *   totalCurrentSeedCount, // 当前在线的总的下载完成的人数（包括连上的和未连上的）
    int     *   totalCurrentPeerCount  // 当前在线的总的下载的人数（包括连上的和未连上的）
    );
```

### *DLBT_Downloader_GetFileCount*

**功能：** 获得该任务（对应一个Torrent文件）中所包含的文件的个数。

```c++
DLBT_API int WINAPI DLBT_Downloader_GetFileCount (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetFileSize*

**功能：** 获得任务（对应一个Torrent文件）中所包含的某个特定文件的大小。

```c++
DLBT_API UINT64 WINAPI DLBT_Downloader_GetFileSize (HANDLE hDownloader, int index);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Downloader_GetFileCount取得的文件的总数目。

### *DLBT_Downloader_GetFileOffset*

**功能：** 获得某个指定文件在torrent中的起始位置（一般VOD点播版本中，对于多文件的种子，计算某个视频文件拖动的位置等需要使用）。

```c++
DLBT_API UINT64 WINAPI DLBT_Downloader_GetFileOffset (HANDLE hDownloader, int index);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Downloader_GetFileCount取得的文件的总数目。

**返回值：** 64位整数，返回文件在torrent中所处的位置（字节数）。

### *DLBT_Downloader_IsPadFile*

**功能：** 判断文件是否为对齐文件（padding file）。

```c++
DLBT_API BOOL WINAPI DLBT_Downloader_IsPadFile (HANDLE hDownloader, int index)
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Downloader_GetFileCount取得的文件的总数目。

**说明：**

Bitcomet以及点量BT 3.6版本后，均有可能有padding file存在，目的是为了更少的文件更新量以及较好的磁盘利用率，详见：DLBT_CreateTorrent的说明。

### *DLBT_Downloader_GetFilePathName*

**功能：** 获得任务（对应一个Torrent文件）中所包含的某个文件的路径和名称。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetFilePathName (
    HANDLE      hDownloader,        // 下载任务的句柄
    int         index,              // 文件的序号
    LPWSTR      pBuffer,            // 传出文件名
    int     *   pBufferSize,        // 传入buffer的大小，传出文件名的实际长度
    bool        needFullPath = false// 是否需要全部的路径还是只需要文件在种子中的相对路径    
    );
```

**说明：**

如果buffer的大小小于要返回的文件路径名大小，则会返回ERROR_INSUFFICIENT_BUFFER错误码，此时pBufferSize中会传出实际需要的大小，成功则返回S_OK。needFullPath如果为false，则只返回名字和在种子文件中的相对路径，否则返回在磁盘上的绝对路径。

### *DLBT_Downloader_DeleteUnRelatedFiles*

**功能：** 将下载目录下存在，但torrent记录中不存在的文件全部删除，对单个文件的种子无效。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_DeleteUnRelatedFiles (HANDLE hDownloader);
```

**说明：**

本函数是对下载的保存目录文件夹进行扫描，列出磁盘上目前有多少文件，然后比较是否torrent中也有该文件存在。如果不存在，则全部删除。 -- 一般用于文件夹的更新中，比如老版本的文件夹中有10个文件在新版本中已经删除了，新版本下载完成后，希望能找出哪些文件不存在于新版本了，直接删除，可以使用本函数。

### *DLBT_Downloader_GetFileHash*

**功能：** 获取某个文件的Hash值（SHA1算法）。只有制作种子时使用bUpdateExt才能获取到。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetFileHash (
	HANDLE      hDownloader,        // 下载任务的句柄
	int         index,              // 要获取的文件的序号，piece的数目可以通过DLBT_Downloader_GetFileCount获得
	LPSTR       pBuffer,            // 传出Hash字符串
	int     *   pBufferSize         // 传入pBuffer的大小，pieceInfoHash固定为个字节，因此此处应该是的长度。
```

**说明：**

如果buffer的大小小于要返回的hash大小---建议使用48即可，则会返回ERROR_INSUFFICIENT_BUFFER错误码，此时pBufferSize中会传出实际需要的大小，成功则返回S_OK。详见DLBT_CreateTorrent中对bUpdateExt的说明。

### *DLBT_Downloader_GetFileProgress*

**功能：** 获得任务（对应一个Torrent文件）中所包含的某个文件的下载进度。

```c++
// 取文件的下载进度，该操作需要进行较多操作，建议仅在必要时使用
DLBT_API float WINAPI DLBT_Downloader_GetFileProgress (HANDLE hDownloader, int index);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Downloader_GetFileCount取得的文件的总数目。

**说明：**

该函数需要对数据进行一遍统计，需要进行一定的操作，建议仅在必要时使用

### *DLBT_FILE_PRIORITIZE*

**功能：** 设置单个文件的下载优先级。

```c++
enum DLBT_FILE_PRIORITIZE
{
    DLBT_FILE_PRIORITY_CANCEL        =   0,     // 取消该文件的下载
    DLBT_FILE_PRIORITY_NORMAL,                  // 正常优先级
    DLBT_FILE_PRIORITY_ABOVE_NORMAL,            // 高优先级
    DLBT_FILE_PRIORITY_MAX                      // 最高优先级（如果有该优先级的文件还未下完，不会下载低优先级的文件）
};
```

### *DLBT_Downloader_SetFilePrioritize*

**功能：** 设置文件的下载的优先级，可以通过这个接口设置某些文件不下载。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_SetFilePrioritize (
    HANDLE                  hDownloader, 
    int                     index,              // 文件序号
    DLBT_FILE_PRIORITIZE    prioritize,         // 优先级
    BOOL                    bDoPriority = TRUE  
    );
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Downloader_GetFileCount取得的文件的总数目。

**prioritize****：**文件的优先级，请参考DLBT_FILE_PRIORITIZE。

**bDoPriority：** 是否立即应用这个设置，如果有多个文件需要设置，建议暂时不立即应用，让最后一个文件应用设置，或者可以主动调用DLBT_Downloader_ApplyPrioritize函数来应用，因为每应用一次设置都要对所有Piece操作一遍，比较麻烦，所以应该一起应用。

### *DLBT_Downloader_ApplyPrioritize*

**功能：** 立即应用对文件优先级的设置。

```c++
DLBT_API void WINAPI DLBT_Downloader_ApplyPrioritize (HANDLE hDownloader);
```

**参数：**

**hDownloader：** 下载任务的句柄。

### *DLBT_Downloader_GetPiecesStatus*

**功能：** 获取当前每个分块的状态，比如可以用于判断是否需要去更新（是否已经拥有了该块）。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetPiecesStatus (
    HANDLE                  hDownloader,    // 任务句柄
    bool                *   pieceArray,     // 标记每个块是否本地已是最新的数组
    int                     arrayLength,    // 数组的长度
    int                 *   pieceDownloaded // 已经下载的分块的数目，在显示下载的分块的图形时，该参数比较有用。如果发现该数字和上次获取时没有
                                            // 变化，则可以不需要重画当前的分块状态图
    );
```

**参数：**

**hDownloader：** 下载任务的句柄。

**pieceArray：** 标记分块状态的数组指针，bool （布尔）类型。该数组的长度必须与任务的总分块数相同，也就是必须是DLBT_Downloader_GetPieceCount个元素的数组，由内核逐一对数组中的元素赋值。True代表该块已经是最新了，false代表还没有该块，或者该块需要更新。

**arrayLength：** 标记传入的pieceArray的长度，内核用于验证是否和任务的总分块数一致。

**pieceDownloaded：** 当前已经拥有的正确的分块的数目，在显示下载的分块图形时，该参数非常有用。如果发现该数字和上次获取时一致，则无需去浏览pieceArray中的内容，也无需重画分块状态图。

**说明：**

该接口可以用于显示分块状态（哪些下载完成了）

### *DLBT_Downloader_SetPiecePrioritize*

**功能：** 设置Piece（分块）的下载优先级，比如可以用于取消某些分块的下载，从指定位置开始下载等。index表示分块的序号。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_SetPiecePrioritize (
    HANDLE                  hDownloader, 
    int                     index,              // 文件序号
    DLBT_FILE_PRIORITIZE    prioritize,         // 优先级
    BOOL                    bDoPriority = TRUE  // 是否立即应用这个设置（如果有多个分块需要设置，建议暂时不立即应用，让最后一个块应用设置，或者可以主动调用DLBT_Downloader_ApplyPrioritize函数来应用，因为每应用一次设置都要对所有Piece操作一遍，比较麻烦，所以应该一起应用
    );
```

**参数：**

**hDownloader：** 下载任务的句柄。

**index：** 块的序号，要求 >=0 , 小于该任务块的总数目：DLBT_Downloader_GetPieceCount。

**prioritize****：**文件的优先级，请参考DLBT_FILE_PRIORITIZE。

**bDoPriority：** 是否立即应用这个设置，如果有多个分块需要设置，建议暂时不立即应用，让最后一个块应用设置，或者可以主动调用DLBT_Downloader_ApplyPrioritize函数来应用，因为每应用一次设置都要对所有Piece操作一遍，比较麻烦，所以应该一起应用。

**说明：**

该接口一可以支持数据块级别的下载优先级设定，使得高优先级的数据块最快下载，更好地支持了音视频点播直播等P2P应用；提升点播或直播数据时拖动的响应速度。在用户拖动进度条时，程序计算出分块的位置，设置该区域的块优先下载，则内核会下载该区域，以实现灵敏的响应进度条拖动。

### *DLBT_Downloader_AddPeerSource*

**功能：** 手工指定连接哪一个用户。

```c++
DLBT_API void WINAPI DLBT_Downloader_AddPeerSource (HANDLE hDownloader, char * ip, USHORT port);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**ip**: 要连接的用户的IP地址。

**port:** 要连接的用户的端口号。

**说明：**

如果连接几次，该用户都不能被连接上（比如对方不在线），那么该用户将有可能被删除出去，不再进行连接。如果在你们的系统中，要连接的是服务器，那么建议每30s或者1分钟调用一次该函数，以防止服务器短期下线。这样每隔一段时间连接一次就会解决这个问题。30s调用一次不会造成资源浪费，内部会有自动判断，如果已经在连接，则不会再建立连接。

### *DLBT_Downloader_GetInfoHash*

**功能：** 获得任务（对应一个Torrent文件）的可读InfoHash值。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_GetInfoHash (
    HANDLE      hDownloader,        // 下载任务的句柄
    LPSTR       pBuffer,            // 传出InfoHash的内存缓冲
    int     *   pBufferSize         // 传入缓冲的大小，传出实际的InfoHash的长度
    );
```

**说明：**

如果pBufferSize的大小小于要返回的长度，则会返回ERROR_INSUFFICIENT_BUFFER错误码，此时pBufferSize中会传出实际需要的大小，成功则返回S_OK。

### *DLBT_Downloader_GetPieceCount和DLBT_Downloader_GetPieceSize*

**功能：** 获得任务（对应一个Torrent文件）的Piece（分块）数和每块的大小。

```c++
DLBT_API int WINAPI DLBT_Downloader_GetPieceCount (HANDLE hDownloader);
DLBT_API int WINAPI DLBT_Downloader_GetPieceSize (HANDLE hDownloader);
```

**说明：**

分块大小是在制作种子时指定的。

### *DLBT_Downloader_SaveStatusFile*

**功能：** 主动保存一次状态文件。

```c++
DLBT_API void WINAPI DLBT_Downloader_SaveStatusFile (HANDLE hDownloader);
```

**说明：**

状态文件在内部默认是下载完成时自动保存一次，或者每次下载任务正常结束，外部程序调用DLBT_Downloader_Release函数时存储一次。目的是为了记录本次启动以来每个分块的下载状态，以及当前连上的一些用户信息等。有状态文件的存在，任务下次启动时可以较快加载启动，迅速知道自己上次的下载状态信息。自动保存的周期可以通过：DLBT_SetStatusFileSavePeriod函数来进行修改。本函数是可以让外部程序可以主动保存一次。内部是异步保存，函数调用完成后有可能需要1-2s才可以看到状态文件生成。

### *DLBT_Downloader_SetStatusFileMode*

**功能：** 设置状态文件的保存模式。

```c++
DLBT_API void WINAPI DLBT_Downloader_SetStatusFileMode (HANDLE hDownloader, BOOL bOnlyPieceStatus);
```

**参数：**

**hDownloader：**下载任务的句柄。

**bOnlyPieceStatus****：**是否只保存一些文件分块信息，便于服务器上生成后发给每个客户机；客户机就不用再比较了，直接快速启动. 默认是FALSE，也就是全部信息都保存。

**说明：**

该函数对于游戏更新类应用创建快照数据非常有用。比如某个游戏之前有1.0版本，新发布了2.0版本，但不希望下面所有的用户都重新扫描一遍磁盘文件才能知道2.0和1.0变化了哪些数据，可以在某台服务器或者服务商的机器上，启动一次2.0的torrent，然后指向保存目录是1.0的文件夹，他会先进行一次完整扫描，此时如果设置了bOnlyPieceStatus为TRUE，则在扫描完成后正常停止任务时，会生成一个状态文件，而这个状态文件里面只有文件数据分块的状态，里面记录了2.0需要下载哪些数据块（相比1.0变化的数据块）。这样将该文件分发到客户机器，客户机器启动任务前，删除老的状态文件，使用上本状态文件，则可以直接跳过扫描，直接基于本状态文件进行下载。

### *DLBT_Downloader_IsSavingStatus*

**功能：** 检查是否状态文件在保存。

```c++
DLBT_API BOOL WINAPI DLBT_Downloader_IsSavingStatus (HANDLE hDownloader);
```

**说明：**

因为DLBT_Downloader_SaveStatusFile函数是一个异步的函数，调用后，内部线程中会安排执行，但不确定什么时间执行完成。则可以调用该函数判断，是否还在保存，如果是FALSE，则说明状态文件已经完成了。

### *DLBT_Downloader_AddPartPieceData*

**功能：** 向BT系统中写入通过其它方式接收来的数据块。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);
```

**参数：**

**hDownloader：** 下载任务的句柄。

**offset：** 本数据块在整个任务中的起始位置。

**size：** 数据的长度。

**data：** 数据指针。

**说明：**

可以支持DLBT和其它协议的扩展结合，比如如果有一块数据是通过ftp或者电驴等协议下载到了，可以直接通过本函数Add进入DLBT，由DLBT进行保存和提供给其它p2p节点。如果本函数传入的数据够了一个分块，经过hash验证是合法的数据才会进行保存，否则会丢弃。如果不足一个分块，会暂存起来等够了一个分块后验证。本函数仅在最全功能版和VOD增强版中有效。

### *DLBT_Downloader_AddPieceData*

**功能：** 向BT系统中写入通过其它方式接收来的数据块。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
    HANDLE                  hDownloader,
    int                     piece,          //分块序号
    char            *       data,           //数据本身
    bool                    bOverWrite      //如果已经有了，是否覆盖
    );
```

**参数：**

**hDownloader：** 下载任务的句柄。

**piece：** 本数据块对应于torrent中的哪个分块

**data：** 数据指针，数据内存必须为本分块的pieceSize大小，完全一样大。

**bOverWrite：** 如果本分块已经有了，是否需要覆盖。

**说明：**

相比DLBT_Downloader_AddPartPieceData可以传入任意大小的数据，本函数只能每次传入恰好一个分块大小的数据，而且必须和所指明的piece序号完全匹配。本函数仅在最全功能版和VOD增强版中有效。

### *DLBT_REPLACE_PROGRESS_CALLBACK*

**功能：** 每次要替换一个文件分片时调用的回调，外部可以获取到替换过程执行的进度，以及随时取消替换。

```c++
typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
      IN void * pContext,                   // 回调的上下文（通过DLBT_Downloader_ReplacePieceData的pContext参数传入），这里传回去，便于外面处理
                                            // 比如，外部传入一个this指针，回调的时候再通过这个指针知道是对应哪个对象
      IN int pieceIndex,                    //本次要替换的数据位于哪个分块（分块在torrent中的索引）
      IN int replacedPieceCount,            //已经完成了多少个piece的替换
      IN int totalNeedReplacePieceCount,    //总共有多少个要替换的piece分块
      IN int fileIndex,                     //本次要替换的数据位于哪个文件
      IN UINT64 offset,                     //在这个文件中，这块数据的偏移量
      IN UINT64 size,                       //这块数据的总大小（距离偏移量）
      IN int replacedFileSliceCount,        //已经完成了多少个文件片段的替换
      IN int totalFileSliceCount            //总共有多少个需要替换的文件片段
      );
```

**说明：**

返回FALSE代表希望立即终止，TRUE代表继续。

一个分块Piece可能会包括多个小文件（或者大文件的尾部，多文件粘连的地方），因此一个分块pieceIndex可能会对应了多个文件片段，但一个文件片段只会对应一个piece。本回调是替换一个文件片段时触发一次。-- 文件片段是指：fileIndex、offset、size三个参数共同确定的一小段文件内容。

### *DLBT_Downloader_ReplacePieceData*

**功能：** 替换数据块的接口：将某块数据直接替换到目标文件的相同位置。

```c++
DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
	HANDLE			hDownloader,		//下载任务句柄
	int   *			pieceArray,			// 需要将哪些分块替换，是一个int数组
	int				arrayLength,		// 分块数组的长度
	LPCWSTR			destFilePath,		// 需要替换的文件（文件夹）的目录。比如：E:\Test\1.rar或者E:\Test\Game\天龙八部 等。
	LPCWSTR			tempRootPathName = NULL,	// 临时目录下载时，如果使用了rootPathName，则这里也要设置上，以便从这个文件（文件夹）下读取数据块
	LPCWSTR			destRootPathName = NULL,	// 需要替换的那个下载任务，如果使用了rootPathName，则这里也要设置上，以便对这个文件（文件夹）进行替换
    LPVOID          pContext = NULL,
    DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  //接收进度，并可以随时取消的回调
	);
```

**说明：**

本函数主要是支持临时目录功能，比如在更新一个文件夹（比如一个游戏）时，源目录下的游戏用户正在玩，不想直接下载数据到原始目录，而是希望下载到一个临时的文件夹，下载完成后再回切回来，就可能用到本函数。大致步骤是：先启动一个对比更新任务，传入新老torrent文件，然后比较得出需要下载哪些数据块；将这些数据块下载到一个临时的文件夹下，下载结束后，调用本函数将所有数据块一次性覆盖。这样下载过程中原始文件可以正常使用，并保留了只下载部分数据的优点。

该函数是立即返回，如果HRESULT返回的不是S_OK，说明出错，需要查看返回值。如果返回S_OK，则内部会启动线程来进行替换，中间的结果随时通过DLBT_Downloader_GetReplaceResult来进行查看结果。也可以随时调用：DLBT_Downloader_CancelReplace进行取消线程操作。或者通过回调来进行取消。

关于临时目录功能的相关函数，只在网游专业版以及最全功能版中提供，对于正式购买客户，我们会提供临时目录相关的详细示例程序源码以供参考。

### *DLBT_Downloader_GetReplaceResult和DLBT_Downloader_CancelReplace*

**功能：** 获取替换数据的结果。

```c++
// ReplacePieceData的一些状态，可以通过DLBT_Downloader_GetReplaceResult来进行查看
enum DLBT_REPLACE_RESULT
{
    DLBT_RPL_IDLE  = 0,     //尚未开始替换
    DLBT_RPL_RUNNING,       //正在运行中
    DLBT_RPL_SUCCESS,       //替换成功
    DLBT_RPL_USER_CANCELED, //替换了一半，用户取消掉了
    DLBT_RPL_ERROR,         //出错，可以通过hrDetail来获取详细信息，参考：DLBT_Downloader_GetReplaceResult
};

// 获取替换数据的结果
DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
    HANDLE          hDownloader,        //下载任务句柄
    HRESULT  *      hrDetail,           //如果是有出错，返回详细的出错原因
    BOOL     *      bThreadRunning      //Replace的整个操作是否结束了（出错也会立即结束的）
    );
// 中间随时取消替换数据的操作（不建议取消，因为有可能会替换到一半，这样有些文件是不完整的）
DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);
```

**说明：**

关于临时目录功能的相关函数，只在网游专业版以及最全功能版中提供，对于正式购买客户，我们会提供临时目录相关的详细示例程序源码以供参考。

------

**以下为Move的相关接口**

### *DLBT_Downloader_Move和**DLBT_Downloader_GetMoveResult*

**功能：** 获得任务（对应一个Torrent文件）的Piece（分块）数和每块的大小。

```c++
enum DOWNLOADER_MOVE_RESULT // Move的结果
{
	DLBT_MOVED	= 0,	//移动成功
	DLBT_MOVE_FAILED,	//移动失败
	DLBT_MOVING         //正在移动
};
//移动到哪个目录，如果是同一磁盘分区，是剪切；如果是不同分区，是复制后删除原始文件。由于操作是异步操作，所以立即返回。结果使用DLBT_Downloader_GetMoveResult去获取
DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCWSTR savePath);
//查看移动操作的结果
DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
	HANDLE			hDownloader,   // 下载任务的句柄
	LPSTR			errorMsg,      // 用于返回出错信息的内存，在DLBT_MOVE_FAILED状态下这里返回出错的详情。如果传入NULL，则不返回错误信息
	int				msgSize		   // 出错信息内存的大小
	);
```

**说明：**

该接口不常用，用法见上面注释或者联系作者。

------



## *3.4* 制作种子的相关接口

### *enum* *DLBT_TORRENT_TYPE*

**功能：** 标记要创建的种子的类型

```c++
enum DLBT_TORRENT_TYPE
{
    USE_PUBLIC_DHT_NODE     = 0,    // 使用公共的DHT网络资源
    NO_USE_PUBLIC_DHT_NODE,         // 不使用公共的DHT网络节点
    ONLY_USE_TRACKER,               // 仅使用Tracker，禁止DHT网络和用户来源交换（私有种子）
};
```

**说明：**

请参考Bitcomet软件的制作种子说明，完全兼容Bitcomet的制作种子：http://blog.mdbchina.com/post/886450/ 。注意：如果禁止DHT网络的torrent，是无法使用无种子模式下载的。

### *DLBT_CreateTorrent*

**功能：** 创建一个种子，返回种子的句柄

```c++
DLBT_API HANDLE WINAPI DLBT_CreateTorrent (
    int             pieceSize,      // 文件的分块大小，单位字节，0代表内核自动确定
    LPCWSTR         file,           // 文件名或者目录（目录则将目录下所有文件制作一个种子）
    LPCWSTR         publisher = NULL,   // 发布者信息
    LPCWSTR         publisherUrl = NULL, // 发布者的网址
    LPCWSTR         comment = NULL,  // 评论和描述
    DLBT_TORRENT_TYPE torrentType = USE_PUBLIC_DHT_NODE,   // 标记种子的类型
    int       *     nPercent = NULL,  // 制作种子的进度
    BOOL      *     bCancel = NULL,   // 用于中间取消种子的制作
	int			    minPadFileSize = -1,  // 文件大于minPadFileSize后就进行补齐优化，传统BT下载时，一个分块可能横跨两个文件，使用这个对齐后
								// 每个文件会单独分块，不和其它文件关联。这样一个文件发生变化后不会影响到其它文件，一般用于文件的更新。-1代表不对齐。0代表对任意大小的文件都对齐
								// 如果专业更新模式（bUpdateExt为TRUE），则强制对齐，如果minPadFileSize设置小于pieceSize（比如-1），那么强制对齐会自动使用pieceSize作为最小对齐标准
								// 也就是说大于一个分块的文件都会自动对齐；小于一个分块的文件会被用于对齐
    BOOL            bUpdateExt = FALSE  //是否增加用于更新的点量扩展信息，可以用于DLBT_Downloader_InitializeAsUpdater接口。仅商业版有效。bUpdateExt会做一些额外工作，如果只是普通下载
					//而不是文件的比较更新，可以不使用该参数。该参数使用时，pieceSize不建议为0，否则新老torrent的分块大小有可能不同，导致更新量会增加。
    );
```

**说明：**

请参考演示程序中制作文件的代码，或者Bitcomet的制作文件流程。发布者的网址可以在Bitcomet上显示出来，用于直接点击访问你的网址。创建的句柄，最后需要调用DLBT_ReleaseTorrent释放。

**pieceSize**: 分块大小，0代表由内核根据文件的大小自动确定；建议大的文件分块大小大一些。比如1G文件可以使用1M分块，2G文件可以使用2M分块，10G文件可以使用8M分块。如果使用bUpdateExt建议设置一个固定的pieceSize，以免新老torrent内核自动确定的pieceSize不同。pieceSize太大和太小都不是很好的选择，建议根据文件大小来确定pieceSize大小。

**nPercent**：实时传出当前制作的进度，可以通过Timer或者多线程来读取获得。

**bCancel**：用于随时可以取消该种子的制作。

**minPadFileSize:** 大于该项设置的文件，如果不是pieceSize的倍数，则会自动补齐padding文件，或者使用小文件补齐。传统BT下载时，一个分块可能横跨两个文件，使用这个对齐后，每个文件会单独分块，不和其它文件关联。这样一个文件发生变化后不会影响到其它文件，一般用于文件的更新。-1代表不对齐。0代表对任意大小的文件都对齐。如果专业更新模式（bUpdateExt为TRUE），则即使minPadFileSize为-1，也会强制对齐，如果minPadFileSize设置小于pieceSize（比如-1），那么强制对齐会自动使用pieceSize作为最小对齐标准。如果大于pieceSize，那么会使用设置的这个选择。也就是说大于一个分块的文件都会自动对齐；小于一个分块的文件可能会被用于对齐。**如果使用了paddingFile，那么可能制作出来的torrent可能有很多BT软件不支持，他们可能下载不完。所以，建议只有所有用户都是点量BT用户的情况下使用该功能**。

**bUpdateExt**：是否增加用于专业更新接口的点量扩展信息，如果要使用专业对比更新功能，则必须将该参数置为TRUE。bUpdateExt会增加一些额外信息，比如文件的Hash值，如果需要获取每个文件的Hash值，也必须将该参数设置为TRUE。如果要最佳的对比更新效果，可以这个参数设为TRUE，minPadFileSize设为pieceSize或者-1（自动内部使用pieceSize）. 该参数仅商业版有效，试用版传入无效果。

### *DLBT_***Torrent_****AddTracker** 

**功能：** 指定种子包含的Tracker地址

```c++
DLBT_API HRESULT WINAPI DLBT_Torrent_AddTracker (
    HANDLE      hTorrent,       // 种子的句柄
    LPCSTR      trackerURL,     // tracker的地址，可以是http Tracker或udp Tracker
    int         tier            // 优先级和顺序
    );
```

**说明：**

tier从0开始，数字越大优先级越高。相同优先级的Tracker表示拥有相同信息的组Tracker。如果同一台tracker服务器，既支持UDP协议，又支持Http协议，希望这里写入两个地址的话，建议使用相同优先级，因为相同优先级代表：如果连上任意一个，则不再连接下一个。

2013年底左右，我们接到用户反馈和测试发现，部分地区运营商启用了tracker协议的封锁，标准的Tracker协议在很多地区获取不到邻居节点，也就无法拥有下载速度。因此，我们3.7.5以后的版本加入了私有协议Tracker功能，但需要Tracker服务器支持，目前配合我们自主研发的点量BT高性能Tracker服务器可以解决这一问题，可以联系我们申请点量BT Tracker来解决这一问题。

### *DLBT_***Torrent_RemoveAllTracker** 

**功能：移除种子中的所有Tracker**

```c++
// 移除种子中的所有Tracker
DLBT_API void WINAPI DLBT_Torrent_RemoveAllTracker (HANDLE hTorrent);
```

**说明：**

一般步骤是，先使用DLBT_OpenTorrent函数打开一个种子文件，然后使用该函数移除所有的tracker。比如局域网中有个服务器先用该种子下载数据到本服务器，然后局域网内的人再下载这个文件时就不想他们再去和外网的人有联系了（避免外网带宽占用），此时，局域网的人下载时可以用RemoveAllTracker接口删除种子中的tracker信息，此时他们将不会同外界用户发生关联。

### *DLBT_Torrent_AddHttpUrl*

**功能：** 指定种子可以使用的http源，如果下载的客户端支持http跨协议下载，则自动从该地址下载

```c++
DLBT_API void WINAPI DLBT_Torrent_AddHttpUrl (HANDLE hTorrent, LPCWSTR httpUrl);
```

**说明：**

不是所有的BT客户端都支持http跨协议下载，如果下载的客户端不支持，则忽略这个配置。更多详情请参考：DLBT_Downloader_AddHttpDownload函数，他们功能是一样的，一个是写入到torrent文件中；一个是在运行期添加，并不保存到torrent中。

### *DLBT_SaveTorrentFile*

**功能：** 保存种子到指定目录，生成种子文件。

```c++
// 保存torrent为磁盘文件,filePath为路径（包括文件名）
DLBT_API HRESULT WINAPI DLBT_SaveTorrentFile (
    HANDLE      hTorrent,               // 种子的句柄
    LPCWSTR     filePath,               // filePath为要保存的torrent的文件路径，一般是包括文件名在内的。但如果bUseHashName是TRUE，说明要求使用hash值字符串作为torrent
                                        // 的文件名，那么filePath参数就不再需要传入文件名，就只是路径即可。
    LPCSTR      password = NULL,        // 如果password不为NULL，则代表需要对种子进行加密，加密后只能用相同的密码打开。另外一个小功能：如果password传入
                                        // "ZiP-OnLY"(区分大小写)则内部不会真正加密，只是对torrent进行一次zip压缩，可以减小torrent大小。如果设置其它密码，加密的同时也会自动zip压缩的。
    BOOL        bUseHashName = FALSE,   // 是否直接使用hash值字符串（唯一的标记字符）作为torrent的名字，如果是，则filePath请只需要传入文件路径，而不包括文件名
    LPCWSTR     extName = NULL          // 扩展名：配合bUseHashName使用，仅在bUseHashName为TRUE时有效。如果为NULL，内部自动使用.torrent作为扩展名； 否则，请自行传入扩展名，如".abc"
    );

```

**参数：**

**hTorrent:** 种子句柄，一般是由DLBT_CreateTorrent返回。

**filePath：** filePath为要保存的torrent的文件路径，一般是包括文件名在内的。 但如果bUseHashName是TRUE，说明要求使用hash值字符串作为torrent的文件名，那么filePath参数就不再需要传入文件名，就只是路径即可。

**Password:** 如果传入一个密码字符串，则使用该字符串加密，否则不对种子进行加密。加密后只能用相同的密码打开。另外一个小功能：如果password传入"ZiP-OnLY"(区分大小写)则内部不会真正加密，只是对torrent进行一次zip压缩，并不真正加密，可以减小torrent大小。3.7.5版本以后，如果设置其它密码，加密的同时也会自动zip压缩的，因此3.7.5版本后，加密后的torrent有可能比不加密时更小。

试用版该参数会被忽略，仅对商业版有效。加密后的种子不能被Bitcomet等其它BT软件使用，防止了别人使用你制作的种子。3.7.5版本后的加密自动加入了zip压缩功能。

**bUseHashName：** 是否直接使用hash值字符串（唯一的标记字符）作为torrent的名字，如果是，则filePath请只需要传入文件路径，而不包括文件名。

**extName：** 要保存的文件的扩展名，配合bUseHashName使用，仅在bUseHashName为TRUE时有效。如果为NULL，内部自动使用.torrent作为扩展名；否则，请自行传入扩展名，如".abc"。

### ***DLBT_ReleaseTorrent***

**功能：** 用完种子句柄后，释放该句柄

```c++
// 释放torrent文件的句柄
DLBT_API void WINAPI DLBT_ReleaseTorrent (HANDLE hTorrent);
```

**参数****hTorrent:** 种子句柄，一般是由DLBT_CreateTorrent或者DLBT_OpenTorrent返回。

## *3.5* 种子市场相关接口

**注意：种子市场功能只在商业版中提供，免费试用版无该功能。在试用版中调用如下接口，将会无效。**

### *DLBT_TM_ITEM**和**DLBT_TM_LIST*

**功能：** 分别用于标记种子市场中的一个种子文件和一批种子文件（列表）。

```c++
struct DLBT_TM_ITEM     //标记种子市场中的一个种子文件
{
	DLBT_TM_ITEM(): fileSize (0) {}
	
	UINT64  fileSize;      // the size of this file
	char	name[256];     // 名字
	LPCSTR	url;           // 用于下载的url
	LPCSTR  comment;       // 种子描述
};

struct DLBT_TM_LIST //标记种子市场中的一批种子文件（多个）
{
	int				count;      //数目
	DLBT_TM_ITEM	items[1];   //种子列表
};
```

### *DLBT_TM_AddSelfTorrentr**和**DLBT_TM_RemoveSelfTorrent*

**功能：** 在本机的种子市场中添加或者删除自己机器上的一个种子。

```c++
// 在本机的种子市场中添加一个种子文件
DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);
// 在本机的种子市场中移除一个种子文件
DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);
```

**参数：**

**torrentFile：** 种子文件的全路径。

**Password**：种子文件的密码（如果加密了）。

**Password**：对应于加密后的种子文件。如果传入一个密码字符串，则使用该字符串解密，否则不对种子进行解密。

### *DLBT_TM_ClearRemoteTorrentList*和*DLBT_TM_ClearSelfTorrentList*

**功能：** 清空所有其它人的种子列表 和 清空自己种子市场中的种子列表

```c++
// 清空所有获取到的其它人的种子列表
DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList ();
// 清空所有自己种子市场中的种子列表
DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList ();
```

### *DLBT_EnableTorrentMarket*

**功能：** 启用种子市场功能（默认情况下，种子市场是关闭的，为了节省资源，如果要开启种子市场，请在启动内核后，调用该函数启动种子市场功能）

```c++
// 设置一下是否启用种子市场，默认不启用。
DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);
```

### *DLBT_TM_GetSelfTorrentList和DLBT_TM_GetRemoteTorrentList*

**功能：** 获取本机的种子市场中种子列表 和 获取其它人种子市场中共享的种子列表

```c++
// 获取本机种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
// 获取其它人种子市场中的种子列表，获取到的列表需要调用DLBT_TM_FreeTMList函数进行释放掉
DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);
```

**参数：**

**ppList：** 返回一个种子市场的情况列表，需要调用DLBT_TM_FreeTMList函数进行释放内存。必要时跟作者索取详细示例程序。

### *DLBT_TM_FreeTMList*

**功能：** 释放DLBT_TM_GetSelfTorrentList或者DLBT_TM_GetRemoteTorrentList获取到的种子列表的内存

```c++
// 释放DLBT_TM_GetSelfTorrentList或者DLBT_TM_GetRemoteTorrentList获取到的种子列表的内存
DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);
```

## *3.6* 获取种子信息的接口

### *DLBT_OpenTorrent*

**功能：** 打开一个种子文件的句柄，用于读取种子内部的信息。用完后，需要调用DLBT_ReleaseTorrent释放torrent文件的句柄。

```c++
DLBT_API HANDLE WINAPI DLBT_OpenTorrent (
    LPCWSTR     torrentFile,    // 种子文件全路径
    LPCSTR      password = NULL                 // 是否加密种子，如果为Null，则是普通种子，否则是种子的密码
```

**参数：**

**torrentFile:**  种子文件的路径，包含种子文件的名字。

**Password:** 对应于加密后的种子文件。如果传入一个密码字符串，则使用该字符串解密，否则不对种子进行解密。试用版该参数会被忽略，仅对商业版有效。加密后的种子不能被Bitcomet等其它BT软件使用，防止了别人使用你制作的种子。

### *DLBT_OpenTorrentFromBuffer*

**功能：** 打开一个内存中流方式的种子文件，用于读取种子内部的信息。用完后，需要调用DLBT_ReleaseTorrent释放torrent文件的句柄。

```c++
DLBT_API HANDLE WINAPI DLBT_OpenTorrentFromBuffer (
    LPBYTE      torrentFile,                    // 可以打开内存中的字符流数据
    DWORD       dwTorrentFileSize,              // 种子内容的大小
    LPCSTR      password = NULL                 // 是否加密种子，如果为Null，则是普通种子，否则是种子的密码
    );
```

**参数：**

**torrentFile：** 种子文件在内存中的内容。

**dwTorrentFileSize：** 种子内容的大小。

**Password:** 对应于加密后的种子文件。如果传入一个密码字符串，则使用该字符串解密，否则不对种子进行解密。试用版该参数会被忽略，仅对商业版有效。加密后的种子不能被Bitcomet等其它BT软件使用，防止了别人使用你制作的种子。

### *DLBT_Torrent_GetComment  DLBT_Torrent_GetCreator和DLBT_Torrent_GetPublisherUrl*

**功能：** 打开一个种子文件的句柄，用于读取种子内部的信息

```c++
//获取种子的备注信息
DLBT_API HRESULT WINAPI DLBT_Torrent_GetComment (
    HANDLE      hTorrent,       // 种子文件句柄
    LPSTR       pBuffer,        // 用于返回信息的内存，为空则在pBufferSize中返回评论信息的实际大小
    int     *   pBufferSize     // 传入评论的内存大小，传出评论的实际大小
    );
//获取创建软件信息
DLBT_API HRESULT WINAPI DLBT_Torrent_GetCreator (
    HANDLE      hTorrent,       // 种子文件句柄
    LPSTR       pBuffer,        // 用于返回信息的内存，为空则在pBufferSize中返回作者信息的实际大小
    int     *   pBufferSize     // 传入存放信息的内存大小，传出作者信息的实际大小
);
//获取发布者网址
DLBT_API HRESULT WINAPI DLBT_Torrent_GetPublisherUrl (
    HANDLE      hTorrent,       // 种子文件句柄
    LPWSTR      pBuffer,        // 用于返回信息的内存，可以为空，为空则在pBufferSize中返回实际大小
    int     *   pBufferSize     // 传入存放信息的内存大小，传出实际大小
);
```

**说明：**

如果buffer的大小小于要返回的文件路径名大小，则会返回ERROR_INSUFFICIENT_BUFFER错误码，此时pBufferSize中会传出实际需要的大小，成功则返回S_OK。

### *DLBT_Torrent_GetTrackerCount*

**功能：** 获得种子文件中记录的所有tracker的个数

```c++
DLBT_API int WINAPI DLBT_Torrent_GetTrackerCount (HANDLE hTorrent);
```

**参数：**

**hTorrent:** 操作的种子文件句柄

### *DLBT_Torrent_GetTrackerUrl*

**功能：** 获得种子中，指定次序的Tracker的URL地址

```c++
DLBT_API LPCSTR WINAPI DLBT_Torrent_GetTrackerUrl (
    HANDLE      hTorrent,       // 种子文件句柄
    int         index           // Tracker的序号，>=0，小于DLBT_Torrent_GetTrackerCount取得的个数
    );
```

### *DLBT_Torrent_GetTotalFileSize*

**功能：** 获得种子中所有文件的总大小 

```c++
DLBT_API UINT64 WINAPI DLBT_Torrent_GetTotalFileSize (
HANDLE hTorrent    // 种子文件句柄
);
```

### *DLBT_Torrent_GetFileCount*

**功能：** 获得种子中所有文件的个数 

```c++
DLBT_API int WINAPI DLBT_Torrent_GetFileCount (
HANDLE hTorrent    // 种子文件句柄
);
```

### *DLBT_Torrent_IsPadFile*

**功能：** 判断某个序号的文件是否Pad补齐文件

```c++
DLBT_API BOOL WINAPI DLBT_Torrent_IsPadFile (HANDLE hTorrent, int index);
```

**参数：**

**hTorrent：** 种子文件的句柄。

**index：** 文件的序号，要求 >=0 , 小于DLBT_Torrent_GetFileCount取得的文件的总数目。

**说明：**

Bitcomet以及点量BT 3.6版本后，均有可能有padding file存在，目的是为了更少的文件更新量以及较好的磁盘利用率，详见：DLBT_CreateTorrent的说明。

### *DLBT_Torrent_GetFileSize*

**功能：** 获得种子中某个文件的大小 

```c++
DLBT_API UINT64 WINAPI DLBT_Torrent_GetFileSize (
    HANDLE      hTorrent,           // 种子文件句柄
    int         index,              // 要获取大小的文件的序号，文件序号是从开始的
    );
```

### *DLBT_Torrent_GetFilePathName*

**功能：** 获得种子中某个文件的名称

```c++
DLBT_API HRESULT WINAPI DLBT_Torrent_GetFilePathName (
    HANDLE      hTorrent,           // 种子文件句柄
    int         index,              // 要获取名字的文件的序号，文件序号是从开始的
    LPWSTR      pBuffer,            // 传出文件名
    int     *   pBufferSize        // 传入buffer的大小，传出文件名的实际长度
    );
```

**说明：** 类似的用法和说明参考DLBT_Downloader_GetFilePathName。

### *DLBT_Torrent_GetPieceCount*和*DLBT_Torrent_GetPieceSize*

**功能：** 获得分块数目和分块的大小，hTorrent参数为种子文件的句柄。

```c++
DLBT_API int WINAPI DLBT_Torrent_GetPieceCount (HANDLE hTorrent); // 获取分块数目
DLBT_API int WINAPI DLBT_Torrent_GetPieceSize (HANDLE hTorrent); // 获取分块大小
```

### *DLBT_Torrent_GetPieceInfoHash**和**DLBT_Torrent_GetInfoHash*

**功能：** 获得每个分块的Hash值。

```c++
// 获取每个分块的Hash值
DLBT_API HRESULT WINAPI DLBT_Torrent_GetPieceInfoHash (
    HANDLE      hTorrent,           // 种子文件句柄
    int         index,              // 要获取的Piece的序号，piece的数目可以通过DLBT_Torrent_GetPieceCount获得
    LPSTR       pBuffer,            // 传出Hash字符串
    int     *   pBufferSize         // 传入pBuffer的大小，pieceInfoHash固定为个字节，因此此处应该是的长度。
);

// 获得整个种子文件的InfoHash值
DLBT_API HRESULT WINAPI DLBT_Torrent_GetInfoHash (
    HANDLE      hTorrent,           // 种子文件的句柄
    LPSTR       pBuffer,            // 传出InfoHash的内存缓冲
    int     *   pBufferSize         // 传入缓冲的大小，传出实际的InfoHash的长度
    );
```

------

## *3.7* P2P辅助性接口

### *enum PORT_TYPE*

**功能：** 标记端口类型（TCP或者UDP端口）

```c++
enum PORT_TYPE
{
    TCP_PORT        = 1,            // TCP 端口
    UDP_PORT                        // UDP 端口
};
```

### *DLBT_AddAppToWindowsXPFirewall*

**功能：** 将某个应用程序添加到ICF防火墙的例外中去，可独立于内核应用，不启动内核仍可使用该函数

```c++
DLBT_API BOOL WINAPI DLBT_AddAppToWindowsXPFirewall (
    LPCWSTR      appFilePath,        // 程序的路径（包括exe的名字）
    LPCWSTR      ruleName            // 在防火墙的例外中显示的这条规则的名字
    );
```

**说明：**

主要适用于XP和Vista系统下的自带防火墙。

### *DLBT_GetCurrentXPLimit*

**功能：** 获得当期系统的并发连接数限制，如果返回0则表示系统可能不是受限的XP系统，无需修改连接数限制。可独立于内核使用，启动内核前即可使用。

```c++
DLBT_API DWORD WINAPI DLBT_GetCurrentXPLimit ();
```

**说明：**

XP SP2增加了一个限制，单个进程最多只能建立10个连接，但这对P2P软件是个麻烦，所以一般P2P软件需要修改这个限制，建议使用128或者更多。

### *DLBT_ChangeXPConnectionLimit*

**功能：** 修改XP的并发连接数限制为指定的数目，返回BOOL标志操作是否成功。

```c++
DLBT_API BOOL WINAPI DLBT_ChangeXPConnectionLimit (DWORD num);
```

**说明：**

XP SP2增加了一个限制，单个进程最多只能建立10个连接，但这对P2P软件是个麻烦，所以一般P2P软件需要修改这个限制，建议使用128或者更多。

------

## *3.8* 批量获取信息接口

### *struct KERNEL_INFO*

**功能：** 用于传递内核整体运行信息的结构体，包含了常见的多个内核整体信息。

`

```c++
struct KERNEL_INFO
{
    USHORT                      port;                           // 监听端口
    BOOL                        dhtStarted;                     // DHT是否启动
    int                         totalDownloadConnectionCount;   // 总的下载连接数
    int                         downloadCount;                  // 下载任务的个数
    int                         totalDownloadSpeed;             // 总下载速度
    int                         totalUploadSpeed;               // 总上传速度
    UINT64                      totalDownloadedByteCount;       // 总下载的字节数
    UINT64                      totalUploadedByteCount;         // 总上传的字节数
    int                         peersNum;                       // 当前连接上的节点总数
    int                         dhtConnectedNodeNum;            // dht连接上的活跃节点数
    int                         dhtCachedNodeNum;               // dht已知的节点数
    int                         dhtTorrentNum;                  // dht中已知的torrent文件数
};
```

### *struct DOWNLOADER_INFO*

**功能：** 用于传递单个任务运行时大量信息的结构体，包含了常见的任务相关的多个信息。

```c++
struct DOWNLOADER_INFO
{
    DLBT_DOWNLOAD_STATE          state;                         // 下载的状态
    float  percentDone; //已下载数据相比torrent总数据的比例（如只选择了部分文件下载，该进度不会100%）
    int                         downConnectionCount;            // 下载建立的连接数
    int                         downloadLimit;                  // 该任务的下载限速
    int                         connectionCount;                // 总建立的连接数（包括上传）
    int  totalCompletedSeeds; // Tracker启动以来，总下载完成的人数，如Tracker不支持scrap，则返回-1
    int                         inCompleteNum; // 总的未完成的人数，如果Tracker不支持scrap，返回-1
    int                         seedConnected;                  // 连上的下载完成的人数
    int                         totalCurrentSeedCount; // 当前在线的总下载完成人数（包括未连上的）
    int                         totalCurrentPeerCount; // 当前在线的总下载人数（包括未连上的）
    float                       currentTaskProgress;            // 当前任务的进度（.0%代表完成）
    BOOL                        bReleasingFiles;                // 是否正在释放文件句柄。
    UINT                        downloadSpeed;                  // 下载的速度
    UINT                        uploadSpeed;                    // 上传的速度
    UINT             serverPayloadSpeed; // 从服务器下载的总有效速度（不包括握手消息等非数据性传输）
    UINT                     serverTotalSpeed; //从服务器下载的总速度(包括握手消息、连接通讯的消耗）
    UINT64                      wastedByteCount;                // 非数据的字节数（控制信息等）
    UINT64                      totalDownloadedBytes;           // 下载的数据的字节数
    UINT64                      totalUploadedBytes;             // 上传的数据的字节数
    UINT64                      totalWantedBytes;               // 选择的总数据大小
    UINT64                      totalWantedDoneBytes;      // 选择的总数据中，已下载完成的数据大小
    UINT64                      totalServerPayloadBytes;      // 从服务器下载的文件型数据总量（本次启动以来的文件数据也包括了收到错误的数据，即使后来丢弃的-- 不过一般服务器如果没问题，不会丢弃数据的）
    UINT64                      totalServerBytes; // 从服务器下载的所有数据的总量（包括握手数据等）
    UINT64                      totalPayloadBytesDown;          // 本次启动后总的下载的数据块类型的数据量（包括了服务器的数据，以及可能丢弃的数据）
    UINT64                      totalBytesDown;                 // 本次启动后，总的所有数据的下行数据量（包括了服务器以及所有客户的数据、辅助通讯数据量等）所以这个数字随着启动时间，会不停增加
    BOOL                        bHaveTorrent;    // 用于无种子下载模式，判断是否已经获取到了torrent
    UINT64                      totalFileSize;                  // 文件的总大小
    UINT64                      totalFileSizeExcludePadding;    // 实际文件的大小，不含padding文件, 如果种子中无padding文件，则和totalFileSize相等
    UINT64                      totalPaddingSize;   // 所有padding数据的大小。如果制作种子时没启用padding文件，则为0
    int                         pieceCount;                     // 分块数
    int                         pieceSize;                      // 每个块的大小
    char                        infoHash [256];                 // 文件的Hash值
};
```

`

### *struct PEER_INFO_ENTRY*

**功能：** 用于传递一个连接者信息的结构体，一般配合PEER_INFO结构体返回所有连接上用户的信息。

```c++
struct PEER_INFO_ENTRY
{
	int				     	connectionType;					// 连接类型0：标准BT(tcp); 1: P2SP（http）2: udp（可能是直接连接或者穿透）
    int                         downloadSpeed;                  // 下载速度
    int                         uploadSpeed;                    // 上传速度
    UINT64                      downloadedBytes;                // 下载的字节数
    UINT64                      uploadedBytes;                  // 上传的字节数
    int                         uploadLimit;                    // 该连接的上传限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况
    int                         downloadLimit;                  // 该连接的下载限速，比如如果对服务器的IP限速了，则这地方可以看到这个IP的限速情况
    char                        ip [64];                        // 对方IP
    char                        client [64];                    // 对方使用的客户端
};
```

### *struct PEER_INFO*

**功能：** 用于传递所有连接者信息的结构体，一般配合PEER_INFO结构体返回所有连接上用户的信息。

```c++
struct PEER_INFO
{
    int                         count;         // 总的节点（用户）数
    PEER_INFO_ENTRY             entries [1];   // 节点信息的数组，数组的数目由count指定
};
```

### *DLBT_GetKernelInfo*

**功能：** 获取内核整体信息，返回一个KERNEL_INFO结构体。

```c++
DLBT_API HRESULT WINAPI DLBT_GetKernelInfo (KERNEL_INFO * info);
```

**说明：**

函数内部不会为Info分配内存，因此要求外部不能传入一个空的info的指针，而应该传入一个指向合法info结构体的指针，比如正确的调用方式应该类似于：

```c++
KERNEL_INFO info;        
DLBT_GetKernelInfo (&info); // 传入一个指向合法KERNEL_INFO的指针，返回的信息存于info中
```

### *DLBT_GetDownloaderInfo*

**功能：** 获取一个下载任务的整体信息，返回一个DOWNLOADER_INFO结构体。

```c++
`DLBT_API HRESULT WINAPI DLBT_GetDownloaderInfo (HANDLE hDownloader, DOWNLOADER_INFO * info);`
```

**说明：**

函数内部不会为Info分配内存，因此要求外部不能传入一个空的info的指针，而应该传入一个指向合法info结构体的指针，比如正确的调用方式应该类似于：

```c++
DOWNLOADER_INFO info;        
DLBT_GetDownloaderInfo (hDownloader, &info); //传入指向合法DOWNLOADER_INFO的指针，返回信息于info中
```

### *DLBT_GetDownloaderPeerInfoList和DLBT_FreeDownloaderPeerInfoList*

**功能：** DLBT_GetDownloaderPeerInfoLis获取一个下载任务所有当前连接的信息，返回一个PEER_INFO指针，指向连接列表。DLBT_FreeDownloaderPeerInfoList用于释放这个列表的内存。

```c++
DLBT_API HRESULT WINAPI DLBT_GetDownloaderPeerInfoList (HANDLE hDownloader, PEER_INFO ** ppInfo);
DLBT_API void WINAPI DLBT_FreeDownloaderPeerInfoList (PEER_INFO * pInfo);
```

**说明：**

调用DLBT_GetDownloaderPeerInfoList时，函数内部会动态分配一块内存，记录连接列表，所以函数调用前外界可以只是传入一个PEER_INFO指针的指针，内存由内部分配；因此，最后使用完列表后，需要主动调用DLBT_FreeDownloaderPeerInfoList函数释放这块内存。正确的调用顺序应该类似于：

```c++
PEER_INFO * pInfo = NULL;
DLBT_GetDownloaderPeerInfoList (hDownloader, &pInfo);
//使用该列表
………….
DLBT_FreeDownloaderPeerInfoList (pInfo);		//用完后释放列表内存
```

### *DLBT_SetDHTFilePathName*

**功能：** 设置DHT状态文件的全路径名。

```C++
DLBT_API void WINAPI DLBT_SetDHTFilePathName (LPCWSTR dhtFile);
```

**说明：**

默认不设置时，会在dll目录下生成DLBT.dht文件，可以调用该函数进行设置文件的名称。全局启动时调用即可。

### *DLBT_Set_IO_OP*和*DLBT_InitDefault_IO_OP*

**功能：** 设置IO操作的结构体的指针；或者先对结构体初始化默认IO函数，然后自行修改个别函数。

```c++
// 可以自定义IO操作的函数（可以将BT里面的读写文件等所有操作外部进行处理，替换内部的读写函数等）
// 该功能为高级版功能，请联系点量获取技术支持，默认版本中不开放该功能

// 设置IO操作的接管结构体的指针
DLBT_API void WINAPI DLBT_Set_IO_OP(void * op);
// 对结构体里面的所有函数先赋值默认的函数指针
DLBT_API void WINAPI DLBT_InitDefault_IO_OP(void * op);
```

**说明：**

可以自定义IO操作的函数（可以将BT里面的读写文件等所有操作外部进行处理，替换内部的读写函数等） 该功能为高级版功能，请联系点量获取技术支持，默认版本中不开放该功能。具体功能请正式客户购买后联系点量获得技术咨询。

### *DLBT_Get_IO_OP*和*DLBT_Get_RAW_IO_OP*

**功能：** 获取当前所用的IO结构体指针或者获取系统原始默认的IO操作的结构体指针.

```C++
// 获取系统内部目前在用的IO对象的指针
DLBT_API void * WINAPI DLBT_Get_IO_OP();
// 获取系统原始IO的指针
DLBT_API void * WINAPI DLBT_Get_RAW_IO_OP();
```

**说明：**

可以自定义IO操作的函数（可以将BT里面的读写文件等所有操作外部进行处理，替换内部的读写函数等） 该功能为高级版功能，请联系点量获取技术支持，默认版本中不开放该功能。具体功能请正式客户购买后联系点量获得技术咨询。



