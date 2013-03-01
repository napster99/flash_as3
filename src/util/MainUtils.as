package util
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class MainUtils
	{
		public function MainUtils()
		{
		}
		
		//虚线绘制函数
		public static function drawDottedLine(disObj:Sprite, x0:Number, y0:Number, x1:Number, y1:Number, color:uint):void
		{
			var x:Number = x0;
			var y:Number = y0;
			var gap:Number = 2;
			
			var g:Graphics = disObj.graphics;
			g.lineStyle(0, color);
			
			if(y0 == y1)
			{
				while(x < x1)
				{
					g.moveTo(x,y);
					x += gap;
					g.lineTo(x,y);
					x += gap;
				}
			}else if(x0 == x1)
			{
				while(y < y1)
				{
					g.moveTo(x,y);
					y += gap;
					g.lineTo(x,y);
					y += gap;
				}
			}
		}
		
		//文本创建函数
		public static function createTextField(color:uint, size:uint = 14, align:String = TextFormatAlign.LEFT, autosize:Boolean = true, autodir:String = TextFieldAutoSize.LEFT):TextField
		{
			var tf1:TextField = new TextField();
			var fmt1:TextFormat = new TextFormat();
			fmt1.size = size;
			fmt1.color = color;
			fmt1.leading = -1;
			fmt1.align = align;
			tf1.defaultTextFormat=fmt1;
			if(autosize)
			{
				tf1.autoSize=autodir;
			}
			tf1.selectable=false;
			tf1.antiAliasType = AntiAliasType.ADVANCED;
			tf1.gridFitType=GridFitType.PIXEL;
			return tf1;
		}
		
		//计算数据的最大值与最小值
		public static function limitMeasure(dataArr:Array):Object
		{
			var limitVal:Object = {};
			var minVal:Number = dataArr[0];
			var maxVal:Number = dataArr[0];
			var i:Number = 0;
			
			for each(var data:Number in dataArr)
			{
				if(data > maxVal)
					maxVal = data;
				if(data < minVal)
					minVal = data;
				//trace("i===:" + i + "   data:"+ data + " maxVal:" + maxVal);
				i++;
			}
			limitVal.min = minVal;
			limitVal.max = maxVal;
			return limitVal;
		}
		
		//加零函数
		public static function add0Before(value:Number):String
		{
			var ret:String;
			if(value < 10)
			{
				ret = "0" + value;
			}else
			{
				ret = value.toString();
			}
			return ret;
		}
		
		public static function drawLegend(disObj:Sprite, text:String, color:uint, textSize:Number = 14):void
		{
			var legendGrap:Sprite= new Sprite();
			disObj.addChild(legendGrap);
			var grapG:Graphics = legendGrap.graphics;
			
			grapG.lineStyle(2, color);
			grapG.moveTo(0, 0);
			grapG.lineTo(14, 0);
			
			var legendText:TextField = createTextField(color, textSize);
			disObj.addChild(legendText);
			legendText.text = text;
			
			legendText.x = legendGrap.width + 5;
			if(legendGrap.height > legendText.height)
			{
				legendText.y = (legendGrap.height - legendText.height)/2;
			}
			else
			{
				legendGrap.y = (legendText.height - legendGrap.height)/2;
			}
			
		}
		
		public static function getBitmapFilter():BitmapFilter 
		{
			var color:Number = 0x000000;
			var angle:Number = 45;
			var alpha:Number = 0.6;
			var blurX:Number = 4;
			var blurY:Number = 4;
			var distance:Number = 3;
			var strength:Number = 0.65;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
		public static function useFilter():Array
		{
			var filter:BitmapFilter = MainUtils.getBitmapFilter();
			var NormalFilters:Array = new Array();
			NormalFilters.push(filter);
			return NormalFilters;
		}
	}
}