# **DLBT: Large Concurrency File Transfer Solution with Low Bandwidth Usage P2P Technology**
**Copyright Notice:** For personal non-commercial use, you are free to use the BitTorrent kernel library and demo programs provided by Dolit Software, as well as the content of this document without any charge. We look forward to receiving your feedback and suggestions.

For commercial use, please contact Dolit Software to apply for a commercial license. The code of all demo programs of the BitTorrent kernel library is open to the public, while the core library code is available only to paying customers.

## **1. About DLBT**

### **1.1 Why was DLBT developed? What are its features?** 

DLBT is developed to allow users to implement a powerful BitTorrent application with just a few lines of code without having to understand the specific implementation details of BT. It aims to reduce the repetitive development and financial cost when more and more applications need to incorporate BT functionality.

The DLBT core provides standard BT functionality support and also supports various popular BT extension protocols. It is a feature-rich BT application development toolkit. In addition to BT functions, DLBT also supports custom protocols, helping you implement your own P2P network communication protocol based on the BT architecture and build your own P2P user base.

The DLBT core is currently the kernel with the least resource usage, the fastest download speed, and the most stable speed. You can try it to understand more about the DLBT core and use it to quickly implement your P2P strategy.

Here are some basic features of DLBT:

**Standard BT Protocol Support:** Full support for the official standard BT protocol, along with support for many commonly used extended protocols, DLBT is fully compatible with various BT application software. Among all existing kernels, DLBT has the best compatibility. You can use the DLBT example program to download a popular torrent file, and the speed is the best among current kernels. This is mainly due to DLBT's full support for extended protocols such as DHT and Peer Exchange, as well as many optimizations made to the BT protocol.

**Extremely Convenient Calling Method:** Adopting the standard DLL method, the calling method is completely similar to system API calls (such as CreateFile and other functions). Combined with the author's comprehensive development documentation and demonstration code, developing a fully functional BT application software takes an unimaginably short amount of time.

**Powerful Cross-platform Support:** The DLBT kernel is one of the most portable BT kernels currently available, with support versions released for mainstream platforms such as Windows, Linux, Android, and iOS (post version 3.7.7). If you need support for other platforms like Windows CE, please contact us for custom development discussions.

**Very Low Resource Usage:** You can test and understand the low memory and CPU usage of DLBT, along with its efficient and stable transmission speed, making it the best choice for selecting BT. DLBT's CPU, memory, and disk resources have the lowest usage in the country at present. After version 3.4, the example program automatically set an 8M cache, which can be excluded when calculating memory usage. In fact, as early as the first version of DLBT, it had achieved the lowest resource usage and the most stable speed in the country. The optimization of version 3.4 further reduced resource usage, reflecting our relentless pursuit and professionalism in the field of BT kernel.

**Compatible with uTorrent's UDP Hole Punching Transmission:** Versions of DLBT after 3.6 support UDP hole punching transmission compatible with uTorrent and others. For users who cannot map, it can automatically adapt to UDP hole punching transmission. Moreover, the UDP hole punching transmission function of DLBT version 3.6 does not require any additional server resources and automatically adapts to hole punching in the P2P network, adapting automatically according to the network type. (Available in versions after 3.6)

**Support for HTTP Protocol Downloading (P2SP):** The current version of DLBT supports cross-protocol downloading via HTTP, which on the one hand, breaks through the blockage of BT ports and protocols in many domestic network environments, and on the other hand, solves the download problem when no one is seeding. By using an HTTP address as a node in the P2P system, it achieves simultaneous downloading between HTTP servers and P2P users. The stability of IIS, and some users who have used CDN, can use IIS as an upload source.

**Adjustable Performance Parameters for Different Networks:** For example, in a gigabit local area network and high-speed hard drive environment, by setting this parameter, it is possible to achieve a one-to-one transfer speed of over 50M/s. When multiple people download simultaneously, it can reach the limits of the disk or network. The default settings are suitable for the majority of users with ordinary network configurations. (Available in versions after 3.6.3)

