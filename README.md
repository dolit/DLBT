# DLBT：大并发文件快速传输省带宽解决方案
版权说明:   如果您是个人作为非商业目的使用，可以完全自由、免费的使用点量BT内核库和演示程序以及本文档的内容，也期待收到您反馈的意见和建议。

如果您是作为商业使用，请联系作者申请产品的商业授权。点量BT内核库所有演示程序的代码对外公开，内核库的代码只限付费用户使用。

# 关于DLBT
## 为什么开发DLBT?它有哪些功能？
DLBT的开发目的是让用户无需关心和了解BT的具体实现细节，只需要写几十行甚至几行代码，便可以实现一个功能完善而且强大的BT应用软件，减少越来越多的应用程序需要纳入BT功能时,大量重复性开发和资金成本消耗。
DLBT内核提供标准的BT功能支持，同时支持目前流行的各类BT扩展协议，是一个功能丰富的BT应用开发工具包。除了BT功能，DLBT还支持客户自定义协议，在基于BT架构的基础上，帮助您实现自己的P2P网络通讯协议，构建自己的P2P用户群。
DLBT内核是目前资源占用最少、下载速度最快、速度最稳定的内核，您可以通过试用它来更多地了解DLBT内核，用它来快速实现您的P2P战略。

这里先列举DLBT的一些基本功能：

**标准BT协议支持：**
完全标准官方BT协议的支持，并支持常用的多项扩展协议，DLBT完全兼容各类BT应用软件。并且在现有的所有内核中，DLBT的兼容性是最好的，您可以使用点量示例程序下载一个流行的种子文件，速度是目前内核中最好的。这主要是由于DLBT内核完全支持DHT和Peer交换等各项扩展协议，以及对BT协议做了很多优化。

