package com
{
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.ChartItem;
	import mx.charts.chartClasses.LegendData;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.styles.StyleManager;

	public class ColorColumnChartRenderer extends UIComponent implements IDataRenderer
	{
		// Array of colors to use
		// YELLOW,GREEN, RED,WHITE		
		private var colors:Array = [0xffff66,0x99CC66,0xFF0000,0xFFFFFF]; 

	    public function ColorColumnChartRenderer():void
	    {
	        super();
	    }
	    private var _chartItem:ChartItem;
	
		public function set data(value:Object):void
	    {
	        if (_chartItem == value)
	            return;
	          // setData also is executed if there is a Legend Data 
	          //defined for the chart. We validate that only chartItems are 
	          //assigned to the chartItem class. 
	        if (value is LegendData) 
	        	return;
	        _chartItem = ChartItem(value);
	        
	    }
	    
	    public function get data():Object
	    {
	        return _chartItem;
	    }

    	override protected function  updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void
    	{
			super.updateDisplayList(unscaledWidth, unscaledHeight);                        
			var rc:Rectangle = new Rectangle(0, 0, width , height );        
			var columnColor:uint;        
			var g:Graphics = graphics;
			g.clear();
			g.moveTo(rc.left,rc.top);            
			// Only if the _chartItem has data         
			if (_chartItem == null)            
				return;
			var color1:* = StyleManager.getStyleDeclaration(".klineStroke21").getStyle('color');
			var color2:* = StyleManager.getStyleDeclaration(".klineStroke22").getStyle('color');
			// Only if the _chartItem has the attributes
			if( _chartItem.item.hasOwnProperty("open") && _chartItem.item.hasOwnProperty("close")){ 
				// Choose a color based on your data          
				if ( Number(_chartItem.item.open) >= Number(_chartItem.item.close)){ 
					// Green
					g.beginFill(color1);
				}else{
					g.beginFill(color2);
				}
			}
			else             
				// WHITE            
				return;                
			// Draw the column
			g.lineTo(rc.right,rc.top);         
			g.lineTo(rc.right,rc.bottom);        
			g.lineTo(rc.left,rc.bottom);         
			g.lineTo(rc.left,rc.top);         
			g.endFill();      
		}
	}
}