**New End Game Play-As-You-Download Mode in the Commercial Official Version:** The first to support micro-end streaming download for P2P downloads, play where you download, smoothly downloading on-demand by unit.

**DHT Network Support:** DLBT provides standard DHT network support and automatically joins the DHT networks of popular clients such as Bitcomet and official BitTorrent, sharing user resources within the entire BT network. This solves the problem of file downloading in the absence of a Tracker on one hand, and improves download speed on the other.

**Optional ZIP Compression Transfer:** Before transmission, text-based files can be compressed, and they will be automatically decompressed upon receipt, significantly reducing the amount of data transferred and saving bandwidth. This is suitable for situations where there are many text-based files in a folder, such as resource files for some games. (Available in versions after 3.6.3)

**Support for Disguised HTTP Protocol:** Used to break through blocks in some special environments. (It has been found that this feature needs to be enabled for network blocks in Brazil, Malaysia, and some other places). This feature is automatically compatible with users who do not enable it. (Available in versions after 3.6.3)

**Support for Private Tracker Protocol:** Around the end of 2013, we received user feedback and test results showing that some operators in certain areas have blocked the Tracker protocol. The standard Tracker protocol could not obtain neighbor nodes in many areas, and thus could not have download speeds. Therefore, our new version has added a private protocol Tracker feature, which requires support from the Tracker server. Currently, it can solve this problem in conjunction with our self-developed DLBT high-performance Tracker server, and we strongly recommend that old customers upgrade this feature. (Available in versions after 3.7.5)

**Intelligent Disk Allocation:** Supports a full pre-allocation mode, where disk space can be pre-allocated before file download to reduce the generation of disk fragments; it also supports the method of allocating while downloading, and users can choose according to their needs. On the NTFS formatted disk system, it also supports the SPARSE sparse allocation method.

**Support for HTTP and UDP Tracker Protocol, Support for Multiple Tracker Protocols, Support for Equivalent Tracker Reporting.**

**Efficient UPnP Penetration:** No need for support from XP SP2, achieving no configuration required for internal networks under various system versions.

**Support for PMP Method Internal Network Penetration:** The new PMP penetration serves as a supplement to UPnP, further improving the efficiency of internal network penetration.

**Support for Automatic Internal Network Discovery:** When there are two or more users downloading within the same local area network, the system will automatically search to make full use of the internal bandwidth of the local area network, and the speed is rapidly increased.

**Support for Bitcomet's Padding File Technology:** When making a seed, you can choose whether to align the file. If the file is aligned, a block will not span two large files. If the end of the file is not enough for a whole block, it is aligned by a small file or a padding file. This mechanism is very suitable for file update applications, ensuring that some changes in a file in a seed file will not affect the need to update other files. Traditional BT technology, when updating a large folder, does not have a padding file to separate the files, and a block may span two files. If the length of the first file changes, the hash of all the data blocks behind the file will change, and all the files behind the file may need to be re-downloaded. Therefore, DLBT's padding file technology greatly reduces the amount of file updates. (Available in versions after 3.6)

**Implementation of Professional File Update Function:**

1. Provide Update interface, DLBT's professional update function does not need to scan and verify the old files, directly compare the differences between the new and old seed files, and quickly start updating the changed data blocks within a few milliseconds. Traditional BT software, when replacing the old seed with a new seed file, needs to first scan the original files to know which data blocks need to be downloaded. If it is a folder of several G, scanning once takes a long time, and the disk occupancy of the machine is serious during the scanning period. So the interface provided by DLBT is extremely effective when there are a large number of files that need to be updated frequently. (Available in versions after 3.5).
2. Use the minimum local update algorithm, for example, a 1G large file, only a few tens of K data blocks have changed, then the core can automatically retrieve the effective data, which is extremely important in the update of large files.
3. After version 3.6, based on the padding file technology, the professional update interface is improved, making the changes in one file not affect other files, further reducing the amount of data that needs to be updated. (Available in versions after 3.6)
4. Support for a temporary directory interface, when updating files, the required downloaded blocks can be downloaded to a temporary directory, and replaced all at once after the download is completed, so that the original files can be normally used during the download process. This feature can provide a call example. (Available in versions after 3.6.3)

