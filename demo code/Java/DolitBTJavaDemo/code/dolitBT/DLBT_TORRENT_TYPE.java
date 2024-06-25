package dolitBT;

public enum DLBT_TORRENT_TYPE {

	USE_PUBLIC_DHT_NODE,    // 使用公共的DHT网络资源
    NO_USE_PUBLIC_DHT_NODE,         // 不使用公共的DHT网络节点
    ONLY_USE_TRACKER;              // 仅使用Tracker，禁止DHT网络和用户来源交换（私有种子）
	
	public static DLBT_TORRENT_TYPE fromInteger(int x)
	 {
       switch(x) 
       {
	        case 0:
	            return USE_PUBLIC_DHT_NODE;
	        case 1:
	            return NO_USE_PUBLIC_DHT_NODE;
	        case 2:
	            return ONLY_USE_TRACKER;
       }
       return USE_PUBLIC_DHT_NODE;
	 }
	
	 public static int toInt(DLBT_TORRENT_TYPE x)
	 {
       switch(x) 
       {
	        case USE_PUBLIC_DHT_NODE:
	            return 0;
	        case NO_USE_PUBLIC_DHT_NODE:
	            return 1;
	        case ONLY_USE_TRACKER:
	            return 2;
       }
       return 0;
	 }
}
