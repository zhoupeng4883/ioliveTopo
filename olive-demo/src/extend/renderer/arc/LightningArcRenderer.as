package extend.renderer.arc
{
	import com.iolive.topology.model.DefaultGraphItem;
	import com.iolive.topology.renderers.AbstractArcRenderer;
	import com.iolive.topology.renderers.ArcMark;
	import com.iolive.topology.renderers.Segment;
	import com.iolive.topology.renderers.arc.ArcInfo;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 闪电连线的渲染
	 * @author jkl
	 * 
	 */
	public class LightningArcRenderer extends AbstractArcRenderer
	{
		private var ll:Lightning;
		public function LightningArcRenderer()
		{
			super();
		}
		override protected function createChildren():void {
			super.createChildren();
			addEventListener(Event.ENTER_FRAME, onframe);
			ll = new Lightning(0xFFFFFF, 2);
			var glow:GlowFilter=new GlowFilter();
			glow.color=0x6D9CCA;
			glow.strength=5;
			glow.quality=3;
			glow.blurX=glow.blurY=10;
			ll.filters=[glow];
			/*ll.maxLength=0;
			ll.thickness=0;
			ll.steps=10;
			ll.alphaFadeType=LightningFadeType.TIP_TO_END;
			ll.thicknessFadeType=LightningFadeType.TIP_TO_END;
			ll.childrenDetachedEnd=true;
			ll.childrenProbability=1;
			ll.childrenAngleVariation=1;
			ll.childrenMaxCount=30;
			ll.wavelength=0.05;
			ll.amplitude=2;
			
			ll.speed=0.5;*/
			addChild(ll);
			
		}
		override public function newInstance():* {
			var renderer:LightningArcRenderer = new LightningArcRenderer();
			copyProperties(renderer);
			return renderer;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		
		override public function drowArc(arcMark:ArcMark,g:Graphics, start:Point, end:Point,dashed:Boolean = false, 
										 dashLength:Number = 10,lineType:String=DefaultGraphItem.LINE_TYPE_STRAIGHT,layout:String="default",
										 color:uint=0,
										 startR:Rectangle=null ,destR:Rectangle=null,segment:Segment=null):ArcInfo{
			ll.startX=start.x;
			ll.startY=start.y;
			ll.endX=end.x;
			ll.endY=end.y;
			var arcInfo:ArcInfo=new ArcInfo();
			arcInfo.arcType=DefaultGraphItem.LINE_TYPE_STRAIGHT;
			arcInfo.startPoint=start;
			arcInfo.endPoint=end;
			arcInfo.brokenPoint=new Array([start,end]);
			return arcInfo;
		}
		private function onframe(event:Event):void {
			ll.update();
		}
		
	}
}