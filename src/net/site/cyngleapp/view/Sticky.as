﻿package net.site.cyngleapp.view{	import com.cyntaxic.cyngle.CyntaxicVO;	import com.cyntaxic.cyngle.view.CynComposite;	import com.cyntaxic.cyngle.view.CynView;	import com.cyntaxic.cyngle.view.interfaces.ICynComposite;	import com.cyntaxic.cyngle.view.interfaces.ICynView;		import comps.fonts.UIMarkerFelt;	import comps.sticky.UISticky;		import flash.display.Shape;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.DropShadowFilter;	import flash.geom.ColorTransform;	import flash.text.AntiAliasType;	import flash.text.Font;	import flash.text.TextField;	import flash.text.TextFieldType;	import flash.text.TextFormat;		import net.site.cyngleapp.Handles;	import net.site.cyngleapp.controller.Controller;	import net.site.cyngleapp.model.Model;	import net.site.cyngleapp.model.vos.StickyVO;	public class Sticky extends CynComposite implements ICynView, ICynComposite	{		public var id:int;		public var message:String = "";		public var color:uint;				private var model:Model;		private var controller:Controller;		private var dropShadow:DropShadowFilter = new DropShadowFilter(3, 70, 0, .4, 5, 5, 1, 3);		private var colorTransform:ColorTransform;		private var stickyShape:Shape;		private var note:TextField = new TextField();		private var markerFelt:Font = new UIMarkerFelt();		private var margin:Number = 10;		private var format:TextFormat = new TextFormat(markerFelt.fontName, 17);		private var close:Close = new Close();				public function Sticky()		{			model = (cynModel as Model);			controller = (cynController as Controller);						stickyShape = this.getChildAt(0) as Shape;						format.leading = 2;						with(note)			{				type = TextFieldType.INPUT;				selectable = true;				multiline = true;				width = stickyShape.width - margin * 2;				x = y = margin;				wordWrap = true;				defaultTextFormat = format;				antiAliasType = AntiAliasType.ADVANCED;			}						addChild(note);						this.filters = [dropShadow];			this.buttonMode = true;						addEventListener(MouseEvent.MOUSE_DOWN, startDragging);			addEventListener(MouseEvent.MOUSE_UP, stopDragging);			addEventListener(Event.CHANGE, resizeNote);						add(close);			close.x = close.y = -12;			close.visible = false;			addEventListener(MouseEvent.ROLL_OVER, showClose);			addEventListener(MouseEvent.ROLL_OUT, hideClose);			close.addEventListener(MouseEvent.CLICK, closeSticky);		}				override public function init(vo:CyntaxicVO):CynView		{			var sticky:StickyVO = vo as StickyVO;						this.id = sticky.id;			this.message = sticky.message;			this.color = sticky.color;						colorTransform = new ColorTransform();			colorTransform.color = sticky.color;			stickyShape.transform.colorTransform = colorTransform;						note.htmlText = sticky.message;			note.height = note.textHeight + margin;						return this;		}				private function hideClose(event:MouseEvent):void		{			close.visible = false;		}				private function showClose(event:MouseEvent):void		{			close.visible = true;		}				private function closeSticky(event:MouseEvent):void		{			controller.execute(Handles.REMOVE_STICKY, new CyntaxicVO({sticky:this}));		}				private function startDragging(event:MouseEvent):void		{			if(event.target is UISticky)			{				this.parent.addChild(this);				startDrag();								model.currentSticky = event.target as Sticky;			}		}				private function stopDragging(event:MouseEvent):void		{			stopDrag();		}				private function resizeNote(event:Event):void		{			if(note.textHeight < (stickyShape.height - margin))			{				note.height = note.textHeight + margin;			}		}	}}