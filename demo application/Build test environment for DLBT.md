---
typora-root-url: ..
---

如果您想初步了解点量 BT，可以从网上找一些 torrent(种子文件)来进行下载获职初步印象;网上的种子由于大部分是迅雷等的用户在下载，有些软件只对自己的用户大量上传对其他软件的用户上传速度做了限制，因此，可能您看到的速度比不上迅雷等软件的下载速度快。但一般对于一些热门的种子，点量 BT 都可以下载到您网络速度的极限。

如果由于连上的用户大都是迅雷等用户，他们对非迅雷的用户上传有限制，如果发现速度不够理想，您有速度方面的顾虑，可以考虑自己搭建一套系统对比自建系统下的下载速度。

如果您想深入了解点量 BT,则可以自己搭建一套完整的 BT下载系统(P2P分发系统),以下是自己搭建的简单说明。

## **一、安装 tracker并启动**

 (如果局域网内测试，这一步可以跳过，因为点量 BT有局域网自动发现功能，不过自动发现需要一定的周期-有可能要 1-2分钟才能互相找到)。

找台机器安装 tracker，**如果在局域网内测试，其实可头不需要 tracker**，因为点量 BT有内网自动发现功能。

如果在公网测试，tracker需要安装在公网的机器上，要有一个固定 IP 或者域名。

可以使用Bitcomet(比特彗星)Tracker0.5免费tracker：
http://download.bitcomet.com/tools/tracker/achive/BitCometTracker 0.5.zip，或者BNBT
tracker开源服务器。也可以联系点量BT技术支持人员http:/www.dolit.cn/contact.htm)，获取点量自主研发的 tracker 服务器程序。

Tracker 的设置比较简单，以 Bitcomet Tracker0.5为例:

![image-20240607090408567](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240607090408567.png)

第一步点击 Config 设置 tracker 的端口，比如 8080;设置完成后，点 Run 即可。

## 二、开启上传

找一台机器来上传数据，步骤是:

1)就是先找个文件或者文件夹，来制作种子，制作种子时，tracker 地址务必是:http://第一步中那个 tracker机器的 IP端囗/announce。比如 http://221.2.156.1:8080/announce。这里的这个 221.2.156.1是tracker 服务器的皿。8080 是第一步时设置的 tracker 的端口。

目前我们检测到，国内有些地方运营商封锁了Tracker 协议，因此，如果您那边没有速度，也可以联系我们申请使用点量 BT Tracker，可以配合我们的点量 BT Tracker 实现私有协议的 Tracker，突破运营商封锁。 也可以直接在这个地址的地方输入 udp 的 tracker :udp://221.2..156.1:8080/annoumce 这种。这里的这个 221.2.156.1号 tacker服务器的PP。8080是第一步时设置的 tacker 的端口。

也可以在制作种子时2个 tacker 地址一起写，中间用竖线间隔，如下所示:http://221 2.156.1:8080/announceludp://221.2.156.1:8080/announceUDP 的 tracker是可以突破
封锁的，但需要 Tracker 服务器支持 UDP 协议。

如果是局域网测试，制作种子时那个 tacker 地址可以填写对方局域网IP(注意 tracker服务器所在机器要开放防火墙端口例外，或者添加端口映射，确保tracker 的端口是可以telnet 通的)。制作种子界面如图所示:

![image-20240607090633631](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240607090633631.png)

如果是单个文件，可以选中单个文件。这里我们用的一个文件夹做示例。按照上面的
设置，就可以对 D:\Test供种测试文件夹制作一个种子。

选中:“制作完成后自动启动上传”，则种子制作完成后，会自动对该文件进行供种上
传，等待别人的下载。

2)等制作完成后，可以看到任务会自动进行上传，开始时会对文件进行一次校验(因为第一次启动还没有状态文件)，需要校验确认文件是 100%和 torrent对应的。状态里面**必须是“供种中”，文件进度是 100%才正常。**

![image-20240607090724782](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240607090724782.png)



## 三、下载

找一台机器(甚至可以和上传同台机器)，选择那个种子文件进行下载，下载到任意一个空
的目录。可以看到他在下载，上传机器在上传。

![image-20240607090803293](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240607090803293.png)

这个下载时一定要找一个新文件夹(也就是下面没有“供种测试”文件夹的)

​                                                                  ![image-20240607090832302](C:\Users\Administrator\AppData\Roaming\Typora\typora-user-images\image-20240607090832302.png)

状态应该是下载中，后面有速度。

下载机器应该也要可以 telnet 通上传机器的9010 端口才可头(上传端默认使用 9010 端口上传)。如果需要测试打洞等高级功能，并且打洞需请联系点量官方客服 http://www.dolit.cn，要服务器配合或者用户量多时方才有效。