﻿/*/****************************************************************************************************************	CYNTAXIC FRAMEWORK	VERSION: See Cyntaxic.VERSION	ACTIONSCRIPT VERSION: 3.0	WEBSITE: http://www.cyntaxic.com	AUTHOR: Robert Abramski	WEBSITE: http://www.robertabramski.com/******************************************************************************************************************/package com.cyntaxic.cynmvc{	import com.cyntaxic.cynccess.cynternal;	import com.cyntaxic.cynmvc.controller.CynController;	import com.cyntaxic.cynmvc.controller.enums.ErrorCodes;	import com.cyntaxic.cynmvc.controller.vos.ErrorCodeVO;	import com.cyntaxic.cynmvc.controller.vos.ResizeVO;	import com.cyntaxic.cynmvc.model.CynModel;	import com.cyntaxic.cynmvc.model.enums.Versions;	import com.cyntaxic.cynmvc.view.CynViewProxy;		import flash.display.DisplayObject;	import flash.display.Stage;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flash.events.Event;	import flash.net.URLRequest;	import flash.net.navigateToURL;	import flash.system.ApplicationDomain;	import flash.ui.ContextMenu;	import flash.ui.ContextMenuItem;	import flash.utils.describeType;
		/**	 * The Cyntaxic framework is a MVC based design pattern created to address everyday coding, 	 * while keeping it simple. Top level objects like <code>root</code> &amp; <code>stage</code> can be 	 * referenced statically from the <code>Cyntaxic</code> base class. It also comes bundled with a bunch of 	 * commonly used utility functions and a built in debugger.	 *  	 * @author robertabramski	 * 	 */	public class Cyntaxic	{		use namespace cynternal;				private static var _INSTANCE:Cyntaxic;		private static var _STAGE:Stage;		private static var _ROOT:DisplayObject;		private static var _FLASH_VARS:FlashVarsVO;		private static var _DEBUGGER:Debugger;		private static var _MODEL:CynModel;		private static var _CONTROLLER:CynController;		private static var _VERSION:String;				private static var _debug:Boolean = true;		private static var _fullScaleFlash:Boolean;		private static var _contextMenu:ContextMenu;		private static var _cmLove:Boolean;		private static var _props:Object;				/**		 * @private Use init to create singleton instance.		 * 		 */		public function Cyntaxic(key:Key, model:CynModel, controller:CynController, doc:DisplayObject = null, props:Object = null)		{			_props = props;						_MODEL = model.init();			_CONTROLLER = controller.init();						_VERSION = model.version.number;						trace(this + " Started version " + _VERSION + ".");						_DEBUGGER = new Debugger();						if(props && props.debug)			{				_DEBUGGER.log(_DEBUGGER, "Debugger is running.");				Cyntaxic.debug = props.debug;			}						if(doc) initDocument(doc);		}				/**		 * Initializes the Cyntaxic framework. 		 *  		 * @param doc The document class of the application.		 * @param model The extended <code>CynModel</code> class.		 * @param controller The extended <code>CynController</code> class.		 * @param props A object containing configuration properties for the framework.		 * @return The <code>Cyntaxic</code> singleton instance.		 * 		 * @see #initDocument()		 * 		 */		public static function init(model:CynModel, controller:CynController, doc:DisplayObject = null, props:Object = null):Cyntaxic		{			_INSTANCE = new Cyntaxic(new Key, model, controller, doc, props);			return _INSTANCE;		}				/**		 * Initializes the document class for the Cyntaxic framework if not 		 * available at the time <code>Cyntaxic.init</code> is called.		 * 		 * @param doc The document class.		 * @param props A object containing configuration properties for the framework.		 * 		 */				public static function initDocument(doc:DisplayObject, props:Object = null):void		{			if(props) _props = props;						_STAGE = doc.stage;			_ROOT = doc;						contextMenu = new BasicContextMenu(_props.cmLove ? _props.cmLove : true).getMenu();						for(var prop:String in _props)			{				Cyntaxic[prop] = _props[prop];			}						_FLASH_VARS = new FlashVarsVO(doc.root.loaderInfo.parameters);		}				/**		 * @private		 * 		 */		cynternal static function describe(object:Object, compact:Boolean = true):String		{			return ObjectDescriptor.describe(object, compact);		}				/**		 * Goes to a webpage. 		 *  		 * @param url The URL to go to.		 * @param target The window to open it in.		 * 		 */		public static function go(url:String, target:String):void		{			navigateToURL(new URLRequest(url), target);		}				/**		 * Adds a view to the framework that cannot extend <code>CynComponent</code>		 * or <code>CynComposite</code>. This allows the view to be notified by the contoller. 		 *  		 * @param view The proxy view to be added.		 * 		 */		public static function addCynViewProxy(view:DisplayObject):void		{			CynViewProxy.add(view);		}				/**		 * Removes a proxy view from notifications from the controller.		 * 		 * @param view The proxy view to be removed.		 * 		 */				public static function removeCynViewProxy(view:DisplayObject):void		{			CynViewProxy.remove(view);		}				/**		 * Returns the version number of the framework as a string.		 *  		 * @return The version number of the framework as a string. 		 * 		 */		public static function get VERSION():String		{			return _VERSION;		}				/**		 * Returns the stage instance of the application. Attempts  		 * at setting will throw an <code>CynError</code>.		 *  		 * @return The stage instance of the application.		 * 		 * @throws CynError If attempting to set.		 * 		 */		public static function get STAGE():Stage 		{			return _STAGE;		}				public static function set STAGE(value:Stage):void		{			if(!_STAGE) _STAGE = value;			else throwError(ErrorCodes.E_1000);		}		/**		 * Returns the root of the application. Attempts  		 * at setting will throw an <code>CynError</code>.		 *  		 * @return The root of the application.		 * 		 * @throws CynError If attempting to set.		 * 		 */		public static function get ROOT():DisplayObject		{			return _ROOT;		}		public static function set ROOT(value:DisplayObject):void		{			if(!_ROOT) _ROOT = value;			else throwError(ErrorCodes.E_1000);		}		/**		 * Returns FlashVars as a value object. Attempts  		 * at setting will throw an <code>CynError</code>.		 *  		 * @return FlashVars as a value object.		 * 		 * @throws CynError If attempting to set.		 * 		 */		public static function get FLASH_VARS_VO():FlashVarsVO		{			return _FLASH_VARS;		}		public static function set FLASH_VARS_VO(value:FlashVarsVO):void 		{			if(!_FLASH_VARS) _FLASH_VARS = value;			else throwError(ErrorCodes.E_1000);		}				/**		 * Returns the debugger instance. The debugger has one function, <code>log</code>		 * which takes 2 arguments. The messenger and the message. The controller and views		 * have shortcut functions for this that assume the first argument as itself. Use this		 * when the intention is to override the messenger parameter. Attempts  		 * at setting will throw an <code>CynError</code>.		 *  		 * @return The debugger instance.		 * 		 * @throws CynError If attempting to set.		 * 		 */		public static function get DEBUGGER():Debugger		{			return _DEBUGGER;		}				public static function set DEBUGGER(value:Debugger):void		{			if(!_DEBUGGER) _DEBUGGER = value;			else throwError(ErrorCodes.E_1000);		}				/**		 * Returns the extended <code>CynModel</code> instance. By 		 * convention this class should be setup as a singleton. This is a		 * pseudo constant as it only can be set once by the framework. Attempts  		 * at setting will throw a <code>CynError</code>.		 *  		 * @return The model singleton instance.		 * 		 * @throws CynError If attempting to set.		 * 		 */		public static function get MODEL():CynModel		{			return _MODEL;		}				public static function set MODEL(value:CynModel):void 		{			if(!_MODEL) _MODEL = value;			else throwError(ErrorCodes.E_1000);		}				/**		 * Returns the extended <code>CynController</code> instance. By 		 * convention this class should be setup as a singleton. This is a 		 * pseudo constant as it only can be set once by the framework. Attempts  		 * at setting will throw a <code>CynError</code>. 		 *  		 * @return The controller singleton instance.		 * 		 * @throws CynError If attempting to set.		 * 		 */				public static function get CONTROLLER():CynController		{			return _CONTROLLER;		}				public static function set CONTROLLER(value:CynController):void 		{			if(!_CONTROLLER) _CONTROLLER = value;			else throwError(ErrorCodes.E_1000);		}				/**		 * The root contextual menu.		 *  		 * @return The root contextual menu.		 * 		 */		public static function get contextMenu():ContextMenu		{			return _contextMenu;		}				public static function set contextMenu(value:ContextMenu):void		{			_ROOT["contextMenu"] = value;		}				/**		 * Sets whether or not the root contextual menu gives credit to 		 * the Cyntaxic framework.		 *  		 * @return True if credit is given otherwise false.		 * 		 */				public static function get cmLove():Boolean		{			return _cmLove;		}				public static function set cmLove(value:Boolean):void		{			_cmLove = value;			contextMenu = new BasicContextMenu(value).getMenu();		}				/**		 * Determines whether or not the application is set for liquid layout. If this 		 * is not set to true <code>CynView</code> resize functions will not fire.		 *  		 * @return True if full scale Flash is desired.  		 * 		 */		public static function get fullScaleFlash():Boolean		{			return _fullScaleFlash;		}				public static function set fullScaleFlash(value:Boolean):void		{			_fullScaleFlash = value;						if(value)			{				_STAGE.align = StageAlign.TOP_LEFT;				_STAGE.scaleMode = StageScaleMode.NO_SCALE;								_STAGE.addEventListener(Event.RESIZE, resizeViews);			}			else			{				_STAGE.align = "";				_STAGE.scaleMode = StageScaleMode.SHOW_ALL;								_STAGE.removeEventListener(Event.RESIZE, resizeViews);			}		}				private static function resizeViews(event:Event):void		{			_CONTROLLER.execute(CyntaxicHandles.RESIZE_VIEWS, new ResizeVO());		}				/**		 * Sets whether or not debugging is enabled.		 *  		 * @return True if debugging is on.		 * 		 */		public static function get debug():Boolean 		{			return _debug;		}		public static function set debug(value:Boolean):void 		{			_debug = DEBUGGER.debug = value;		}				/**		 * @private		 * 		 */		cynternal static function throwError(error:ErrorCodeVO):void		{			_CONTROLLER.execute(CyntaxicHandles.THROW_ERROR, error);		}				/**		 * @private		 * 		 */		cynternal static function execute(handle:String, vo:CyntaxicVO):void		{			_CONTROLLER.execute(handle, vo);		}	}}
