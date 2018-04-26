package display {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class GlueableObject {
		private var _parent:DisplayObject;
		private var _glueList:Array = new Array();
		private var parentX:Number;
		private var parentY:Number;
		
		/**
		 * A GlueableObject is a property on DisplayObjects containing a list of other DisplayObjects that are "glued" to it, where a GlueableObject can automatically update all glued DisplayObjects' positions when it moves. Note that if you move a child DisplayObject that it won't move its parent
		 * @param	parent The parent DisplayObject that will hold this GlueableObject instance
		 * @param	... glueList A starting list of DisplayObjects to glue to the parent, otherwise call the glueObject method to add more instances. Ignored if a value is either not a DisplayObject or the Stage
		 */
		public function GlueableObject(parent:DisplayObject, ... glueList) {
			_parent = parent;
			parentX = _parent.x;
			parentY = _parent.y;
			
			for (var i:uint = 0; i < glueList.length; i++) {
				glueObject(glueList[i]);
			}
		}
		
		/**
		 * The parent DisplayObject that this GlueableObject is attached to
		 */
		public function get parent():DisplayObject { return _parent; }
		
		/**
		 * Gets a copy of the glueList, not the original Array itself since any values you wish to manipulate should be used with the glueObject and unglueObject methods
		 */
		public function get glueList():Array { return _glueList.concat(); }
		
		/**
		 * Adds the target DisplayObject to the glueList, moving if its parent moves and calls the updatePositions method. You cannot glue multiple DisplayObjects together, otherwise recursion results
		 * @param	target The target DisplayObject to glue to this GlueableObject instance (ignored if the target already exists in the Array or is the Stage)
		 */
		public function glueObject(target:DisplayObject):void {
			if (_glueList.indexOf(target) == -1 && !(target is Stage)) _glueList.push(target);
		}
		
		/**
		 * Removes the target DisplayObject from the glueList, no longer moving when its original parent moved and called the updatePositions method
		 * @param	target The target DisplayObject to unglue from this GlueableObject instance (ignored if the target doesn't exist in the Array)
		 */
		public function unglueObject(target:DisplayObject):void {
			var index:int = _glueList.indexOf(target);
			
			if (index != -1) _glueList.removeAt(index);
		}
		
		/**
		 * Updates all the positions of this GlueableObject's children in relation to the position change of their parent
		 */
		public function updatePositions():void {
			var differenceX:Number = _parent.x - parentX;
			var differenceY:Number = _parent.y - parentY;
			
			for (var i:uint = 0; i < _glueList.length; i++) {
				var currentChild:DisplayObject = _glueList[i];
				currentChild.x += differenceX;
				currentChild.y += differenceY;
			}
			
			parentX = _parent.x;
			parentY = _parent.y;
		}
	}
}