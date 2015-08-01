package designs
{
	import com.iolive.topology.model.DefaultGraphArc;
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.model.DefaultGraphModel;
	import com.iolive.topology.model.DefaultGraphNode;
	import com.iolive.topology.model.IGraphNode;
	import com.iolive.topology.utils.Uuid;

	/**
	 * 画布Model
	 */ 
	public class DesignGraphModel extends DefaultGraphModel
	{
		[Bindable]
		public var mcolor:uint=0x000000;
		[Bindable]
		public var mweight:int=1;
		[Bindable]
		public var marcType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT;
		[Bindable]
		public var mType:String="实线";
		
		private var _nodeProperties:Object = {showLabel:true,labelposition:"center",dropShadow:true};
		
		
		public function addDesignModel(type:String = "", text:String = "",
									   x:Number = NaN,y:Number = NaN,
									   nodeData:Object = null):void{
			nodeData.showLabel = nodeProperties.showLabel;
			nodeData.labelPosition = nodeProperties.labelPosition;
			nodeData.dropShadow = nodeProperties.dropShadow;
			var node:DefaultGraphNode = new DefaultGraphNode(new Uuid().toString(),type,text,nodeData);
			if(!isNaN(x))node.layoutX = x;
			if(!isNaN(y))node.layoutY = y;
			super.addNode(node);
		}
		
		public function addDesignArc(startNode:IGraphNode,endNode:IGraphNode):void{
			var arcData:Object=new Object();
			//arcData.color=mcolor;
			if(startNode == endNode) return;//暂时不要自己连自己
			var arc:DefaultGraphArc = new DefaultGraphArc(new Uuid().toString(),startNode,endNode,mType,arcData,false,true,mweight,marcType);
			arc.color=mcolor;
			super.addArc(arc);
		}
		
		public function set nodeProperties(val:Object):void{
			this._nodeProperties = val;
		}
		
		public function get nodeProperties():Object{
			return this._nodeProperties;
		}
	}
}