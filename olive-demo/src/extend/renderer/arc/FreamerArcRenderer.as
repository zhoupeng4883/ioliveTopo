package extend.renderer.arc
{
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.renderers.AbstractArcRenderer;
	import com.iolive.topology.renderers.ArcMark;
	import com.iolive.topology.renderers.Segment;
	import com.iolive.topology.renderers.arc.ArcInfo;
	import com.iolive.topology.utils.LineMath;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osmf.layout.ScaleMode;
	
	public class FreamerArcRenderer extends AbstractArcRenderer
	{
		private const dasLength:int = 10; //每段长度
		private var startPoint:Point = new Point(0,0);
		private var endPoint:Point = new Point(0,0);
		private var currentColor:uint = 0x00FF00;//Timer runing中每段的颜色
		private var firstColor:uint = 0x00FF00;//线第一段的颜色
		private var timer:Timer;
		public function FreamerArcRenderer()
		{
			super();
			timer = new Timer(300);
		}
		override protected function createChildren():void {
			super.createChildren();
			//addEventListener(Event.ENTER_FRAME,freamer);
			timer.addEventListener(TimerEvent.TIMER,timerHanlder);
			timer.start();
			trace("createChildren.......");
		}
		private function freamer(event:Event = null):void{
			draw();
		}
		
		private function timerHanlder(event:TimerEvent):void{
			draw();
		//	trace("timer......");
		}
		
		override public function newInstance():* {
			var renderer:FreamerArcRenderer = new FreamerArcRenderer();
			copyProperties(renderer);
			return renderer;
		}
		
		override public function drowArc(arcMark:ArcMark,g:Graphics, start:Point, end:Point,dashed:Boolean = false, 
										 dashLength:Number = 10,lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT,layout:String="default",
										 color:uint=0,
										 startR:Rectangle=null ,destR:Rectangle=null,segment:Segment=null):ArcInfo{
			startPoint=start;
			endPoint=end;
			draw();
			var arcInfo:ArcInfo=new ArcInfo();
			arcInfo.arcType=DefaultGraphItem.LINE_TYPE_STRAIGHT;
			arcInfo.startPoint=start;
			arcInfo.endPoint=end;
			arcInfo.brokenPoint=new Array([start,end]);
			return arcInfo;
		}
		public function draw():void{
			var g:Graphics = this.graphics;
			g.clear();
			var l:Number=Math.sqrt((endPoint.x-startPoint.x)*(endPoint.x-startPoint.x)+(endPoint.y-startPoint.y)*(endPoint.y-startPoint.y));
			var num:int = l/ dasLength;
			g.lineTo(startPoint.x,startPoint.y);
			
			for(var i:int = 1; i <= num; i ++){
				var color:uint = getColor(i);
				if(i == 1) firstColor = color;
				g.lineStyle(5,color,1,false,ScaleMode.NONE,CapsStyle.ROUND);
				var h:Number=i*dasLength;
				var y:Number=(endPoint.y-startPoint.y)*h/l+startPoint.y;
				var x:Number=(endPoint.x-startPoint.x)*h/l+startPoint.x;
				g.lineTo(x,y);
			}
		}
		
		private function getColor(i:int):uint{
			currentColor = currentColor == 0x000000 ? 0x00FF00 : 0x000000;
			if(i == 1 && currentColor == firstColor) currentColor = currentColor == 0x000000 ? 0x00FF00 : 0x000000;
			return currentColor;
		}
	}
}