**极其方便的调用方式：**
采用标准DLL方式，调用方式完全类似于系统API (CreateFile等函数），结合作者完善的开发文档和演示代码，开发一个功能完善的BT应用软件，所需时间之短超出你的想象。 

**强大的跨平台支持：**
DLBT内核是目前最具有可移植性的BT内核之一，目前发布有Windows、Linux、Android、IOS等主流平台的支持版本（3.7.7以后版本）。如需要Windows CE等其他平台的支持，也可以联系我们交流定制开发。

**极低的资源占用：**
DLBT的内存和CPU占用您可以通过测试了解，极低的资源占用以及高效稳定的传输速度，是您选择BT的最佳选择。 DLBT的CPU、内存、硬盘等资源是目前国内资源占用最低的内核，3.4版本以后，示例程序自动设置了8M的缓存，计算内存占用时可以考虑去除8M的缓存使用。其实早在DLBT的第一个版本，就已经做到了是国内最少资源占用和速度最稳定的的内核,3.4版本的优化使得资源占用有了进一步降低，体现了在BT内核领域我们的不懈追求和专业。

**兼容uTorrent的UDP穿透传输：**
DLBT3.6以后版本支持兼容uTorrent等的udp穿透传输，对无法映射的用户可以自动适应进行udp穿透传输。并且，DLBT3.6版本的udp穿透传输功能，无需任何额外服务器资源，在p2p网络中自动适应穿透，根据网络类型自动判断适应。(3.6以后版本)

**支持HTTP协议同时下载（P2SP）：**
DLBT当前版本支持Http跨协议下载，一方面突破了国内很多网络环境对BT端口和协议的封锁，另一方面解决了无人供种时的下载问题。将一个Http地址作为P2P系统中的一个节点，实现了在Http服务器和P2P用户之间同时下载。 IIS的稳定性，以及一些使用了CDN的用户，可以用IIS作为上传源。

**可调节不同网络下的性能参数：**
比如在千M局域网中，高速硬盘环境下，通过设置该参数，可以实现单对单传输达50M/s以上的速度，多人同时下载时可以达到磁盘或者网络的极限。默认设置为适合绝大多数普通网络模式的用户配置。(3.6.3以后版本)

**商业正式版中新增端游边下边玩模式：**
首创P2P下载支持微端流式下载，玩到哪里下到哪里，流畅按需按unit下载。

**DHT网络支持：**
DLBT提供标准的DHT网络支持，并自动加入Bitcomet、官方Bittorent等流行客户端的DHT网络，共享整个BT网络内的用户资源，一方面解决了无Tracker状态下的文件下载，另一方面提高了下载速度。 

**可选zip压缩传输：**
在传输前可对文本型文件可以进行压缩，收到后自动解压，大大减少传输的数据量和节约带宽，适合文件夹中很多文本型文件的情况，比如一些游戏的资源文件。(3.6.3以后版本)

**支持伪装Http协议：**
用于突破一些特殊环境下的封锁。（目前发现的有巴西、马来西亚等一些网络封锁需要启用该功能）。该功能可以和不启用的用户自动兼容。(3.6.3以后版本)

**支持私有Tracker协议：**
2013年底左右，我们接到用户反馈和测试发现，部分地区运营商启用了tracker协议的封锁，标准的Tracker协议在很多地区获取不到邻居节点，也就无法拥有下载速度。因此，我们新版加入了私有协议Tracker功能，但需要Tracker服务器支持，目前配合我们自主研发的DLBT高性能Tracker服务器可以解决这一问题，强烈建议老客户升级这一功能。(3.7.5以后版本)

**智能磁盘分配：**
支持全面预分配模式，此模式下可以文件下载前预先分配磁盘空间，减少磁盘碎片的产生；同时也支持边下载边分配的方式，用户可以根据需要自己选择。 在NTFS格式的磁盘系统，还支持SPARSE稀缺分配方式。

**支持HTTP和UDP**
 Tracker协议，支持多Tracker协议，支持等效Tracker报告。 

**高效的UPnP穿透：**
无需XP SP2的支持，实现各版本系统下的内网免配置。

**支持PMP方式的内网穿透：**
新型的PMP穿透作为UPnP的补充，进一步提升内网穿透的效率 。

**支持内网自动发现：**
在同一个局域网内有两个以上用户下载时，系统会进行自动寻找，尽量利用上局域网内部带宽，速度得到迅速提升。

**支持兼容Bitcomet的padding_file技术：**
制作种子时可以选择是否对齐文件，如果对齐文件后，一个分块不会横跨2个大的文件，文件末尾不足一整块的，由小文件或者padding_file对齐。这种机制非常适合文件更新的应用，保证了一个种子文件中，一个文件的某些变化，不会影响到其它文件也需要更新。 而传统的BT技术如果做大型文件夹的更新，由于没有padding_file间隔开文件，一个分块可能横跨了两个文件，第一个文件如果长度发生了变化，该文件后面的所有数据的分块hash均会变化，这样，该文件后面的所有文件都可能需要重新下载。 所以，DLBT的padding_file技术大大减少了文件更新量。(3.6以后版本)

**实现了专业的文件更新功能：**

1）提供Update接口，DLBT的专业更新功能无需对老文件进行任何扫描校验，直接对比新老种子文件的差异，几毫秒内快速启动更新变化过的数据块。传统的BT软件在有新种子文件替换老种子时，需要先扫描原始文件才能获知需要去下载哪些数据块，如果一个几G的文件夹，扫描一次需要很久，并且扫描期间机器磁盘占用严重。所以DLBT提供的这个接口，在有大量文件需要频繁更新时极其有效。（3.5以后版本）。

2）使用最少量局部更新算法，比如一个1G大的文件，只有几十k的数据块发生了改变，那么内核可以自动检索出有效数据，这在大文件的更新中极为重要。

3）3.6版本以后，基于padding_file技术，改进专业更新接口，使得一个文件的变化，不会影响到其它文件，进一步减少需要更新的数据量。(3.6以后版本)

4）支持临时目录接口，更新文件时，可以将所需下载的分块下载到一个临时目录，下载完成后一次性替换，这样下载过程中原始文件可以正常使用。该功能可以提供调用示例。（3.6.3以后版本）

**数据块级别下载优先级指定：**
优化数据块下载优先级算法，支持数据块级别的下载优先级设定，使得高优先级的数据块最快下载，更好地支持了音视频点播直播等P2P应用；提升点播直播数据时拖动的响应速度。

**自动防火墙穿透技术：**
全自动穿透XP、Vista网络连接防火墙(ICF)和网络连接共享(ICS)。 
**支持XP SP2的TCP/IP连接数限制的破解修改**，保证P2P的良好效果。 

**智能文件续传：**
记录上次文件的各种信息，下次启动时无需扫描，立即启动下载。并且保存了上次的Peer信息，提高启动下载的速度。 

**完善丰富的接口支持：**
提供丰富的控制和获取信息的接口，满足应用程序绝大部分的功能需求。比如，不仅可以限制全局上传下载速度和连接数，也可以对每个任务单独设置等。可获取当前所有连接的详情、整体情况、单个任务情况、每个文件的信息、健康率、分享率等。 

**提供专业上传服务器模式：**
DLBT配套有专业上传服务器内核，该内核专注于上传性能的提升，优化大量文件上传时的传输效率和IO性能，适合提供大量文件给客户下载时使用（比如视频网站、游戏程序的分发时，由专门的服务器使用上传服务器模式支撑大量用户的下载）。 

**私有种子加密：**
通过私有种子加密，可以构建自己的私有BT网络，防止其它客户端使用你公司的种子文件。并且对于较大的torrent文件还可以选择zip压缩，减少torrent文件的大小。 

**私有协议支持：**
支持设置自定义协议，构建自己的私有P2P网络（可防止其它BT软件下载您的文件），并突破各网络环境对BT应用的封锁。私有模式下去除了BT的痕迹，可以穿透运营商对BT协议的封锁。

**协议加密和数据加密支持：**
DLBT 3.0以后的版本支持对协议进行加密，或者对数据进行加密，在不兼容Bitcomet等BT客户端的同时，突破运营商对BT软件的封锁。同时，数据加密还可用于传输保密数据。 

**支持常见的各类代理：**
支持用户设置Http、Http1.1、Socks4、Socks5、需要密码的Socks5等代理。 

**高兼容性的种子制作功能：**
支持UTF-8扩展和多语言，支持嵌入发布者等信息到种子文件。 
**支持所有字符的种子文件、支持UTF-8和非UTF-8的标准和非标准种子文件：**
DLBT已经在几十种字符文件中进行了测试，可以完美支持日韩等东方字符，以及各类特殊字符的文件；同时完美兼容UTF-8和非UTF-8的种子文件。 

**支持种子市场、Peer信息交换等扩展协议**。

**优秀的磁盘缓存效率：**
DLBT内核3.6版本改进的磁盘缓存机制，自动适应多种磁盘缓存算法，提高磁盘缓存命中率，从而提升下载和上传速度，较好地提升内核整体性能。

**支持IPV6：**
同时兼容IPV4和IPV6扩展，可以自动适应。

**支持无种子模式下载（magnet磁链）：**

可以高效的支持  “DLBT://4DFFG5667F44DD346A0C944225432452(种子文件的Hash值)/天龙八部(名称）”  这种地址直接从网址上自动下载，而不再需要种子文件，种子文件将通过P2P网络传输，减轻服务器提供种子文件的压力 --- 我们同时可提供这类网站和客户端的架设、设计方案。

**提供源代码：**
BT源代码可以在支付一定费用后对用户提供，解除您的后顾之忧，可以完全控制您的BT控件。

**完善的多种语言示例代码：**
DLBT开发包目前提供VC （C++/MFC）版本、Delphi版本、C#版本、VB版本、Java、Borland C++、VB.NET等示例程序源代码，易语言等其它语言的示例程序也可以联系点量软件申请获得，尽可能减少客户的开发量。
## 适用场景
如果您需要开发BT或者P2P的下载功能，那么可以考虑使用DLBT，您可以在DLBT的基础上开发，希望能对您有所帮助，节省您的开发成本。

如果您需要提供较大数据量的软件、视频等文件供其它人在互联网进行下载，而且您希望节省带宽和服务器成本，并获取更快的速度，那么可以考虑使用DLBT，使用DLBT开发工具包很快就可以实现您想要的上传服务。

DLBT可以被应用于视频网站、软件站点、网络游戏的下载和更新、教育视频和文档的下载、视频点播VOD系统等领域。
## DLBT专业上传服务器
DLBT已经于2009年1月3日，正式发布了专业上传服务器内核。该服务器专注于提供上传，适用于视频和游戏等运营商，可以采用该版本提供上万文件的上传，该版本具有如下特点：

**大并发量支持：**
可以支持数万用户的同时下载，由于采用了高效的服务器编程模式，因此该服务器可以支持大量用户的同时下载。
支持特大文件和特大文件量的上传：
DLBT专业上传服务器，可以支持单个种子几十G的上传，支持单个种子几十万文件的上传。对任务的大小和文件数没有限制。

**独创的休眠模式：**
如果你有1000个任务启动了上传，但可能此时只有20个任务有人下载，这时，剩余的980个任务是休眠的，只是定期报告Tracker，但任何资源都不占用，此时可以使得资源最少占用，比如在200个任务（每个平均2G的游戏任务）时，如果只有几个任务下载只需要30M左右的内存，一旦有用户下载，系统则自动开启任务，实现全自动化处理，一旦任务一段时间无人下载，则自动转入休眠，释放所有资源占用。

**极低的资源占用：**
一方面由于采用休眠模式，不上传的任务不占用资源；另一方面，点量专业上传服务器大量采用内存池、线程池等高性能服务器设计模式，实现了资源的重复利用，在几千个大任务的上传时，很好地体现了资源占用极低的优势。
长时间运行保障：点量专业上传服务器内核，已经被多家游戏更新运营商使用，经过了成熟的测试，可实现长时间无障碍运行。

**节省您的服务器资源：**
根据客户的反馈，原来有些客户使用北京某家公司的内核，一方面是长期上传大量文件不稳定，经常崩溃；另一方面，由于内核不是为上传而设计，几乎只能同时上传300个左右的大型游戏文件，客户如果要上传全部自己的内容，需要很多台服务器资源；后来客户更换了点量专业上传服务器内核，一台服务器可以支持1000个大型游戏文件的上传 + 3000多个中小型软件的上传，节省了至少3倍以上的服务器硬件资源。并且下载速度比以前高出了60%以上。这一点，我们可以做出承诺，DLBT专业上传服务器的性能肯定高于目前国内的任何一家BT软件。

**单服务器可支撑几十万文件、数十T的大小、数万用户的下载。**

另外，DLBT还拥有自己的Tracker服务器，结合专业上传服务器，提供更为专业和高效的BT上传服务器系统。
如果您需要一个服务器，提供上万文件的上传，那么DLBT专业上传服务器是您的最佳选择。

DLBT专业上传服务器版本的信息，请及时关注点量官方网站，关于点量专业上传服务器版本：http://blog.dolit.cn/dlbtserver-introduction-html  
## DLBT内核和专业上传服务器内核有什么区别？
**DLBT专业上传服务器内核**主要用于几百、几千、上万文件的供种上传，是**专门用于提供BT文件上传的服务器程序**。可以单服务器支持**几十万用户**的并发下载，并支持**几十G的超大文件的上传**，和**大数量文件的上传**。

**独创了休眠模式，上传休眠模式是指的：**
如果你有1000个任务启动了上传，但可能此时只有20个任务有人下载，这时，剩余的980个任务是休眠的，只是定期报告Tracker，但任何资源都不占用，此时可以使得资源最少占用，比如在200个任务（每个平均2G的游戏任务）时，如果只有几个任务有人下载，只需要30M左右的内存，一旦有用户下载，系统则自动开启任务，实现全自动化处理，一旦任务一段时间无人下载，则自动转入休眠，释放所有资源占用。

而**DLBT内核版本**，则是**标准的BT内核**，提供标准的BT功能支持，同时支持目前流行的各类BT扩展协议，是一个**功能丰富的BT应用开发工具包**，提供更多的功能，它也可以提供大量文件的上传，并且在支持大量文件上不逊于任何一款BT软件。

比如有些客户使用它在每天上传几千个游戏，每个游戏都是几个G的大小，每个游戏中有上万个文件，这种情况下DLBT内核仍然可以稳定上传。但是，我们是致力于最佳效果，最佳性能的团队，我们没有满足现在的这个现状，而是如何更好、更有效，于是就有了专致力于上传的DLBT专业上传服务器内核。
**一般的应用，使用DLBT内核就足够**了，因为它完全也能胜任上千文件的上传，在支持上传和大量文件上绝不逊于任何一款BT软件。在您需要更高要求的服务器上，可以使用DLBT专业上传服务器版本提供文件的供种和上传。

## 支持的语言和开发环境
DLBT提供标准的动态链接库/静态库文件（DLL/SO/Lib），可供C/C++、Delphi、C#、Java、VB、易语言、VB.NET等语言调用，让您完全像调用系统API一样的使用DLBT开发工具包（SDK）。

DLBT内核和MFC版本示例程序的开发环境是Visual Studio .Net 2005 （也可以采用2003版本），如果您需要编译和阅读DLBT SDK中的MFC版本的示例程序，建议您安装 Visual Studio .Net 2005以上开发环境。

DLBT开发工具包中提供了分别基于MFC、Delphi、C#、VB、VB.NET、JAVA等版本的示例程序，你完全可以参考来调用DLBT内核。Delphi版本感谢网友ZZL、萧峰等提供，可供Delphi中使用进行参考；具体调用的规则和功能方面，以VC版的示例程序代码为准。

# DLBT接口整体介绍
# 接口的模块结构
DLBT对外提供的接口，可以划分为如下几个部分：
**Kernel整体环境相关：**
Kernel整体环境承担着整个DLBT整体的管理功能，负责监听一个TCP端口和一个UDP端口（UDP端口可选，用于DHT通讯，如果不启动DHT则不需要监听UDP端口）。它管理着内核中所有的下载任务和整个内核。

**下载任务的相关接口：**
每个Torrent种子文件的下载对应一个下载任务对象Downloader，该部分提供对某个单一下载任务的控制（启动、暂停、限速等）和信息的读取接口。

**制作种子的相关接口：**
用于种子文件的制。该部分不仅符合标准BT协议规范，并且支持国内比较流行的BT客户端软件Bitcomet的一些扩展做法（嵌入发布者信息、默认使用公共DHT网络节点等）。一个Torrent文件中可以包含多个要下载文件的描述。

**获取种子信息的接口：**可以在不启动任务下载的情况下，打开指定的种子文件，获取种子文件内的相关信息。

P**2P辅助功能接口：**这部分提供P2P软件都需要的一些接口，包括UPnP穿透、穿透ICF防火墙、突破操作系统并发连接数限制等。不仅可以应用于DLBT，也可以应用于其它任何需要的程序，独立于内核，不需要内核的启动。

**批量获取信息接口：**该部分是为了方便一次性取出大量信息时调用，可以通过调用少量接口函数返回一个信息的结构体或者结构体数组，包含常用的大量信息。

## 2.2常见的调用流程

1）首先，在程序启动的时候，根据实际需要，选择调用突破系统防火墙的接口将当前的应用程序以及相关进程加入防火墙的例外；调用接口检查操作系统的并发连接数限制，判断是否需要进行连接数的修改；调用UPnP穿透接口，将相关应用程序所有需要监听的端口，添加到UPnP设备中去――DLBT内核内部使用的TCP和UDP端口无需外部程序调用添加，内部会自动添加。

2）程序启动后，根据用户的界面操作，启动一个Torrent文件的下载。一般需要用户选择一个Torrent文件和下载的保存路径。启动Torrent文件时，只需要调用下载任务的启动接口即可，下载任务会自动启动下载，并立即返回该任务的句柄。

3）下载过程中应用程序可以随时调用下载任务的接口获取下当前下载的速度和进度、连接情况、Torrent中每个文件的进度等各种信息，可以随时调用下载任务的接口设置下载限速等。

4）下载任务启动成功后，内核不会自动停止该任务，需要应用程序主动调用停止和删除。一般地当检查到下载任务的进度到了100％或者状态是供种状态时，程序可以选择停止任务或者设置一个上传限速，继续上传。

5）程序结束前，需要调用下载任务的接口，将每个Torrent任务停止，然后调用内核的关闭接口，释放内核的所有资源。

**注意：**
建议对BT相关操作尽量控制在一个线程内进行，除非特殊情况，尽量不要跨线程，这样便于避免系统内部需要等待不同线程锁，提高系统运行速度。这个可以参考演示程序源码中的实现。

# 接口函数
## 接口整体说明
**DLBT_API和WINAPI**
**功能：**设置DLL库导出方式，对用户使用DLBT没有影响，可以忽略。
~~~ #define DLBT_API extern "C"  __declspec(dllimport)
#define WINAPI   __stdcall
~~~

**说明：**
用户使用接口函数时，不需要理会这两个宏，比如调用DLBT_Startup函数时，可以完全想象它的声明是：BOOL DLBT_Startup。
## Kernel整体环境接口
***DLBT_Startup***

**功能：**启动DLBT内核，初始化BT的运行环境,返回值表示是否成功
~~~// 内核启动时的基本参数（是否启动DHT以及启动端口等）
struct DLBT_KERNEL_START_PARAM
{
    BOOL bStartLocalDiscovery;		// 是否启动局域网内的自动发现（不通过DHT、Tracker，只要在一个局域网也能立即发现，局域网速度快，可以加速优先发现同一个局域网的人）

    BOOL bStartUPnP;				// 是否自动UPnP映射DLBT内核所需的端口

    BOOL bStartDHT;				// 是否启动DHT，如果默认不启动，可以后面调用接口来启动

BOOL bLanUser;                  // 是否纯局域网用户（不希望用户进行外网连接和外网通讯，纯局域网下载模式---不占用外网带宽，只通过内网的用户间下载），适用于内网下载。

    BOOL bVODMode;                  // 设置内核的下载模式是否严格的VOD模式，严格的VOD模式下载时，一个文件的分块是严格按比较顺序的方式下载，从前向后下载；或者从中间某处拖动的位置向后下载
 该模式比较适合边下载边播放,针对这个模式做了很多优化。但由于不是随机下载，所以不大适合纯下载的方案，只建议在边下载边播放时使用。默认是普通模式下载。仅VOD以上版本中有效

    USHORT  startPort;	            // 内核监听的端口，如果startPort和endPort均为或者startPort > endPort || endPort > 32765 这种参数非法，则内核随机监听一个端口。如果startPort和endPort合法

    USHORT  endPort;				// 内核则自动从startPort ---- endPort之间监听一个可用的端口。这个端口可以从DLBT_GetListenPort获得
    
    // 以下是内核内部的默认设置（默认使用随机端口，并启动DHT等）
    DLBT_KERNEL_START_PARAM ()
    {
        bStartLocalDiscovery = bStartUPnP = bStartDHT = TRUE;
        bLanUser = FALSE;
bVODMode = FALSE;
        startPort = 0;
        endPort = 0;
    }
};
//=======================================================================================
//  内核的启动函数，商业授权版才有私有协议功能，演示版只能用标准BT方式
//=======================================================================================
DLBT_API BOOL WINAPI DLBT_Startup (
    DLBT_KERNEL_START_PARAM * param = NULL, // 内核启动设置，参考DLBT_KERNEL_START_PARAM，如果为NULL，则使用内部默认设置
    LPCSTR  privateProtocolIDs = NULL,  // 可以自定义私有协议，突破运营商限制。如果为NULL，则作为标准的BT客户端启动， DLBT的私有协议在.4版本中进行了全新改进，可以穿透大部分运营商对协议的封锁
    bool    seedServerMode = false,     // 是否上传模式，上传模式内部有些参数进行了优化，适合大并发上传，但不建议普通客户端启用，只建议上传服务器使用,专业上传服务器模式仅在商业版中有效，演示版暂不支持该功能。
    LPCSTR  productNum = NULL           // 商业版用户的数字ID，在购买后作者会提供一个产品密钥，激活商业版功能，试用版用户请使用NULL。   
    );
~~~

  
**参数：**

**param：**内核启动设置的参数指针，参考DLBT_KERNEL_START_PARAM结构体中各项注释的含义。如果传入NULL，则使用内置的默认参数（启动DHT、UPnP以及内网自动发现，并使用随机端口），随机端口可以在监听成功后通过 DLBT_GetListenPort 来获得。如果使用固定端口，则可以将param里面的startPort和endPort设置完全相同，比如都是9010，内部则会使用9010作为启动端口，一旦9010被其他程序使用，则会返回失败。
**privateProtocolIDs：**自定义的私有协议串，可以突破运营商对标准BT协议的限制，或者用于构建自己专属的保密数据传输。如果为NULL（默认），则作为标准的BT客户端启动。DLBT的私有协议在3.3版本中进行了全新改进，私有模式下去除了BT的痕迹，可以穿透运营商对协议的封锁。建议字符串的长度为6到16个字符，比如“DLBT Protocol”
如果使用标准协议，则是完全兼容uTorrent、Bitcomet、迅雷等BT软件的；如果使用私有协议，则是完全私有化的网络，下载的用户只能是相同私有协议串的DLBT内核，好处是可以穿透任意的协议封锁。当然，标准协议下，如果使用了BT扩展协议中的加密传输（详见DLBT_SetEncryptSetting的说明）方式，也可以穿透大部分运营商的封锁，同时可以和uTorrent、Bitcomet、比特精灵等兼容。

**seedServerMode：**是否以上传为主，适合上传要求大于下载要求时使用。--- DLBT内核3.1版本以后，已经正式推出了独立的专业上传服务器，因此如果需要几万文件的使用，可以参考了解DLBT专业上传服务器的介绍。 该参数为保留参数，暂时不对外开放，商业用户请在点量官方客服的指导下使用该参数。

**productNum：**商业版用户的数字ID，在购买后作者会提供一个产品密钥，激活商业版功能，试用版用户请使用NULL。

**说明：**
DLBT_Startup 函数必须作为第一个被调用的BT函数，如果传入了Port并且Port已经被占用,则返回失败,如果没有指定端口,一般情况下会成功,因为内核会尝试多个端口找一个可用的,这种情况下，可以调用DLBT_GetListenPort函数获得。建议第一次运行时使用一个随机端口（或者端口固定某个端口范围，一旦监听成功后下次就使用该固定端口，并可以浮动一个范围，以免端口被占用（可以记录到外部程序的配置文件中）。

***DLBT_SetLsdSetting***

**功能：**设置局域网自动发现的一些设置
~~~
DLBT_API void WINAPI DLBT_SetLsdSetting (int interval_seconds, bool bUseBroadcast);
~~~

interval_seconds：组播周期秒数：建议不要低于10s。内部默认是5分钟一次。
bUseBroadcast：是否使用广播模式，默认内部使用组播，如果使用广播，可能局域网有无用流量太多，一般不建议。
