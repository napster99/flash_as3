package util
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.osmf.display.ScaleMode;

	public class InitUtil
	{
		public function InitUtil()
		{
		}
		
		public static function setStage(stage:Stage):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
		}
		
		public static function setContextMenu(obj:Object):void
		{
			var menu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("hexin v1.0");
			menu.customItems.push(item);
			menu.hideBuiltInItems();
			obj.contextMenu = menu;
		}
	}
}