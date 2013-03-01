package com
{

import mx.charts.HitData;
import mx.charts.chartClasses.HLOCSeriesBase;
import com.KchartItemRenderer;
import mx.charts.series.items.HLOCSeriesItem;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;
import mx.charts.chartClasses.GraphicsUtilities;

use namespace mx_internal;

[Style(name="declineFill", type="mx.graphics.IFill", inherit="no")]
[Style(name="fill", type="mx.graphics.IFill", inherit="no")]
[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
[Style(name="boxStroke", type="mx.graphics.IStroke", inherit="no")]
[Style(name="dstroke", type="mx.graphics.IStroke", inherit="no")]
[Style(name="dboxStroke", type="mx.graphics.IStroke", inherit="no")]
public class KchartSeries extends HLOCSeriesBase
{
	private static var stylesInited:Boolean = initStyles();	

	private static function initStyles():Boolean
	{
		HaloDefaults.init();

		var KchartSeriesStyle:CSSStyleDeclaration =
			HaloDefaults.createSelector("KchartSeries");

		KchartSeriesStyle.defaultFactory = function():void
		{
			this.boxStroke = new Stroke(0, 0);
			this.declineFill = new SolidColor(0);
			this.fill = new SolidColor(0xFFFFFF);
			this.itemRenderer = new ClassFactory(KchartItemRenderer);
			this.stroke = new Stroke(0, 0);
		}

		return true;
	}

	public function KchartSeries()
	{
		super();
	}

	override public function findDataPoints(x:Number,y:Number,sensitivity:Number):Array
	{
		if (interactive == false)
			return [];
			
			
		
		var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
		var minItem:HLOCSeriesItem;		

		var len:uint = _renderData.filteredCache.length;
		var i:uint;
		
		for (i=0;i<len;i++)
		{
			var v:HLOCSeriesItem = _renderData.filteredCache[i];
			
			var dist:Number = Math.abs((v.x + _renderData.renderedXOffset) - x);
			if (dist > minDist)
				continue;
				
				

			var lowValue:Number = Math.max(v.low,Math.max(v.high,v.close));
			var highValue:Number = Math.min(v.low,Math.min(v.high,v.close));
			if(!isNaN(v.open)) 
			{
				lowValue = Math.max(lowValue,v.open);
				highValue = Math.min(highValue,v.open);
			}

			if (highValue - y > sensitivity)
				continue;

			if (y - lowValue > sensitivity)
				continue;

				
			minDist = dist;
			minItem = v;
			if (dist < _renderData.renderedHalfWidth)
			{
				// we're actually inside the column, so go no further.
				break;
			}
		}

		if (minItem != null)
		{
			var ypos:Number = (minItem.open + minItem.close)/2;
			var id:uint = minItem.index;
			var hd:HitData = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
			var f:Object = getStyle("declineFill");
			
			hd.contextColor = GraphicsUtilities.colorFromFill(f);
			
			hd.dataTipFunction = formatDataTip;
			return [hd];
		}
		return [];
	}
}

}
