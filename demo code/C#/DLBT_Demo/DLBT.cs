//=======================================================================================
//                 ����BT��DLBT������ ��������רҵ��BT�ں�DLL��
//                                  ��ʡ���Ŀ���ʱ��
// 
//	Copyright:	Copyright (c) ����������޹�˾ 
//  ��Ȩ���У�	����������޹�˾ (QQ:52401692   <support at dolit.cn>)
//
//              ������Ǹ�����Ϊ����ҵĿ��ʹ�ã����������ɡ���ѵ�ʹ�õ���BT�ں˿����ʾ����
//              Ҳ�ڴ��յ�������������ͽ��飬��ͬ�Ľ�����BT
//              ���������ҵʹ�ã���ô����Ҫ��ϵ���������Ʒ����ҵ��Ȩ��
//              ����BT�ں˿�������ʾ����Ĵ�����⹫�����ں˿�Ĵ���ֻ�޸����û�����ʹ�á�
//        
//  �ٷ���վ��  http://www.dolit.cn      http://blog.dolit.cn
//
//=======================================================================================   

using System;
using System.Text;
using System.Runtime.InteropServices;


namespace DLBT_Demo
{
	/// <summary>
	/// DLBT ��ժҪ˵����
	/// </summary>
	public class DLBT
	{
		
