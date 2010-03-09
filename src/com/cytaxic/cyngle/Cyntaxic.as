
/*/****************************************************************************************************************

	CYNTAXIC FRAMEWORK
	VERSION: 0.0.1
	ACTIONSCRIPT VERSION: 3.0

	AUTHOR: Robert Abramski
	WEBSITE: http://www.robertabramski.com/
	
	BUG LIST:
	
	TO DO:
	- Command stack for undo and redo functionality
	- Redraw on resize functionality
	- Preloader functionality using Frame metatag
	- Deep linking
	- Focus manager
	- Tooltips on all views
	- HTML title control
	
	CORE GOALS:
	- Less abstraction
	- Less code written for same result
	- More dependence on the controller
	- Works well extending Flash graphics
	- Common tasks built right in
	- Debugging built in
	- Strong typing with value objects
	- Comes with many utilities out of the box
	- Static access to top level objects anywhere
	- Function as good as possible with code hinting

******************************************************************************************************************/

package com.cytaxic.cyngle
{
	import com.cytaxic.cyngle.controller.CynController;
	import com.cytaxic.cyngle.controller.enums.ErrorCodes;
	import com.cytaxic.cyngle.controller.vos.ErrorCodeVO;
	import com.cytaxic.cyngle.model.CynModel;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	
	public class Cyntaxic
	{
		private static var _INSTANCE:Cyntaxic;
		private static var _STAGE:Stage;
		private static var _ROOT:DisplayObject;
		private static var _FLASH_VARS:FlashVars;
		private static var _DEBUGGER:Debugger;
		private static var _DEBUG:Boolean = true;
		private static var _DEEP_DEBUG:Boolean = false;
		private static var _MODEL:CynModel;
		private static var _CONTROLLER:CynController;
		private static var _CONTEXT_MENU:ContextMenu;
		private static var _VERSION:String;
		
		public function Cyntaxic(key:Key, doc:DisplayObject, model:CynModel, controller:CynController, debug:Boolean = true)
		{
			_VERSION = model.version.number;
			
			trace(this + " Started version " + _VERSION + ".");
			
			STAGE = doc.stage;
			ROOT = doc;
			
			DEBUGGER = new Debugger(debug);
			DEBUG = debug;
			
			MODEL = model.init();
			CONTROLLER = controller.init();
			
			FLASH_VARS = new FlashVars(doc.root.loaderInfo.parameters);
			CONTEXT_MENU = new BasicContextMenu().getMenu();
		}
		
		public static function init(doc:DisplayObject, model:CynModel, controller:CynController, debug:Boolean = true):Cyntaxic
		{
			_INSTANCE = new Cyntaxic(new Key, doc, model, controller, debug);
			return _INSTANCE;
		}
		
		public static function get VERSION():String
		{
			return _VERSION;
		}
		
		public static function get STAGE():Stage 
		{
			return _STAGE;
		}
		
		public static function set CONTEXT_MENU(value:ContextMenu):void
		{
			_ROOT["contextMenu"] = value;
		}
		
		public static function set FULL_SCALE_FLASH(value:Boolean):void
		{
			if(value)
			{
				_STAGE.align = StageAlign.TOP_LEFT;
				_STAGE.scaleMode = StageScaleMode.NO_SCALE;
				
				_STAGE.addEventListener(Event.RESIZE, redrawViews);
			}
			else
			{
				_STAGE.align = "";
				_STAGE.scaleMode = StageScaleMode.SHOW_ALL;
				
				_STAGE.removeEventListener(Event.RESIZE, redrawViews);
			}
		}

		public static function set STAGE(value:Stage):void
		{
			if(!_STAGE) _STAGE = value;
			else throwError(ErrorCodes.E_5000);
		}

		public static function get ROOT():DisplayObject
		{
			return _ROOT;
		}

		public static function set ROOT(value:DisplayObject):void
		{
			if(!_ROOT) _ROOT = value;
			else throwError(ErrorCodes.E_5000);
		}

		public static function get FLASH_VARS():FlashVars
		{
			return _FLASH_VARS;
		}

		public static function set FLASH_VARS(value:FlashVars):void 
		{
			if(!_FLASH_VARS) _FLASH_VARS = value;
			else throwError(ErrorCodes.E_5000);
		}
		
		public static function get DEBUGGER():Debugger
		{
			return _DEBUGGER;
		}
		
		public static function set DEBUGGER(value:Debugger):void
		{
			if(!_DEBUGGER) _DEBUGGER = value;
			else throwError(ErrorCodes.E_5000);
		}
		
		public static function get DEBUG():Boolean 
		{
			return _DEBUG;
		}

		public static function set DEBUG(value:Boolean):void 
		{
			_DEBUG = DEBUGGER.debug = value;
		}

		public static function get DEEP_DEBUG():Boolean 
		{
			return _DEEP_DEBUG;
		}

		public static function set DEEP_DEBUG(value:Boolean):void 
		{
			_DEEP_DEBUG = DEBUGGER.deepDebug = value;
		}
		
		public static function get MODEL():CynModel
		{
			return _MODEL;
		}
		
		public static function set MODEL(value:CynModel):void 
		{
			if(!_MODEL) _MODEL = value;
			else throwError(ErrorCodes.E_5000);
		}
		
		public static function get CONTROLLER():CynController
		{
			return _CONTROLLER;
		}
		
		public static function set CONTROLLER(value:CynController):void 
		{
			if(!_CONTROLLER) _CONTROLLER = value;
			else throwError(ErrorCodes.E_5000);
		}
		
		private static function throwError(error:ErrorCodeVO):void
		{
			_CONTROLLER.execute(CyntaxicHandles.THROW_ERROR, error);
		}
		
		private static function redrawViews(event:Event):void
		{
			_CONTROLLER.execute(CyntaxicHandles.REDRAW_VIEWS, null, true);
		}
	}
}

internal dynamic class FlashVars extends Object
{
	public var vars:Object;
	
	public function FlashVars(vars:Object)
	{
		this.vars = vars;
		
		for(var prop:String in vars)
		{
			this[prop] = vars[prop];
		}
		
		com.cytaxic.cyngle.Cyntaxic.DEBUGGER.log(this, "Loaded: " + describe());
	}
	
	public function describe():String
	{
		var description:String = "{";
		
		for(var param:String in vars)
		{
			description += param + ":" + vars[param] + ", ";
		}
		
		description += "}";
		description = description.replace(", }", "}");
		
		return description;
	}
	
	public function getVarByName(varName:String):Object
	{
		return vars[varName];
	}
} 

internal class Debugger
{
	public var debug:Boolean;
	public var deepDebug:Boolean;
	
	public function Debugger(debug:Boolean, deepDebug:Boolean = false)
	{
		this.debug = debug;
		this.deepDebug = deepDebug;
		
		if(debug) this.log(this, "Debug: " + debug + ". Deep debug: " + deepDebug + ".");
	}
	
	public function log(messenger:Object, message:String):void
	{
		if(debug) trace(messenger + " " + message);
	}
}

internal class BasicContextMenu
{
	private var cm:flash.ui.ContextMenu; 
	
	public function BasicContextMenu()
	{
		cm = new flash.ui.ContextMenu();
		cm.hideBuiltInItems();
	}
	
	public function getMenu():flash.ui.ContextMenu
	{
		return cm;
	}
}

internal class Key { }

