### DLBT 3.7.9 Version (January 4, 2022) - 2022 Edition
1) Optimized x64 Demo handling for some versions such as Java.
2) Added features like IP blacklist that some customers need.
3) Optimized LAN synchronization on Linux, supporting custom IO on Linux.
4) Improved compatibility handling of magnetic chain.

### DLBT 3.7.9 Version (January 6, 2020) - 2020 Edition
1) Optimized compatibility handling of the latest standard magnetic link address.
2) Upgraded the version of OpenSSL on Android to meet the requirements of Google Play.
3) Optimized the professional seeding mode, and reported to the tracker for some optimizations, which can maintain the seed server information for a long time in conjunction with the new version of the tracker.
4) Implemented automatic compatibility between streaming media on-demand mode and traditional download mode.
5) Improved the IP blacklist mechanism, with more comprehensive automatic ban processing for illegal data and nodes.
6) Fixed a bug in the log version that may cause a multi-thread conflict after enabling logs.
7) Optimized the automatic compilation of iOS and Android, and upgraded to the latest environment for compilation.

### DLBT 3.7.9 Version (January 3, 2019) - 2019 Edition
1) Added x64 version in the commercial official version, supporting 64-bit mode calls (not available for download in the trial version, available for commercial users after purchase).
2) Added a new game-on-demand mode in the commercial official version, pioneering P2P download support for micro-end streaming download, playing and downloading where needed, smoothly downloading on-demand by unit.
3) P2SP added a configurable option for path encoding format and the ability to set special virtual extensions for files to prevent interference from operator cache hijacking.
4) Optimized P2P VOD on-demand processing, smoother on-demand, while supporting private seeds and publicly available ordinary torrent files on the Internet.
5) Optimized Tracker performance and optimized LAN discovery for users, adding settings for LAN automatic discovery intervals to better support high-speed mutual transmission of various types of LAN users such as education networks.
6) Optimized torrent encryption algorithm, adopting a new encryption mode.
7) Optimized speed limit mode, more accurate LAN and WAN speed limiting.
8) Support for HTTPS mode P2SP downloads, reducing interference from operator cache hijacking, and adapting to many CDNs such as Wangsu, Tencent, and Kingsoft for accelerated downloads.
9) Fixed some bugs, optimized mobile performance, and enhanced system stability.

### DLBT 3.7.8 Version (January 3, 2018) - 2018 Edition
1) Improved Android and IOS example code, opening more default interface functions on Android.
2) Extended the trial period.

### DLBT 3.7.8 Version (January 6, 2017) - 2017 Edition
1) Added custom IO functionality, allowing users to set their own read and write IO functions through the interface. Convenient for virtual disk, supports Android SAF, OTG, and other application requirements.
2) Android example added P2P video-on-demand functionality demonstration, using DLBT for mobile P2P video is the best choice!
3) For systems with a large number of users, optimized the handling algorithm for user Peer information exchange to prevent excessive network occupation affecting users' Internet access.
4) Optimized CPU usage for seeds with a large number of files, such as "World of Warships" (about 260,000 files).
5) Corrected several exceptions that may occur in seedless mode (magnetic link mode) and when obtaining connection information when the other end's terminal mark is too long.
6) Enhanced and improved the security of encrypted seeds and private protocols.
7) Optimized the handling method of asynchronous replacement mode.
8) Made many detailed optimizations to improve efficiency and robustness.

### DLBT 3.7.7 Version (January 21, 2016) - 2016 Edition
1) Officially released Linux and IOS versions, which have been maturely used by many customers. Since then, DLBT has fully supported mainstream platforms such as Windows, Linux, IOS, and Android.
2) Optimized the interface method of the Android version, making it easier for users to extend functions on their own.
3) Optimized CPU usage (especially CPU usage in chunk processing of VOD version).
4) Further optimized P2P VOD version processing, accelerating drag effects.
5) Corrected a few small detail errors such as a case where folder case sensitivity was distinguished in DeleteUnRelatedFiles and a case where scrap statistics might be inaccurate.
6) Optimized the handling of environments with disk restoration, supporting image-based directories.
7) Corrected a bug in tracker replacement.
8) Further expanded the limits of the number of files and chunks in torrent files, supporting ultra-large game files (ultra-large game directories where the seed is tens of M after seed completion).