**Data Block Level Download Priority Specification:** Optimize the data block download priority algorithm, support for data block level download priority settings, making high-priority data blocks download the fastest, better supporting P2P applications such as audio and video on-demand live broadcast; improve the response speed when dragging data during on-demand live broadcast.

**Automatic Firewall Penetration Technology:** Automatically penetrate the network connection firewall (ICF) and network connection sharing (ICS) of XP, Vista.

**Support for Cracking and Modifying the TCP/IP Connection Limit of XP SP2**, ensuring the good effect of P2P.

**Intelligent File Resumption:** Record the various information of the last file, and start downloading immediately without scanning the next time it starts. And save the last Peer information to improve the speed of starting the download.

**Comprehensive and Rich Interface Support:** Provide a wealth of control and information acquisition interfaces to meet the vast majority of functional requirements of the application. For example, you can not only limit the global upload and download speeds and connection numbers, but also set each task separately, etc. You can obtain the details of all current connections, the overall situation, the situation of a single task, the information of each file, health rate, sharing rate, etc.

**Provide Professional Upload Server Mode:** DLBT is equipped with a professional upload server kernel, which focuses on improving upload performance, optimizing the transmission efficiency and IO performance when uploading a large number of files, suitable for providing a large number of files for customers to download (for example, when video websites, game programs are distributed, a special server is used to support the download of a large number of users using the upload server mode).

**Private Seed Encryption:** Through private seed encryption, you can build your own private BT network to prevent other clients from using your company's seed files. And for larger torrent files, you can also choose ZIP compression to reduce the size of the torrent file.

**Private Protocol Support:** Support for setting custom protocols, building your own private P2P network (can prevent other BT software from downloading your files), and breaking through the blockade of BT applications in various network environments. In private mode, the traces of BT are removed, and the blockade of BT protocol by operators can be penetrated.

**Protocol Encryption and Data Encryption Support:** DLBT versions after 3.0 support encrypting the protocol or encrypting the data. While being incompatible with Bitcomet and other BT clients, it breaks through the blockade of BT software by operators. At the same time, data encryption can also be used for the transmission of confidential data.

**Support for Common Various Proxies:** Support for users to set Http, Http1.1, Socks4, Socks5, Socks5 with password, and other proxies.

**High Compatibility Seed Production Function:** Support for UTF-8 extension and multi-language, support for embedding publisher and other information into the seed file. **Support for Seed Files of All Characters, Support for Standard and Non-standard Seed Files of UTF-8 and Non-UTF-8:** DLBT has been tested in dozens of character files and can perfectly support East Asian characters such as Japanese and Korean, as well as various special character files; at the same time, it perfectly compatible with standard and non-standard seed files of UTF-8 and non-UTF-8.

**Support for Seed Market, Peer Information Exchange and Other Extension Protocols.**

**Excellent Disk Cache Efficiency:** DLBT core version 3.6 improved disk cache mechanism, automatically adapt to a variety of disk cache algorit.

**Support for IPV6:**
It is compatible with both IPV4 and IPV6 extensions and can adapt automatically.

**Support for Seedless Download Mode (Magnet Links):**

It can efficiently support direct downloads from URLs like "DLBT://4DFFG5667F44DD346A0C944225432452 (the Hash value of the seed file)/Demi-Gods and Semi-Devils (Name)" without the need for a seed file. The seed file will be transmitted through the P2P network, reducing the pressure on the server to provide seed files --- We can also provide construction and design solutions for such websites and clients.

**Source Code Provided:**
The BT source code can be made available to users after paying a certain fee, relieving your concerns and allowing you to fully control your BT control component.

**Comprehensive Example Code in Multiple Languages:**
The DLBT development package currently provides example program source code for VC (C++/MFC), Delphi, C#, VB, Java, Borland C++, VB.NET, and other languages. Example programs in other languages such as Easy Language can also be requested from Dolit Software to minimize the development effort for clients.

### **1.2 Applicable Scenarios:**

If you are in need of developing functionalities for BT or P2P downloads, DLBT is an ideal choice to consider. You can build upon the foundation that DLBT provides, which we hope will be of assistance and help reduce your development costs.

