package dolitBT;

import com.sun.jna.Memory;
import com.sun.jna.Native;
import com.sun.jna.Pointer;

/**
 * 将点量BT.dll相关的功能封装成JAVA类
 * 管理整个BT DLL的整体环境相关的对象，包括全局限速等。
 * 
 */
public class BTKernel
{     
    // 载入DLL wrapper对象
    public static BTInterFace BT=(BTInterFace)Native.loadLibrary("dll/DLBT", BTInterFace.class);
      
    /// 整个程序只需要执行一次DLL的启动，最后退出时执行相应的关闭，不需要每次都调用
    public static void StartBT ()
    {
    	DLBT_KERNEL_START_PARAM param = new DLBT_KERNEL_START_PARAM();
    	param.startPort = 9010;
    	param.endPort = 9020;
    	BT.DLBT_Startup(param, 0, false, "");   //试用期序列号
    }
    
    public static void ShutdownBT()
    {
    	BT.DLBT_Shutdown();
    }
    
    /////////////////////////////   以下是一些接口函数 /////////////////////////

   /*
    *  启动一个Http下载任务
    *  @param url	  要获取的文件的网址
    *  @return	true代表成功，false失败
    */
    public BTDownloader StartDownload (String torrentFilePath, String savePath)
    {
         BTDownloader downloader = new BTDownloader();
         if (downloader.StartDownload(torrentFilePath, savePath))
         {
        	 // TODO：存入一个列表
        	 return downloader;
         }
         return null;
    }
    
    ///////////////////////////////////  相关获取信息接口 ////////////////////////////////////////////
    public KERNEL_INFO GetKernelInfo()
    {
    	KERNEL_INFO info = new KERNEL_INFO();
    	
    	Pointer p = new Memory(56); //结构体在C++中的内存大小
 	    	
        long ret = BT.DLBT_GetKernelInfo(p);
        if (ret != 0 || Pointer.NULL == p) {
            return null;
        }
        
        long pos = 0;
    	info.port = p.getShort(pos);
    	pos += 4;	//4字节对齐
    	info.dhtStarted = (p.getInt(pos) > 0);
    	pos += 4;
    	
    	info.totalDownloadConnectionCount = p.getInt(pos);
    	pos += 4;    	
    	info.downloadCount = p.getInt(pos);
    	pos += 4;
    	info.totalDownloadSpeed = p.getInt(pos);
    	pos += 4;
    	info.totalUploadSpeed = p.getInt(pos);
    	pos += 4;
    	
    	info.totalDownloadedByteCount = p.getLong(pos);
    	pos += 8;
    	info.totalUploadedByteCount = p.getLong(pos);
    	pos += 8;
    	
    	info.peersNum = p.getInt(pos);
    	pos += 4;    	
    	info.dhtConnectedNodeNum = p.getInt(pos);
    	pos += 4;
    	info.dhtCachedNodeNum = p.getInt(pos);
    	pos += 4;
    	info.dhtTorrentNum = p.getInt(pos);
    	
    	return info;
    }
}
