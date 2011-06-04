package com.cyntaxic.cynmvc.controller.enums
{
	import com.cyntaxic.cynmvc.controller.vos.ErrorCodeVO;
	
	public class ErrorCodes
	{
		public static const E_5000:ErrorCodeVO = new ErrorCodeVO("Error #5000: Property is only set once in Cyntaxic.", 5000);
		public static const E_5001:ErrorCodeVO = new ErrorCodeVO("Error #5001: Object does not extend CynView. Use removeChildAt to remove.", 5001);
		public static const E_5002:ErrorCodeVO = new ErrorCodeVO("Error #5002: Event listening on the controller is not supported.", 5002);
		public static const E_5003:ErrorCodeVO = new ErrorCodeVO("Error #5003: CynController and CynModel are meant to be abstract. The extended constructor should pass itself to its superclass. Use super(this).", 5003);
	}
}