Should you require offering large volumes of data, such as software, videos, and other files, for others to download over the Internet, and you wish to save on bandwidth and server costs while achieving faster speeds, DLBT is worth considering. By utilizing the DLBT development toolkit, you can swiftly implement the upload services you desire.

DLBT is suitable for a variety of applications including video websites, software distribution sites, game downloads and updates, educational video and document downloads, video-on-demand (VOD) systems, and more.

### 1.3 DLBT Professional Upload Server

DLBT officially released the professional upload server kernel on January 3, 2009. This server is dedicated to providing uploads and is suitable for operators such as video and game providers. It can handle uploads of tens of thousands of files using this version, which has the following features:

**High Concurrency Support:** Capable of supporting tens of thousands of users downloading simultaneously. Thanks to the efficient server programming model adopted, this server can support a large number of users downloading at the same time.

**Support for Extremely Large Files and Volumes of Uploads:** The DLBT professional upload server can support uploads of individual seeds of dozens of GBs and uploads of hundreds of thousands of files per seed. There are no restrictions on the size of tasks or the number of files.

**Innovative Sleep Mode:** If you have 1000 tasks initiated for upload, but perhaps only 20 tasks are being downloaded at the moment, then the remaining 980 tasks are in sleep mode. They only report to the Tracker periodically but do not consume any resources. This can result in minimal resource usage. For example, when there are 200 tasks (each an average game task of 2GB), if only a few tasks are being downloaded, it requires only about 30MB of memory. Once a user starts downloading, the system automatically activates the task, achieving fully automated processing. If a task goes undownloaded for a period, it automatically enters sleep mode, releasing all resource occupation.

**Very Low Resource Consumption:** On the one hand, due to the sleep mode, tasks that are not being uploaded do not consume resources. On the other hand, the DLBT professional upload server extensively uses high-performance server design patterns such as memory pools and thread pools, achieving repeated use of resources. When uploading thousands of large tasks, it well demonstrates the advantage of very low resource consumption.

**Long-term Operation Assurance:** The DLBT professional upload server kernel has been used by many game update operators and has undergone mature testing, capable of running without faults for 365×24 hours, proving to be stable and reliable.

**Save Your Server Resources:** Based on customer feedback, some customers previously used a kernel from a company in Beijing, which was unstable for long-term uploading of a large number of files and often crashed. On the other hand, since the kernel was not designed for uploading, it could only upload about 300 large game files at a time. If customers wanted to upload all their content, many server resources were needed. After switching to the DLBT professional upload server kernel, one server could support the upload of 1000 large game files + more than 3000 small and medium-sized software files, saving at least three times the server hardware resources. Moreover, the download speed has increased by more than 60% compared to before. We can promise that the performance of the DLBT professional upload server is definitely higher than that of any other BT software in the country currently.

**A Single Server Can Support Hundreds of Thousands of Files, Dozens of T in Size, and Downloads for Tens of Thousands of Users.**

Additionally, DLBT also has its own Tracker server, which, combined with the professional upload server, provides a more professional and efficient BT upload server system.

If you need a server to provide uploads for tens of thousands of files, then the DLBT professional upload server is your best choice.

Please follow the official Dianliang website for information on the DLBT professional upload server version, about the DLBT professional upload server version: http://blog.dolit.cn/dlbtserver-introduction-html

**1.4 Supported Languages and Development Environments** DLBT provides standard dynamic link library/static library files for languages such as C/C++, Delphi, C#, Java, VB, Easy Language, VB.NET, etc., allowing you to use the DLBT development toolkit (SDK) just like calling system APIs.

**2. Overall Introduction to DLBT Interface** DLBT, as a middleware product, was initially designed to allow developers who need BT technology to integrate it quickly without having to develop it from scratch. The interface is as simple as possible to facilitate easier understanding and use of DLBT's interface.

**2.1 Interface Module Structure** The interfaces provided by DLBT can be divided into several parts: Kernel overall environment related, download task related interfaces, seed production related interfaces, seed information acquisition interfaces, and P2P auxiliary function interfaces.

