package dolitBT;

import com.sun.jna.Memory;
import com.sun.jna.WString;
import com.sun.jna.Pointer;

/**
 * 将点量HttpFtp.dll相关的检测功能封装成JAVA类
 * 管理一个下载（Http下载性能检测）对象，内部操作HttpFtp.dll的接口，对上层提供封装好的HttpDownloader类。
 * 相当于将HttpFtp.dll中 和网络性能检测相关的接口，进行了wrapper封装。
 * 
 */
public class BTDownloader
{
	 // 记录自己的ID，唯一标记自己，每个httpDownloader均有一个唯一ID。HttpFtp.dll中启动成功一个下载任务时会返回标记这个下载的一个ID。
    private long m_downloaderID  = 0;
         
    // 析构函数，一定要记得Release Downloader，否则会有资源泄露，并且导致长时间运行后在运行的downloader太多导致系统变慢
    protected void finalize()
    {
      Close ();
    }	
    
    /// 下载完成后，调用该函数释放资源。否则会有资源泄露
    /// <returns>无</returns>
    
    public void Close ()
    {
        if (m_downloaderID > 0)
        {
        	BTKernel.BT.DLBT_Downloader_Release(m_downloaderID, 0);
            m_downloaderID = 0;
        }
    }
        
    /////////////////////////////   以下是一些接口函数 /////////////////////////

    // 获取任务ID，用于显示区分不同的检测任务
    public long GetDownloaderID ()
    {
        return m_downloaderID;
    }
    
   /*
    *  启动一个BT下载任务
    *  @param torrentFilePath	  种子文件在磁盘上的路径
    *  @param savePath   希望下载到的文件夹
    *  @return	true代表成功，false失败
    */
    public boolean StartDownload (String torrentFilePath, String savePath)
    {
        if (m_downloaderID != 0)    // 已经有任务在运行了，一个downloader只能同时运行一个URL（任务）
            return false;
                  
        WString torrent = new WString (torrentFilePath);
        WString save = new WString (savePath);
        WString status = new WString ("");
        long ret = BTKernel.BT.DLBT_Downloader_Initialize(torrent, save, status, DLBT_FILE_ALLOCATE_TYPE.toInt(DLBT_FILE_ALLOCATE_TYPE.FILE_ALLOCATE_SPARSE), 0, 0, null, null, false, 0);
        if (ret != 0)
        {
        	m_downloaderID = ret;
            return true;
        }
        return false;
    }
    
    ///////////////////////////////////  相关获取信息接口 ////////////////////////////////////////////
    public DOWNLOADER_INFO GetDownloaderInfo()
    {
    	if (m_downloaderID == 0)
    		return null;
    	DOWNLOADER_INFO info = new DOWNLOADER_INFO();
    	
    	Pointer p = new Memory(436);
        long ret = BTKernel.BT.DLBT_GetDownloaderInfo(m_downloaderID, p);
        if (ret != 0 || Pointer.NULL == p) {
            return null;
        } 
        
        long pos = 0;
    	info.state = DLBT_DOWNLOAD_STATE.fromInteger(p.getInt(pos));
    	pos += 4;
    	info.percentDone = p.getFloat(pos);
    	pos += 4;
    	
    	info.downConnectionCount = p.getInt(pos);
    	pos += 4;    	
    	info.downloadLimit = p.getInt(pos);
    	pos += 4;
    	info.connectionCount = p.getInt(pos);
    	pos += 4;
    	info.totalCompletedSeeds = p.getInt(pos);
    	pos += 4;    	
    	info.inCompleteNum = p.getInt(pos);
    	pos += 4;    	
    	info.seedConnected = p.getInt(pos);
    	pos += 4;
    	info.totalCurrentSeedCount = p.getInt(pos);
    	pos += 4;
    	info.totalCurrentPeerCount = p.getInt(pos);
    	pos += 4;
    	info.currentTaskProgress = p.getFloat(pos);
    	pos += 4;
    	info.bReleasingFiles = p.getInt(pos);
    	pos += 4;
    	
    	info.downloadSpeed = p.getInt(pos);
    	pos += 4;
    	info.uploadSpeed = p.getInt(pos);
    	pos += 4;
    	
    	info.serverPayloadSpeed = p.getInt(pos);
    	pos += 4;
    	info.serverTotalSpeed = p.getInt(pos);
    	pos += 4;
            	
    	info.wastedByteCount = p.getLong(pos);
    	pos += 8;
    	info.totalDownloadedBytes = p.getLong(pos);
    	pos += 8;
    	info.totalUploadedBytes = p.getLong(pos);
    	pos += 8;
    	info.totalWantedBytes = p.getLong(pos);
    	pos += 8;
    	info.totalWantedDoneBytes = p.getLong(pos);
    	pos += 8;
    	
    	info.totalServerPayloadBytes = p.getLong(pos);
    	pos += 8;
    	info.totalServerBytes = p.getLong(pos);
    	pos += 8;
    	info.totalPayloadBytesDown = p.getLong(pos);
    	pos += 8;
    	info.totalBytesDown = p.getLong(pos);
    	pos += 8;
    	
    	info.bHaveTorrent = p.getInt(pos);
    	pos += 4;
    	
    	pos += 4;   //java 是8字节对齐，C++是4字节，这里补齐下
    	
    	info.totalFileSize = p.getLong(pos);
    	pos += 8;
    	info.totalFileSizeExcludePadding = p.getLong(pos);
    	pos += 8;
    	info.totalPaddingSize = p.getLong(pos);
    	pos += 8;
    	
    	info.pieceCount = p.getInt(pos);
    	pos += 4;    	
    	info.pieceSize = p.getInt(pos);
    	pos += 4;
    	
    	//char ch[]= p.getCharArray(pos, 256);
    	info.infoHash = p.getString(pos);
    	
    	return info;
    }
    
}
