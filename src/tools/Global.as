package  tools
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.net.LocalConnection;
	
	/**
	 * ...
	 * @author Ofeng (Tools -> Custom Arguments...)
	 */
	public class Global 
	{
		
		public function Global() 
		{
			
		}
		
		//判断股票是否指数
		static public function isIndex(code:String):Boolean{
			var indexPattern:RegExp = /^(1A|1B|1C|399|3C|HSI)/;
			return code.match(indexPattern)? true : false;
		}
		
		//判断股票是否港股
		static public function isGg(code:String):Boolean{
			if(!code) return false;
			return code.indexOf("HK") == 0 || code.indexOf("HS") == 0;
		}
		
		//值是否再数值中
		static public function in_array(str:*, arr:Array):*
		{
			for( var i:uint=0;i<arr.length;i++ )
			{
				if( arr[i] == str )
					return i;
			}
			return false;
		}
		
		//值是否在对象中
		static public function in_array_obj(str:String, arr:Array ,key:String):*
		{
			for( var i:uint=0;i<arr.length;i++ )
			{
				if( arr[i][key] == str )
					return i;
			}
			return false;
		}
		
        //深复制
        public static function cloneObject(source:Object) :*
        {
			var typeName:String = flash.utils.getQualifiedClassName(source);
			  
			var packageName:String = typeName ;
			var type:Class = Class(flash.utils.getDefinitionByName(typeName));
			   
			flash.net.registerClassAlias(packageName, type);
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source);
			copier.position = 0;
			return copier.readObject();
  		}
		
		
		//删除所有子元素
		public static function removeChildrenAll(obj:DisplayObjectContainer):void
		{
			while (obj.numChildren > 0 ) {
				obj.removeChildAt(0);
			}
		}
		
		//弹出某页面
		public static function gotoUrl(url:String):void
		{
			ExternalInterface.call("window.open", url);
		}
		
		//弹出某页面
		public static function T(msg:String):void
		{
			ExternalInterface.call("trace", msg);
		}
		
	}
	
}