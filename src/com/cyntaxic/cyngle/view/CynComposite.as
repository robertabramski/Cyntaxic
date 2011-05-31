package com.cyntaxic.cyngle.view
{
	import com.cyntaxic.cynccess.cynternal;
	import com.cyntaxic.cyngle.Cyntaxic;
	import com.cyntaxic.cyngle.CyntaxicEvent;
	import com.cyntaxic.cyngle.controller.enums.ErrorCodes;
	import com.cyntaxic.cyngle.model.CynModel;
	import com.cyntaxic.cyngle.view.interfaces.ICynView;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.System;
	
	public class CynComposite extends CynView implements ICynView
	{
		use namespace cynternal;
		
		public function CynComposite()
		{
			
		}
		
		public function add(view:CynView, props:Object = null):CynView
		{
			addChild(view as DisplayObject);
			addProps(view, props);
			
			return view;
		}
		
		public function addAt(view:CynView, index:int, props:Object = null):CynView
		{
			addChildAt(view as DisplayObject, index);
			addProps(view, props);
			
			return view;
		}
		
		private function addProps(view:CynView, props:Object):void
		{
			for(var prop:String in props)
			{
				view[prop] = props[prop];
			}
		}
		
		private function removeChildViews(composite:CynComposite):void
		{
			if(composite.hasEventListener(CyntaxicEvent.NOTIFY)) 
				composite.removeEventListener(CyntaxicEvent.NOTIFY, update);
			
			for(var i:int = 0; i < cynModel.views.length; i++)
			{
				var view:CynView = cynModel.views[i] as CynView;
				
				if(composite.contains(view))
				{
					cynModel.views.splice(i, 1);
					if(view is CynComposite) removeChildViews(view as CynComposite);
					trace('recursive ' + view);
				}
			}
			
			composite = null;
		}
		
		public function remove(view:CynView):void
		{
			for(var i:int = 0; i < cynModel.views.length; i++)
			{
				if(view == cynModel.views[i])
				{
					cynModel.views.splice(i, 1);
					if(view is CynComposite) removeChildViews(view as CynComposite);
				}
			}
			
			removeChild(view as DisplayObject); 
			view = null; System.gc();
		}
		
		public function removeAt(index:int):void
		{
			if(getChildAt(index) is CynView)
			{
				var view:CynView = getChildAt(index) as CynView; 
				
				cynModel.views.splice(index, 1);
				if(view is CynComposite) removeChildViews(view as CynComposite);
				trace(view);
				
				removeChildAt(index); 
				view = null; System.gc();
				
				trace(cynModel.views);
			}
			else
			{
				throw new Error(ErrorCodes.E_5001);
			}
		}
	}
}