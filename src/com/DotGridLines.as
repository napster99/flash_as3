package com
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.GridLines;
	import mx.charts.chartClasses.CartesianChart;
	import mx.charts.chartClasses.ChartBase;
	import mx.charts.chartClasses.ChartState;
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.charts.chartClasses.IAxisRenderer;
	import mx.graphics.IStroke;
	
	[Style(name="midbold", type="Boolean", inherit="no")]

	public class DotGridLines extends GridLines
	{
		
		public var dotLength:Number = 2;
        public var gap:Number = 1;
        public var start:Number = 2;
		
		public function DotGridLines(){
			super();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);

		var len:int;
		var c:Object;
		var stroke:IStroke;
		var changeCount:int;
		var ticks:Array;
		var spacing:Array;
		var axisLength:Number;
		var colors:Array;
		var rc:Rectangle;
		var originStroke:IStroke;
		var chart:ChartBase = this.chart;
		var addedFirstLine:Boolean;
		var addedLastLine:Boolean;
		var midbold:Boolean;
		
		var midcolor:uint;
		
		midbold = getStyle("midbold") as Boolean;
		
		if (chart == null ||
			chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ||
			chart.chartState == ChartState.HIDING_DATA)
		{
			return;
		}
		
		var g:Graphics = graphics;
		g.clear();
		
		var direction:String = getStyle("direction");
		if (direction == "horizontal" || direction == "both")
		{
			stroke = getStyle("horizontalStroke");
			
			changeCount = Math.max(1, getStyle("horizontalChangeCount"));
			if ((changeCount * 0 != 0) || changeCount <= 1)
				changeCount = 10;


			
			len = changeCount;
			spacing = [];
			for (var i:int = 1; i < len; i++)
			{
				spacing[i - 1] = i/len;
			}
			
					
			addedFirstLine = false;
			addedLastLine = false;

			if (spacing[0] != 0)
			{
				addedFirstLine = true;
				spacing.unshift(0);
			}

			if (spacing[spacing.length - 1] != 1)
			{
				addedLastLine = true;
				spacing.push(1);
			}

			axisLength = unscaledHeight;
			for (i = 0; i < spacing.length; i++)
			{
				var idx:int = len - 1 - i;

				var bottom:Number = spacing[idx] * axisLength;
				var top:Number =
					spacing[Math.max(0, idx - 1)] * axisLength;
				rc = new Rectangle(0, top, unscaledWidth, bottom-top);

				
				if (stroke != null && rc.bottom >= -1) //round off errors
				{
					if (addedFirstLine && idx == 0)
						continue;
					if (addedLastLine && idx == (spacing.length-1))
						continue;

					stroke.apply(g);
					if(i==5 && midbold){
						g.moveTo(rc.left, rc.bottom);
						g.lineTo(rc.right, rc.bottom);
						g.moveTo(rc.left, rc.bottom+1);
						g.lineTo(rc.right, rc.bottom+1);
					}
					else{
						drawDottedHorizontalLineTo(g,rc.bottom,rc.left,rc.right);
					}
				}
			}
		}

		if (direction == "vertical" || direction == "both")
		{
			stroke = getStyle("verticalStroke");
			
			changeCount = Math.max(1,getStyle("verticalChangeCount"));
			
			if (isNaN(changeCount) || changeCount <= 1)
				changeCount = 1;

			var horizontalAxisRenderer:IAxisRenderer =
				CartesianChart(chart).horizontalAxisRenderer;
			
			ticks = horizontalAxisRenderer.ticks.concat();

		
			if (getStyle("verticalTickAligned") == false)
			{
				len = ticks.length;
				spacing = [];
				for (i = 1; i < len; i++)
				{
					spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
				}
			}
			else
			{
				spacing = ticks;
			}

			addedFirstLine = false;
			addedLastLine = false;
			
			if (spacing[0] != 0)
			{
				addedFirstLine = true;
				spacing.unshift(0);
			}

			if (spacing[spacing.length - 1] != 1)
			{
				addedLastLine = true;
				spacing.push(1);
			}
				
			axisLength = unscaledWidth;
							
			colors = [ getStyle("verticalFill"),
					   getStyle("verticalAlternateFill") ];

			for (i = 1; i < spacing.length; i += changeCount)
			{
				c = colors[(i / changeCount) % 2];
				var left:Number = spacing[i] * axisLength;
				var right:Number =
					spacing[Math.min(spacing.length - 1,
									 i + changeCount)] * axisLength;
				rc = new Rectangle(left, 0, right - left, unscaledHeight);
				if (c != null)
				{
					g.lineStyle(0, 0, 0);
					GraphicsUtilities.fillRect(g, rc.left, rc.top,
											   rc.right, rc.bottom, c);
				}

				if (stroke != null) // round off errors
				{
					if (addedFirstLine && i == 0)
						continue;
					if (addedLastLine && i == spacing.length-1)
						continue;
						
					stroke.apply(g);
					if(i == 121 && midbold){
						g.moveTo(rc.left, rc.top);
						g.lineTo(rc.left, rc.bottom);
						g.moveTo(rc.left+1, rc.top);
						g.lineTo(rc.left+1, rc.bottom);
					}
					else{
						drawDottedVerticalLineTo(g,rc.left,rc.top,rc.bottom);
					}

				}
			}
		}

		var horizontalShowOrigin:Object = getStyle("horizontalShowOrigin");
		var verticalShowOrigin:Object = getStyle("verticalShowOrigin");
		/*
		if (verticalShowOrigin || horizontalShowOrigin)
		{
			var cache:Array = [ { xOrigin: 0, yOrigin: 0 } ];
			var sWidth:Number = 0.5;

			dataTransform.transformCache(cache, "xOrigin", "x", "yOrigin", "y");

			if (horizontalShowOrigin &&
				cache[0].y > 0 && cache[0].y < unscaledHeight)
			{
				originStroke = getStyle("horizontalOriginStroke");
				originStroke.apply(g);
				g.moveTo(0, cache[0].y - sWidth / 2);
				g.lineTo($width, cache[0].y - sWidth / 2);
			}

			if (verticalShowOrigin &&
				cache[0].x > 0 && cache[0].x < unscaledWidth)
			{
				originStroke = getStyle("verticalOriginStroke");
				originStroke.apply(g);
				g.moveTo(cache[0].x - sWidth / 2, 0);
				g.lineTo(cache[0].x - sWidth / 2, $height);
			}
		}
		*/
	}
	
	
		public  function drawDottedHorizontalLineTo( 
				g:Graphics, 
				y : Number, 
				x0 : Number, 
				x1 : Number 
				) : void
			{
				if( x0 < x1){
					g.moveTo(x0, y);
					for(var x:Number = x0 + start; x<x1; x+= dotLength + gap){
						if( x + dotLength + gap <= x1){
							g.lineTo(x + dotLength,y);
							g.moveTo(x + dotLength + gap, y);
						}else{
							if(x + dotLength > x1){
								g.lineTo(x1, y);
							}else{
								g.lineTo(x + dotLength,y);
								
							}
						}
						
					}
				}else{
					g.moveTo(x0, y);
					for(var xx:Number = x0  ; xx>x1; xx-= dotLength + gap){
						
						if(xx - (dotLength + gap )>=x1){
							g.lineTo(xx - dotLength,y);
							g.moveTo(xx - dotLength - gap, y);
						}else{
							if(xx - dotLength < x1){
								//trace(xx)
								g.lineTo(x1, y);
							}else{
								g.lineTo( xx - dotLength, y);
							}
						}
						
					}
				}
				
			}		
			
			public  function drawDottedVerticalLineTo( 
				g:Graphics, 
				x : Number, 
				y0 : Number, 
				y1 : Number 
				) : void
			{
				if(y0 <= y1){
					g.moveTo(x, y0);
					for(var y:Number=y0; y <= y1; y+= dotLength + gap){
						if( y + dotLength + gap <= y1){
							g.lineTo(x, y + dotLength);
							g.moveTo(x, y + dotLength + gap);
						}else{
							if( y + dotLength > y1){
								g.lineTo(x, y1);
							}else{
								g.lineTo( x, y + dotLength );
							}
						}
						
					}
				}else{
					g.moveTo(x, y1);
					for(var yy:Number = y0; yy>= y1; yy-=dotLength + gap){
						if(yy - dotLength  - gap >= y1){
							g.lineTo(x, yy - dotLength);
							g.moveTo(x, yy - dotLength - gap);
						}else{
							if(yy - dotLength < y1){
								g.lineTo(x, y1);
							}else{
								g.lineTo(x, yy - dotLength );
							}
						}
						
					}
				}
			}
	}
}