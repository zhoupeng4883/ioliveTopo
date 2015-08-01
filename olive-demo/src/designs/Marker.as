package designs
{
	import spark.components.BorderContainer;
	import spark.components.SkinnableContainer;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.core.SpriteVisualElement;
	
	public class Marker extends SpriteVisualElement
	{
		public function Marker()
		{
			draw();
		}
		
		public function draw():void{
			this.graphics.lineStyle(1,0xFF0000);
			this.graphics.beginFill(0xFF0000,0.4);
			this.graphics.drawCircle(5,5,5);
			this.graphics.endFill();
		}
	}
}