**2.2 Common Calling Process** The document outlines the steps for initializing the BT application, starting a download task, monitoring the download process, and ending the task and kernel before the program exits.

**3. Interface Functions** The document provides examples of some of the interface functions available in DLBT, such as getting the listening port, setting upload/download speed limits, and setting maximum upload connections and total connections.

**4. Frequently Asked Questions (FAQ)** The document answers common questions about the advantages of DLBT, comparison with other BT software, resource usage, professional upload server kernel, and the convenience of using DLBT.

### 1.4 Supported Languages and Development Environments

DLBT offers standard dynamic link library/static library files (DLL/SO/Lib) that can be invoked by languages such as C/C++, Delphi, C#, Java, VB, Easy Language, VB.NET, etc., allowing you to use the DLBT Development Toolkit (SDK) just as you would use system APIs.

The development environment for the DLBT kernel and the MFC version sample programs is Visual Studio .Net 2005 (the 2003 version can also be used). If you need to compile and read the MFC version sample programs in the DLBT SDK, it is recommended that you install the Visual Studio .Net 2005 or higher development environment.

The DLBT Development Toolkit provides sample programs based on MFC, Delphi, C#, VB, VB.NET, JAVA, and other versions, which you can refer to for calling the DLBT kernel. The Delphi version, for which thanks go to netizens ZZL, Xiao Feng, and others, is provided for reference in Delphi; the specific calling rules and functionalities are subject to the example program code of the VC version.

# 2. Overall Introduction to DLBT Interface

DLBT, as a middleware product, was developed to facilitate the rapid integration of BT technology for developers, eliminating the need to start from scratch. This approach is designed to make it easier for those who require this technology but may not be familiar with it, to better utilize the convenience brought by technological advancements. Therefore, the interface has been kept as simple as possible. For your convenience in understanding the calling of DLBT interfaces, here is a comprehensive introduction.

## 2.1 Interface Module Structure

The interfaces provided by DLBT can be divided into the following parts:

**Kernel Environment Related:**
The Kernel environment is responsible for the overall management of the entire DLBT, monitoring a TCP port and an optional UDP port (used for DHT communication; if DHT is not enabled, there is no need to monitor the UDP port). It manages all download tasks within the kernel and the kernel itself.

**Download Task Related Interfaces:**
Each Torrent seed file download corresponds to a download task object, Downloader. This part provides control (start, pause, rate limiting, etc.) and information reading interfaces for a single download task.

**Seed Production Related Interfaces:**
Used for the creation of seed files. This part complies not only with the standard BT protocol specifications but also supports some extended practices of popular BT client software like Bitcomet in China (embedding publisher information, default use of public DHT network nodes, etc.). A Torrent file can contain descriptions of multiple files to be downloaded.

**Seed Information Acquisition Interfaces:**
Allows you to open a specified seed file and obtain relevant information within the seed file without starting the task download.

**P2P Auxiliary Function Interfaces:**
This part provides some interfaces needed by P2P software, including UPnP penetration, penetration of ICF firewalls, and overcoming the operating system's concurrent connection limit. It can be applied to any program that requires it, independent of the kernel and without the need to start the kernel.

**Batch Information Acquisition Interfaces:**
This part is designed to facilitate the retrieval of a large amount of information at once. A few interface functions can return a structure or an array of structures containing commonly used information.

## 2.2 Common Calling Process

1) First, at program startup, according to actual needs, choose to call the interface that breaks through the system firewall to add the current application and related processes to the firewall's exceptions; call the interface to check the operating system's concurrent connection limit and determine whether a change is needed; call the UPnP penetration interface to add all ports that the application needs to monitor to the UPnP device — the TCP and UDP ports used internally by the DLBT kernel are automatically added internally and do not require external program calls to add.

2) After the program starts, based on user interface operations, initiate the download of a Torrent file. Users typically need to select a Torrent file and the download save path. When starting the Torrent file, simply call the download task's start interface, and the download task will automatically start downloading and immediately return the handle of the task.

