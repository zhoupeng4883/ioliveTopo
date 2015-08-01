package extend.layers
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Extent;

	public final class MapLayerType
	{
		public static const GOOGLE_VECTOR:String = "谷哥矢量图";
		public static const GOOGLE_TERRAIN:String = "谷哥地形图";
		public static const GOOGLE_IMAGE:String = "谷哥影像图";
		public static const NOKIA_VECTOR:String = "诺记矢量图";
		public static const NOKIA_TERRAIN:String = "诺记地形图";
		public static const NOKIA_IMAGE:String = "诺记影像图";
		
		public static const china_extent:Extent = new Extent(7197369.376439955,2332368.585195727,16589951.412119914,6774277.172902707,new SpatialReference(102113));
	}
}