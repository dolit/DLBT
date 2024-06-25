package dolitBT;

import com.sun.jna.Structure;

//// 内核的基本信息
public class DOWNLOADER_INFO extends Structure implements Structure.ByValue
{	
    public DLBT_DOWNLOAD_STATE          state;                         // 下载的状态
    public float                       percentDone;                    // 已经下载的数据，相比整个torrent总数据的大小 （如果只选择了一部分文件下载，那么该进度不会到100%）
    public int                         downConnectionCount;            // 下载建立的连接数
    public int                         downloadLimit;                  // 该任务的下载限速
    public int                         connectionCount;                // 总建立的连接数（包括上传）
    public int                         totalCompletedSeeds;            // Tracker启动以来，总下载完成的人数，如果Tracker不支持scrap，则返回-1
    public int                         inCompleteNum;                  // 总的未完成的人数，如果Tracker不支持scrap，则返回-1
    public int                         seedConnected;                  // 连上的下载完成的人数
    public int                         totalCurrentSeedCount;          // 当前在线的总的下载完成的人数（包括连上的和未连上的）
    public int                         totalCurrentPeerCount;          // 当前在线的总的下载的人数（包括连上的和未连上的）
    public  float                      currentTaskProgress;            // 当前任务的进度 （100.0%代表完成）
    public int                         bReleasingFiles;                // 是否正在释放文件句柄，一般下载完成后，虽然进度完成了，但文件句柄和缓存内部还可能需要一点时间在释放。

    public int                        downloadSpeed;                  // 下载的速度
    public int                        uploadSpeed;                    // 上传的速度
    public int                        serverPayloadSpeed;             // 从服务器下载的总有效速度（不包括握手消息等非数据性传输）
    public int                        serverTotalSpeed;               // 从服务器下载的总速度(包括握手消息、连接通讯的消耗）

    public long                      wastedByteCount;                // 非数据的字节数（控制信息等）
    public long                      totalDownloadedBytes;           // 下载的数据的字节数
    public long                      totalUploadedBytes;             // 上传的数据的字节数
    public long                      totalWantedBytes;               // 选择的总数据大小
    public long                      totalWantedDoneBytes;           // 选择的总数据中，已下载完成的数据大小
    public long                      totalServerPayloadBytes;        // 从服务器下载的数据总量（本次启动以来的文件数据，也包括了如果收到错误的数据，即使后来丢弃的 -- 不过一般服务器如果没问题，不会丢弃数据的）
    public long                      totalServerBytes;               // 从服务器下载的所有数据的总量（包括totalServerPayloadBytes，以及握手数据、收发消息等）
    public long                      totalPayloadBytesDown;          // 本次启动后总的下载的数据块类型的数据量（包括了服务器的数据，以及可能丢弃的数据）
    public long                      totalBytesDown;                 // 本次启动后，总的所有数据的下行数据量（包括了服务器以及所有客户的数据、辅助通讯数据量等）


    // Torrent信息
    public int                        bHaveTorrent;                   // 用于无种子下载模式，判断是否已经获取到了torrent文件
    public long                      totalFileSize;                  // 文件的总大小
    public long                      totalFileSizeExcludePadding;    // 实际文件的大小，不含padding文件, 如果种子中无padding文件，则和totalFileSize相等
    public long                      totalPaddingSize;               // 所有padding数据的大小。如果制作种子时没启用padding文件，则为0
    public int                         pieceCount;                     // 分块数
    public int                         pieceSize;                      // 每个块的大小
    public String                     infoHash;                // 文件的Hash值
	public DOWNLOADER_INFO ()
	{
		
	}
}

