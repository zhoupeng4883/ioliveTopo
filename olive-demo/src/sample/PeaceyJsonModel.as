package sample
{
	import com.iolive.topology.model.DefaultGraphArc;
	import com.iolive.topology.model.DefaultGraphModel;
	import com.iolive.topology.model.DefaultGraphNode;
	import com.iolive.topology.model.IGraphNode;
	import com.iolive.topology.ui.alert.AlertTitle;
	
	import flash.events.Event;
	
	public class PeaceyJsonModel extends DefaultGraphModel
	{
		private var _json:String;	
		public function set json(jsonStr:String):void{
			if(_json == jsonStr) return;
			this._json = jsonStr;
			parJson();
		}
		
		
		public function get json():String{
			return _json;
		}
		
		private function parJson():void{
			try{
				var jsonObj:Object = JSON.parse(json);
				if(jsonObj){
					var root:IGraphNode = createNode(jsonObj);
					
					var children:Array = jsonObj['host'];
					
					for each(var host:Object in children){
						var childNode:IGraphNode = createNode(host);
						createArc(root,childNode);
					}
				}
			}catch(e:Error){
				AlertTitle.showTip("不能正确解析Json",null,AlertTitle.error);
			}
		}
			
			private function createNode(obj:Object):DefaultGraphNode{
				obj['icon'] = "assets/topo/pc.png";//这里先写死一个图片，让每个节点显示不同的图片的话建议在json数据源里面添加一个icon字段
				var node:DefaultGraphNode = new DefaultGraphNode(obj['hcode'],"服务器",obj['hcode'],obj);
				super.addNode(node);
				return node;
			}
			
			public function createArc(srcNode:IGraphNode,toNode:IGraphNode):void{
				var arc:DefaultGraphArc = new DefaultGraphArc(srcNode.id+"-"+toNode.id,srcNode,toNode,"下挂");
				super.addArc(arc);
			}
			
			
	}
}