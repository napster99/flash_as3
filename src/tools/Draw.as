package tools 
{	
	import flash.display.Graphics;
	/**
	 * 常用画线方法
	 * @author Ofeng (Tools -> Custom Arguments...)
	 */
	public class Draw 
	{
		
		public function Draw() 
		{
			
		}
		
		//水平虚线
		public static function drawHDotLine(g:Graphics, y:Number, x0:Number, x1:Number, dotLen:Number, gap:Number):void
		{
			var i:int;
			if (x0 < x1) {
				g.moveTo(x0, y);
				for(i = x0; i<x1; i+= dotLen + gap){
					if( i + dotLen + gap <= x1){
						g.lineTo(i + dotLen,y);
						g.moveTo(i + dotLen + gap, y);
					}else{
						if(i + dotLen > x1)
							g.lineTo(x1, y);
						else
							g.lineTo(i + dotLen,y);
					}
					
				}
			}
			else {
				g.moveTo(x0, y);
				for(i = x0  ; i>x1; i-= dotLen + gap){
					
					if(i - (dotLen + gap )>=x1){
						g.lineTo(i - dotLen,y);
						g.moveTo(i - dotLen - gap, y);
					}else{
						if(i - dotLen < x1)
							g.lineTo(x1, y);
						else
							g.lineTo( i - dotLen, y);
					}
				}
			}
		}
		
		
		//垂直虚线
		public static function drawVDotLine(g:Graphics, x:Number, y0:Number, y1:Number, dotLen:Number, gap:Number):void
		{
			var i:int;
			if (y0 < y1) {
				g.moveTo(x, y0);
				for(i = y0 ; i<y1; i+= dotLen + gap){
					if( i + dotLen + gap <=y1){
						g.lineTo(x,i + dotLen);
						g.moveTo(x,i + dotLen + gap);
					}else{
						if(i + dotLen > y1)
							g.lineTo(x, y1);
						else
							g.lineTo(x,i + dotLen);
					}
					
				}
			}
			else {
				g.moveTo(x, y0);
				for(i = y0  ; i>y1; i-= dotLen + gap){
					
					if(i - (dotLen + gap )>=y1){
						g.lineTo(x,i - dotLen);
						g.moveTo(x,i - dotLen - gap);
					}else{
						if(i - dotLen < y1)
							g.lineTo(x, y1);
						else
							g.lineTo(x, i - dotLen);
					}
				}
			}
		}
		
		
		//曲线
		public static function drawCurveLine(g:Graphics, x:Number, y:Number, w:Number, h:Number, sourceData:Array, yField:String, color:uint, 
											yMax:Number = 0, yMin:Number = 0,weight:Number = 1, alpha:Number = 1,
											xField:String = undefined, xMax:Number = 0, xMin:Number = 0
											):void
		{
			var i:int;
			var x_from:Number, y_from:Number, x_to:Number, y_to:Number;
			var len:int = sourceData.length;
			
			if (!len) return;
			
			if (yMax == 0 ) {
				var ysourceClone:Array = Global.cloneObject(sourceData);
				var ymaxArr:Array = ysourceClone.sortOn(yField, Array.NUMERIC | Array.DESCENDING);

				yMax = ymaxArr[0][yField];
				yMin = ymaxArr[len - 1][yField];
			}
			if (xField && xMax == 0) {
				var xsourceClone:Array = Global.cloneObject(sourceData);
				var xmaxArr:Array = xsourceClone.sortOn(xField, Array.NUMERIC | Array.DESCENDING);
				xMax = xmaxArr[0][xField];
				xMin = xmaxArr[len - 1][xField];
			}
			
			g.lineStyle(weight,color,alpha);
			for (i = 0; i < len - 1; i++) {
				if(xMax == 0){
					x_from = x + w / len * i;
					x_to = x + w / len * (i + 1);
				}
				
				y_from = y + h - (Number(sourceData[i][yField]) - yMin) * h / (yMax - yMin);
				y_to = y + h - (Number(sourceData[i + 1][yField]) - yMin) * h / (yMax - yMin); 
				
				g.moveTo(x_from, y_from);
				g.lineTo(x_to, y_to);
			}
		}
		
		//柱状图
		public static function drawColumnLine(g:Graphics,x:Number,y:Number,w:Number,h:Number,sourceData:Array):void
		{
			
		}
		
	}
	
}