3) During the download process, the application can call the download task's interface at any time to obtain current download speed and progress, connection status, progress of each file in the Torrent, and various other information. It can also set download rate limits as needed.

4) After the download task is successfully started, the kernel will not automatically stop the task, and the application needs to actively call stop and delete. Generally, when the download task's progress reaches 100% or the status is seeding, the program can choose to stop the task or set an upload rate limit to continue uploading.

5) Before the program ends, it is necessary to call the download task's interface to stop each Torrent task, and then call the kernel's shutdown interface to release all kernel resources.

**Note:**
It is recommended to try to control BT-related operations within a single thread. Unless special circumstances, try not to cross threads to avoid the system needing to wait for different thread locks, which improves system speed. This can be seen in the implementation of the demonstration program's source code.

#  3. Interface Functions

**Note:** Due to the large number of interface functions, only a few are selected as examples here. For details, please refer to the `api` folder.

**DLBT_API and WINAPI** 

**Function:** Sets the export method for the DLL library. It has no impact on the user's utilization of DLBT and can be disregarded.

~~~ c++
#define WINAPI   __stdcall
~~~

**Function：**
When utilizing the interface functions, users should not be concerned with these two macros. For instance, when calling the `DLBT_Startup` function, you can simply envision its declaration as: `BOOL DLBT_Startup();`.

***DLBT_GetListenPort***

**Function:** Retrieve the port that the current kernel is listening on.

~~~c++
DLBT_API USHORT WINAPI DLBT_GetListenPort ();   
~~~
***DLBT_SetUploadSpeedLimit 和 DLBT_SetDownloadSpeedLimit***

**Function:** Set the maximum overall upload/download speed limit for the entire BT kernel.

~~~c++
DLBT_API void WINAPI DLBT_SetUploadSpeedLimit (int limit);   	// Upload Limit
DLBT_API void WINAPI DLBT_SetDownloadSpeedLimit (int limit);		// download Limit
~~~
**Parameter:**

**limit:** The maximum upload/download speed. The system's default is set to the maximum value (i.e., no restrictions are applied). If the limit is less than or equal to 0, it also indicates no restrictions. Therefore, to set a speed limit, please set the limit to a positive number. The unit is bytes. For example, to set the limit to 1MB, you need to enter 1024*1024.

***DLBT_SetMaxUploadConnection 和 DLBT_SetMaxTotalConnection***

**Function:** Set the overall maximum number of connections for the entire BT kernel's uploads.

~~~c++
DLBT_API void WINAPI DLBT_SetMaxUploadConnection (int limit);   	// Upload Connection Limit
DLBT_API void WINAPI DLBT_SetMaxTotalConnection (int limit);		// TotalConnection Limit
~~~
**Parameters:**

**limit:** The maximum limit for upload/total connections. The system's default is -1, which means no restrictions are applied. The connection limit is, in most cases, equivalent to the number of people. Generally, the maximum number of upload/download connections limit refers to the maximum number of people with whom you can simultaneously upload or download.

##   4. Frequently Asked Questions - FAQ

**4.1 What are the advantages of DLBT?**

1. **Fast Download Speed:** Since DLBT is a fully standard BT protocol and has implemented a large number of extended BT protocols such as DHT, Peer Exchange, and LAN Discovery, you can download a popular movie and compare it with other BT kernels, and the download speed of DLBT is very fast.

   **Why is the download not as fast as Bitcomet or Xunlei?** It is well known in the download field that Xunlei and Bitcomet have very aggressive upload restrictions, and only when uploading to their own users are there no restrictions. If the other party is Dianliang or other software, the upload speed of Xunlei and others is extremely low (this can be seen through the upload speed of the other party in the connection). Because Xunlei has a large user base, their download speed is very fast (they have many people). But this does not mean that the download speed of Dianliang is slow. --- As long as you use Dianliang to build your own BT network, when the network is all using Dolit software, Dianliang is a non-aggressive, healthy upload, so everyone's speed will be very fast. I can promise you that the speed is definitely not lower than the speed of Xunlei and others, which has been confirmed by many customers.

