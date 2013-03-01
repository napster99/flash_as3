package com
{
	import mx.charts.GridLines;

	public class MinuteGridLines extends GridLines
	{
		public function MinuteGridLines()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
												  
	    {
	    	super.updateDisplayList(unscaledWidth,unscaledHeight);
	    }
		
	}
}