package Demo;

import com.sun.jna.Memory;
import com.sun.jna.Pointer;
import com.sun.jna.WString;

import dolitBT.BTDownloader;
import dolitBT.BTKernel;
import dolitBT.DLBT_TORRENT_TYPE;
import dolitBT.DOWNLOADER_INFO;
import dolitBT.KERNEL_INFO;

// 示例程序
public class BTDemo 
{	 
	public static void main(String[] args) 
	{		
		TestBT();
		
		//演示如何制作种子
		//TestMakeTorrent();
	}
	
	public static void TestBT()
	{
		System.out.println("点量BT示例程序启动：");
		
		// 加载BT环境
		BTKernel bt = new BTKernel();
		BTKernel.StartBT();
		
		// 演示BT下载的调用
        BTDownloader downloader = bt.StartDownload("H:\\test\\test.torrent", "H:\\test\\save\\");
        
        if (downloader == null)
        {
        	System.out.println("添加任务失败，请重试！");
            return;
        }
        
     // 模拟timer周期调用，这里用循环来模拟
        int num = 0;
        while (num ++ < 300)
        {   
	        // 获取任务的运行结果	        
	        String str = "";
	        
	        KERNEL_INFO kInfo = bt.GetKernelInfo();
	        if (kInfo != null)
	        {
	        	// TODO: 打印kInfo的信息
	        	str += "DHT:" + (kInfo.dhtStarted ? "true" : "false");
	        	str += " port:" + kInfo.port;
	        }
	        
	        str +=  "任务【" + downloader.GetDownloaderID () + "】";
	        DOWNLOADER_INFO info = downloader.GetDownloaderInfo();
	        if (info != null)
	        {
	        	 //TODO：将Info中的内容打印出来
	        	str += " 状态:" + info.state;
	        	str += " percentDone:" + info.percentDone;
	        	str += " downloadSpeed:" + info.downloadSpeed;
	        	
	        	// if state == finished || seeding 代表下载完成了。剩余的可以参考C++示例代码来使用
	        }

	        System.out.println(str);	
	        try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	//sleep一下，以免很快循环结束
        }
        
        downloader.Close();
		
		// 释放BT.dll
		BTKernel.ShutdownBT();
        
        System.out.println("点量BT示例程序结束");
	}		
	
	
	public static void TestMakeTorrent()
	{
		System.out.println("制作种子演示");
		
		final int pieceSize = 0;  //内部自动设置分块大小
		
		final Pointer pPercent = new Memory(4); //C++中不停返回制作的进度
		final Pointer pCancel = new Memory(4); //是否取消制作种子
		pCancel.setInt(0, 0);
		pPercent.setInt(0, 0);
				
		// 因为制作种子，如果目标文件很大，可能需要一些时间，为了防止阻塞主界面，以及为了获取进度等信息，这里使用一个线程
		Thread t = new Thread(new Runnable(){  
	          public void run(){  
	        	  WString filePath = new WString("H:\\Test\\testFile.zip");
	        	  int hTorrent = BTKernel.BT.DLBT_CreateTorrent(pieceSize, filePath, null, null, null, DLBT_TORRENT_TYPE.toInt(DLBT_TORRENT_TYPE.USE_PUBLIC_DHT_NODE), 
	        			  pPercent, pCancel, -1, false);
	              
	              if (hTorrent == 0)
	              {
	            	  System.out.println("制作种子失败！");
	                  return;
	              }
	              
	              // 这里添加tracker地址：
	              BTKernel.BT.DLBT_Torrent_AddTracker (hTorrent, new WString("http://www.a.com:8080/announce"), 0);	//如果有多个tracker，请参考我们的bt服务器建议文档，这里需要多次添加
	              BTKernel.BT.DLBT_Torrent_AddTracker (hTorrent, new WString("udp://www.a.com:8080/announce"), 0);	//如果有多个tracker，请参考我们的bt服务器建议文档，这里需要多次添加
	              BTKernel.BT.DLBT_Torrent_AddTracker (hTorrent, new WString("http://www.test.com:8080/announce"), 1);	//如果有多个tracker，请参考我们的bt服务器建议文档，这里需要多次添加
	              BTKernel.BT.DLBT_Torrent_AddTracker (hTorrent, new WString("udp://www.test.com:8080/announce"), 1);	//如果有多个tracker，请参考我们的bt服务器建议文档，这里需要多次添加
	              
	              //为加速下载，提供P2SP加速地址
	              BTKernel.BT.DLBT_Torrent_AddHttpUrl (hTorrent, new WString("http://www.test.com/download/testFile.zip"));
	              
	              // 开始保存种子文件，建议先删除老的（如果老的存在
	             
	              
	              if (BTKernel.BT.DLBT_SaveTorrentFile (hTorrent, new WString("H:\\Test\\testFile.zip.torrent"), null, false, null) != 0)
	              {        
	            	  System.out.println("保存种子文件失败！");
	            	  BTKernel.BT.DLBT_ReleaseTorrent (hTorrent);   
	                  return;
	              }
	              BTKernel.BT.DLBT_ReleaseTorrent(hTorrent);
	              pPercent.setInt(0, 100);
	              System.out.println("保存种子文件成功");
	          }
	    });  
        
		t.start();  
		
		// 如果文件较大，您可以在主线程里面定期获取进度信息、也可以随时取消，如果想取消，就是设置 pCancel.setInt(0, 1); 这样内部就会直接中止制作
		while (t.isAlive())
		{
			int nPercent = pPercent.getInt(0);
			System.out.println("make progress : " + nPercent + "%");
			
			// 如果想中止
			//pCancel.setInt(0,  1);
			
			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
        
        System.out.println("制作种子结束");
	}
}
