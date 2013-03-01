package com
{
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	import mx.charts.ChartItem;
	

	import mx.charts.ColumnChart;
	import mx.charts.chartClasses.LegendData;



	public class MacdRenderer extends UIComponent implements IDataRenderer
	{
		// Array of colors to use
		// YELLOW,GREEN, RED,WHITE		
		private var colors:Array = [0xffff66,0x99CC66,0xFF0000,0xFFFFFF]; 

	    public function MacdRenderer():void
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
		

	                                            
    override protected function  updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void    {
			super.updateDisplayList(unscaledWidth, unscaledHeight);                        
			var rc:Rectangle = new Rectangle(0, 0, width , height );        
			var columnColor:uint;        
			var g:Graphics = graphics;         
			g.clear();                
			g.moveTo(rc.left,rc.top);            
			// Only if the _chartItem has data         
			if (_chartItem == null)            
				return;            
			// Only if the _chartItem has the attributes         
			if( _chartItem.item.hasOwnProperty("open") && _chartItem.item.hasOwnProperty("close")){ 
				// Choose a color based on your data          
				if ( Number(_chartItem.item.macd) >= 0 ) { 
					// Green 
					g.lineStyle(0,0xFF0000,1)                     
				}          
				else              
					// WHITE           
					g.lineStyle(0,0x22B14C,1)
					//g.beginFill(0xFF0000);          
			}else             
				// WHITE            
				return;                
			// Draw the column    
	  
			g.lineTo(rc.left,rc.bottom);         
			g.endFill();      
		}
                              

		
	}
}


