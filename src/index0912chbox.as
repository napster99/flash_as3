package 
{
    
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.system.Security;
    import flash.text.TextField;
    import flash.utils.ByteArray;
    import flash.utils.clearTimeout;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    
    import tools.Global;
    
    /**
     * 主程序
     * @author Ofeng
     */
    public class index0912chbox extends Sprite 
    {
        private var stockId:String;
        private var timeArea:String;
        private var datas:Array;
        private var fsData:Array;
        private var valMax:Number;
        private var valMin:Number;
        private var unit:int;
        private var unitStr:String;
        //昨收
        private var _midVal:Number;
        private var _forcedMidVal:Number;
        private var _forceMid:Boolean;
        private var _activeFields:Array;
        private var _colors:Array;
        private var _texts:Array;
        private var _tipsText:Array;
        private var chks:Array;
        
        private var mc:MinuteChart;
        private var _w:Number;
        private var _h:Number;
        private static const TIME_AREA:String = '0930,1130|1300,1500';
        private static const HK_TIME_AREA:String = "0930,1200|1300,1600";
        private var _timeTips_SH:Array = ["09:30","10:30","11:30","14:00","15:00"];
        /** 港股2011年3月7日起修改交易时间 **/
        private var _timeTips_HK:Array = ["09:30","12:00","16:00"];
        private var _chartPadding:Array;
        private var _chartGridH:Number;
        private var _flashVars:Object;
        
        //分时上下的间隙
        private static const GAP:Number = 5;
        
        private var bgTxt:TextField;
        
        public function index0912chbox():void 
        {
			trace(111);
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
			trace(222);
        }
        
        private function init(e:Event = null):void 
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            // entry point
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            //Security.allowInsecureDomain("*.10jqka.com.cn");
            Security.allowDomain("*");
            Security.allowInsecureDomain("*");
            
            var flashVars:Object = LoaderInfo(root.loaderInfo).parameters;
            _flashVars = flashVars;
            stockId = flashVars.stockid;
            if (!stockId) stockId = '';
            
            timeArea = flashVars.timearea;
            if (!timeArea) timeArea = TIME_AREA;
            
            _w = stage.stageWidth;
            _h = stage.stageHeight;
            
            if (flashVars.w)
                _w = Number(flashVars.w);
            
            if (flashVars.h)
                _h = Number(flashVars.h);
            
            _forceMid = flashVars.forceMid == 'true';
            
            if(_forceMid && flashVars.midVal){
                _midVal = flashVars.midVal;
                _forcedMidVal = _midVal;
            }
            
            if(flashVars.colors)
                _colors = flashVars.colors.split(',');
            if(flashVars.texts){
                _texts  = flashVars.texts.split(',');
            }
            if(flashVars.tips){
                _tipsText = flashVars.tips.split(',');
            }
            unit = Number(flashVars.unit) || 1;
            unitStr = flashVars.unitStr || '';
            
            if(flashVars.padding)
            {
                _chartPadding = flashVars.padding.split(" ");
            }
            
            if(flashVars.gridH)
            {
                _chartGridH = parseInt(flashVars.gridH);
            }
            
            var chartTop:Number = 0;
            var chartH:Number = _h - 20;
            
            mc = new MinuteChart(0, chartTop, _w, chartH);
            addChild(mc);
            
            if(!isNaN(_chartGridH))
            {
                mc.gridHeight = _chartGridH;
            }
            //设置chart padding
            if(_chartPadding is Array && _chartPadding.length > 0)
            {
                switch(_chartPadding)
                {
                    case 1:
                        mc.paddingTop = parseInt(_chartPadding[0]);
                        mc.paddingRight = parseInt(_chartPadding[0]);
                        mc.paddingBottom = parseInt(_chartPadding[0]);
                        mc.paddingLeft = parseInt(_chartPadding[0]);
                        break;
                    case 2:
                        mc.paddingTop = parseInt(_chartPadding[0]);
                        mc.paddingRight = parseInt(_chartPadding[0]);
                        mc.paddingBottom = parseInt(_chartPadding[1]);
                        mc.paddingLeft = parseInt(_chartPadding[1]);
                        break;
                    case 4:
                    default:
                        mc.paddingTop = parseInt(_chartPadding[0]);
                        mc.paddingRight = parseInt(_chartPadding[1]);
                        mc.paddingBottom = parseInt(_chartPadding[2]);
                        mc.paddingLeft = parseInt(_chartPadding[3]);
                        break;
                }
            }
            
            //变灰
            //var mat:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
            //var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
            //this.filters = [colorMat];
            
            //防止伪安全水箱问题, 延迟请求及申明
            setTimeout(delayLoad, 500);
        }
        
        /*
        public function drawCheckBox():void
        {
            if(chks && chks.length){
                return;
            }
            chks = [];
            var x:Number = 0;;
            for(var i:int = 0,len:int = _texts.length; i < len; i++){
                var chk:CheckBox = new CheckBox();
                chk.y = _h - 20;
                chk.x = x;
                var fmt1:TextFormat = chk.getStyle('textFormat') as TextFormat;
                if(!fmt1) fmt1 = new TextFormat();
                fmt1.size = 12;
                fmt1.color = _colors[i];
                chk.setStyle('textFormat',fmt1);
                chk.label = _texts[i];
                chk.width = 22 + _texts[i].length*14;
                addChild(chk);
                chks.push(chk);
                x += chk.width;
                chk.addEventListener(MouseEvent.CLICK,chkClickHandler);
            }
        }
        */
        
        private function chkClickHandler(e:MouseEvent):void
        {
            var fields:Array = [];
            for(var i:int = 0,len:int = chks.length; i < len; i++){
                if(chks[i].selected){
                    fields.push(i);
                }
            }
            handleFields(fields);
            for(var j:int = 0,jlen:int = chks.length; j < jlen; j++){
                chks[j].selected = _activeFields.indexOf(j) >= 0;
            }
            handleData();
        }
        
        /**
         * 防止伪安全水箱问题, 延迟请求及申明
         */
        private function delayLoad():void
        {
            
            ExternalInterface.addCallback("sendData", sendData);
            ExternalInterface.call(ExternalInterface.objectID + "Ready");
        }
        
        private function handleFields(fields:Array):void
        {
            fields = fields || [];
            if(fields.length <= 0){
                _activeFields = _activeFields;
            }else{
                _activeFields = fields;
                for(var j:int = 0, jlen:int = _activeFields.length; j < jlen; j++){
                    _activeFields[j] = Number(_activeFields[j]);
                }
            }
        }
        
        public function sendData(data:String, fields:Array = null):void
        {
            fields = fields || [0];
            handleFields(fields);
            /*
            drawCheckBox();
            for(var i:int = 0,len:int = chks.length; i < len; i++){
                chks[i].selected = _activeFields.indexOf(i) >= 0;
            }
            */
            setStringData(data);
        }
        
        private function clear():void
        {
            mc.clear();
        }
        
        private function isCorrectTime(time:String,isGg:Boolean):Boolean
        {
            time = time.replace(":", "");
            if(isGg)
                return (Number(time) >= Number(_timeTips_HK.startTime)&&Number(time) <= Number(_timeTips_HK.endTime))
            else
                return (Number(time) >= Number(_timeTips_SH.startTime)&&Number(time) <= Number(_timeTips_SH.endTime))
        }
        
        private function loadDataHandler(event:Event):void
        {
            var loader:URLLoader = URLLoader(event.target);        
            var ba:ByteArray = loader.data;
            ba.uncompress();
            
            var s:String = ba.toString();
            setStringData(s);
        }
        
        /**
         * 设置字符串数据
         * @param	String	data
         */
        public function setStringData(s:String):void
        {
            var stockArr:Array = s.split('|');
            if(stockArr.length > 0 && stockArr[stockArr.length - 1].length < 5){
                stockArr.length--;
            }
            datas = [];
            for (var i:int = 1, len:int = stockArr.length; i < len; i++){
                datas.push( stockArr[i].split(';') );
            }
            handleData();
        }
        
        
        private function getTimeTips():Array
        {
            var tips:Array = [];
            if( _flashVars.isFenShi == 'true' ){
                if (Global.isGg(stockId)){
                    tips = _timeTips_HK;
                }else{
                    tips = _timeTips_SH;
                }
            } else {
                var dis:Number = datas.length / ( ( _flashVars.xLabelCount || 9 ) - 1 );
                tips.push( datas[ 0 ][ 0 ] );
                for( var i:int = 0; i < ( _flashVars.xLabelCount || 9 ) - 2; i++ ){
                    tips.push( datas[ Math.round( i * dis ) ][ 0 ] );
                }
                tips.push( datas[ datas.length - 1 ][ 0 ] );
            }
            return tips;
        }
        
        public function handleData():void
        {
            clear();
            
            valMax = Number.NEGATIVE_INFINITY;
            valMin = Number.POSITIVE_INFINITY;
            
            fsData = [];
            var isGg:Boolean = Global.isGg(stockId);
            var val:Number, j:int, itemData:Array, fldIdx:int, fLen:int = _activeFields.length; 
            for (var i:int = 0, len:int = datas.length; i < len; i++) 
            {
                itemData = [datas[i][0]];
                for(j = 0; j < fLen; j++){
                    fldIdx = _activeFields[j] + 1;
                    val = Number(datas[i][fldIdx]);
                    itemData.push(val/unit);
                    if (valMax < val) valMax = val;
                    if (valMin > val) valMin = val;
                }
                fsData.push(itemData);
            }
            
            valMax  = Math.ceil(valMax/unit);
            valMin  = Math.floor(valMin/unit);
            if(!_forceMid){
                _midVal = (valMax + valMin)/2;
            }else{
                _midVal = _forcedMidVal/unit;
            }
            
            if (Global.isGg(stockId)){
                timeArea    = HK_TIME_AREA;
            }else{
                timeArea    = TIME_AREA;
            }
            mc.timeTips = getTimeTips();
            
            if (fsData.length >1)
            {
                mc.colors  = _colors;
                mc.texts   = _texts;
                mc.tipTexts= _tipsText;
                mc.forceMid= _forceMid;
                mc.max     = valMax;
                mc.min     = valMin;
                mc.unitStr = unitStr;
                mc.mid     = _midVal;
                mc.fields  = _activeFields;
                mc.xData   = initxdata();
                mc.fsData  = fsData;
                mc.drawGrid();
                mc.drawLabels(0);
                mc.drawFsLine();
            }
            else
                mc.drawGrid();
            
            ExternalInterface.call(ExternalInterface.objectID + "DataReady");
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void 
        {
            mc.drawGrid();
        }
        
        private function initxdataNormal(timeArea:String):Array
        {
            var xdata:Array = new Array();
            var i:int;
            if( _flashVars.isFenShi == 'true' ){
                var times:Array = timeArea.split("|");
                var sm:int = 0;
                var em:int = 59;
                
                for ( i = 0; i < times.length; i++)
                {
                    var range:Array = times[i].toString().split(",");
                    
                    var start_h:int = int(Number(range[0])/100);
                    var start_m:int = int(Number(range[0])%100);
                    
                    var end_h:int = int(Number(range[1])/100);
                    var end_m:int = int(Number(range[1])%100);
                    
                    for (var j:int = start_h; j <= end_h; j++ )
                    {
                        if(j == end_h){
                            sm = 0;
                            em = end_m;
                        }else if(j == start_h){
                            sm = start_m;
                            em = 59;
                        }else{
                            sm = 0;
                            em = 59;
                        }
                        for (var k:int = sm; k <= em; k++)
                        {
                            var xh:String = (j<10)? '0'+j.toString() : j.toString();
                            var xm:String = (k<10)? '0'+k.toString() : k.toString();
                            var xitem:String=xh+":"+xm;
                            xdata.push(xitem);
                        }
                    }
                }
            } else {
                for( i = 0; i < datas.length; i++ ){
                    xdata.push( datas[ i ][ 0 ] );
                }
            }
            return xdata;
        }
        
        //初始化x坐标标签
        private function initxdata():Array
        {
            return initxdataNormal(timeArea);
        }
        
        private function formatMoney(value:Number):String
        {
            if (isNaN(value)) return "";
            if (value >= 100000000)
            {
                return (value / 100000000).toFixed(2)+"亿";
            }
            if (value >= 10000)
            {
                return (value / 10000).toFixed(2)+"万";
            }
            return value.toFixed(2);
        }
    }
}
