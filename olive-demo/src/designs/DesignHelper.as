package designs
{
	import com.iolive.topology.canvas.IGraph;
	import com.iolive.topology.events.GraphDragDropEvent;
	import com.iolive.topology.events.GraphNodeEvent;
	import com.iolive.topology.events.SelectedNodesChangedEvent;
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.model.GroupedNode;
	import com.iolive.topology.model.IGraphNode;
	import com.iolive.topology.ui.alert.AlertTitle;
	import com.iolive.topology.utils.GraphicsUtils;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.controls.Menu;
	import mx.core.UIComponent;
	import mx.events.MenuEvent;
	import mx.managers.CursorManager;

	/**
	 * 设计器处理逻辑类
	 */ 
	public class DesignHelper
	{
		[Bindable]
		private var _graph:IGraph;
		[Bindable]
		private var _model:DesignGraphModel;
		private var menu:Menu;
		private var draging:Boolean = false;
		private var startNode:IGraphNode;
		private var endNode:IGraphNode;
		private var _lineStyle:Object = {color:0x8EA3BE,alpha:1,thickness:1,dashed:false, dashLength:10};
		[Embed(source='assets/topo/mou.png')]
		private const drawCursor:Class;
		private var cursorId:uint;
		private var nodeRightMenu:Menu;
		public function set model(_value:DesignGraphModel):void{
			this._model = _value;
		}
		
		public function get model():DesignGraphModel{
			return this._model;
		}
		public function get graph():IGraph{
			return _graph;
		}
		
		public function set lineStyle(value:Object):void{
			this._lineStyle = value;
		}
		
		public function get lineStyle():Object{
			return this._lineStyle;
		}
		
		public function set graph(_value:IGraph):void{
			this._graph = _value;
			if(_graph){
				_graph.addEventListener(GraphDragDropEvent.graphDragDrop,dropHanlder);
				_graph.addEventListener(GraphNodeEvent.NODE_MOUSE_OVER,nodeMouseOverHanlder);
				_graph.addEventListener(SelectedNodesChangedEvent.SELECTED_NODES_CHANGED,selectedChanger);
				_graph.addEventListener(DesignEvent.markerMouseClick,markerClickHanlder);//在某个节点渲染器上的Marker上点击触发开始连线
				_graph.addEventListener(GraphNodeEvent.NODE_CLICK,nodeClickHanlder);//在其他节点上点击时触发结束连线操作
				_graph.addEventListener(MouseEvent.MOUSE_MOVE,graphMoveHanlder);
				_graph.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHanlder);
				_graph.addEventListener(GraphNodeEvent.NODE_RIGHT_CLICK,nodeRightClickHanlder);
				(_graph as UIComponent).doubleClickEnabled = true;
				_graph.addEventListener(MouseEvent.DOUBLE_CLICK,graphDoubleClickHanlder);
			}

		}
		
		/**
		 * 画布接收到拖拽对象时
		 */ 
		protected function dropHanlder(drop:GraphDragDropEvent):void{
			_model.addDesignModel(drop.data.type,drop.data.name,graph.nodesLayer.mouseX,graph.nodesLayer.mouseY,drop.data);
		}
		
		/**
		 * 选择的节点发生变化时，此事件由画布抛出
		 */ 
		protected function selectedChanger(event:SelectedNodesChangedEvent):void{
			if(graph.selectedNode is GroupedNode) return;
			clearAllMarker();
			var selNode:IGraphNode = graph.selectedNode;
			despatchSelectEvent(selNode);
		}
		
		/**
		 * 清除Marker状态
		 */ 
		protected function clearAllMarker():void{
			var renderer:CompositeRenderer = null;
			var nodes:Array = model.nodes;
			for(var i:int = 0, size:int = nodes.length; i < size; i ++){
				renderer = graph.nodeToUI(nodes[i]) as CompositeRenderer;
				if(renderer)renderer.dispatchEvent(
					new DesignEvent(DesignEvent.nodeUnSelected,nodes[i],renderer));
			}
		}
		
		/**
		 * 鼠标移入节点时显示Marker
		 */ 
		protected function nodeMouseOverHanlder(event:GraphNodeEvent):void{
			if(graph.selectedNode is GroupedNode) return;
			clearAllMarker();
			despatchSelectEvent(event.node);
		}
		
		/**
		 * 抛出事件，通知渲染器显示Marker
		 */ 
		protected function despatchSelectEvent(node:IGraphNode):void{
			if(node is GroupedNode) return;
			var renderer:CompositeRenderer = graph.nodeToUI(node) as CompositeRenderer;
			if(renderer)renderer.dispatchEvent(
				new DesignEvent(DesignEvent.nodeSelected,node,renderer));
		}
		
		/**
		 * 在几点上悬浮时,出现一个菜单选项，用于连接两个节点
		 */ 
		protected function nodeClickHanlder(event:GraphNodeEvent):void{
			if(draging){
				endNode = event.node;
				joinComplete();
			}
		}
		
		/**
		 * 渲染器鼠标移入的监听
		 */ 
		private function markerClickHanlder(event:DesignEvent):void{
			draging = true;
			startNode = event.node;
			if(CursorManager.currentCursorID == CursorManager.NO_CURSOR){
				cursorId = CursorManager.setCursor(drawCursor);
			}
		}
		
		/**
		 * 连接完成
		 */ 
		protected function joinComplete():void{
			model.addDesignArc(startNode,endNode);
			startNode = null;
			endNode = null;
			draging = false;
			graph.drawGraphc.clear();
			CursorManager.removeCursor(CursorManager.currentCursorID);
			cursorId = 0;
		}
		
		/**
		 * 在画布上移动鼠标时
		 */ 
		protected function graphMoveHanlder(event:MouseEvent):void{
			if(draging){
				graph.drawGraphc.clear();
				graph.drawGraphc.lineStyle(lineStyle.thickness,lineStyle.color,lineStyle.alpha);
				var startPoint:Point = new Point(startNode.centerX,
					startNode.centerY);
				var endPoint:Point = new Point(graph.nodesLayer.mouseX,graph.nodesLayer.mouseY);

				if(lineStyle.arcType ==DefaultGraphItem.LINE_TYPE_STRAIGHT){
					GraphicsUtils.drawLine(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}else if(lineStyle.arcType ==DefaultGraphItem.LINE_TYPE_BROKEN_1){
					GraphicsUtils.drawBrokenLineP1(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}else if(lineStyle.arcType ==DefaultGraphItem.LINE_TYPE_BROKEN_2){
					GraphicsUtils.drawBrokenLineP2(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}else if(lineStyle.arcType ==DefaultGraphItem.LINE_TYPE_CIRCULAR){
					GraphicsUtils.drawCircular(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}else if(lineStyle.arcType ==DefaultGraphItem.LINE_TYPE_DIRECTEDBALLOON){
					GraphicsUtils.drawDirectedBalloonEdge(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}else{
					GraphicsUtils.drawLine(graph.drawGraphc,startPoint,endPoint,lineStyle.dashed,lineStyle.dashLength);
				}
			}
		}
		
		/**
		 * 双击取消操作
		 */ 
		protected function graphDoubleClickHanlder(event:MouseEvent):void{
			draging = false;
			graph.drawGraphc.clear();
			CursorManager.removeCursor(CursorManager.currentCursorID);
			cursorId = 0;
		}
		
		/**
		 * 键盘监听
		 */ 
		protected function keyDownHanlder(event:KeyboardEvent):void{
			var selectedNoes:Array = graph.selectedNodes;
			if(event.keyCode == Keyboard.DELETE){
				model.removeNodes(selectedNoes);
				AlertTitle.showTip("删除了"+selectedNoes.length+"个节点",null,AlertTitle.success);
			}
		}
		
		/**
		 * 在节点右键点击时触发
		 */ 
		protected function nodeRightClickHanlder(event:GraphNodeEvent):void{
			if(nodeRightMenu){
				nodeRightMenu.hide();
				nodeRightMenu.removeEventListener(MenuEvent.ITEM_CLICK,menuItemClickHanlder);
				nodeRightMenu = null;
			}
			
			nodeRightMenu = Menu.createMenu(graph.nodeToUI(event.node),[{label:"隐藏"},{label:"删除"},{label:"重命名"}]);
			nodeRightMenu.addEventListener(MenuEvent.ITEM_CLICK,menuItemClickHanlder);
			var p:Point = graph.nodesLayer.localToGlobal(new Point(graph.nodesLayer.mouseX,graph.nodesLayer.mouseY));
			nodeRightMenu.show(p.x,p.y);
			
			function menuItemClickHanlder(ev:MenuEvent):void{
				if(ev.item.label == "隐藏")graph.filterManager.hiddenItemsFilter.hideNode(event.node);
				else if(ev.item.label == "删除")model.removeNode(event.node);
				else if(ev.item.label == "重命名")graph.renameNode(event.node);
			}
		}
	}
}