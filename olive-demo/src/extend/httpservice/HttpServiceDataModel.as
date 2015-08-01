package extend.httpservice
{
	import com.iolive.topology.model.DefaultGraphArc;
	import com.iolive.topology.model.DefaultGraphModel;
	import com.iolive.topology.model.DefaultGraphNode;
	import com.iolive.topology.ui.alert.AlertTitle;
	
	import mx.collections.ArrayCollection;

	/**
	 * 对应HttpService获取到的数据解析程序
	 */ 
	public class HttpServiceDataModel extends DefaultGraphModel
	{
		
		/**
		 * 后台获取的Json对象解析
		 */ 
		public function addJsonDatas(jsonStr:String):void{
			var jsonObj:Object = JSON.parse(jsonStr);//此处对应的即为后台传递过来的Map<String,Object>，在flex中对应解析为Json
			var nodeArr:Array = jsonObj.nodes;//对应后台传递的Map的key nodes
			var arcArr:Array =  jsonObj.arcs;//对应后台传递的Map的key arcs
			for(var i:int = 0, size:int = nodeArr.length; i < size; i ++){
				var nodeObj:Object = nodeArr[i];
				addNode(new DefaultGraphNode(nodeObj.id,nodeObj.type,nodeObj.name,nodeObj));//调用父类addNode，将节点添加到画布
			}
			
			for(var j:int = 0, jsize:int = arcArr.length; j < jsize; j ++){
				var arcObj:Object = arcArr[j];
				addArc(new DefaultGraphArc(arcObj.id,getNode(arcObj.source),getNode(arcObj.destination),arcObj.type,arcObj));
			}
		}
		
		/**
		 * 后台获取的XML数据解析
		 */ 
		public function addXMLDatas(xmlStr:String):void{
			try{
				var xmlDatas:XML = XML(xmlStr);
				var nodesList:XMLList = xmlDatas.node;
				var arcsList:XMLList = xmlDatas.arc;
				for each(var nodeObj:Object in nodesList){
					addNode(new DefaultGraphNode(nodeObj.@id,nodeObj.@type,nodeObj.@name,{id:nodeObj.@id,name:nodeObj.@name,icon:nodeObj.@icon.toString()}));//调用父类addNode，将节点添加到画布
				}
				
				for each(var arcObj:Object in arcsList){
					addArc(new DefaultGraphArc(arcObj.@id,getNode(arcObj.@source),getNode(arcObj.@destination),arcObj.@type,arcObj));
				}
			}catch(e:Error){
				AlertTitle.showTip("错误的XML数据",null,AlertTitle.error);
			}
		}
	}
}