package 
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import tools.Draw;
	import tools.Global;
	
	import util.MainUtils;

	/**
	 * ...
	 * @author Ofeng (Tools -> Custom Arguments...)
	 */
	public class MinuteChart extends Sprite 
	{
		private var  _CHARTX:Number = 44;
		private var  _CHARTX_R:Number = 5;
		private var  _CHARTY:Number = 4;
		private var  _CHARTY_D:Number = 15;
		private var  _CHART_GAP:Number = 5;
		
		private var  _GRIDH:Number = 15;
		
		public var chartW:Number;
		public var lChartH:Number;
		
		private var li:int;
		private var ci:int;
		
        private var _forceMid:Boolean;
		private var _fsData:Array;
		private var _xData:Array;
		private var _max:Number;
		private var _min:Number;
		private var _mid:Number;
        private var _fields:Array;
        private var _colors:Array;
        private var _texts:Array;
        private var _tipTexts:Array;
        private var _unitStr:String;
		
		private var allPoints:Array  = new Array();
		private var lines:Sprite  = new Sprite();
		private var labels:Sprite = new Sprite();
		private var annotation:Sprite = new Sprite();
        private var timeLbl:Sprite = null;
		
		private var _w:Number;
		private var _h:Number;
		private var txtFormat:TextFormat;
        
        private var tip:Sprite;
		
		private static var _timeTips:Array = ["09:30","11:30","15:00"];
		
		public function set timeTips(value:Array):void
		{
			_timeTips = value;
		}
		
		public function get timeTips():Array
		{
			return _timeTips;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if(isNaN(value)) return;
			_CHARTX = value;
		}
		
		public function get paddingLeft():Number
		{
			return _CHARTX;
		}
		
		public function set paddingRight(value:Number):void
		{
			if(isNaN(value)) return;
			_CHARTX_R = value;
		}
		
		public function get paddingRight():Number
		{
			return _CHARTX_R;
		}
		
		public function set paddingTop(value:Number):void
		{
			if(isNaN(value)) return;
			_CHARTY = value;
		}
		
		public function get paddingTop():Number
		{
			return _CHARTY;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if(isNaN(value)) return;
			_CHARTY_D = value;
		}
		
		public function get paddingBottom():Number
		{
			return _CHARTY_D;
		}
		
		public function MinuteChart(x:Number,y:Number,w:Number,h:Number) 
		{	
			this.x = x;
			this.y = y;
			this._w = w;
			this._h = h;
			this.chartW = _w - (_CHARTX+_CHARTX_R);
		}
        
        private function showTip(data:Array, x:Number):void
        {
            if(!tip){
                tip = new Sprite();
                addChild(tip);
            }
            setChildIndex(tip, numChildren - 1);
            var g:Graphics =  tip.graphics;
            g.clear();
            for(var idx:int = tip.numChildren - 1; idx >= 0; idx--){
                tip.removeChildAt(idx);
            }
            tip.visible = true;
            var timeT:TextField = MainUtils.createTextField(0x000000, 12);
            var date:String;
            if( _timeTips.length > 5 ){
                date = data[ 0 ].substr( 0, 2 ) + '月' + data[ 0 ].substr( 3, 2 ) + '日';
            } else {
                date = data[ 0 ]
            }
            timeT.text = '时间: ' + date;
            timeT.x = 5;
            timeT.y = 5;
            tip.addChild(timeT);
            var textY:Number = 30;
            tip.y = _CHARTY + 40;
            
            var w:Number = 0;
            for(var i:int = 0, len:int = _fields.length; i < len; i++){
                var fidx:int = _fields[i];
                var v:Number = Number(data[i+1]);
                var str:String = _tipTexts[fidx]+': '+( isNaN(v) ? '-' : v.toFixed(2) );
                var text:TextField = MainUtils.createTextField(_colors[fidx], 12);
                text.text = str + ' ' + _unitStr;
                text.y = textY;
                text.x = 5;
                textY += 22;
                tip.addChild(text);
                w = Math.max(w, text.width);
            }
            g.lineStyle(1, 0xb4b4b4);
            g.beginFill(0xffffff, 1);
            g.drawRect(0, 0, w + 10, textY);
            g.endFill();
//            timeT.x = (w + 10 - timeT.width)/2;
            if( x < _CHARTX + chartW/2 ){
                tip.x = _CHARTX + chartW - tip.width - 10;
            }else{
                tip.x = _CHARTX + 10;
            }
        }
		
		public function set gridHeight(value:Number):void
		{
			if(isNaN(value) || value < 10) return;
			_GRIDH = value;
		}
        
        public function checkMidMaxMin():void
        {
            if(!_forceMid){
                return;
            }
            var upDiff:Number = _max - _mid;
            var dnDiff:Number = _mid - _min;
            if(upDiff > dnDiff){
                _min = _mid - upDiff;
            }else if(dnDiff > upDiff){
                _max = _mid + dnDiff;
            }
        }
		
		public function drawGrid():void
		{
            lChartH = _h - (_CHARTY+_CHARTY_D);
			graphics.lineStyle(1,0xb3b3b3,1);
//			graphics.beginFill(0xFFFFFF);
            graphics.moveTo( _CHARTX, _CHARTY );
            graphics.lineTo( _CHARTX, _CHARTY + lChartH );
            graphics.lineTo( _CHARTX + _w - (_CHARTX+_CHARTX_R), _CHARTY + lChartH );
            graphics.lineTo( _CHARTX + _w - (_CHARTX+_CHARTX_R), _CHARTY );
//			graphics.drawRect(_CHARTX, _CHARTY, _w - (_CHARTX+_CHARTX_R), lChartH);
//			graphics.endFill();
            
            checkMidMaxMin();
			
			li = lChartH / (2*_GRIDH);
			drawGridLine("v", _timeTips.length, _CHARTX, _CHARTY, _w - (_CHARTX + _CHARTX_R), lChartH, true);
			
			drawGridLine("h", 2 * li, _CHARTX, _CHARTY, _w - (_CHARTX+_CHARTX_R), lChartH, true);
			
			if(annotation){
				var g:Graphics = annotation.graphics;
				g.clear();
				g.beginFill(0xFF0000,0);
				g.drawRect(0,0,_w,_h);
				g.endFill();
			}
			
			//annotation.hitArea = lines;
			//lines.mouseEnabled = false;
			annotation.addEventListener(MouseEvent.MOUSE_MOVE, showInfo);
            annotation.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent){
                hideTip();
            });
			
			addChild(lines);
			addChild(labels);
			addChild(annotation);
			
			lines.graphics.clear();//清空线
			Global.removeChildrenAll(labels);
            addLogo();
		}
		
        private function addLogo():void
        {
            var textF:TextField = new TextField();
            var textFormate:TextFormat = new TextFormat();
            textFormate.color = 0x999999;
            textFormate.size = 15;
            textF.text = '基于同花顺LEVEL-2';
            textF.setTextFormat( textFormate );
            textF.autoSize = TextFieldAutoSize.RIGHT;
            textF.y = 5;
            textF.x = stage.stageWidth - textF.textWidth - 10;
            addChild( textF );
            setChildIndex( textF, 0 );
        }
        
		public function resize(w:Number, h:Number):void
		{
			this._w = w;
			this._h = h;
			this.chartW = _w - (_CHARTX+_CHARTX_R);
		}
		
		public function get fsData():Array
		{
			return _fsData;
		}
		
		public function set fsData(value:Array):void
		{
			_fsData = value;
		}
		
		public function get xData():Array
		{
			return _xData;
		}
		
		public function set xData(value:Array):void
		{
			_xData = value;
		}
		
		public function get max():Number
		{
			return _max;
		}
		
		public function set max(value:Number):void
		{
			_max = value;
		}
		
		public function get min():Number
		{
			return _min;
		}
		
		public function set min(value:Number):void
		{
			_min = value;
		}
		
		public function get mid():Number
		{
			return _mid;
		}
		
		public function set mid(value:Number):void
		{
            _mid = value;
		}
        
        public function get forceMid():Boolean
        {
            return _forceMid;
        }
        
        public function set forceMid(isF:Boolean):void
        {
            _forceMid = isF;
        }
        
        public function get fields():Array
        {
            return _fields;
        }
        
        public function set fields(fields:Array):void
        {
            if(!fields){
                fields = [];
            }
            _fields = fields.slice(0, fields.length);
        }
        
        public function get colors():Array
        {
            return _colors;
        }
        
        public function set colors(cls:Array):void
        {
            _colors = cls;
        }
        
        public function set texts(txs:Array):void
        {
            _texts = txs;
        }
        
        public function get texts():Array
        {
            return _texts;
        }
        
        public function set tipTexts(txs:Array):void
        {
            _tipTexts = txs;
        }
        
        public function get tipTexts():Array
        {
            return _tipTexts;
        }
        
        public function set unitStr(v:String):void
        {
            _unitStr = v;
        }
		
		private function drawGridLine(position:String,count:Number,chartX:Number,chartY:Number,w:Number,h:Number,centerLine:Boolean):void
		{
			var g:Graphics = this.graphics;
			var i:int, x:Number, y:Number;
			var per:Number;

			if (position == 'h') {
				per = h / count;
				for (i = 0; i <= count ; i++ ) {
					y = chartY + i * per;
					
					if (i == count / 2 && centerLine) {
						g.lineStyle(1, 0xb4b4b4, 1);
					}
					else if (i == 0 && !centerLine) {
						g.lineStyle(1, 0xb4b4b4, 1);
					}
					else {
						g.lineStyle(1, 0xb4b4b4, 0.3);
					}
					Draw.drawHDotLine(g,y,chartX,chartX+w,3,2);
				}
			}
			else 
			{
				per = w / ( count - 1 );
				var step:int = (count < 4) ? 2 : 1;
				while (lines.numChildren > 0) lines.removeChildAt(0);
				for (i = 1; i <= count ; i++ ) 
				{
					x = chartX + i * per;
					if (i == count / 2  && centerLine)
						g.lineStyle(1, 0xb4b4b4, 1);
					else
						g.lineStyle(1, 0xb4b4b4, 0.3);
					
//					Draw.drawVDotLine(g,x,chartY,chartY+h,3,2);
					//g.moveTo(x, chartY);
					//g.lineTo(x, chartY + h);
					var lbX:Number = (i-1)*step*per+_CHARTX/2;
					var alg:String = "center";

					if(i == 1){
						lbX = _CHARTX-2;
						alg = "left";
					}else if(i == count){
						lbX = (i-1)*step*per+4;
						alg = "right"
					} else {
                        alg = "center";
                    }
					lines.addChild(createLabel(_timeTips[i-1], 0x000000, lbX, chartY + h, alg,_CHARTX, true));
				}
			}
		}
        
        public function drawLine(fieldIdx:int):Array
        {
            var g:Graphics = lines.graphics;
            var i:int;
            var obj_from:Object;
            var obj_to:Object;
            var allDataLength:int = Math.max(_xData.length, _fsData.length);
            var dataLength:int = _fsData.length;
            var points:Array   = new Array(dataLength);     
            for (i = 0; i < (dataLength - 1); i++) {
                obj_from = _fsData[i]     as Array;
                obj_to   = _fsData[i + 1] as Array;
                
                //现价
                var x_from:Number = _CHARTX + chartW/(allDataLength - 1)* i;
                var x_to:Number   = _CHARTX + chartW/(allDataLength - 1)* (i + 1);
                
                var y_from:Number = lChartH + _CHARTY - ((Number(obj_from[fieldIdx + 1])-_min) /(_max - _min)) * lChartH;
                var y_to:Number   = lChartH + _CHARTY - ((Number(obj_to[fieldIdx + 1])  -_min) /(_max - _min)) * lChartH;
                
                g.lineStyle(1, _colors[_fields[fieldIdx]], 1);
                g.moveTo(x_from,y_from);
                g.lineTo(x_to, y_to);
                
                points[i] = { x:x_from, y:y_from };
                
                if (i == _fsData.length - 2) {
                    points[i + 1] = { x:x_to, y:y_to };
                }
            }
            return points;
        }
		
		public function drawFsLine():void {
			var g:Graphics = lines.graphics;
			g.clear();
			
			if (max == min)
			{
				return;
			}
            var points:Array;
            allPoints = new Array(_fields.length);
            for(var j:int = 0, len:int = _fields.length; j < len; j++){
                points = drawLine(j);
                allPoints[j] = points;
            }
		}
		
		public function drawLabels(precise:int):void
		{
			var fsLabels:Number;
			var bfbLabels:String;
			var xsLabels:String;
			var i:int;
			var y:Number;
			
			Global.removeChildrenAll(labels);
			
			var per:Number = (_max - _mid) / li;
			var perH:Number = lChartH / (2 * li);
			
			for (i = 0; i < li; i++) {
				fsLabels = _mid -(li - i) * per; 
				bfbLabels = ((_mid - fsLabels) * 100/_mid).toFixed(2) + "%";
				y = _CHARTY + lChartH - i * perH -((i==0)?10:8);
				
				labels.addChild(createLabel(fsLabels.toFixed(precise), 0x000000, 0, y, "right",_CHARTX));
				//labels.addChild(createLabel(bfbLabels, 0x00B700, chartW - _CHARTX_R, y, "left",_CHARTX_R));
			}

			for (i = li; i >= 0; i--) {
				fsLabels = _mid + (li - i) * per;
				bfbLabels = ((Number(fsLabels) - _mid) * 100 / _mid).toFixed(2) + "%";
				y = _CHARTY + lChartH - (2*li - i) * perH -((i==0)?5:8);
				labels.addChild(createLabel(fsLabels.toFixed(precise), 0x000000, 0, y, "right",_CHARTX));
				//labels.addChild(createLabel(bfbLabels, color, chartW - _CHARTX_R, y, "left",_CHARTX_R));
			}
			
		}
		
		private function createLabel(text:String, color:uint, x:Number,y:Number,align:String,w:Number, isTimeTip:Boolean=false):TextField
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.align = align;
			txtFormat.color = color;
			txtFormat.size = 12;
			txtFormat.font = "Arial";
			
			var tf:TextField = new TextField();
            if(isTimeTip){
                if(align == 'right'){
                    tf.autoSize = TextFieldAutoSize.RIGHT;
                } else if( align == 'center' ) {
                    tf.autoSize = TextFieldAutoSize.CENTER;
                } else {
                    tf.autoSize = TextFieldAutoSize.LEFT;
                }
                if(text.length > 5){
                    txtFormat.bold = true;    
                }
            }
            tf.defaultTextFormat = txtFormat;
			tf.text = text;
			tf.x = x;
			tf.y = y;
			tf.selectable = false;
			tf.width = w;
			tf.height = 18;
			
			return tf;
		}
		
		private function showInfo(e:MouseEvent):void
		{
			Global.removeChildrenAll(annotation);
			var g:Graphics = annotation.graphics;
			g.clear();
			
			g.beginFill(0xFFFFFF,0);
			g.drawRect(0,0,_w,_h);
			g.endFill();
			
			g.lineStyle(1, 0x007cc8, 1);
            
			var pos:int = isOnLine(e.stageX, e.stageY);
			if (pos >= 0 && pos <_fsData.length) {
				var obj:Object = allPoints[pos];
                g.moveTo(e.stageX, _CHARTY);
                g.lineTo(e.stageX, _h - _CHARTY_D);
                var data:Array = _fsData[pos];
                showTip(data, e.stageX);
			}
		}
		
		private function isOnLine(x:Number, y:Number):int 
		{
            if(allPoints.length <= 0){
                return -1;
            }
			var i:int;
			var len:int=allPoints[0].length;
			var chartTop:Number = _CHARTY;
			var chartLeft:Number = _CHARTX; 
			var chartW:Number = _w - (_CHARTX+_CHARTX_R); 
			var chartH:Number = lChartH;
			
			if(len > 0 && x > (chartLeft-3) && x < _w && y > (chartTop-3)){
				if(chartW <= 0){
					chartW = 1;
				}
				i = Math.round((x-chartLeft)/chartW*(_xData.length-1));
				
				if(!isNaN(i) && i>=0 && allPoints[0][i]){
					return i;
				}
			}
			return -1;
		}
		
		public function hideTip():void
		{
			if(annotation){
				Global.removeChildrenAll(annotation);
				var g:Graphics = annotation.graphics;
				g.clear();
				
				g.beginFill(0xFFFFFF,0);
				g.drawRect(0,0,_w,_h);
				g.endFill();
			}
            if(tip){
                tip.visible = false;
            }
		}
		
		public function clear():void
		{
			graphics.clear();
			if (labels)
			{
				labels.graphics.clear();
				Global.removeChildrenAll(labels);
			}
			if (lines)
			{
				lines.graphics.clear();
				Global.removeChildrenAll(lines);
			}
			hideTip();
            allPoints = [];
		}
		
		private function drawCross(e:MouseEvent):void
		{
			Global.removeChildrenAll(annotation);
			var fsLabel:String;
			var bfbLabel:String;
			
			var g:Graphics = annotation.graphics;
			g.clear();
			
			g.lineStyle(1, 0x000000, 1);
			if (e.localX > _CHARTX && e.localX < (chartW - _CHARTX_R) && e.localY > _CHARTY && e.localY < (_CHARTY + lChartH)) {
				g.moveTo(_CHARTX, e.localY);
				g.lineTo(chartW - _CHARTX_R, e.localY);
				
				g.moveTo(e.localX, _CHARTY);
				g.lineTo(e.localX, _CHARTY + lChartH);
				
				if (e.localY < (_CHARTY + lChartH)) {
					fsLabel = (_min + (_CHARTY + lChartH -e.localY) * (_max - _min) / lChartH).toFixed(2);
					
					var color:uint;
					color = (Number(fsLabel) > _mid)? 0xFF0000:0x00B700;
					color = (fsLabel == _mid.toFixed(2))? 0x000000:color;
					
					var fsText:TextField = createLabel(fsLabel, color,  0, e.localY-9, "right",_CHARTX_R);
					fsText.background = true;
					fsText.backgroundColor = 0xA9D3ED;
					fsText.border = true;
					fsText.borderColor = 0x8A8A8A;
					annotation.addChild(fsText);
					
					bfbLabel = (Math.abs(Number(fsLabel) - _mid) * 100 / _mid).toFixed(2) + '%';
					var bfbText:TextField = createLabel(bfbLabel, color,  chartW-_CHARTX, e.localY-9, "left",_CHARTX);
					bfbText.background = true;
					bfbText.backgroundColor = 0xA9D3ED;
					bfbText.border = true;
					bfbText.borderColor = 0x8A8A8A;
					annotation.addChild(bfbText);
					
				}
				
				var pos:int = int((e.localX - _CHARTX)* _xData.length / (chartW - (_CHARTX+_CHARTX_R)));
				var sjText:TextField = createLabel(_xData[pos], 0xFF0000, (e.localX - _CHARTX), (_CHARTY + lChartH), "right",_CHARTX_R);
				sjText.background = true;
				sjText.backgroundColor = 0xA9D3ED;
				sjText.border = true;
				sjText.borderColor = 0x8A8A8A;
				annotation.addChild(sjText);
			}
		}
		
	}
	
}