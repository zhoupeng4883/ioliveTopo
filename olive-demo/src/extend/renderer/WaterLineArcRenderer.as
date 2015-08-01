package extend.renderer
{
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.renderers.AbstractArcRenderer;
	import com.iolive.topology.renderers.ArcMark;
	import com.iolive.topology.renderers.Segment;
	import com.iolive.topology.renderers.arc.ArcInfo;
	import com.iolive.topology.utils.Bezier;
	import com.iolive.topology.utils.GraphicsUtils;
	import com.iolive.topology.utils.LineGroup;
	import com.iolive.topology.utils.LineMath;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.Image;
	
	public class WaterLineArcRenderer extends AbstractArcRenderer
	{
		
		[Embed(source="/assets/star/flare.png")]
		private const FLARE:Class;
		
		private var ball:Shape;
		private var ballArr:Array = new Array(10);
		private var arrow:Shape;
		
		
		public function WaterLineArcRenderer()
		{
			super();
			mouseOverEnabled = false;
		}
		override protected function createChildren():void {
			super.createChildren();
			if(stage)
				init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		override public function newInstance():* {
			var renderer:WaterLineArcRenderer = new WaterLineArcRenderer();
			copyProperties(renderer);
			return renderer;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		private var _arcMark:ArcMark;
		
		private var lineMath:LineMath=new LineMath();
		private var lineGroup:LineGroup=new LineGroup();
		
		private var steps:uint;
		private var crtStep:int=0;
		
		private var bezier:Bezier=null;
		
		private var _lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT;
		
		override public function drowArc(arcMark:ArcMark,g:Graphics, start:Point, end:Point,dashed:Boolean = false, 
										 dashLength:Number = 10,lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT,layout:String="default",
										 color:uint=0,
										 startR:Rectangle=null ,destR:Rectangle=null,segment:Segment=null):ArcInfo
		{
			
			this._lineType=lineType;
			var arcInfo:ArcInfo=super.drowArc(arcMark,g, start, end,dashed, dashLength,lineType,layout,color,startR,destR,segment);
			if(data.data.hasOwnProperty("dataFlow")&&data.data.dataFlow==true){
				if(lineType==DefaultGraphItem.LINE_TYPE_CIRCULAR){
					if(bezier==null){
						bezier=new Bezier();
					}
					steps=bezier.init(arcInfo.startPoint,arcInfo.anchorPoint,arcInfo.endPoint,2);
					
				}else if(lineType==DefaultGraphItem.LINE_TYPE_QUAD_CURVE){
					if(bezier==null){
						bezier=new Bezier();
					}
					steps=bezier.init(arcInfo.startPoint,arcInfo.anchorPoint,arcInfo.endPoint,2);
				}else{
					steps=lineGroup.initBroken(arcInfo.brokenPoint,2);
				}
				this.crtStep = 0;//当前步
			}
			
			return arcInfo;
		}
		
		
		private function init(e:Event = null):void {
			if(data.data.hasOwnProperty("dataFlow")&&data.data.dataFlow==true){
				//箭头
				this.arrow = new Shape();
				var c:Bitmap = new FLARE();
				arrow.graphics.beginBitmapFill(c.bitmapData);
				//	arrow.graphics.drawCircle(0,0,5);
				arrow.graphics.drawRect(0,0,30,20);
				arrow.graphics.endFill();	
				
				this.addChild(arrow);
				this.addEventListener(Event.ENTER_FRAME, onframe);
			}
			
		}
		
		private function onframe(e:Event=null):void {
			if(arrow==null){
				return ;
			}
			if(_lineType==DefaultGraphItem.LINE_TYPE_QUAD_CURVE||_lineType==DefaultGraphItem.LINE_TYPE_CIRCULAR){
				if(bezier==null){
					return ;
				}
				var tmpArr:Array = bezier.getAnchorPoint(crtStep);
				arrow.x =  tmpArr[0] ;
				arrow.y =  tmpArr[1] + 10;
				arrow.rotation =  tmpArr[2];
				this.crtStep++;
				if(crtStep>steps){
					crtStep=0;
				}
			}else{
				if(lineGroup==null){
					return ;
				}
				var tmpPoint:Point = lineGroup.getAnchorPoint(crtStep);
				arrow.x =  tmpPoint.x - 15;
				arrow.y =  tmpPoint.y - 10;
				///arrow.rotation =  tmpArr[2];
				this.crtStep++;
				if(crtStep>steps){
					crtStep=0;
				}
			}
			
		}
		
		/*private function onframe(e:Event=null):void {
		if(arrow==null){
		return ;
		}
		var tmpArr:Point = lineMath.getAnchorPoint(crtStep);
		arrow.x =  tmpArr.x;
		arrow.y =  tmpArr.y;
		///arrow.rotation =  tmpArr[2];
		this.crtStep++;
		if(crtStep>steps){
		crtStep=0;
		}
		}*/
		
		public function get arcMark():ArcMark
		{
			return _arcMark;
		}
		
		public function set arcMark(value:ArcMark):void
		{
			_arcMark = value;
		}
		
		public function get lineType():String
		{
			return _lineType;
		}
		
		public function set lineType(value:String):void
		{
			_lineType = value;
		}
		
		
	}
}