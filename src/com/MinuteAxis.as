package com 
{

import flash.events.Event;

import mx.charts.AxisLabel;
import mx.charts.chartClasses.AxisLabelSet;
import mx.charts.chartClasses.NumericAxis;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The LinearAxis class maps numeric values evenly
 *  between a minimum and maximum value along a chart axis.
 *  By default, it determines <code>minimum</code>, <code>maximum</code>,
 *  and <code>interval</code> values from the charting data
 *  to fit all of the chart elements on the screen.
 *  You can also explicitly set specific values for these properties.
 *  
 *  <p>The auto-determination of range values works as follows:
 *
 *  <ol>
 *    <li> Flex determines a minimum and maximum value
 *    that accomodates all the data being displayed in the chart.</li>
 *    <li> If the <code>autoAdjust</code> and <code>baseAtZero</code> properties
 *    are set to <code>true</code>, Flex makes the following adjustments:
 *      <ul>
 *        <li>If all values are positive,
 *        Flex sets the <code>minimum</code> property to zero.</li>
 *  	  <li>If all values are negative,
 *        Flex sets the <code>maximum</code> property to zero.</li>
 *  	</ul>
 *    </li>
 *    <li> If the <code>autoAdjust</code> property is set to <code>true</code>,
 *    Flex adjusts values of the <code>minimum</code> and <code>maximum</code>
 *    properties by rounding them up or down.</li>
 *    <li> Flex checks if any of the elements displayed in the chart
 *    require extra padding to display properly (for example, for labels).
 *    It adjusts the values of the <code>minimum</code> and
 *    <code>maximum</code> properties accordingly.</li>
 *    <li> Flex determines if you have explicitly specified any padding
 *    around the <code>minimum</code> and <code>maximum</code> values,
 *    and adjusts their values accordingly.</li>
 *  </ol>
 *  </p>
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LinearAxis&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LinearAxis
 *    <strong>Properties</strong>
 *    interval="null"
 *    maximum="null"
 *    maximumLabelPrecision="null"
 *    minimum="null"
 *    minorInterval="null"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.chartClasses.IAxis
 *
 *  @includeExample examples/HLOCChartExample.mxml
 */
public class MinuteAxis extends NumericAxis 
{

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *	Constructor.
	 */
	public function MinuteAxis() 
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  label count
	//----------------------------------
	private var _labelCount:int;
	public function set labelCount(value:int):void
	{
		_labelCount = value;
	}
	//----------------------------------
	//  interval
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _userInterval:Number;
	
	/**
	 *  @private
	 */
	private var _numberFix:Number;
	
	public function set NumberFix(_fix:Number):void
	{
		_numberFix = _fix;
	}

	/**
	 *  @private
	 */
	private var _alignLabelsToInterval:Boolean = true;

    [Inspectable(category="General")]

	/**
	 *  Specifies the numeric difference between label values along the axis.
	 *  Flex calculates the interval if this property
	 *  is set to <code>NaN</code>.  
	 *  The default value is <code>NaN</code>.
	 */
	public function get interval():Number
	{
		return computedInterval;
	}
	
	/**
	 *  @private
	 */
	public function set interval(value:Number):void
	{
		if (value <= 0)
			value = NaN;
			
		_userInterval = value;

		computedInterval = value;
		invalidateCache();

		dispatchEvent(new Event("axisChange"));
	}
	
	/**
	* @private
	*/
	public function get alignLabelsToInterval():Boolean
	{
		return _alignLabelsToInterval;
	}
	/**
	* @private
	*/
	public function set alignLabelsToInterval(value:Boolean):void
	{
		if(value != _alignLabelsToInterval)
		{
			_alignLabelsToInterval = value;
			invalidateCache();
			dispatchEvent(new Event("mappingChange"));
			dispatchEvent(new Event("axisChange"));					
		}
	}

	//----------------------------------
	//  maximum
	//----------------------------------

    [Inspectable(category="General")]

	/**
	 *  Specifies the maximum value for an axis label.
	 *  If you set the <code>autoAdjust</code> property to <code>true</code>,
	 *  Flex calculates this value. 
	 *  If <code>NaN</code>, Flex determines the maximum value
	 *  from the data in the chart. 
	 *  The default value is <code>NaN</code>.
	 */
	public function get maximum():Number
	{
		return computedMaximum;
	}
	
	/**
	 *  @private
	 */
	public function set maximum(value:Number):void
	{
		assignedMaximum = value;
		computedMaximum = value;

		invalidateCache();

		dispatchEvent(new Event("mappingChange"));
		dispatchEvent(new Event("axisChange"));
	}

	//----------------------------------
	//  maximumLabelPrecision
	//----------------------------------

	/**
	 *  @private
	 */	
	private var _labelPrecision:Number;
	
	/**
	 *  @private
	 */
	public function get maximumLabelPrecision():Number
	{
		return _labelPrecision;
	}
	
	/**
	 *  Specifies the maximum number of decimal places for representing fractional values on the labels
	 *  generated by this axis. By default, the axis autogenerates this value from the labels themselves.
	 *  A value of 0 rounds to the nearest integer value, while a value of 2 rounds to the nearest 1/100th 
	 *  of a value.
	 */
	public function set maximumLabelPrecision(value:Number):void
	{
		_labelPrecision = value;

		invalidateCache();
	}

	//----------------------------------
	//  minimum
	//----------------------------------

    [Inspectable(category="General")]

	/**
	 *  Specifies the minimum value for an axis label.
	 *  If <code>NaN</code>, Flex determines the minimum value
	 *  from the data in the chart. 
	 *  The default value is <code>NaN</code>.
	 */
	public function get minimum():Number
	{
		return computedMinimum;
	}
	
	/**
	 *  @private
	 */
	public function set minimum(value:Number):void
	{
		assignedMinimum = value;
		computedMinimum = value;

		invalidateCache();

		dispatchEvent(new Event("mappingChange"));
		dispatchEvent(new Event("axisChange"));
	}

	//----------------------------------
	//  minorInterval
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the minorInterval property.
	 */
	private var _minorInterval:Number;

	/**
	 *  @private
	 */
	private var _userMinorInterval:Number;

    [Inspectable(category="General")]
	
	/**
	 *  Specifies the numeric difference between minor tick marks along the axis.
	 *  Flex calculates the difference if this property
	 *  is set to <code>NaN</code>.  
	 */
	public function get minorInterval():Number
	{
		return _minorInterval;
	}
	
	/**
	 *  @private
	 */
	public function set minorInterval(value:Number):void
	{
		if (value <= 0)
			value = NaN;
			
		_userMinorInterval = value;
		_minorInterval = value;

		invalidateCache();

		dispatchEvent(new Event("axisChange"));
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods: NumericAxis
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override protected function buildLabelCache():Boolean
	{
		if (labelCache)
			return false;

		labelCache = [];

		var r:Number = computedMaximum - computedMinimum;
		var zuoshou:Number = Math.round((computedMaximum + computedMinimum)*1000)/2000;
		
		var precision:Number = _labelPrecision;
		if (isNaN(precision))
		{
			var decimal:Number = Math.abs(computedInterval) -
								 Math.floor(Math.abs(computedInterval));
			
			precision =
				decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10);
			
			decimal = Math.abs(computedMinimum) -
					  Math.floor(Math.abs(computedMinimum));
			
			precision = Math.max(precision,
				decimal == 0 ? 1: -Math.floor(Math.log(decimal) / Math.LN10));
		}
		var roundBase:Number = Math.pow(10, precision);
		
		
		var k:int=0;
		var roundedValue:Number;
		
		if (labelFunction != null)
		{
			var previousValue:Number = NaN;
			
			for(var j:int=_labelCount;j>0;j--)
			{
				roundedValue = Math.round((zuoshou - computedInterval * j) * roundBase) / roundBase;
				labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, labelFunction(roundedValue, previousValue, this)));
				k++
			}	
			roundedValue = zuoshou;
			labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, labelFunction(roundedValue, previousValue, this)));
			k++;
			for(var i:int=1;i<=_labelCount;i++)
			{
				roundedValue = Math.round((zuoshou + computedInterval * i) * roundBase) / roundBase;
				labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, labelFunction(roundedValue, previousValue, this)));
				k++;
			}
			
			previousValue = roundedValue;
		}
		else{
			for(var j1:int=_labelCount;j1>0;j1--)
			{
				roundedValue = Math.round((zuoshou - computedInterval * j1) * roundBase) / roundBase;
				labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, roundedValue.toFixed(_numberFix)));
				k++
			}	
			roundedValue = zuoshou;
			labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, roundedValue.toFixed(_numberFix)));
			k++;
			for(var i1:int=1;i1<=_labelCount;i1++)
			{
				roundedValue = Math.round((zuoshou + computedInterval * i1) * roundBase) / roundBase;
				labelCache.push(new AxisLabel(k/(_labelCount*2), roundedValue, roundedValue.toFixed(_numberFix)));
				k++;
			}
		}
		return true;
	}

	/**
	 *  @private
	 */
	override public function reduceLabels(intervalStart:AxisLabel,
										  intervalEnd:AxisLabel):AxisLabelSet
	{
		// What's this calculation?
		// We're trying to figure out how many labels we need to skip.
		// If we assume that every adjacent label is 1 computedInterval apart,
		// then we can guess the ordinal distance between any two labels by
		// dividing the difference in their values by computedInterval.
		// So, what's with the round? Well, in theory, the distance
		// between any two labels is an integral number of _intervals.
		// but floating-point rounding errors, especially on small intervals,
		// can throw us off by a little bit. So we add in a round()
		// to get us back to a nice whole integer.
		var intervalMultiplier:Number = 4;
		if(computedInterval > 0)
		{
			intervalMultiplier =Math.round((Number(intervalEnd.value) -Number(intervalStart.value)) / computedInterval) + 1;
		}
		var newMinorInterval:Number = intervalMultiplier * _minorInterval;
		
		var labels:Array = [];
		var newMinorTicks:Array = [];
		var newTicks:Array = [];		

		var n:int = labelCache.length;
		for (var i:int = 0; i < n; i += intervalMultiplier)
		{
			labels.push(labelCache[i]);
			newTicks.push(labelCache[i].position);
		}		
		
		var r:Number = computedMaximum - computedMinimum;	
			
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum)/newMinorInterval) * 
			newMinorInterval;

		if(_alignLabelsToInterval)
			labelBase = Math.ceil(labelBase / newMinorInterval) * newMinorInterval;

		var labelTop:Number = computedMaximum + 0.000001

		for (var j:Number = labelBase; j <= labelTop; j += newMinorInterval)
		{
			newMinorTicks.push((j - computedMinimum) / r);
		}		

		var labelSet:AxisLabelSet = new AxisLabelSet();
		labelSet.labels = labels;
		labelSet.minorTicks = newMinorTicks;
		labelSet.ticks = newTicks;
		labelSet.accurate = true;
		return labelSet;
	}

	/**
	 *  @private
	 */
	override protected function buildMinorTickCache():Array
	{
		var cache:Array = [];

		var r:Number = computedMaximum - computedMinimum;		
		
		var labelBase:Number = labelMinimum -
			Math.floor((labelMinimum - computedMinimum) / _minorInterval) *
			_minorInterval;

		if(_alignLabelsToInterval)
			labelBase = Math.ceil(labelBase / _minorInterval) * _minorInterval;

		var labelTop:Number = computedMaximum + 0.000001;

		for (var i:Number = labelBase; i <= labelTop; i += _minorInterval)
		{
			cache.push((i - computedMinimum) / r);
		}
				
		return cache;
	}
	
	/**
	 *  @private
	 */
	override protected function adjustMinMax(minValue:Number,
											 maxValue:Number):void
	{
		var interval:Number = _userInterval;

		if (autoAdjust == false && 
			!isNaN(_userInterval) &&
			!isNaN(_userMinorInterval))
		{
			return;
		}

		// New calculations to accomodate negative values.
		// Find the nearest power of ten for y_userInterval
		// for line-grid and labelling positions.
		if (maxValue == 0 && minValue == 0)
			maxValue = 100;
		var maxPowerOfTen:Number =
			Math.floor(Math.log(Math.abs(maxValue)) / Math.LN10);
		var minPowerOfTen:Number =
			Math.floor(Math.log(Math.abs(minValue)) / Math.LN10);
		var powerOfTen:Number =
			Math.floor(Math.log(Math.abs(maxValue - minValue)) / Math.LN10)
		
		var y_userInterval:Number;
		
		if (isNaN(_userInterval))
		{
			y_userInterval = Math.pow(10, powerOfTen);

			if (Math.abs(maxValue - minValue) / y_userInterval < 4)
			{
				powerOfTen--;
				y_userInterval = y_userInterval * 2 / 10;
			}
		}
		else
		{
			y_userInterval = _userInterval;
		}

		// Bug 148745:
		// Using % to decide if y_userInterval divides maxValue evenly
		// is running into floating point errors.
		// For example, 3 % .2 == .2.
		// Multiplication and division don't seem to have the same problems,
		// so instead we divide, round and multiply.
		// If we get back to the same value, it means that either it fit evenly,
		// or the difference was trivial enough to get rounded out
		// by imprecision.
		
		var y_topBound:Number =
			Math.round(maxValue / y_userInterval) * y_userInterval == maxValue ?
			maxValue :
			(Math.floor(maxValue / y_userInterval) + 1) * y_userInterval;
		
		var y_lowerBound:Number;
		
		if (isFinite(minValue))
			y_lowerBound = 0;
		
		if (minValue < 0 || baseAtZero == false)
		{
			y_lowerBound =
				Math.floor(minValue / y_userInterval) * y_userInterval;
	
			if (maxValue < 0)
				y_topBound = 0;			
		}
		else 
		{
			y_lowerBound = 0;
		}

		// OK, we've figured out our interval.
		// If the caller wants us to lower it based on layout rules,
		// we have more to do. Otherwise, return here.
		// If the user didn't provide us with an interval,
		// we'll use the one we just generated
			
		if (isNaN(_userInterval))
			computedInterval = y_userInterval;
			
		if (isNaN(_userMinorInterval))
			_minorInterval = computedInterval / 2;
		
		// If the user wanted to us to autoadjust the min/max
		// to nice clean values, record the ones we just caluclated.
		// If the user has provided us with specific min/max values,
		// we won't blow that away here.
		if (autoAdjust)
		{
			if (isNaN(assignedMinimum))
				computedMinimum = y_lowerBound;
			
			if (isNaN(assignedMaximum))
				computedMaximum = y_topBound;
		}
	}
}

}
