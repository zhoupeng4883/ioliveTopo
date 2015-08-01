package designs
{
	import com.iolive.topology.model.IGraphNode;
	
	import flash.events.Event;
	
	/**
	 * 用于设计器的各类交互事件
	 */ 
	public class DesignEvent extends Event{
		
		/**
		 * 在选中的节点上，鼠标移动到marker时触发
		 */ 
		public static const markerMouseOver:String = "markerMouseOver";
		
		/**
		 * 在选中的节点上，鼠标到marker上点击时触发
		 */ 
		public static const markerMouseClick:String = "markerMouseClick";
		
		/**
		 * 节点在选中时
		 */
		public static const nodeSelected:String = "nodeSelected";
		
		/**
		 * 节点在去除选中状态时
		 */
		public static const nodeUnSelected:String = "nodeUnSelected";
		
		public var node:IGraphNode;
		
		public var renderer:CompositeRenderer;
		
		public function DesignEvent(type:String, node:IGraphNode = null,renderer:CompositeRenderer = null){
			super(type, true, true);
			this.node = node;
			this.renderer = renderer;
		}
	}
}