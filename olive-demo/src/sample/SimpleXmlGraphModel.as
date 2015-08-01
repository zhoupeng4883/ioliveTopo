package sample
{
	import com.iolive.topology.events.GraphXMLModelEvent;
	import com.iolive.topology.model.DefaultGraphArc;
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.model.DefaultGraphModel;
	import com.iolive.topology.model.DefaultGraphNode;
	import com.iolive.topology.model.IGraphArc;
	import com.iolive.topology.model.IGraphNode;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	
	import mx.controls.Alert;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import spark.formatters.DateTimeFormatter;
	
	
	[Event(name="xml_loaded", type="com.iolive.topology.events.GraphXMLModelEvent")]
	[Event(name="xmlmodel_added", type="com.iolive.topology.events.GraphXMLModelEvent")]
	/**
	 * 使用XML作为数据源
	 * <br>
	 * @author yc
	 */ 
	public class SimpleXmlGraphModel extends DefaultGraphModel
	{
		private var _xmlUrl:String;
		
		public var inverted:Boolean =false;
		public var directed:Boolean =true;
		public var lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT;
		public var layout:String="default";
		private var startTime:Number;
		
		private var format:DateTimeFormatter = new DateTimeFormatter();
		
		private var nodesCache:Object = {};
		public function SimpleXmlGraphModel(_url:String = null)
		{
			this._xmlUrl = _url;
			format.dateTimePattern = "yyyy-MM-dd hh:mm:ss";
			super();
		}
		
		/**
		 * 设置XML路径
		 * <br>在设置url属性后，立即读取XML并解析为相应的Model
		 * <br>请注意文件跨域权限
		 */ 
		public function set url(value:String):void{
			startTime = (new Date()).time;
			this._xmlUrl = value;
			var urlRequest:URLRequest = new URLRequest(value);
			var load:URLLoader = new URLLoader(urlRequest);
			load.addEventListener(Event.COMPLETE,xmlLoaded);
		}
		
		/**
		 * XML路径
		 */ 
		public function get url():String{
			return this._xmlUrl;
		}
		
		/**
		 * XML文件Load完成时
		 */ 
		protected function xmlLoaded(event:Event):void{
			var xml:XML = XML(event.target.data);
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder();
			var xmlObject:Object = decoder.decodeXML(new XMLDocument(xml));
			var e1:GraphXMLModelEvent = new GraphXMLModelEvent(GraphXMLModelEvent.XML_LOADED);
			e1.xml = xml;
			e1.xmlObject = xmlObject;
			dispatchEvent(e1);
			
			var nodes:* = xmlObject.graph.node;
			if(nodes){
				if(nodes is Array){
					for each(var nodeObj:Object in nodes){
						addSimpleNode(nodeObj.id,nodeObj.type,nodeObj.text,nodeObj,nodeObj.bounds);
					}
				}else{
						addSimpleNode(nodes.id,nodes.type,nodes.text,nodes,nodes.bounds);
				}
			}
			var arcs:* = xmlObject.graph.arc;
			if(arcs){
				if(arcs is Array){
					for each(var arcObj:Object in arcs){
						
						if(arcObj.inverted!=null){
							inverted=arcObj.inverted;
						}
						if(arcObj.directed!=null){
							directed=arcObj.directed;
						}
						if(arcObj.lineType!=null){
							lineType=arcObj.lineType;
						}
						var aNode:IGraphNode = nodesCache[arcObj.source];
						var bNode:IGraphNode = nodesCache[arcObj.destination];
						if(!aNode || !bNode)continue;
						
						if(arcObj.layout!=null){
							layout=arcObj.layout;
						}
						
						addSimpleArc(arcObj.id,aNode, bNode,
							arcObj.type,arcObj,inverted,directed,lineType,layout);
					}
				}else{
					addSimpleArc(arcs.id,getNode(arcs.source), getNode(arcs.destination),
						arcs.type,arcs,inverted,directed,lineType);
				}
			}
			var e2:GraphXMLModelEvent = new GraphXMLModelEvent(GraphXMLModelEvent.XMLMODEL_ADDED);
			e2.xml = xml;
			e2.xmlObject = xmlObject;
			dispatchEvent(e2);
			var endTime:Number = (new Date()).time;
			trace("画布加载完成,耗时:"+((endTime-startTime)/1000));
		}
		
		/**
		 * 添加单个节点数据模型
		 * @param nodeId 节点Id
		 * @param nodeType 节点类型
		 * @param nodeText 节点显示名称
		 * @param nodeData 节点附带数据
		 * @return IGraphNode 节点数据模型
		 */ 
		public function addSimpleNode(nodeId:String, nodeType:String = "节点",
									  nodeText:String = "",nodeData:Object = null,
									  bounds:String=null):IGraphNode{
			var node:DefaultGraphNode = new DefaultGraphNode(nodeId, nodeType, nodeText,nodeData);
			if(bounds != null){
				var arr:Array = bounds.split(",");
				if(arr && arr.length == 4){//x,y,width,height
					var initX:Number = arr[0];
					var initY:Number = arr[1];
					var width:Number = arr[2];
					var height:Number = arr[3];
					if(!isNaN(initX)){
						node.layoutX = initX;
					}
					if(!isNaN(initY)){
						node.layoutY = initY;
					}
					if(!isNaN(width) && width > 0){
						node.layoutWidth = width;
					}
					if(!isNaN(height) && height > 0){
						node.layoutHeight = height;
					}
				}
			}
			super.addNode(node);
			nodesCache[nodeId] = node;
			return node;
		}
		
		/**
		 * 添加单个线段模型
		 * @param arcId 线段Id
		 * @param srcNode 线段A端节点对象
		 * @param distNode 线段B端节点对象
		 * @param arcType 线段类型
		 * @param arcData 线段附带数据
		 * @return IGraphArc 线段数据模型对象
		 */
		public function addSimpleArc(arcId:String,srcNode:IGraphNode,distNode:IGraphNode,
									 arcType:String = "连线",arcData:Object = null,inverted:Boolean = false,
									 directed:Boolean = true,lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT,
									 layout:String="default"):IGraphArc{

			var arc:DefaultGraphArc = new DefaultGraphArc(arcId, 
				srcNode, distNode,
				arcType, arcData,inverted,directed,-1,lineType,layout);
			super.addArc(arc);
			return arc;
		}
	}
}