### DLBT 3.7.6 Version (January 7, 2015) - 2015 Edition
1) Optimized many algorithms in the VOD on-demand version and has been stably used in many video and audio systems.
2) Snapshot files can be directly generated on the server side, and game upgrade versions no longer need file comparison, just use snapshot information.
3) Improved the update comparison algorithm, making the efficiency of comparing updates between old and new torrents higher, basically without reading disk files, improving comparison speed.
4) Optimized support for systems with disk restoration, supporting directories of various restored disks.
5) Enhanced the encryption algorithm for torrent encryption mode.
6) The Android version is available for formal customers, with performance and functionality basically consistent with the PC side, compiled from the same code, ensuring the stability of the Android version's P2P components.
7) Corrected some bugs.
8) Added several new interface functions.

### DLBT 3.7.5 Version (January 7, 2014)
1) Improved UDP hole punching service mode, allowing users to choose between server-assisted mode and peer-assisted hole punching mode.
2) Resolved the issue of high physical memory usage when operating large files on operating systems above Windows 7.
3) Added an optimized P2P  VOD on-demand version, which further supports drag response. It also supports adding cross-protocol downloaded data directly into DLBT.
4) In conjunction with the DLBT Tracker server, private tracker support is added to break through blockades on HTTP trackers in some regions discovered at the end of 2013.
5) The block replacement operation in the temporary directory feature is changed to asynchronous and can return progress through callbacks.
6) Improved server speed limiting: It is possible to set server IPs to avoid connecting to the server when the speed is fast, reducing server resource usage.
7) Added pure intranet mode: In pure intranet mode, users hardly connect to the external network and only use intranet P2P downloads, reducing the occupation of external network traffic by intranet users in internet cafes.
8) Added an interface to delete extra files not recorded in the torrent after downloading is completed: DLBT_Downloader_ReleaseAllFiles.
9) Optimized the processing of encrypted torrents, making the encrypted torrent size even smaller than the unencrypted one. Also added a parameter for zip compression without encryption, allowing direct launching of zip-compressed torrents.
10) Default addition of empty directories to the torrent.
11) Improved the efficiency of an internal thread.
12) Optimized seedless mode: Multiple tracker addresses can be passed, and the speed of obtaining torrents in seedless mode is increased.
13) Optimized speed display and rate limiting mechanisms.
14) Added statistics for server upload data volume, upload speed, and some data information obtained from the server.
15) Before stopping tasks, added an interface to release files, which can be released after successful release.
16) save Torrent can be named using hash values.
17) Improved file priority handling mechanism.
18) Improved LAN automatic discovery, UDP Tracker, and other UDP communication mechanisms.

### DLBT 3.7.3 Version (June 17, 2013)
1) Pause mode startup no longer affects the content changes of the target file (convenient for comparison before downloading to a temporary directory, etc.).
2) Fixed an issue with the sparse mode that could cause unknown problems on machines above Vista in some rare cases.
3) Improved UDP hole punching algorithm, increasing the success rate in standalone UDP server mode.
4) Modified the processing algorithm for some tail data in P2SP mode.
5) Multiple internal stability adjustments.
6) Added two interface functions to obtain P2SP connection information.
7) Improved the speed of making seeds for folders with a large number of files.
8) Improved the efficiency of several areas.
9) Added example code for calling the DLBT kernel in the JAVA version.

### DLBT 3.7.2 Version (January 28, 2013)
1) Fixed a debug code that was not deleted before the release of 3.7.1, which could cause the DLL to create a gibberish folder outside the current directory when started (a bug introduced in 3.7.1).
2) Supported extremely large seed files in seedless mode.

