package com
{

import flash.display.Graphics;
import flash.geom.Rectangle;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.series.items.HLOCSeriesItem;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.skins.ProgrammaticSkin;




public class KchartItemRenderer extends ProgrammaticSkin
									 implements IDataRenderer
{

	public function KchartItemRenderer() 
	{
		super();
	}


	private var _chartItem:HLOCSeriesItem;

	[Inspectable(environment="none")]


	public function get data():Object
	{
		return _chartItem;
	}


	public function set data(value:Object):void
	{
		_chartItem = value as HLOCSeriesItem;
			
		invalidateDisplayList();
	}


	override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var stroke:IStroke;
		var boxStroke:IStroke;
		
		var fill:IFill;
		var w:Number = boxStroke ? boxStroke.weight / 2 : 0;
		var rc:Rectangle;
		var g:Graphics = graphics;
		
		if (_chartItem)
		{
			fill = GraphicsUtilities.fillFromStyle(
						_chartItem && _chartItem.open < _chartItem.close ?
						getStyle("declineFill") :
						getStyle("fill"));
			
			stroke = _chartItem && _chartItem.open < _chartItem.close ?
						getStyle("dstroke") :
						getStyle("stroke");
						
			boxStroke = _chartItem && _chartItem.open < _chartItem.close ?
						getStyle("dboxStroke") :
						getStyle("boxStroke");
												
			var max:Number = Math.min(_chartItem.high,Math.min(_chartItem.close,_chartItem.open));
			var min:Number = Math.max(_chartItem.low,Math.max(_chartItem.open,_chartItem.close));
			
			var boxMin:Number = Math.min(_chartItem.open, _chartItem.close);
			var boxMax:Number = Math.max(_chartItem.open, _chartItem.close);
	
			var candlestickHeight:Number = min- max;
			var heightScaleFactor:Number = height / candlestickHeight;
			
			rc = new Rectangle(w,
							   (boxMin - max) *
							   heightScaleFactor + w,
							   width - 2 * w,
							   (boxMax - boxMin) * heightScaleFactor - 2 * w);

			g.clear();		
			g.moveTo(rc.left,rc.top);
			if (boxStroke)
				boxStroke.apply(g);
			else
				g.lineStyle(0,0,0);
			if (fill)
				fill.begin(g,rc);
			g.lineTo(rc.right, rc.top);
			g.lineTo(rc.right, rc.bottom);
			g.lineTo(rc.left, rc.bottom);
			g.lineTo(rc.left, rc.top);
			if (fill)
				fill.end(g);
			if (stroke)
			{
				stroke.apply(g);
				g.moveTo(width / 2, 0);
				g.lineTo(width / 2, (boxMin - max) * heightScaleFactor);
				g.moveTo(width / 2, (boxMax - max) * heightScaleFactor);
				g.lineTo(width / 2, height);
			}
		}
		else
		{
			fill = GraphicsUtilities.fillFromStyle(getStyle("declineFill"));
			var declineFill:IFill =
				GraphicsUtilities.fillFromStyle(getStyle("fill"));
			
			rc = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
			
			g.clear();		
			g.moveTo(width, 0);
			if (fill)
				fill.begin(g, rc);
			g.lineStyle(0, 0, 0);
			g.lineTo(0, height);			
			if (boxStroke)
				boxStroke.apply(g);
			g.lineTo(0, 0);
			g.lineTo(width, 0);
			if (fill)
				fill.end(g);
			if (declineFill)
				declineFill.begin(g, rc);
			g.lineTo(width, height);
			g.lineTo(0, height);
			g.lineStyle(0, 0, 0);
			g.lineTo(width, 0);			
			if (declineFill)
				declineFill.end(g);
		}
	}
}

}
