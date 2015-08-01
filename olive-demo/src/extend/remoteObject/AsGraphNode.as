package extend.remoteObject
{
	import com.iolive.topology.model.DefaultGraphNode;
	/**
	 * 节点数据模型
	 * 与后台com.iolive.demo.model.JavaGraphNode对应适配
	 * 在AMF传输过程中会自动映射
	 */ 
	[RemoteClass(alias="com.iolive.demo.model.JavaGraphNode")]
	public class AsGraphNode extends DefaultGraphNode
	{
	 	public function AsGraphNode(){
			super(id,type,text,data);
		}
	}
}