### DLBT 3.7.1 Version (January 17, 2013)
1) Improved encrypted torrent functionality, with the encrypted torrent size basically not increasing.
2) Some basic information about the torrent can be obtained without reloading after making the seed.
3) Supported extremely large torrent files of 50M or torrents with millions of files (these types of files are generally not supported by Xunlei and uTorrent).
4) The local download can be set to change the file modification time to the server time recorded in the torrent.
5) A separate speed limit can be set for LAN transmission, with one limit for the external network and another for data transmission within the LAN.
6) When making a torrent for a folder with tens of thousands of files, the intelligent chunk setting is optimized to improve the speed of making the torrent.

### DLBT 3.6.5 Version (June 14, 2012)
1) Optimized the processing of torrents containing padding-files in P2SP mode, reducing data request volume.
2) Optimized the handling of completed downloads and seeding tasks, improving the efficiency of client connections and allowing seed nodes to connect to clients for uploading more quickly.
3) Fully optimized IPV6 support and memory usage.
4) Added a new encryption mode that balances CPU and data transmission security.
5) Added optional features such as creating empty directories, modifying file times to server time, and automatically overwriting read-only files.

### DLBT 3.6.3.1 Version (February 3, 2012)
1) Added default support for multiple connections to a single server in p2sp (configurable), enhancing p2sp download speed.
2) Optimized UPnP penetration processing.
3) Extended trial period and other minor optimizations.

### DLBT 3.6.3 Version (August 16, 2011)
1) Supported zip compression transmission, allowing text-based files to be compressed before transmission, greatly reducing the amount of data transferred and saving bandwidth, suitable for cases where there are many text-based files in a folder, such as some game resource files.
2) Supported disguised HTTP protocol to break through blocks in some special environments (currently found to be necessary in some network blocks in Brazil, Malaysia, etc.). This feature is automatically compatible with users who do not enable it.
3) Added an interface to adjust performance parameters under different network conditions, such as achieving a one-to-one transmission speed of over 50M/s in a gigabit LAN with a high-speed hard drive environment, reaching the limits of the disk or network when multiple people download simultaneously.
4) Supported Replace interface, allowing downloaded chunks to be downloaded to a temporary directory during file updates, and replacing them all at once after completion, allowing the original file to be used normally during the download process. This feature can provide a calling example.
5) Set to save the state file at any time, reducing the chance of scanning verification after illegal exits (such as power outages), improving startup speed.
6) Optimized exit speed.
7) Supported a separate UDP penetration server.
8) Improved disk IO efficiency.
9) Optimized p2sp, supporting a bug in the IIS server in Windows 2003 Server RC2.
10) Optimized the quick comparison update feature, actually verifying the chunks that need to be updated, which still requires some disk scanning but is much more accurate. The early quick comparison did not require disk scanning.
11) Corrected the issue of non-standard support for a single file in a directory.
12) Improved the performance of functions such as speed acquisition.
13) Corrected the bug when there is only one file in a torrent, but a folder method is still used to make the seed.
14) Added example programs, header files, and Lib files for calling DLBT with Borland C++.

### DLBT 3.6.2 Version (November 30, 2010)
1) Further reduced memory usage (especially when using the rootPathName parameter).
2) Speeded up the connection to the tracker at startup.
3) Corrected an error in making the seed.

### DLBT 3.6.1 Version (November 6, 2010)
1) Optimized the network layer structure, enhancing the overall performance and throughput of the network layer.
2) Improved the DLBT transmission protocol, breaking through all current blockades under private protocol.
3) Corrected the issue of seed failure for certain files.
4) Improved the choke algorithm, enhancing upload and download capabilities.
5) Reduced the file size of the compiled DLBT.dll.
6) Shortened the exit time for seeding tasks.
7) Corrected some bugs reported by users after the release of 3.6.0.

### DLBT 3.6 Version (October 15, 2010)
1) Supported UDP penetration transmission compatible with uTorrent, automatically adapting to UDP penetration transmission for users who cannot map. Moreover, the UDP penetration transmission function of DLBT 3.6 version does not require any additional server resources and automatically adapts to penetration in the P2P network, automatically judging according to the network type.