        //=======================================================================================
        //  �ں˵������͹رպ���
        //=======================================================================================
        [DllImport("DLBT.dll", EntryPoint="DLBT_Startup",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Startup(ref DLBT_KERNEL_START_PARAM param, string protocol, bool seedServerMode, string  productNum);

        // ����ں˼����Ķ˿�
        [DllImport("DLBT.dll", EntryPoint="DLBT_GetListenPort",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt16 DLBT_GetListenPort ();

        // ���رյ���BT�ں�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Shutdown",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Shutdown ();

        // ���ڹرյ��ٶȿ��ܻ�Ƚ���(��Ҫ֪ͨTracker Stop), ���Կ��Ե��øú�����ǰ֪ͨ,��������ٶ�
        // Ȼ������ڳ�������˳�ʱ����DLBT_Shutdown�ȴ������Ľ���
        [DllImport("DLBT.dll", EntryPoint="DLBT_PreShutdown",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_PreShutdown ();

        //=======================================================================================
        //  �ں˵��ϴ������ٶȡ���������û���������
        //=======================================================================================
        // �ٶ����ƣ���λ���ֽ�(BYTE)�������Ҫ����1M�������� 1024*1024
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetUploadSpeedLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetUploadSpeedLimit (int limit);

        [DllImport("DLBT.dll", EntryPoint="DLBT_SetDownloadSpeedLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetDownloadSpeedLimit (int limit);

        [DllImport("DLBT.dll", EntryPoint="DLBT_SetMaxUploadConnection",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetMaxUploadConnection (int limit);        

        [DllImport("DLBT.dll", EntryPoint="DLBT_SetMaxTotalConnection",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetMaxTotalConnection (int limit);
        
        // ��෢������������ܶ����ӿ����Ƿ����ˣ�����û���ϣ���xpϵͳĬ�������10����DLBT_ChangeXPConnectionLimit�ӿں����ͻ��������ơ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetMaxHalfOpenConnection",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetMaxHalfOpenConnection (int limit);

        // ���������Ƿ�Ը��Լ���ͬһ�����������û����٣�limit���Ϊtrue����ʹ�ú�������е�������ֵ�������٣������ޡ�Ĭ�ϲ���ͬһ���������µ��û�Ӧ�����١�
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetLocalNetworkLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetLocalNetworkLimit (
            bool    limit,              // �Ƿ����þ���������
            int     downSpeedLimit,     // ������þ��������٣��������ٵĴ�С����λ�ֽ�/��
            int     uploadSpeedLimit    // ������þ��������٣������ϴ��ٶȴ�С����λ�ֽ�/��
            );  

        // �����ļ�ɨ��У��ʱ����Ϣ������circleCount����ѭ�����ٴ���һ����Ϣ��Ĭ����0��Ҳ���ǲ���Ϣ��
        // sleepMs������Ϣ��ã�Ĭ����1ms
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetFileScanDelay",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetFileScanDelay (int circleCount, int sleepMs);  

        // �����ļ�������ɺ��Ƿ��޸�Ϊԭʼ�޸�ʱ�䣨��������ʱÿ���ļ����޸�ʱ��״̬�������øú�����������torrent�л������ÿ���ļ���ʱ���޸�ʱ����Ϣ
        // �û�������ʱ�������������Ϣ�����ҵ����˸ú����������ÿ���ļ����ʱ���Զ����ļ����޸�ʱ������Ϊtorrent�����м�¼��ʱ��
        // ���ֻ�����صĻ����������˸ú��������������ӵĻ�����û��ʹ�øú�����������û��ÿ���ļ���ʱ����Ϣ������Ҳ�޷�����ʱ���޸�
        [DllImport("DLBT.dll", EntryPoint="DLBT_UseServerModifyTime",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_UseServerModifyTime(Boolean bUseServerTime);


		// �Ƿ�����UDP��͸���书�ܣ�Ĭ�����Զ���Ӧ������Է�֧�֣���tcp�޷�����ʱ���Զ��л�ΪudpͨѶ
		[DllImport("DLBT.dll", EntryPoint="DLBT_EnableUDPTransfer",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_EnableUDPTransfer(Boolean bEnabled);

		// �Ƿ�����αװHttp���䣬ĳЩ�����������������ǡ�������һЩ���磩��Http�����٣�����P2P������20K���ң��������绷���£���������Http����
		//  Ĭ��������αװHttp�Ĵ�����루���Խ������ǵ�ͨѶ�������Լ���������Ӳ�����αװ�� ����ͻ�Ⱥ���������û������Կ��Ƕ����ã�����αװ��
		// ������αװҲ�и����ã�������Щ����������һ������ͨ��������Http����ʹ��������������ʹ��IP����BT�����У��Է�û�кϷ������������ᱻ�������ƽ�ɱ
		// ������������ƣ���������αװ���û���ٶȡ����������ʵ��ʹ��ѡ��
		[DllImport("DLBT.dll", EntryPoint="DLBT_SetP2PTransferAsHttp",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_SetP2PTransferAsHttp (bool bHttpOut, bool bAllowedIn);

		// �Ƿ�ʹ�õ����Ĵ�͸�������������ʹ�õ�������������͸��Э������ĳ��˫���������ϵĵ�����p2p�ڵ㸨�����
		[DllImport("DLBT.dll", EntryPoint="DLBT_AddHoleServer",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern Boolean DLBT_AddHoleServer(string ip, short port);

        // ���÷�������IP�����Զ�ε������ö�������ڱ����ЩIP�Ƿ��������Ա�ͳ�ƴӷ��������ص������ݵ���Ϣ�������ٶȵ���һ���̶ȿ��ԶϿ����������ӣ���ʡ����������
        // P2SP���������Զ��ᱻ���Ϊ������������Ҫ�ٵ�������
        [DllImport("DLBT.dll", EntryPoint="DLBT_AddServerIP",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_AddServerIP (string ip);
        // ��ȥ�������p2sp��url�������ظ�����. Ŀ���ǣ�����Ƿ������ϣ����p2sp��url���ڱ�������û��Ҫȥ�������url��
        [DllImport("DLBT.dll", EntryPoint = "DLBT_AddBanServerUrl", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern void DLBT_AddBanServerUrl(string url);

		// ����һ��״̬�ļ����������ڲ�Ĭ��ȫ��������ɺ󱣴�һ�Ρ����Ե���Ϊ�Լ���Ҫ��ʱ�����������Ŀ������ÿ5���ӱ���һ�Σ���������100�����ݺ󱣴�һ��
		[DllImport("DLBT.dll", EntryPoint="DLBT_SetStatusFileSavePeriod",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern Boolean DLBT_SetStatusFileSavePeriod (
						  int             iPeriod,               //����������λ���롣Ĭ����0���������������ɣ�������������
						  int             iPieceCount            //�ֿ���Ŀ��Ĭ��0���������������ɣ�������������
						  );

        //=======================================================================================
        //  ���ñ���Tracker�ı���IP���������غ͹���ʱ�����Լ�NAT�Ĺ���IP��Ƚ���Ч����ϸ�ο�
        //  ����BT��ʹ��˵���ĵ�
        //=======================================================================================
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetReportIP",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetReportIP (string ip);

        [DllImport("DLBT.dll", EntryPoint="DLBT_GetReportIP",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern string DLBT_GetReportIP (string ip);

        [DllImport("DLBT.dll", EntryPoint="DLBT_SetUserAgent",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetUserAgent (string agent);

        //=======================================================================================
        //  ���ô��̻��棬3.3�汾���Ѷ��⿪�ţ�3.3�汾��ϵͳ�ڲ��Զ�����8M���棬���������ʹ�ø�
        //  �������е�������λ��K������Ҫ����1M�Ļ��棬��Ҫ����1024
        //=======================================================================================
        [DllImport("DLBT.dll", EntryPoint="DLBT_SetMaxCacheSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetMaxCacheSize (UInt32 size);

		// һЩ���ܲ������ã�Ĭ������£�����BT��Ϊ����ͨ���绷���µ��������ã��������ǧM��������
		// ���Ҵ����������ã�����50M/s����100M/s�ĵ����ļ������ٶȣ�����Ҫ������Щ����
		// ������������ý��飬����ѯ���������ȡ

		[DllImport("DLBT.dll", EntryPoint="DLBT_SetPerformanceFactor",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_SetPerformanceFactor(
								 int             socketRecvBufferSize,      // ����Ľ��ջ�������Ĭ�����ò���ϵͳĬ�ϵĻ����С
								 int             socketSendBufferSize,      // ����ķ��ͻ�������Ĭ���ò���ϵͳ��Ĭ�ϴ�С
								 int             maxRecvDiskQueueSize,      // ���������δд�꣬������������󣬽���ͣ���գ��ȴ������ݶ���С�ڸò���
								 int             maxSendDiskQueueSize       // ���С�ڸò����������߳̽�Ϊ���͵������������ݣ������󣬽���ͣ���̶�ȡ
								 );


        //=======================================================================================
        //  DHT��غ���,port��DHT�����Ķ˿ڣ�udp�˿ڣ������Ϊ0��ʹ���ں˼�����TCP�˿ںż���
        //=======================================================================================
        [DllImport("DLBT.dll", EntryPoint="DLBT_DHT_Start",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_DHT_Start (UInt16 port);
        
        [DllImport("DLBT.dll", EntryPoint="DLBT_DHT_Stop",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_DHT_Stop ();

        [DllImport("DLBT.dll", EntryPoint="DLBT_DHT_IsStarted",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_DHT_IsStarted ();


        /*
         * ʱ���ϵ����ʱû�з������²��ֵ�C������������������ط�ʵ�֣��������ѣ�����ϵ���ߣ�
         * 
         * //=======================================================================================
            //  ���ô�����غ���,��ҵ��Ȩ����д˹��ܣ���ʾ���ݲ��ṩ
            //=======================================================================================
            struct DLBT_PROXY_SETTING
            {
                char    proxyHost [256];    // �����������ַ 
                int     nPort;              // ����������Ķ˿�
                char    proxyUser [256];    // �������Ҫ��֤�Ĵ���,�����û���
                char    proxyPass [256];    // �������Ҫ��֤�Ĵ���,��������

                enum DLBT_PROXY_TYPE
                {
                    DLBT_PROXY_NONE,            // ��ʹ�ô���
                    DLBT_PROXY_SOCKS4,          // ʹ��SOCKS4������Ҫ�û���
                    DLBT_PROXY_SOCKS5,          // ʹ��SOCKS5���������û���������
                    DLBT_PROXY_SOCKS5A,         // ʹ����Ҫ������֤��SOCKS5������Ҫ�û���������
                    DLBT_PROXY_HTTP,            // ʹ��HTTP�����������ʣ��������ڱ�׼��HTTP���ʣ�Tracker��Http��Э�鴫�䣬�����򲻿���
                    DLBT_PROXY_HTTPA            // ʹ����Ҫ������֤��HTTP����
                };

                DLBT_PROXY_TYPE proxyType;      // ָ�����������
            };

            //=======================================================================================
            //  ��ʶ����Ӧ������Щ���ӣ�Tracker�����ء�DHT��http��Э�����صȣ�
            //=======================================================================================
            #define DLBT_PROXY_TO_TRACKER       1  // ��������Trackerʹ�ô���
            #define DLBT_PROXY_TO_DOWNLOAD      2  // ��������ʱͬ�û���Peer������ʹ�ô���
            #define DLBT_PROXY_TO_DHT           4  // ����DHTͨѶʹ�ô���DHTʹ��udpͨѶ����Ҫ������֧��udp��
            #define DLBT_PROXY_TO_HTTP_DOWNLOAD 8  // ����HTTP����ʹ�ô�����������http��Э������ʱ��Ч��������Tracker��

            // �����о�ʹ�ô���
            #define DLBT_PROXY_TO_ALL   (DLBT_PROXY_TO_TRACKER | DLBT_PROXY_TO_DOWNLOAD | DLBT_PROXY_TO_DHT | DLBT_PROXY_TO_HTTP_DOWNLOAD)

            DLBT_API void WINAPI DLBT_SetProxy (
                DLBT_PROXY_SETTING  proxySetting,   // �������ã�����IP�˿ڵ� 
                int                 proxyTo         // ����Ӧ������Щ���ӣ���������궨��ļ������ͣ�����DLBT_PROXY_TO_ALL
                ); 

         //���ip������(���������һ����Χ�ڵ�ip,���ֻ��һ��ip�ڶ�����������ΪNULL),�ɹ�����0��ʧ�ܷ���<0
        DLBT_API int WINAPI DLBT_AddIpBlackList(const char*ipRangeStart,const char*ipRangeEnd);
        //��յ�ǰip�������б�
        DLBT_API void WINAPI DLBT_RemoveAllBlackList();
        DLBT_API int WINAPI DLBT_Downloader_GetTrackerCount(HANDLE hDownloader);
        DLBT_API HRESULT WINAPI DLBT_Downloader_GetTrackerUrl (HANDLE hDownloader, int index, LPSTR url, int * urlBufferSize);
         * 
            //=======================================================================================
            //  ��ȡ��������ã�proxyTo��ʶ������һ�����ӵĴ�����Ϣ����proxyToֻ�ܵ�����ȡĳ������
            //  �Ĵ������ã�����ʹ��DLBT_PROXY_TO_ALL���ֶ�����ѡ��
            //=======================================================================================
            DLBT_API void WINAPI DLBT_GetProxySetting (DLBT_PROXY_SETTING * proxySetting, int proxyTo);
        */

        //=======================================================================================
		//  ���ü�����غ���,��Э���ַ��������������ݾ����ܣ�ʵ�ֱ��ܴ��䣬�ڼ���BTЭ����ͻ��
		//  ���󲿷���Ӫ�̵ķ�������ǰ���ᵽ��˽��Э�鲻ͬ���ǣ�˽��Э����γ��Լ�
		//  ��P2P���磬����ͬ����BT�ͻ��˼��ݣ���˽��Э����ȫ����BTЭ���ˣ�û��BT�ĺۼ������Դ�͸
		//  ������Ӫ�̵ķ�������ͬ�������£�������Ҫ��ͬ���á����αװHttpʹ�ã���ĳЩ������Ч������
		//=======================================================================================
		public enum DLBT_ENCRYPT_OPTION
		{
			DLBT_ENCRYPT_NONE,                  // ��֧���κμ��ܵ����ݣ��������ܵ�ͨѶ��Ͽ�
			DLBT_ENCRYPT_COMPATIBLE,            // ����ģʽ���Լ���������Ӳ�ʹ�ü��ܣ���������˵ļ������ӽ��룬�������ܵ���ͬ�Է��ü���ģʽ�Ự�� 
			DLBT_ENCRYPT_FULL,                  // �������ܣ��Լ����������Ĭ��ʹ�ü��ܣ�ͬʱ������ͨ�ͼ��ܵ��������롣�����������ü���ģʽ�Ự�������Ǽ�����������ģʽ�Ự��
			// Ĭ������������
			DLBT_ENCRYPT_FORCED,                // ǿ�Ƽ��ܣ���֧�ּ���ͨѶ����������ͨ���ӣ����������ܵ���Ͽ�
		};

        // ���ܲ㼶�ߣ������ϻ��˷�һ��CPU�������ݴ��䰲ȫ��ͻ�Ʒ�����������������
        public enum DLBT_ENCRYPT_LEVEL
        {
            DLBT_ENCRYPT_PROTOCOL,          // ������BT��ͨѶ����Э��  ����һ�����ڷ�ֹ��Ӫ�̵���ֹ
            DLBT_ENCRYPT_DATA,              // ���������������������ݣ����� ���ڱ�����ǿ���ļ�����
            DLBT_ENCRYPT_PROTOCOL_MIX,      // �������������ʹ�ü���Э��ģʽ��������Է�ʹ�������ݼ��ܣ�Ҳ֧��ͬ��ʹ�����ݼ���ģʽͨѶ
            DLBT_ENCRYPT_ALL                // Э������ݾ��������� 
        };

        [DllImport("DLBT.dll", EntryPoint="DLBT_SetEncryptSetting",  CharSet=CharSet.Unicode, SetLastError=true, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetEncryptSetting (
            DLBT_ENCRYPT_OPTION     encryptOption,      // ����ѡ������������ͻ��߲�����
            DLBT_ENCRYPT_LEVEL      encryptLevel        // ���ܵĳ̶ȣ������ݻ���Э����ܣ�
            );            

        // ***************************  �����ǵ���������صĽӿ� ********************************

        // �������ص�״̬
        public enum DLBT_DOWNLOAD_STATE
        {	
            BTDS_QUEUED,	                // �����	
            BTDS_CHECKING_FILES,	        // ���ڼ��У���ļ�
            BTDS_DOWNLOADING_TORRENT,	    // ������ģʽ�£����ڻ�ȡ���ӵ���Ϣ	
            BTDS_DOWNLOADING,	            // ����������
            BTDS_PAUSED,                    // ��ͣ
            BTDS_FINISHED,	                // ָ�����ļ��������
            BTDS_SEEDING,	                // �����У������е������ļ�������ɣ� 	
            BTDS_ALLOCATING,                // ����Ԥ������̿ռ� -- Ԥ����ռ䣬���ٴ�����Ƭ���� 
            // ����ѡ���йأ�����ʱ���ѡ��Ԥ������̷�ʽ�����ܽ����״̬
            BTDS_ERROR,                     // ����������д���̳����ԭ����ϸԭ�����ͨ������DLBT_Downloader_GetLastError��֪
        };

        // �ļ��ķ���ģʽ,���ʹ��˵���ĵ�
        public enum DLBT_FILE_ALLOCATE_TYPE
        {
            FILE_ALLOCATE_REVERSED  = 0,   // Ԥ����ģʽ,Ԥ�ȴ����ļ�,����ÿһ���ŵ���ȷ��λ��
            FILE_ALLOCATE_SPARSE,          // Default mode, more effient and less disk space.NTFS����Ч http://msdn.microsoft.com/en-us/library/aa365564(VS.85).aspx
            FILE_ALLOCATE_COMPACT          // �ļ���С�������ز�������,ÿ����һ�����ݰ������������һ��,���������ǵ�����λ��,�����в��ϵ���λ��,����ļ�λ�÷���ȷ��         .
        };


        //=======================================================================================
        //  ����һ���ļ������أ�����������صľ�����Ժ�Ը�������������в�������Ҫ���ݾ��������
        //=======================================================================================
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_Initialize",  CharSet=CharSet.Unicode, SetLastError=true, CallingConvention=CallingConvention.StdCall)]
        public static extern IntPtr DLBT_Downloader_Initialize (
            string              torrentFile,   
            string              outFile,
            string              statusFile,
            DLBT_FILE_ALLOCATE_TYPE     fileAllocateType,
            Boolean             bPaused,
            Boolean             bQuickSeed,
            IntPtr              password,   // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
            string              rootPathName,  // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                                // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
            Boolean             bPrivateProtocol,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
            Boolean             bZipTransfer // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
            );

        /*
         * ʱ���ϵ�������½ӿڲ����ã���ʱû�з������²��ֵ�C������������������ط�ʵ�֣��������ѣ�����ϵ���ߣ�
         * 
         * 
		// ����һ���ڴ��е������ļ����ݣ������������ļ����Ƕ����洢���߰�ĳ�����ܷ�ʽ�������ӵ���������Խ����ܺ�����ݴ���BT�ں�
		DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromBuffer (
				LPBYTE              torrentFile,                    // �ڴ��е������ļ�����
				DWORD               dwTorrentFileSize,              // �������ݵĴ�С
				LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
				LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
				DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
				BOOL                bPaused = FALSE,
				BOOL                bQuickSeed = FALSE,             // �Ƿ���ٹ��֣�����ҵ���ṩ��
				LPCSTR              password = NULL,                // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ����룬���ð治֧�֣��ò����ᱻ����
				LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
																	// �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				BOOL                bPrivateProtocol = FALSE,
				BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
				);

		// ��һ��Torrent�������һ������
		DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromTorrentHandle (
				HANDLE              torrentHandle,                    // Torrent���
				LPCWSTR             outPath,                        // ���غ�ı���·����ֻ��Ŀ¼��
				LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
				DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
				BOOL                bPaused = FALSE,
				BOOL                bQuickSeed = FALSE,              // �Ƿ���ٹ��֣�����ҵ���ṩ��
				LPCWSTR             rootPathName = NULL,             // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
																	// �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				BOOL                bPrivateProtocol = FALSE,
				BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
			);

		//��������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
		DLBT_API HANDLE WINAPI DLBT_Downloader_Initialize_FromInfoHash (
				LPCSTR              trackerURL,                     // tracker�ĵ�ַ
				LPCSTR              infoHash,                       // �ļ���infoHashֵ
				LPCWSTR             outPath,        
				LPCWSTR             name = NULL,                    // �����ص�����֮ǰ����û�а취֪�����ֵģ���˿��Դ���һ����ʱ������
				LPCWSTR             statusFile = L"",              // ״̬�ļ���·��
				DLBT_FILE_ALLOCATE_TYPE  fileAllocateType = FILE_ALLOCATE_SPARSE,         // �ļ�����ģʽ
				BOOL                bPaused = FALSE,
				LPCWSTR             rootPathName = NULL,            // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
																	// �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
				BOOL                bPrivateProtocol = FALSE,
				BOOL				bZipTransfer = FALSE			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
				);

         * */

        // ������ģʽ����һ���ӿڣ�����ֱ��ͨ����ַ���أ���ַ��ʽΪ�� DLBT://xt=urn:btih: Base32 �������info-hash [ &dn= Base32������� ] [ &tr= Base32���tracker�ĵ�ַ ]  ([]Ϊ��ѡ����)��Ҳ֧��magnet���ֱ�׼Э��
        // ��ȫ��ѭuTorrent�Ĺٷ�BT��չЭ��
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_Initialize_FromUrl", CharSet = CharSet.Unicode, SetLastError = true, CallingConvention = CallingConvention.StdCall)]
        private static extern IntPtr DLBT_Downloader_Initialize_FromUrl(
            IntPtr url,                            // ��ַ
            string outFile,                         // ����Ŀ¼
            string statusFile,
            DLBT_FILE_ALLOCATE_TYPE fileAllocateType,
            Boolean bPaused,
            string rootPathName,        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
                                        // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
            Boolean bPrivateProtocol,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
            Boolean bZipTransfer        // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
            );

        public static IntPtr DLBT_Downloader_Initialize_FromUrl(
            string url,                            // ��ַ
            string outFile,                         // ����Ŀ¼
            string statusFile,
            DLBT_FILE_ALLOCATE_TYPE fileAllocateType,
            Boolean bPaused,
            string rootPathName,        // �����ڲ�Ŀ¼�����֣����ΪNULL�����������е����֣������Ϊָ����������֡�
            // �Ե����ļ���ֱ�ӽ��и���Ϊָ�����������
            Boolean bPrivateProtocol,       // �������Ƿ�˽��Э�飨���ԶԲ�ͬ���Ӳ��ò�ͬ�����ط�ʽ��
            Boolean bZipTransfer        // �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
            )
        {
            IntPtr hUrl = IntPtr.Zero;
            if (url != null && url.Length > 0)
                hUrl = Marshal.StringToHGlobalAnsi(url);

            IntPtr result = DLBT_Downloader_Initialize_FromUrl(hUrl, outFile, statusFile, fileAllocateType, bPaused, rootPathName, bPrivateProtocol, bZipTransfer);

            // Always free the unmanaged string.
            if (hUrl != IntPtr.Zero)
                Marshal.FreeHGlobal(hUrl);
            return result;
        }

		// רҵ�ļ����½ӿڣ����������������ļ�Ϊ�����������������ļ�����������ļ��仯�������ݿ顣����ҵ�����ṩ

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_InitializeAsUpdater",  CharSet=CharSet.Unicode, SetLastError=true, CallingConvention=CallingConvention.StdCall)]
		public static extern IntPtr DLBT_Downloader_InitializeAsUpdater ( 
			string             curTorrentFile,    //��ǰ�汾�������ļ� 
			string             newTorrentFile,   //  �°������ļ� 
 			string             curPath,    //  ��ǰ�ļ���·�� 
			string             statusFile, // ״̬�ļ���·��
 			DLBT_FILE_ALLOCATE_TYPE    type, //  �ļ����䷽ʽ������͵�ǰ�汾һ�£��°汾Ҳ��ʹ�ø÷��䷽ʽ�� 
 			Boolean             bPaused ,     // �Ƿ���ͣ��ʽ���� 
  			char[]              curTorrentPassword,   
 			char[]              newTorrentFilePassword, 
 			string              rootPathName,
			Boolean				bPrivateProtocol,
			ref float		    fProgress,         //�����ΪNULL���򴫳���DLBT_Downloader_GetOldTorrentProgressһ����һ������
			Boolean				bZipTransfer			// �Ƿ�ѹ�����䣬һ�������ı��ļ������أ�����Է���֧��������ܵ�dlbt�û�������Ի���ѹ�����䣬��������
		);

        /*
		// רҵ�ļ�����ʱ�������������ӣ�Ȼ��ֱ�Ӵ��������Ӻ������ӵĲ�����������ȣ������������99%������ζ��ֻ��1%��������Ҫ���ء�
		DLBT_API float WINAPI DLBT_Downloader_GetOldTorrentProgress (
			LPCWSTR             curTorrentFile,    //��ǰ�汾�������ļ� 
			LPCWSTR             newTorrentFile,   //  �°������ļ� 
			LPCWSTR             curPath,    //  ��ǰ�ļ���·�� 
			LPCWSTR             statusFile = L"", // ״̬�ļ���·��
			LPCSTR              curTorrentPassword = NULL,   
			LPCSTR              newTorrentFilePassword = NULL
			);
         * 
         * 
        // ��ȡ���������е�Http���ӣ��ڴ�������DLBT_Downloader_FreeConnections�ͷ�
        DLBT_API void WINAPI DLBT_Downloader_GetHttpConnections(HANDLE hDownloader, LPSTR ** urls, int * urlCount);
        // �ͷ�DLBT_Downloader_GetHttpConnections�������ڴ�
        DLBT_API void WINAPI DLBT_Downloader_FreeConnections(LPSTR * urls, int urlCount);
         */


        // �ر�����֮ǰ�����Ե��øú���ͣ��IO�̶߳Ը�����Ĳ������첽�ģ���Ҫ����DLBT_Downloader_IsReleasingFiles��������ȡ�Ƿ����ͷ��У���
        // �ú������ú���ֱ�ӵ���_Release�����ɶԸþ���ٵ�������DLBT_Dwonloader�������������ڲ�������ͣ�����������أ�Ȼ���ͷŵ��ļ����
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_ReleaseAllFiles",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_ReleaseAllFiles(IntPtr hDownloader);
        // �Ƿ����ͷž���Ĺ�����
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_IsReleasingFiles",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Downloader_IsReleasingFiles(IntPtr hDownloader);

		// DLBT_Downloader_Releaseʱ��һЩѡ��
		public enum DLBT_RELEASE_FLAG
		{
			DLBT_RELEASE_NO_WAIT = 0,           // Ĭ�Ϸ�ʽRelease��ֱ���ͷţ����ȴ��ͷ����
			DLBT_RELEASE_WAIT = 1,              // �ȴ������ļ����ͷ����
			DLBT_RELEASE_DELETE_STATUS = 2,     // ɾ��״̬�ļ�
			DLBT_RELEASE_DELETE_ALL = 4         // ɾ�������ļ�
		};

        // �ر�hDownloader����ǵ���������,�����Ҫɾ���ļ�,���Խ���2��������ΪTrue
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_Release",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_Release (IntPtr hDownloader, DLBT_RELEASE_FLAG nReleaseFlag);

        // ����һ��http�ĵ�ַ�����������ļ���ĳ��Web����������http����ʱ����ʹ�ã�web�������ı��뷽ʽ���ΪUTF-8�������������ʽ������ϵ������������޸�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_AddHttpDownload",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_AddHttpDownload (IntPtr hDownloader, string url);

        // �Ƴ�һ��P2SP�ĵ�ַ��������������У�����жϿ����ҴӺ�ѡ���б����Ƴ������ٽ�������
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_RemoveHttpDownload", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_RemoveHttpDownload(IntPtr hDownloader, string url);

		// ����һ��Http��ַ�������Խ������ٸ����ӣ�Ĭ����1������. ������������ܺã������������ã���������10�������Ƕ�һ��Http��ַ�����Խ���10�����ӡ�
		// ����֮ǰ����Ѿ�һ��Http��ַ�������˶�����ӣ����ܸ����ƣ��������ú���Ч
		[DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetMaxSessionPerHttp",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_Downloader_SetMaxSessionPerHttp (IntPtr hDownloader, int limit);

        // �������������Ƿ�˳������,Ĭ���Ƿ�˳������(���������,һ����ѭϡ��������,���ַ�ʽ�ٶȿ�),��˳�����������ڱ��±߲���
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetDownloadSequence",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetDownloadSequence (IntPtr hDownloader, Boolean ifSeq);

        // ���ص�״̬ �Լ� ��ͣ�ͼ����Ľӿ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetState",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern DLBT_DOWNLOAD_STATE DLBT_Downloader_GetState (IntPtr hDownloader);

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_IsPaused",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Downloader_IsPaused (IntPtr hDownloader);    // �Ƿ���ͣ״̬

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_Pause",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_Pause (IntPtr hDownloader);       // ��ͣ

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_Resume",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_Resume (IntPtr hDownloader);      // ����

        //����״̬�µ������ӿ� ��һ��ֻ���ڼ�������������ļ��޷�д��ʱ�Ż��������������ˣ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetLastError",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Downloader_GetLastError (
							IntPtr      hDownloader,
							StringBuilder       pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
							ref int      pBufferSize             // ����buffer���ڴ��С������������Ϣ��ʵ�ʴ�С
							);  

		public static string DLBT_Downloader_GetLastError(IntPtr hDownloader)
		{
			string name = "";
			System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
			int len = 1024;
            
			if (DLBT_Downloader_GetLastError (hDownloader, str, ref len) == 0)
				name = str.ToString ();
			else if (len > 1024)
			{
				str = new System.Text.StringBuilder(len);
				if (DLBT_Downloader_GetLastError (hDownloader, str, ref len) == 0)
					name = str.ToString ();
			}

			return name;
		}

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_ResumeInError",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_ResumeInError (IntPtr hDownloader); //���������󣬳������¿�ʼ����

        // ���������ص���ؽӿڣ�������ģʽ�����ð�����Ч�����Ե�����Щ�ӿڣ���������Ч����
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_IsHaveTorrentInfo",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Downloader_IsHaveTorrentInfo (IntPtr hDownloader); // ����������ʱ�������ж��Ƿ�ɹ���ȡ����������Ϣ

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_MakeURL",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Downloader_MakeURL (  // ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
                             IntPtr      hDownloader,
                             StringBuilder       pBuffer,                // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
                             ref int      pBufferSize             // ����buffer���ڴ��С������URL��ʵ�ʴ�С
                             );  

        // дһ��C#�бȽ�����ʹ�õ�MakeURL�Ľӿ�
        public static string DLBT_Downloader_MakeURL (IntPtr hDownloader)
        {
            string url = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            
            if (DLBT_Downloader_MakeURL (hDownloader, str, ref len) == 0)
                url = str.ToString ();

            return url;
        }

        // ���ص����ٺ��������ӵĽӿ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetDownloadLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetDownloadLimit (IntPtr hDownloader, int limit);    
  
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetUploadLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetUploadLimit (IntPtr hDownloader, int limit);    

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetMaxUploadConnections",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetMaxUploadConnections (IntPtr hDownloader, int limit);    

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetMaxTotalConnections",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetMaxTotalConnections (IntPtr hDownloader, int limit);   
 
        // ȷ������ֻ�ϴ���������
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetOnlyUpload",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetOnlyUpload (IntPtr hDownloader, bool bUpload);

        // ���öԷ�����IP�����������٣���λ��BYTE(�ֽڣ��������Ҫ����1M��������1024*1024
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_SetServerDownloadLimit", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetServerDownloadLimit(IntPtr hDownloader, int limit);
        // ���ñ�������ȥ�����еķ�����IP�������ӣ����ڶԷ������������ӣ���ҪBTЭ������ͨ����֪���Ƕ�Ӧ�������������hDownloader�ĺ���ٶϿ�����
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_BanServerDownload", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_BanServerDownload(IntPtr hDownloader, bool bBan);

        
        // ���ط����� (�ϴ�/���صı������Ľӿ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetShareRateLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetShareRateLimit (IntPtr hDownloader, float fRate);    

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetShareRate",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern double DLBT_Downloader_GetShareRate (IntPtr hDownloader);    


        // �������ص��ļ������ԣ��ļ���С������������ȵȣ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetTorrentName",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Downloader_GetTorrentName (
            IntPtr hDownloader,
            StringBuilder       pBuffer,                // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
            ref int      pBufferSize             // ����buffer���ڴ��С���������ֵ�ʵ�ʴ�С
            );   

        // дһ��C#�����õ�DLBT_Downloader_GetTorrentName�Ľӿ�
        public static string DLBT_Downloader_GetTorrentName (IntPtr hDownloader)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            
            if (DLBT_Downloader_GetTorrentName (hDownloader, str, ref len) == 0)
                name = str.ToString ();

            return name;
        }
        
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetTotalFileSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetTotalFileSize (IntPtr hDownloader);    
  
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetTotalWanted",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetTotalWanted (IntPtr hDownloader);  // ����ѡ���˶������������������������ص��ļ�
   
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetTotalWantedDone",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetTotalWantedDone (IntPtr hDownloader);  // ��ѡ�����ļ��У������˶���
   
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetProgress",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern float DLBT_Downloader_GetProgress (IntPtr hDownloader);  

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetDownloadedBytes",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetDownloadedBytes (IntPtr hDownloader);  

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetUploadedBytes",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetUploadedBytes (IntPtr hDownloader); 

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetDownloadSpeed",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt32 DLBT_Downloader_GetDownloadSpeed (IntPtr hDownloader); 

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetUploadSpeed",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt32 DLBT_Downloader_GetUploadSpeed (IntPtr hDownloader); 

        // ��ø�����Ľڵ����Ŀ����Ŀ�Ĳ���Ϊint��ָ�룬�������Ҫĳ��ֵ����NULL
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetPeerNums",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_GetPeerNums (
            IntPtr hDownloader,         // ��������ľ��
            out int connectedCount,     // �����������ϵĽڵ������û�����
            out int totalSeedCount,     // �ܵ�������Ŀ�����Tracker��֧��scrap���򷵻�-1
            out int seedsConnected,     // �Լ����ϵ�������
            out int inCompleteCount,    // δ��������������Tracker��֧��scrap���򷵻�-1
            out int totalCurrentSeedCount, // ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
            out int totalCurrentPeerCount  // ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
            );

        // ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetFileCount",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_GetFileCount (IntPtr hDownloader); 

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetFileSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetFileSize (IntPtr hDownloader, int index);

        // ��ȡ�ļ���torrent�е���ʼλ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetFileOffset",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Downloader_GetFileOffset (IntPtr hDownloader, int index);

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_IsPadFile",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Downloader_IsPadFile (IntPtr hDownloader, int index);

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetFilePathName",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_GetFilePathName (
            IntPtr hDownloader,     // ��������ľ��
            int index,              // �ļ������
            StringBuilder pBuffer,     // �����ļ���ָ��
            ref int pBufferSize,    // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ���
            bool needFullPath       // �Ƿ���Ҫȫ����·������ֻ��Ҫ�ļ��������е����·��  
            );

        // дһ��C#�бȽ�����ʹ�õ�DLBT_Downloader_GetFilePathName�Ľӿ�
        public static int DLBT_Downloader_GetFilePathName (
            IntPtr hDownloader,     // ��������ľ��
            int index,              // �ļ������
            ref string fileName,         // �����ļ���
            bool needFullPath       // �Ƿ���Ҫȫ����·������ֻ��Ҫ�ļ��������е����·��  
            )
        {
            fileName = "";
            System.Text.StringBuilder fName = new System.Text.StringBuilder (1024);
            int len = 1024;
            
            int ret = DLBT_Downloader_GetFilePathName (hDownloader, index, fName, ref len, needFullPath);
            if (ret == 0)
            {
                fileName = fName.ToString ();
            }
            return ret;
        }


        // ȡ�ļ������ؽ��ȣ��ò�����Ҫ���н϶������������ڱ�Ҫʱʹ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetFileProgress",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Single DLBT_Downloader_GetFileProgress (IntPtr hDownloader, int index);

        public enum DLBT_FILE_PRIORITIZE
        {
            DLBT_FILE_PRIORITY_CANCEL        =   0,     // ȡ�����ļ�������
            DLBT_FILE_PRIORITY_NORMAL,                  // �������ȼ�
            DLBT_FILE_PRIORITY_ABOVE_NORMAL,            // �����ȼ� 
            DLBT_FILE_PRIORITY_MAX                      // ������ȼ�������и����ȼ����ļ���δ���꣬�������ص����ȼ����ļ���
        };

        // �����ļ����������ȼ��������������ȡ��ĳ��ָ���ļ�������,index��ʾ�ļ������
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_SetFilePrioritize", SetLastError = true, CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_SetFilePrioritize (
            IntPtr                  hDownloader, 
            int                     index,              // �ļ����
            DLBT_FILE_PRIORITIZE    prioritize,         // ���ȼ�
            Boolean                 bDoPriority         // �Ƿ�����Ӧ��������ã�����ж���ļ���Ҫ���ã�������ʱ������Ӧ�ã������һ���ļ�Ӧ������
                                                        // ���߿�����������DLBT_Downloader_ApplyPrioritize������Ӧ�ã���ΪÿӦ��һ�����ö�Ҫ������Piece
                                                        // ����һ�飬�Ƚ��鷳������Ӧ��һ��Ӧ��
            );

        // ����Ӧ�����ȼ�������
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_ApplyPrioritize", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_ApplyPrioritize (IntPtr hDownloader);

		/*
            // ��ȡ��ǰÿ���ֿ��״̬��������������ж��Ƿ���Ҫȥ���£��Ƿ��Ѿ�ӵ���˸ÿ飩��
            DLBT_API HRESULT WINAPI DLBT_Downloader_GetPiecesStatus (
                HANDLE                  hDownloader,    // ������
                bool                *   pieceArray,     // ���ÿ�����Ƿ񱾵��������µ�����
                int                     arrayLength,    // ����ĳ���
                int                 *   pieceDownloaded // �Ѿ����صķֿ����Ŀ������ʾ���صķֿ��ͼ��ʱ���ò����Ƚ����á�������ָ����ֺ��ϴλ�ȡʱû��
                                                        // �仯������Բ���Ҫ�ػ���ǰ�ķֿ�״̬ͼ
                );

            // ���ÿ���������ȼ����������ڷֿ�ľֲ����£����ļ��ľֲ����µȣ���index��ʾ������
            DLBT_API HRESULT WINAPI DLBT_Downloader_SetPiecePrioritize (
                HANDLE                  hDownloader, 
                int                     index,              // �����
                DLBT_FILE_PRIORITIZE    prioritize,         // ���ȼ�
                BOOL                    bDoPriority = TRUE  // �Ƿ�����Ӧ��������ã�����ж������Ҫ���ã�������ʱ������Ӧ�ã������һ����Ӧ������
                                                            // ���߿�����������DLBT_Downloader_ApplyPrioritize������Ӧ�ã���ΪÿӦ��һ�����ö�Ҫ������Piece
                                                            // ����һ�飬�Ƚ��鷳������Ӧ��һ��Ӧ��
                );

        */
        // �����ֹ�ָ����Peer��Ϣ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_AddPeerSource",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_AddPeerSource (IntPtr hDownloader, string ip, Int16 port);

        // �ú����Ὣ����Ŀ¼�´��ڣ���torrent��¼�в����ڵ��ļ�ȫ��ɾ�����Ե����ļ���������Ч��������ʹ�á�
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_DeleteUnRelatedFiles", SetLastError = true, CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
        public static extern long DLBT_Downloader_DeleteUnRelatedFiles(IntPtr hDownloader);
            
        /*
        // ��ȡÿ���ļ���Hashֵ��ֻ����������ʱʹ��bUpdateExt���ܻ�ȡ��
        DLBT_API HRESULT WINAPI DLBT_Downloader_GetFileHash (
	        HANDLE      hDownloader,        // ��������ľ��
	        int         index,              // Ҫ��ȡ���ļ�����ţ�piece����Ŀ����ͨ��DLBT_Downloader_GetFileCount���
	        LPSTR       pBuffer,            // ����Hash�ַ���
	        int     *   pBufferSize         // ����pBuffer�Ĵ�С��pieceInfoHash�̶�Ϊ20���ֽڣ���˴˴�Ӧ����20�ĳ��ȡ�
	        );
            
        //////////////////////   Move����ؽӿ�   /////////////
        // Move�Ľ��
        enum DOWNLOADER_MOVE_RESULT
        {
	        DLBT_MOVED	= 0,	//�ƶ��ɹ�
	        DLBT_MOVE_FAILED,	//�ƶ�ʧ��
	        DLBT_MOVING         //�����ƶ�
        };

        //�ƶ����ĸ�Ŀ¼�������ͬһ���̷������Ǽ��У�����ǲ�ͬ�������Ǹ��ƺ�ɾ��ԭʼ�ļ������ڲ������첽������������������
        //���ʹ��DLBT_Downloader_GetMoveResultȥ��ȡ
        DLBT_API void WINAPI DLBT_Downloader_Move (HANDLE hDownloader, LPCWSTR savePath);
        //�鿴�ƶ������Ľ��
        DLBT_API DOWNLOADER_MOVE_RESULT WINAPI DLBT_Downloader_GetMoveResult (
	        HANDLE			hDownloader,   // ��������ľ��
	        LPSTR			errorMsg,      // ���ڷ��س�����Ϣ���ڴ棬��DLBT_MOVE_FAILED״̬�����ﷵ�س�������顣�������NULL���򲻷��ش�����Ϣ
	        int				msgSize		   // ������Ϣ�ڴ�Ĵ�С
	        ); 

         * */

        // ��ÿ���ʾ���ļ�Hashֵ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetInfoHash",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Downloader_GetInfoHash (
                IntPtr  hDownloader,        // ��������ľ��
                StringBuilder  pBuffer,         // ����InfoHash���ڴ滺��
                ref int pBufferSize         // ���뻺��Ĵ�С������ʵ�ʵ�InfoHash�ĳ���
            );

        public static string DLBT_Downloader_GetInfoHash (IntPtr hDownloader)
        {
            string str = "";

            StringBuilder sb = new StringBuilder (128);
            int size = 128;

//            IntPtr pBuffer = Marshal.AllocCoTaskMem (128);
//            int size = 128;
//
            int ret = DLBT_Downloader_GetInfoHash (hDownloader, sb, ref size);
            if (ret == 0)
                str = sb.ToString ();
//                str = Marshal.PtrToStringAnsi (pBuffer);
//
//            Marshal.FreeCoTaskMem (pBuffer);

            return str;
        }


        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetPieceCount",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_GetPieceCount (IntPtr hDownloader);

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_GetPieceSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Downloader_GetPieceSize (IntPtr hDownloader);

		
		//����״̬�ļ����
		// �ڲ�Ĭ��ÿ15���ӱ���һ��״̬�ļ������Ե���Ϊ�Լ���Ҫ��ʱ�䣬��λ����
		[DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetStatusFileSavePeriod",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern Boolean DLBT_Downloader_SetStatusFileSavePeriod (IntPtr hDownloader, int dwPeriod);
		// ��������һ��״̬�ļ���֪ͨ�ڲ��������̺߳��������أ����첽���������ܻ���һ���ӳٲŻ�д
		[DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SaveStatusFile",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_Downloader_SaveStatusFile (IntPtr hDownloader);

        //bOnlyPieceStatus�� �Ƿ�ֻ����һЩ�ļ��ֿ���Ϣ�����ڷ����������ɺ󷢸�ÿ���ͻ������ͻ����Ͳ����ٱȽ��ˣ�ֱ�ӿ�������. Ĭ����FALSE��Ҳ����ȫ����Ϣ������
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_SetStatusFileMode",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_SetStatusFileMode (IntPtr hDownloader, Boolean bOnlyPieceStatus);

        // �鿴����״̬�ļ��Ƿ����
        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_IsSavingStatus",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Downloader_IsSavingStatus (IntPtr hDownloader);


        // ����Ϊtorrent�ļ�,filePathΪ·���������ļ����������password��Ϊ�գ��������Ҫ�����ӽ��м���
        [DllImport("DLBT.dll", EntryPoint = "DLBT_Downloader_SaveTorrentFile", SetLastError = true, CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall)]
        private static extern int DLBT_Downloader_SaveTorrentFile(IntPtr hDownloader, string filePath, IntPtr password);

        public static int DLBT_Downloader_SaveTorrentFile(IntPtr hTorrent, string filePath, string password)
        {
            IntPtr hPassword = IntPtr.Zero;
            if (password != null && password.Length > 0)
                hPassword = Marshal.StringToHGlobalAnsi(password);

            int result = DLBT_Downloader_SaveTorrentFile(hTorrent, filePath, hPassword);

            // Always free the unmanaged string.
            if (hPassword != IntPtr.Zero)
                Marshal.FreeHGlobal(hPassword);
            return result;
        }

        /*
         * // ��BTϵͳ��д��ͨ��������ʽ�����������ݿ顣offsetΪ�����ݿ��������ļ����ļ��У��е�ƫ������sizeΪ���ݿ��С��dataΪ���ݻ�����
            // �ɹ�����S_OK��ʧ��Ϊ������ʧ��ԭ������Ǹÿ鲻��Ҫ�ٴδ����ˡ� ��������VOD��ǿ������Ч
            DLBT_API HRESULT WINAPI DLBT_Downloader_AddPartPieceData(HANDLE hDownloader, UINT64 offset, UINT64 size, char *data);

            // �ֹ����һ�����������ݽ��� ��������VOD��ǿ������Ч
            DLBT_API HRESULT WINAPI DLBT_Downloader_AddPieceData(
                HANDLE                  hDownloader,
                int                     piece,          //�ֿ����
                char            *       data,           //���ݱ���
                bool                    bOverWrite      //����Ѿ����ˣ��Ƿ񸲸�
                );


            // ÿ��Ҫ�滻һ�����ݿ�ʱ����һ������ص����ⲿ���Ը�������ص���ʾ�滻�Ľ��ȣ��Լ��Ƿ���ֹ�����滻�����������൱�ڣ�DLBT_Downloader_CancelReplace)
            // ����FALSE����ϣ��������ֹ��TRUE���������
            // һ���ֿ���ܻ�������С�ļ������ߴ��ļ���β�������ļ�ճ���ĵط��������һ���ֿ�pieceIndex���ܻ��Ӧ�˶���ļ�Ƭ�Ρ����ص����滻һ���ļ�Ƭ��ʱ����һ��
            typedef BOOL (WINAPI * DLBT_REPLACE_PROGRESS_CALLBACK) (
                  IN void * pContext,                   // �ص��������ģ�ͨ��DLBT_Downloader_ReplacePieceData��pContext�������룩�����ﴫ��ȥ���������洦��
                                                        // ���磬�ⲿ����һ��thisָ�룬�ص���ʱ����ͨ�����ָ��֪���Ƕ�Ӧ�ĸ�����
                  IN int pieceIndex,                    //����Ҫ�滻������λ���ĸ��ֿ飨�ֿ���torrent�е�������
                  IN int replacedPieceCount,            //�Ѿ�����˶��ٸ�piece���滻
                  IN int totalNeedReplacePieceCount,    //�ܹ��ж��ٸ�Ҫ�滻��piece�ֿ�
                  IN int fileIndex,                     //����Ҫ�滻������λ���ĸ��ļ�
                  IN UINT64 offset,                     //������ļ��У�������ݵ�ƫ����
                  IN UINT64 size,                       //������ݵ��ܴ�С������ƫ������
                  IN int replacedFileSliceCount,        //�Ѿ�����˶��ٸ��ļ�Ƭ�ε��滻                                  
                  IN int totalFileSliceCount            //�ܹ��ж��ٸ���Ҫ�滻���ļ�Ƭ��
                  );

            // �滻���ݿ�Ľӿڣ���ĳ������ֱ���滻��Ŀ���ļ�����ͬλ�ã�һ�����ڣ�����ʱ����Ҫ���صķֿ��Զ����ص�һ����ʱĿ¼����ɺ����滻��ԭʼ�ļ�
            // �������ع�����ԭʼ�ļ���������ʹ�ã���������ֻ���ز������ݵ��ŵ㡣
            // �ú������������أ����HRESULT���صĲ���S_OK��˵��������Ҫ�鿴����ֵ��
            // �������S_OK�����ڲ��������߳��������滻���м�Ľ����ʱͨ��DLBT_Downloader_GetReplaceResult�����в鿴�������ʱ���Ե��ã�DLBT_Downloader_CancelReplace����ȡ���̲߳���
            DLBT_API HRESULT WINAPI DLBT_Downloader_ReplacePieceData(
	            HANDLE			hDownloader,		//����������
	            int   *			pieceArray,			// ��Ҫ����Щ�ֿ��滻����һ��int����
	            int				arrayLength,		// �ֿ�����ĳ���
	            LPCWSTR			destFilePath,		// ��Ҫ�滻���ļ����ļ��У���Ŀ¼�����磺E:\Test\1.rar����E:\Test\Game\�����˲� �ȡ�
	            LPCWSTR			tempRootPathName = NULL,	// ��ʱĿ¼����ʱ�����ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У��¶�ȡ���ݿ�
	            LPCWSTR			destRootPathName = NULL,	// ��Ҫ�滻���Ǹ������������ʹ����rootPathName��������ҲҪ�����ϣ��Ա������ļ����ļ��У������滻
                LPVOID          pContext = NULL,
                DLBT_REPLACE_PROGRESS_CALLBACK  callback = NULL  //���ս��ȣ���������ʱȡ���Ļص�
	            );

            // ReplacePieceData��һЩ״̬������ͨ��DLBT_Downloader_GetReplaceResult�����в鿴
            enum DLBT_REPLACE_RESULT
            {
                DLBT_RPL_IDLE  = 0,     //��δ��ʼ�滻
                DLBT_RPL_RUNNING,       //����������
                DLBT_RPL_SUCCESS,       //�滻�ɹ�
                DLBT_RPL_USER_CANCELED, //�滻��һ�룬�û�ȡ������
                DLBT_RPL_ERROR,         //��������ͨ��hrDetail����ȡ��ϸ��Ϣ���ο���DLBT_Downloader_GetReplaceResult
            };

            // ��ȡ�滻���ݵĽ��
            DLBT_API DLBT_REPLACE_RESULT WINAPI DLBT_Downloader_GetReplaceResult(
                HANDLE          hDownloader,        //����������
                HRESULT  *      hrDetail,           //������г���������ϸ�ĳ���ԭ��
                BOOL     *      bThreadRunning      //Replace�����������Ƿ�����ˣ�����Ҳ�����������ģ�
                );

            // �м���ʱȡ���滻���ݵĲ�����������ȡ������Ϊ�п��ܻ��滻��һ�룬������Щ�ļ��ǲ������ģ�
            DLBT_API void WINAPI DLBT_Downloader_CancelReplace(HANDLE hDownloader);
         * */
        

        // ***************************  ������������صĽӿ� ********************************
        public enum DLBT_TORRENT_TYPE
        {
            USE_PUBLIC_DHT_NODE     = 0,    // ʹ�ù�����DHT������Դ
            NO_USE_PUBLIC_DHT_NODE,         // ��ʹ�ù�����DHT����ڵ�
            ONLY_USE_TRACKER,               // ��ʹ��Tracker����ֹDHT������û���Դ������˽�����ӣ�
        };

        [DllImport("DLBT.dll", EntryPoint="DLBT_CreateTorrent",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern IntPtr DLBT_CreateTorrent (
            int             pieceSize,      // �ļ��ķֿ��С
            string          file,           // �ļ�������Ŀ¼��Ŀ¼��Ŀ¼�������ļ�����һ�����ӣ�
            string          publisher,      // ��������Ϣ
            string          publisherUrl,   // �����ߵ���ַ
            string          comment,        // ���ۺ�����    
            DLBT_TORRENT_TYPE torrentType,  // ������ӵ�����
            ref int         nPercent,       // �������ӵĽ���
            IntPtr		    bCancel,        // �����м�ȡ�����ӵ�����
            int			    minPadFileSize,  // �ļ�����minPadFileSize��ͽ��в����Ż�����ͳBT����ʱ��һ���ֿ���ܺ�������ļ���ʹ����������
            // ÿ���ļ��ᵥ���ֿ飬���������ļ�����������һ���ļ������仯�󲻻�Ӱ�쵽�����ļ���һ�������ļ��ĸ��¡�-1�������롣0����������С���ļ�������
            // ���רҵ����ģʽ��bUpdateExtΪTRUE������ǿ�ƶ��룬���minPadFileSize����С��pieceSize������-1������ôǿ�ƶ�����Զ�ʹ��pieceSize��Ϊ��С�����׼
            // Ҳ����˵����һ���ֿ���ļ������Զ����룻С��һ���ֿ���ļ��ᱻ���ڶ���
            Boolean          bUpdateExt  //�Ƿ��������ڸ��µĵ�����չ��Ϣ����������DLBT_Downloader_InitializeAsUpdater�ӿڡ�����ҵ����Ч��bUpdateExt����һЩ���⹤�������ֻ����ͨ����
            //�������ļ��ıȽϸ��£����Բ�ʹ�øò������ò���ʹ��ʱ��pieceSize������Ϊ0����������torrent�ķֿ��С�п��ܲ�ͬ�����¸����������ӡ�
            );

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_AddTracker",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Torrent_AddTracker (
            IntPtr      hTorrent,       // ���ӵľ��
            string      trackerURL,     // tracker�ĵ�ַ��������http Tracker��udp Tracker
            int         tier            // ���ȼ���˳��
            );

        [DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_RemoveAllTracker",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Downloader_RemoveAllTracker (IntPtr hDownloader);

		[DllImport("DLBT.dll", EntryPoint="DLBT_Downloader_AddHttpTrackerExtraParams",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_Downloader_AddHttpTrackerExtraParams (IntPtr hDownloader, string extraParams);

        // �Ƴ������е�����Tracker
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_RemoveAllTracker",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Torrent_RemoveAllTracker (IntPtr hTorrent);
        
        // ָ�����ӿ���ʹ�õ�httpԴ��������صĿͻ���֧��http��Э�����أ�����Զ��Ӹõ�ַ��������
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_AddHttpUrl",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Torrent_AddHttpUrl (IntPtr hTorrent, string httpUrl);

        // ����Ϊtorrent�ļ�,filePathΪ·���������ļ����������password��Ϊ�գ��������Ҫ�����ӽ��м���
        [DllImport("DLBT.dll", EntryPoint="DLBT_SaveTorrentFile",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_SaveTorrentFile(IntPtr hTorrent, string filePath, IntPtr password, Boolean bUseHashName, String extName);

        public static int DLBT_SaveTorrentFile(IntPtr hTorrent, string filePath, string password, Boolean bUseHashName, String extName)
        {
            IntPtr hPassword = IntPtr.Zero;
            if (password != null && password.Length > 0)
                hPassword = Marshal.StringToHGlobalAnsi(password);

            int result = DLBT_SaveTorrentFile(hTorrent, filePath, hPassword, bUseHashName, extName);

            // Always free the unmanaged string.
            if (hPassword != IntPtr.Zero)
                Marshal.FreeHGlobal(hPassword);
            return result;
        }

        // �ͷ�torrent�ļ��ľ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_ReleaseTorrent",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_ReleaseTorrent (IntPtr hTorrent);

        /*
         * 
         * ***************************  ������������صĽӿ� ********************************
         * 
         * */

        // ��һ�����Ӿ���������޸Ļ��߶�ȡ��Ϣ���в������������Ҫ����DLBT_ReleaseTorrent�ͷ�torrent�ļ��ľ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_OpenTorrent",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern IntPtr DLBT_OpenTorrent (
            string          torrentFile,    // �����ļ�ȫ·��
            IntPtr          password       // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ�����,�Դ�������н��� 
            );

        public static IntPtr DLBT_OpenTorrent (
            string          torrentFile,    // �����ļ�ȫ·��
            string          password       // �Ƿ�������ӣ����Ϊ�գ�������ͨ���ӣ����������ӵ�����,�Դ�������н��� 
            )
        {
            IntPtr hPassword = IntPtr.Zero;
            if (password != null && password.Length > 0)
                hPassword = Marshal.StringToHGlobalAnsi(password);

            IntPtr hTorrent = DLBT_OpenTorrent(torrentFile, hPassword);

            // Always free the unmanaged string.
            if (hPassword != IntPtr.Zero)
                Marshal.FreeHGlobal(hPassword);
            return hTorrent;
        }

        [DllImport("DLBT.dll", EntryPoint="DLBT_OpenTorrentFromBuffer",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern IntPtr  DLBT_OpenTorrentFromBuffer (
            byte[]      torrentFile,                    // ���Դ��ڴ��е��ַ�������
            int         dwTorrentFileSize,              // �������ݵĴ�С
            IntPtr      password                       // �Ƿ�������ӣ����ΪNull��������ͨ���ӣ����������ӵ�����,�Դ�������н���
            );

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetComment",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetComment (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������۵�ʵ�ʴ�С
            ref int         pBufferSize     // �������۵��ڴ��С���������۵�ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetComment�Ľӿ�
        public static string DLBT_Torrent_GetComment (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Downloader_GetTorrentName(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }
        

        // ���ش����������Ϣ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetCreator",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetCreator (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
            ref int         pBufferSize     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetCreator�Ľӿ�
        public static string DLBT_Torrent_GetCreator (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Torrent_GetCreator(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }


        // ���ط�������Ϣ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetPublisher",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetPublisher (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���������Ϣ��ʵ�ʴ�С
            ref int         pBufferSize     // ��������Ϣ���ڴ��С������������Ϣ��ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetPublisher�Ľӿ�
        public static string DLBT_Torrent_GetPublisher (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Torrent_GetPublisher(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }

        // ���ط�������ַ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetPublisherUrl",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetPublisherUrl (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���ʵ�ʴ�С
            ref int         pBufferSize     // ��������Ϣ���ڴ��С������ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetPublisherUrl�Ľӿ�
        public static string DLBT_Torrent_GetPublisherUrl (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Torrent_GetPublisherUrl(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }
        
        // ͨ�����ӣ�����һ�����Բ���Ҫ���Ӽ������ص���ַ���ο�DLBT_Downloader_Initialize_FromUrl
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_MakeURL",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_MakeURL (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з������ֵ�ʵ�ʴ�С
            ref int         pBufferSize     // ����buffer���ڴ��С������URL��ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_MakeURL�Ľӿ�
        public static string DLBT_Torrent_MakeURL (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Torrent_MakeURL(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetTrackerCount",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Torrent_GetTrackerCount (IntPtr hTorrent);

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetTrackerUrl",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern string DLBT_Torrent_GetTrackerUrl (
            IntPtr      hTorrent,       // �����ļ����
            int         index           // Tracker����ţ���0��ʼ
            );

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetTotalFileSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Torrent_GetTotalFileSize (IntPtr hTorrent);

        // ���������а�������ļ�ʱ��һЩ�ӿ�,indexΪ�ļ������кţ���0��ʼ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetFileCount",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Torrent_GetFileCount (IntPtr hTorrent);
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_IsPadFile",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_Torrent_IsPadFile (IntPtr hTorrent, int index);
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetFileSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt64 DLBT_Torrent_GetFileSize (
            IntPtr      hTorrent,           // �����ļ����
            int         index               // Ҫ��ȡ��С���ļ�����ţ��ļ�����Ǵ�0��ʼ��
            );


        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetFilePathName",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetFilePathName (
            IntPtr          hTorrent,       // �����ļ����
            int             index,          // Ҫ��ȡ���ֵ��ļ�����ţ��ļ�����Ǵ�0��ʼ��
            StringBuilder   pBuffer,        // ���ڴ����ļ���������Ϊ�գ�Ϊ������pBufferSize�з���ʵ�ʴ�С
            ref int         pBufferSize     // ����buffer�Ĵ�С�������ļ�����ʵ�ʳ��� 
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetFilePathName�Ľӿ�
        public static string DLBT_Torrent_GetFilePathName (IntPtr hTorrent, int index)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (1024);
            int len = 1024;
            if (DLBT_Torrent_GetFilePathName(hTorrent, index, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }

        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetPieceCount",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Torrent_GetPieceCount (IntPtr hTorrent);
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetPieceSize",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern int DLBT_Torrent_GetPieceSize (IntPtr hTorrent);

        // ��ȡ������ÿ���ֿ��Hashֵ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetPieceInfoHash",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetPieceInfoHash (
            IntPtr          hTorrent,       // �����ļ����
            int             index,          // Ҫ��ȡ��Piece����ţ�piece����Ŀ����ͨ��DLBT_Torrent_GetPieceCount���
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���InfoHash��ʵ�ʴ�С
            ref int         pBufferSize     // ����buffer���ڴ��С������InfoHash��ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetPieceInfoHash�Ľӿ�
        public static string DLBT_Torrent_GetPieceInfoHash (IntPtr hTorrent, int index)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (128);
            int len = 128;
            if (DLBT_Torrent_GetPieceInfoHash(hTorrent, index, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }

        // ��������ļ���InfoHashֵ
        [DllImport("DLBT.dll", EntryPoint="DLBT_Torrent_GetInfoHash",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_Torrent_GetInfoHash (
            IntPtr          hTorrent,       // �����ļ����
            StringBuilder   pBuffer,        // ���ڷ�����Ϣ���ڴ棬����Ϊ�գ�Ϊ������pBufferSize�з���InfoHash��ʵ�ʴ�С
            ref int         pBufferSize     // ����buffer���ڴ��С������InfoHash��ʵ�ʴ�С
            );
  
        // дһ��C#�����õ�DLBT_Torrent_GetInfoHash�Ľӿ�
        public static string DLBT_Torrent_GetInfoHash (IntPtr hTorrent)
        {
            string name = "";
            System.Text.StringBuilder str = new System.Text.StringBuilder (128);
            int len = 128;
            if (DLBT_Torrent_GetInfoHash(hTorrent, str, ref len) == 0)
                name = str.ToString ();
            return name;
        }



        /****
        // **************************** �����������г��йصĽӿ� *****************************
        // �����г�������ҵ�汾���ṩ��������ð�����ʱ���ṩ�ù���
        struct DLBT_TM_ITEM     //��������г��е�һ�������ļ�
        {
	        DLBT_TM_ITEM(): fileSize (0) {}
        	
	        UINT64  fileSize;      // the size of this file
	        char	name[256];     // ����
	        LPCSTR	url;           // �������ص�url
	        LPCSTR  comment;       // ��������
        };

        struct DLBT_TM_LIST //��������г��е�һ�������ļ��������
        {
	        int				count;      //��Ŀ
	        DLBT_TM_ITEM	items[1];   //�����б�
        };

        // �ڱ����������г������һ�������ļ�
        DLBT_API HRESULT WINAPI DLBT_TM_AddSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);
        // �ڱ����������г����Ƴ�һ�������ļ�
        DLBT_API HRESULT WINAPI DLBT_TM_RemoveSelfTorrent (LPCWSTR torrentFile, LPCSTR password = NULL);

        // ��ȡ���������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
        DLBT_API HRESULT WINAPI DLBT_TM_GetSelfTorrentList (DLBT_TM_LIST ** ppList);
        // ��ȡ�����������г��е������б���ȡ�����б���Ҫ����DLBT_TM_FreeTMList���������ͷŵ�
        DLBT_API HRESULT WINAPI DLBT_TM_GetRemoteTorrentList (DLBT_TM_LIST ** ppList);

        // �ͷ�DLBT_TM_GetSelfTorrentList����DLBT_TM_GetRemoteTorrentList��ȡ���������б���ڴ�
        DLBT_API HRESULT WINAPI DLBT_TM_FreeTMList (DLBT_TM_LIST * pList);

        // ������л�ȡ���������˵������б�
        DLBT_API void WINAPI DLBT_TM_ClearRemoteTorrentList ();
        // ��������Լ������г��е������б�
        DLBT_API void WINAPI DLBT_TM_ClearSelfTorrentList ();

        // ����һ���Ƿ����������г���Ĭ�ϲ����á�
        DLBT_API BOOL WINAPI DLBT_EnableTorrentMarket (bool bEnable);
         */


        // *********************  �����Ƿ���ǽ��UPnP��͸��P2P�����Խӿ� **********************

        // �˿ڵ�����
        public enum PORT_TYPE
        {
            TCP_PORT        = 1,            // TCP �˿�
            UDP_PORT                        // UDP �˿�
        };

        //  ��ĳ��Ӧ�ó�����ӵ�ICF����ǽ��������ȥ���ɶ������ں�Ӧ�ã��������ں���Ȼ����ʹ�øú���
        [DllImport("DLBT.dll", EntryPoint="DLBT_AddAppToWindowsXPFirewall",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_AddAppToWindowsXPFirewall (
                string      appFilePath,        // �����·��������exe�����֣�
                string      ruleName            // �ڷ���ǽ����������ʾ���������������
                );
        
        // ��ĳ���˿ڼ���UPnPӳ�䣬����BT�ڲ������ж˿��Ѿ��Զ����룬����Ҫ�ٴμ��룬�����ṩ�����ǹ��ⲿ��������Լ�����˿�
		[DllImport("DLBT.dll", EntryPoint="DLBT_AddUPnPPortMapping",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
		public static extern void DLBT_AddUPnPPortMapping(
		                            UInt16      nExternPort,        // NATҪ�򿪵��ⲿ�˿�
		                            UInt16      nLocalPort,         // ӳ����ڲ��˿ڣ��������˿ڣ���һ���ǳ����ڼ����Ķ˿�
		                            PORT_TYPE   nPortType,          // �˿����ͣ�UDP����TCP��
		                            string      appName             // ��NAT����ʾ���������������
		                            );

        // ��õ���ϵͳ�Ĳ������������ƣ��������0���ʾϵͳ���ܲ������޵�XPϵͳ�������޸�����������
        // �ɶ������ں�ʹ�ã������ں�ǰ����ʹ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_GetCurrentXPLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern UInt32 DLBT_GetCurrentXPLimit ();
        
        // �޸�XP�Ĳ������������ƣ�����BOOL��־�Ƿ�ɹ�
        [DllImport("DLBT.dll", EntryPoint="DLBT_ChangeXPConnectionLimit",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        public static extern Boolean DLBT_ChangeXPConnectionLimit (UInt32 num);


        [StructLayout(LayoutKind.Sequential)]
        public struct KERNEL_INFO
        {
            public UInt16    port;                          // �����˿�
            public Boolean   dhtStarted;                    // DHT�Ƿ�����
            public Int32     totalDownloadConnectionCount;  // �ܵ�����������
            public Int32     downloadCount;                 // ��������ĸ���
            public Int32     totalDownloadSpeed;            // �������ٶ�
            public Int32     totalUploadSpeed;              // ���ϴ��ٶ�
            public UInt64    totalDownloadedByteCount;      // �����ص��ֽ���
            public UInt64    totalUploadedByteCount;        // ���ϴ����ֽ���

            public Int32     peersNum;                       // ��ǰ�����ϵĽڵ�����
            public Int32     dhtConnectedNodeNum;            // dht�����ϵĻ�Ծ�ڵ���
            public Int32     dhtCachedNodeNum;               // dht��֪�Ľڵ���
            public Int32     dhtTorrentNum;                  // dht����֪��torrent�ļ���
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct DOWNLOADER_INFO_FIXED
        {
            // Downloader��Ϣ
            public DLBT_DOWNLOAD_STATE         state;                   // ���ص�״̬            
            public Single                      percentDone;             // �Ѿ����ص����ݣ��������torrent�����ݵĴ�С �����ֻѡ����һ�����ļ����أ���ô�ý��Ȳ��ᵽ100%��
            public int                         downConnectionCount;     // ���ؽ�����������
            public int                         downloadLimit;           // ���������������
            public int                         connectionCount;         // �ܽ������������������ϴ���
            public int                         totalCompletedSeeds;     // �����������������������Tracker��֧��scrap���򷵻�-1
            public int                         inCompleteNum;           // �ܵ�δ��ɵ����������Tracker��֧��scrap���򷵻�-1
            public int                         seedConnected;           // ���ϵ�������ɵ�����
            public int                         totalCurrentSeedCount;   // ��ǰ���ߵ��ܵ�������ɵ��������������ϵĺ�δ���ϵģ�
            public int                         totalCurrentPeerCount;   // ��ǰ���ߵ��ܵ����ص��������������ϵĺ�δ���ϵģ�
            public float                       currentTaskProgress;     // ��ǰ����Ľ��� ��100.0%������ɣ�
            public Boolean                     bReleasingFiles;         // �Ƿ������ͷ��ļ������һ��������ɺ���Ȼ��������ˣ����ļ�����ͻ����ڲ���������Ҫһ��ʱ�����ͷš�

            public UInt32                      downloadSpeed;           // ���ص��ٶ�
            public UInt32                      uploadSpeed;             // �ϴ����ٶ�
            public UInt32                      serverPayloadSpeed;      // �ӷ��������ص�����Ч�ٶȣ�������������Ϣ�ȷ������Դ��䣩
            public UInt32                      serverTotalSpeed;        // �ӷ��������ص����ٶ�(����������Ϣ������ͨѶ�����ģ�

            public UInt64                      wastedByteCount;         // �����ݵ��ֽ�����������Ϣ�ȣ�
            public UInt64                      totalDownloadedBytes;    // ���ص����ݵ��ֽ���
            public UInt64                      totalUploadedBytes;      // �ϴ������ݵ��ֽ���
            public UInt64                      totalWantedBytes;        // ѡ��������ݴ�С
            public UInt64                      totalWantedDoneBytes;    // ѡ��������ص����ݴ�С

            public UInt64                      totalServerPayloadBytes; // �ӷ��������ص��������������������������ļ����ݣ�Ҳ����������յ���������ݣ���ʹ���������� -- ����һ����������û���⣬���ᶪ�����ݵģ�
            public UInt64                      totalServerBytes;        // �ӷ��������ص��������ݵ�����������totalServerPayloadBytes���Լ��������ݡ��շ���Ϣ�ȣ�
            public UInt64                      totalPayloadBytesDown;   // �����������ܵ����ص����ݿ����͵��������������˷����������ݣ��Լ����ܶ��������ݣ�
            public UInt64                      totalBytesDown;          // �����������ܵ��������ݵ������������������˷������Լ����пͻ������ݡ�����ͨѶ�������ȣ�
            
            // Torrent��Ϣ
            public Boolean                     bHaveTorrent;            // ��������������ģʽ���ж��Ƿ��Ѿ���ȡ����torrent�ļ�
            public UInt64                      totalFileSize;           // �ļ����ܴ�С
            public UInt64                      totalFileSizeExcludePadding;    // ʵ���ļ��Ĵ�С������padding�ļ�
            public UInt64                      totalPaddingSize;               // ����padding�Ĵ�С
            public int                         pieceCount;              // �ֿ���
            public int                         pieceSize;               // ÿ����Ĵ�С
        };

        public struct DOWNLOAD_INFO
        {
            public DOWNLOADER_INFO_FIXED       downloadInfoFiexed;  
            public string                      infoHash;                // �ļ���Hashֵ
        }


        [StructLayout(LayoutKind.Sequential)]
        public struct PEER_INFO_FIXED
        {
            public int		                   connectionType;	    	// �������� 0����׼BT(tcp); 1: P2SP��http�� 2: udp��������ֱ�����ӻ��ߴ�͸��
            public int                         downloadSpeed;           // �����ٶ�
            public int                         uploadSpeed;             // �ϴ��ٶ�
            public UInt64                      downloadedBytes;         // ���ص��ֽ���
            public UInt64                      uploadedBytes;           // �ϴ����ֽ���
            public int                         uploadLimit;             // �����ӵ��ϴ����٣���������Է�������IP�����ˣ�����ط����Կ������IP���������
            public int                         downloadLimit;           // �����ӵ��������٣���������Է�������IP�����ˣ�����ط����Կ������IP���������

        };

        public struct PEER_INFO
        {
            public PEER_INFO_FIXED             peerInfoFixed;
            public string                      ip;                      // �Է�IP
            public string                      client;                  // �Է�ʹ�õĿͻ���
        };


        [StructLayout(LayoutKind.Sequential)]
        public struct DLBT_KERNEL_START_PARAM
        {
            public Boolean bStartLocalDiscovery;	// �Ƿ������������ڵ��Զ����֣���ͨ��DHT��Tracker��ֻҪ��һ��������Ҳ���������֣��������ٶȿ죬���Լ������ȷ���ͬһ�����������ˣ�
            public Boolean bStartUPnP;				// �Ƿ��Զ�UPnPӳ�����BT�ں�����Ķ˿�
            public Boolean bStartDHT;				// Ĭ���Ƿ�����DHT�����Ĭ�ϲ����������Ժ�����ýӿ�������
            public Boolean bLanUser;                // �Ƿ񴿾������û�����ϣ���û������������Ӻ�����ͨѶ��������������ģʽ---��ռ����������ֻͨ���������û������أ�
            public Boolean bVODMode;                // �����ں˵�����ģʽ�Ƿ��ϸ��VODģʽ���ϸ��VODģʽ����ʱ��һ���ļ��ķֿ����ϸ񰴱Ƚ�˳��ķ�ʽ���أ���ǰ������أ����ߴ��м�ĳ���϶���λ���������
                                                    // ��ģʽ�Ƚ��ʺϱ����ر߲���,������ģʽ���˺ܶ��Ż��������ڲ���������أ����Բ����ʺϴ����صķ�����ֻ�����ڱ����ر߲���ʱʹ�á�Ĭ������ͨģʽ����
                                                    // ��VOD���ϰ汾����Ч

            public UInt16  startPort;	            // �ں˼����Ķ˿ڣ����startPort��endPort��Ϊ0 ����startPort > endPort || endPort > 32765 ���ֲ����Ƿ������ں��������һ���˿ڡ� ���startPort��endPort�Ϸ�
            public UInt16  endPort;				    // �ں����Զ���startPort ---- endPort֮�����һ�����õĶ˿ڡ�����˿ڿ��Դ�DLBT_GetListenPort���

            public void Init ()
            {
                bStartLocalDiscovery = true;
                bStartUPnP = true;
                bStartDHT = true;
                bVODMode = false;

                startPort = 0;
                endPort = 0;
            }
        };


        // ��ȡ��Ϣ����
        [DllImport("DLBT.dll", EntryPoint="DLBT_GetKernelInfo",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_GetKernelInfo (IntPtr info);

        public static int DLBT_GetKernelInfo (ref KERNEL_INFO info)
        {
            IntPtr  infoMem = Marshal.AllocCoTaskMem (1024);
            if (DLBT_GetKernelInfo (infoMem) == 0)
            {
                info = (KERNEL_INFO)Marshal.PtrToStructure (infoMem, typeof (KERNEL_INFO));
            }
            Marshal.FreeCoTaskMem (infoMem);
            return 0;
        }


        [DllImport("DLBT.dll", EntryPoint="DLBT_GetDownloaderInfo",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_GetDownloaderInfo (IntPtr hDownloader, IntPtr info);

        public static int DLBT_GetDownloaderInfo (IntPtr hDownloader, ref DOWNLOAD_INFO info)
        {
            IntPtr infoMem = Marshal.AllocCoTaskMem (1024);
            if (DLBT_GetDownloaderInfo (hDownloader, infoMem) == 0)
            {
                info.downloadInfoFiexed = (DOWNLOADER_INFO_FIXED)Marshal.PtrToStructure (infoMem, typeof (DOWNLOADER_INFO_FIXED));

                IntPtr  p = (IntPtr)(infoMem.ToInt64 () + Marshal.SizeOf (info.downloadInfoFiexed));
                info.infoHash = Marshal.PtrToStringAnsi (p);
            }
            Marshal.FreeCoTaskMem (infoMem);
            return 0;
        }

        [DllImport("DLBT.dll", EntryPoint="DLBT_GetDownloaderPeerInfoList",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern int DLBT_GetDownloaderPeerInfoList (IntPtr hDownloader, ref IntPtr info);

        public static int DLBT_GetDownloaderPeerInfoList (IntPtr hDownloader, ref int count, ref PEER_INFO [] entries)
        {
            IntPtr  info = IntPtr.Zero;
            DLBT_GetDownloaderPeerInfoList (hDownloader, ref info);
            if (info != IntPtr.Zero)
            {
                count = Marshal.ReadInt32 (info);
                if (count <= 0)
                    entries = null;
                else
                {
                    entries = new PEER_INFO [count];
                    
                    for (int i = 0; i < count; ++i)
                    {
                        int offset = 8 + (Marshal.SizeOf (typeof(PEER_INFO_FIXED)) + 64 + 64) * i;  //  The starting of a structure is aligned at 8 byte boundary
                        IntPtr p = (IntPtr)(info.ToInt64() + offset);
                        entries[i].peerInfoFixed = (PEER_INFO_FIXED)Marshal.PtrToStructure (p, typeof(PEER_INFO_FIXED));

                        p = (IntPtr)(p.ToInt64 () + Marshal.SizeOf (typeof(PEER_INFO_FIXED)));
                        entries[i].ip = Marshal.PtrToStringAnsi (p); 
                        p = (IntPtr)(p.ToInt64 () + 64);
                        entries[i].client = Marshal.PtrToStringAnsi (p);
                    }
                }
                DLBT_FreeDownloaderPeerInfoList (info);
            }
            return 0;
        }

        [DllImport("DLBT.dll", EntryPoint="DLBT_FreeDownloaderPeerInfoList",  SetLastError=true, CharSet=CharSet.Ansi, CallingConvention=CallingConvention.StdCall)]
        private static extern void DLBT_FreeDownloaderPeerInfoList (IntPtr info);


        [DllImport("DLBT.dll", EntryPoint="DLBT_SetDHTFilePathName",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_SetDHTFilePathName (string dhtFile);


        // �����Զ���IO�����ĺ��������Խ�BT����Ķ�д�ļ������в����ⲿ���д����滻�ڲ��Ķ�д�����ȣ�
        // �ù���Ϊ�߼��湦�ܣ�����ϵ������ȡ����֧�֣�Ĭ�ϰ汾�в����Ÿù���

        // ����IO�����Ľӹܽṹ���ָ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_Set_IO_OP",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_Set_IO_OP (IntPtr op);

        // �Խṹ����������к����ȸ�ֵĬ�ϵĺ���ָ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_InitDefault_IO_OP",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern void DLBT_InitDefault_IO_OP (IntPtr op);

        // ��ȡϵͳ�ڲ�Ŀǰ���õ�IO�����ָ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_Get_IO_OP",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern IntPtr DLBT_Get_IO_OP ();

        // ��ȡϵͳԭʼIO��ָ��
        [DllImport("DLBT.dll", EntryPoint="DLBT_Get_RAW_IO_OP",  SetLastError=true, CharSet=CharSet.Unicode, CallingConvention=CallingConvention.StdCall)]
        public static extern IntPtr DLBT_Get_RAW_IO_OP ();
	}
}