2. **Very Low Resource Occupation:** DLBT's CPU, memory, hard disk, and other resources are the lowest in the country at present. After version 3.4, the example program automatically set an 8M cache, which can be excluded when calculating memory occupation. In fact, as early as the first version of DLBT, it has achieved the lowest resource occupation and the most stable speed in the country. The optimization of version 3.4 further reduced the resource occupation, reflecting our relentless pursuit and professionalism in the field of BT kernel.

   You can use it in conjunction with our Dianliang Professional Upload Server Kernel. If you use the Dianliang Professional Upload Server Kernel on the seed server, compared with any other BT software, you can ensure that you only need less server hardware resources to obtain higher upload speeds. The reason is the professional upload design of our professional upload server kernel and very low resource occupation.

   According to customer feedback, some customers previously used self-developed or other open-source kernels developed online, which were unstable and often crashed when uploading and handling a large number of files in the long run; on the other hand, since the kernel was not designed for uploading, it could only upload about 300 large game files at the same time. If customers want to upload all their own content, many server resources are needed; later, customers switched to the Dianliang Professional Upload Server Kernel, and one server could support the upload of 1000 large game files + thousands of small and medium-sized software, saving at least more than 3 times the server hardware resources. And the download speed is more than 60% higher than before. We can promise that the performance of DLBT Professional Upload Server is definitely higher than that of any other BT software in the country at present.

For a detailed introduction to the Professional Upload Server Kernel, please refer to:

http://blog.dolit.cn/dlbtserver-introduction-html

**Comprehensive Services and Good Service Attitude:** You can see the professionalism and thoughtfulness of our services from the completeness of our documents, example programs, and functions. With our detailed documents, excellent services, and complete example programs, you can quickly master the DLBT kernel. In addition, genuine users of DLBT kernel enjoy free upgrade services for one year after purchase, lifelong bug upgrades, and after one year, you only need to pay the price difference of the version at the time of purchase or a small service fee to enjoy lifelong free upgrade services, eliminating your worries.

1. **Focus leads to professionalism, and professionalism leads to trust:** From the speed of our continuous upgrades, you can see that we are a team that specializes in P2P kernels, and we will also be committed to the research and development and improvement of the kernel for a long time, which is different from companies or individuals whose main business is other businesses.
2. **Stability:** We have many customers who used their own R&D or other company's kernels in the early stage, but encountered many problems in download speed and stability. After finally choosing DLBT, they truly achieved unattended operation throughout the year.
3. **Break through the operator's blockade:** In addition to private protocols, it also supports encrypted transmission, achieving compatibility with Bitcomet and other BT software while breaking through the operator's blockade. It can also use disguised Http transmission to break through the blockade in some special networks such as Malaysia and Brazil.
4. **Complete Functions: Support** intelligent disk allocation, minimized block-level partial updates, LAN discovery acceleration, seedless mode downloading, DHT and Peer Exchange protocols, private protocols, data transmission encryption (breaking through operator blockade), and many other functions. For details, see: http://blog.dolit.cn/dlbt-introduction-html
5. **Customizable Development Services:** We have long-term R&D experience in P2P and project design experience. The P2P projects we have developed cover P2P downloads, P2P on-demand, P2P live broadcasts, P2P software updates and upgrades, cloud computing infrastructure platforms, etc. Therefore, we can provide you with excellent customized development services in the field of P2P. In addition, our technical team has rich development experience in C++, C#, PHP/AJAX/Perl/Python/Asp.net/ASP, VB, Delphi, Flash AS3, etc., and has various technical strengths such as network communication, optimization and construction of websites with large concurrent users, distributed processing of website databases, building efficient servers, DRM copyright control, PDF, UI libraries, etc. So if you have any software development needs, you might as well consult our professional development engineers, who will provide you with a good solution. Reducing the repetitive development and basic development for customers has always been our goal!

**4.2 There are some open-source BT software now, why do you still need DLBT?**

There are some open-source BT software now, but they are not so easy to call, and open-source software often has problems with documentation and ease of use. Even more seriously, many open-source BT software has bugs of varying degrees. What's more serious is that they all lack reliable technical support services, so I developed DLBT, hoping to improve in these aspects and promote the broader development of BT applications. You can choose the appropriate BT kernel according to your needs.

