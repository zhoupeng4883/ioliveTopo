package  extend.bar
{
	
	import extend.bar.skins.MetroBtnSkin;
	
	import spark.components.Button;
	
	public class MetroButton extends Button{
		
		public function MetroButton(){
			this.setStyle("skinClass",MetroBtnSkin);
		}
		
		override protected function measure():void{
			super.measure();
			if(this.iconDisplay){
				this.width = this.iconDisplay.bitmapData.width;
				this.height = this.iconDisplay.bitmapData.height;
			}
		}
		
	}
}