import flash.utils.describeType;

internal dynamic class FlashVarsVO extends com.cyntaxic.cynmvc.CyntaxicVO{	public function FlashVarsVO(vars:Object)	{		for(var prop:String in vars)		{			this[prop] = vars[prop];		}	}} internal class Debugger{	public var debug:Boolean;		public function Debugger(debug:Boolean = true)	{		this.debug = debug;	}		public function log(messenger:Object, message:Object):void	{		if(debug) trace(messenger + " " + message);	}}internal class BasicContextMenu{	private var cm:flash.ui.ContextMenu;	private var love:flash.ui.ContextMenuItem;		public function BasicContextMenu(addLove:Boolean)	{		cm = new flash.ui.ContextMenu();		cm.hideBuiltInItems();				if(addLove)		{			love = new flash.ui.ContextMenuItem("Cyntaxic Version " + com.cyntaxic.cynmvc.Cyntaxic.VERSION, false, true);			love.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, navigateToSite);						cm.customItems = [love];		}	}		private function navigateToSite(event:flash.events.ContextMenuEvent):void	{		com.cyntaxic.cynmvc.Cyntaxic.go('http://www.cyntaxic.com', '_blank');	}		public function getLove():flash.ui.ContextMenuItem	{		return love;	}		public function getMenu():flash.ui.ContextMenu	{		return cm;	}}internal class Key { }internal class ObjectDescriptor {	private static var level:int = 1;	public static var maxLevel:int = 100;		private static const ERROR_MAX_LEVELS:String = "The max level of " + maxLevel + " has been exceeded. Data trucated.";	private static const SEV_ERR:String = "error";	private static const SEV_WARN:String = "warning";		public static function describe(object:Object, compact:Boolean):String	{		return compact ? convertToString(object) : format(convertToString(object));	}		private static function format(val:String):String	{		var formatted:String = '';		var str:String = val;		var pos:int = 0;		var strLen:int = str.length;		var indentStr:String = '\t';		var newLine:String = '\n';		var char:String = '';		var inString:Boolean = false;				for(var i:int = 0; i < strLen; i++) 		{			char = str.substring(i, i + 1);						if(char == '"' && !inString) inString = true;			else if(char == '"' && inString) inString = false;						if(char == '}' || char == ']')			{				if(!inString) formatted = formatted + newLine;				pos = pos - 1;								for(var j:int = 0; j < pos; j++) 				{					if(!inString) formatted = formatted + indentStr;				}			}						formatted = formatted + char;						if(char == '{' || char == '[' || char == ',')			{				if(!inString) formatted = formatted + newLine;								if(char == '{' || char == '[')				{					pos = pos + 1;				}								for(var k:int = 0; k < pos; k++)				{					if(!inString) formatted = formatted + indentStr;				}			}						if(char == ':')			{				var nextChar:String = str.substring(i + 1, i + 2);				var tokenIsNext:Boolean = (nextChar == '{' || nextChar == '[');								if(!inString && tokenIsNext) formatted = formatted + newLine;								for(var l:int = 0; l < pos; l++)				{					if(!inString && tokenIsNext) formatted = formatted + indentStr;				}			}		}				return newLine + formatted;	}		private static function convertToString(value:Object):String 	{		switch(true)		{			case (value is String): 					return escapeString(value as String);			case (value is Number): 					return isFinite(value as Number) ? value.toString() : "null";			case (value is Function): 					return escapeString(value.toString());			case (value is Boolean):					return value ? "true" : "false";			case (value is Array):						return arrayToString(value as Array);			case (value is XML):						return escapeString(value.toString());			case (value is XMLList):					return escapeString(value.toString());			case isXMLListCollection(value):			return collectionToString(value);			case isArrayList(value):					return collectionToString(value);			case isArrayCollection(value):				return collectionToString(value);			case (value is Object && value != null):	return level < maxLevel ? objectToString(value) : errorString(SEV_ERR, ERROR_MAX_LEVELS);						default: 									return "null";		}	}		private static function isArrayList(object:Object):Boolean	{		var type:XML = flash.utils.describeType(object);		var className:String = "mx.collections::ArrayList";				if(type.@name == className || type.@base == className) return true;				return false;	}		private static function isXMLListCollection(object:Object):Boolean	{		var type:XML = flash.utils.describeType(object);		var className:String = "mx.collections::XMLListCollection";				if(type.@name == className || type.@base == className) return true;				return false;	}		private static function isArrayCollection(object:Object):Boolean	{		var type:XML = flash.utils.describeType(object);		var className:String = "mx.collections::ArrayCollection";				if(type.@name == className || type.@base == className) return true;				return false;	}		private static function collectionToString(o:Object):String 	{		var s:String = "";		var classInfo:XML = flash.utils.describeType(o);		var className:String = classInfo.@name;		var baseClass:String = classInfo.@base;				for(var i:int = 0; i < o.source.length; i++)		{			if(s.length > 0) s += ","; 						if(o.source[i] is XML || o.source[i] is XML) s += escapeString(o.source[i]);			else s += convertToString(o.source[i]);		}				return '{"type":' + escapeString(className) + ',"base":' + escapeString(baseClass) + ',"length":' + o.source.length + ',"array":[' + s + ']}';	}		private static function errorString(severity:String, error:String):String	{		return '{"' + severity + '":"' + error + '"}';	}		private static function escapeString(str:String):String 	{		var s:String = "";		var ch:String;		var len:Number = str.length;				for(var i:int = 0; i < len; i++) 		{			ch = str.charAt(i);						switch(ch)			{				case '"': 	s += "\\\""; 	break; // quotation mark				case '\\': 	s += "\\\\"; 	break; // reverse solidus				case '\b': 	s += "\\b"; 	break; // bell				case '\f':	s += "\\f";		break; // form feed				case '\n':	s += "\\n";		break; // newline				case '\r':	s += "\\r";		break; // carriage return				case '\t':	s += "\\t";		break; // horizontal tab								default:									if(ch < ' ')				{					var hexCode:String = ch.charCodeAt(0).toString(16);					var zeroPad:String = hexCode.length == 2 ? "00" : "000";					s += "\\u" + zeroPad + hexCode;				}				else s += ch;			}		}				return "\"" + s + "\"";	}		private static function arrayToString(a:Array):String 	{		var s:String = "";		var classInfo:XML = flash.utils.describeType(a);		var className:String = classInfo.@name;		var baseClass:String = classInfo.@base;				for(var i:int = 0; i < a.length; i++)		{			if(s.length > 0) s += ","; 			s += convertToString(a[i]);			}				return '{"type":' + escapeString(className) + ',"base":' + escapeString(baseClass) + ',"length":' + a.length + ',"array":[' + s + ']}';	}		private static function objectToString(o:Object):String	{		var s:String = "";		var classInfo:XML = flash.utils.describeType(o);		var className:String = classInfo.@name;		var baseClass:String = classInfo.@base;		var appendObjectString:Function = function(s:String, v:XML):String		{			var t:String = "";						if(s.length > 0) t += ",";			try { t += escapeString(v.@name.toString()) + ":" + convertToString(o[v.@name]); }			catch(error:Error) { t += escapeString(v.@name.toString()) + ':"[write-only]"';  }						return t;		};				if(level == maxLevel) return errorString(SEV_ERR, ERROR_MAX_LEVELS);		else level++;				for(var key:String in o)		{			if(s.length > 0) s += ",";						var value:Object = o[key];			s += escapeString(key) + ":" + convertToString(value);		}				for each(var v:XML in classInfo..*.(name() == "variable" || name() == "accessor"))		{			s += appendObjectString(s, v);		}				return '{"type":' + escapeString(className) + ',"base":' + escapeString(baseClass) + ',"object":{' + s + '}}';	}}