Another reason is that basically all open-source BT software is not adapted to the national conditions of our country, there are many problems that are not suitable for the domestic network situation and file situation. DLBT can make you completely don't need to worry about these, and make your own P2P application in a few days.

**4.3 Does DLBT have a follow-up upgrade plan?**

Since the release of DLBT, it has been continuously improved and has released multiple versions of DLBT. We will also continue to persist in optimizing and improving DLBT, allowing more people and more applications to develop directly based on DLBT, saving the waste of development repetition - this is also the long-term goal of Dolit software. We will later on the one hand, according to customer feedback, on the other hand, based on our understanding of BT applications, BT protocols, and the P2P industry, continuously improve and update. We also provide special versions suitable for various segments and scenarios such as online game updates, video while downloading and playing, and system image large file distribution.

If you have good suggestions for improvement, we also look forward to your contact.

**4.4 Does DLBT Provide Source Code?**

All the code for the DLBT demonstration programs is fully open-sourced. However, the code for the demonstration programs is merely for the purpose of demonstrating the use of the kernel and may not be as elegant and reliable as the actual DLBT kernel code itself. You will need to use the demonstration programs as a reference to write your own calling code that suits your needs.

If you require the source code for the DLBT kernel program, you will first need to pay a certain authorization fee. Please contact Dolit software for more detailed information.

**4.5 Is the DLBT Kernel Fully Compatible with the BT Protocol?**

Yes, it is fully compatible. It is currently the most standard commercial kernel for the BT protocol. Unlike other kernels that are only compatible with the basic BT protocol, we also support a variety of extended BT protocols. You can compare this when downloading torrent files online; the download speed of the DLBT kernel is far superior to other kernels. Many of them only have basic BT protocols, whereas the DLBT kernel supports all kinds of BT extended protocols and DHT, making it a standard BT program like Bitcomet.

**4.6 Can I Request the Author to Add Functions That Are Not Currently Provided?**

Absolutely, we welcome your feedback. Based on your needs, we can add specific features at an appropriate time.

**4.7 How Can I Provide Feedback to the Author?**

You can obtain our latest contact information on the DLBT homepage at http://www.dolit.cn or on the official blog at http://blog.dolit.cn. The official website's contact information includes email, phone, QQ (52401692), and other contact methods.

Alternatively, you can send us an email directly at: [market@dolit.cn](mailto:market@dolit.cn)

We will strive to respond to your feedback as quickly as possible.

**4.8 Can I Use the DLBT Kernel for Free?**

Yes, you can, but there are some usage restrictions on the free version, and it cannot be used for commercial purposes. The software developed can only be used on up to 3 personal machines, cannot be released publicly, and is only for personal learning and understanding. It is not allowed to publish programs that include the DLBT kernel online; otherwise, we can pursue legal responsibility.

**4.9 How Can I Obtain the Commercial Version of DLBT and Its Authorization?**

Contact us, pay a certain fee, and sign a commercial agreement to obtain the commercial version's serial number.

**4.10 What Is the Difference Between the Commercial Version and the Demonstration Version?**

The commercial version has no usage restrictions, and we can provide functions such as seedless downloading, seed encryption, encrypted protocol transmission, etc., according to your needs, and offer customized functions and more comprehensive technical guidance. The demonstration version is not authorized for commercial use.

**4.11 Is It Convenient to Use DLBT?**

It is very convenient. You can call DLBT in a way that is similar to calling system APIs like DeleteFile. If you are a programmer with some work experience, you can master the use of DLBT in just 3 days and develop a very functional BT application software within a week.

Moreover, we provide example program source code in various languages such as VC, Delphi, Borland C++, and C#.

**4.12 How to Call DLBT in Languages Like VC, VB, C#, etc.?**

It is very convenient. You can refer to the calling methods of the VC version, and the official SDK currently provides example programs for VC, Delphi, C#, VB, Java, Borland C++, Android, iOS, and other versions. Example programs for languages like Easy Language can also be requested from us.