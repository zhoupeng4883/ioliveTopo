package  sample
{
	import com.iolive.topology.model.DefaultGraphArc;
	import com.iolive.topology.model.DefaultGraphModel;
	import com.iolive.topology.model.DefaultGraphNode;

	/**
	 * 程序添加Object方式
	 */
	public class SimpleGraphModel extends DefaultGraphModel
	{
		
		private var nextNodeID:uint = 1;
		private var nextArcID:uint = 100;
		
		public function SimpleGraphModel() {
			super();
		}
		
		public function addSimpleNode(label:String, nodeType:String = "node", 
							initialX:Number = NaN, initialY:Number = NaN):DefaultGraphNode {
			var node:DefaultGraphNode = new DefaultGraphNode(nextNodeID.toString(10), nodeType, label);
			if (!isNaN(initialX)) {
				node.layoutX = initialX;
			}
			if (!isNaN(initialY)) {
				node.layoutY = initialY;
			} 
			super.addNode(node);
			nextNodeID++;
			return node;
		}
		
		public function addSimpleArc(src:DefaultGraphNode, dest:DefaultGraphNode, arcType:String = "connectedTo",
								inverted:Boolean = false, directed:Boolean = true):DefaultGraphArc {
			var arc:DefaultGraphArc = new DefaultGraphArc(nextArcID.toString(10), src, dest, arcType,
														  null, inverted, directed);
			super.addArc(arc);
			nextArcID++;
			return arc;
		}
		
	}
}