2) **Padding File Technology Integration:**

   - DLBT has integrated padding file technology, compatible with Bitcomet, which allows for the alignment of files when creating a torrent.
   - With aligned files, a piece will not span across two large files, and any insufficient block at the end of a file is padded by a small file or a padding file.
   - This mechanism is particularly suitable for file updating applications, ensuring that changes in one file within a torrent do not affect the need to update other files.
   - Traditional BT technology, when updating large folders, may have a piece span two files without padding files. If the length of the first file changes, the hash of all subsequent data blocks will change, potentially requiring a re-download of all subsequent files. DLBT's padding file technology significantly reduces the amount of file updates.

3) **Professional Update Interface Improvement:**
   - Based on the padding file technology, the professional update interface has been improved to quickly compare the pieces that need updating at the block level without the need for file scanning.
   - This allows for a rapid comparison within milliseconds, updating only the changed data blocks, ensuring changes in one file do not affect others.

4) **Disk Cache Algorithm Optimization:**
   - The disk cache algorithm has been optimized to increase the cache hit rate, thereby improving download and upload speeds and enhancing the overall performance of the kernel.

5) **Kernel Structure Improvement:**
   - The kernel structure has been improved to reduce locking and enhance system performance.

6) **Kernel File Size Reduction:**
   - The overall size of the kernel, after compiling all features, has been reduced to approximately 700-800K.

7) **Blocking Algorithm Optimization:**
   - The blocking algorithm has been optimized to prevent flood attacks and improve the P2P network's ability to select and adapt.

8) **Magnet Link Support:**
   - DLBT supports the uTorrent-standard magnet link format and also supports its custom DLBT:// protocol for seedless downloads, which better addresses issues with Chinese characters compared to uTorrent's protocol standard.

9) **IPV6 Support in Internal Transfers:**
   - The internal transfer system now supports IPV6.

10) **Bug Fixes:**
    - Various other bugs have been corrected.

### DLBT 3.5.3 Version (October 15, 2010)

1) **Half-Open Connection Setting Interface:**
   - An interface for setting the number of half-open connections has been added to prevent excessive connections from affecting activities such as web browsing.

2) **Private Protocol Task Setting:**
   - It is now possible to set whether to use a private protocol for individual tasks, allowing some torrents to use a private protocol while others use the standard BT protocol within the same kernel.

3) **UPnP Penetration Success Rate Improvement:**
   - Algorithms have been improved to increase the success rate of UPnP penetration.

4) **Move Interface Addition:**
   - A Move interface has been added, allowing files to be cut or copied to other directories after download completion.

5) **Bug Fixes:**
   - Corrected two bugs: one that could cause task startup failure on very few machines and another that caused crashes when entering P2SP addresses when making seeds.

### DLBT 3.5.1 and 3.5.2 Versions:

- Some features needed by customers were added but not officially released.

### DLBT 3.5.0 Version (May 12, 2010)

1) **Professional File Update Feature:**
   - The professional update feature of DLBT does not require any scanning or verification of old files. It directly compares the differences between new and old torrent files and quickly initiates updates for changed data blocks within milliseconds.
   - Traditional BT software requires scanning of the original files to know which data blocks need to be downloaded when a new torrent replaces an old seed. This can take a long time for a multi-G folder, with significant disk usage during scanning. The interface provided by DLBT is extremely effective when there are many files that need frequent updates.

2) **P2SP Function Improvement:**
   - The P2SP function (using HTTP servers as regular P2P nodes) has been improved to support various encodings such as Utf8 and GB2312. Users can freely download from both HTTP servers and regular P2P nodes simultaneously.

3) **Bug Fixes for Vista:**
   - Corrected a bug that might cause exceptions when exiting under Vista.

4) **Additional Seed Information Support:**
   - Extended support to obtain additional seed information from BT clients.

5) **Exit Speed Improvement:**

   - Improved the speed of exiting the application.