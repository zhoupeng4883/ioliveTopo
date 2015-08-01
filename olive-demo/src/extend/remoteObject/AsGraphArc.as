package extend.remoteObject
{
	import com.iolive.topology.model.DefaultGraphArc;

	/**
	 * 线段数据模型
	 * 与后台com.iolive.demo.model.JavaGraphArc对应适配
	 * 在AMF传输过程中会自动映射
	 */ 
	[RemoteClass(alias="com.iolive.demo.model.JavaGraphArc")]
	public class AsGraphArc extends DefaultGraphArc
	{
		 public function AsGraphArc(){
		 	super(id,sourceNode,destinationNode,type,data);
		 }
	}
}