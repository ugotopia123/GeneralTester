package display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Align {
		/**
		 * The UP align direction. Puts the top side of one Object to the other's
		 */
		public static const UP:String = "UP";
		
		/**
		 * The DOWN align direction. Puts the bottom side of one Object to the other's
		 */
		public static const DOWN:String = "DOWN";
		
		/**
		 * The LEFT align direction. Puts the left side of one Object to the other's
		 */
		public static const LEFT:String = "LEFT";
		
		/**
		 * The RIGHT align direction. Puts the right side of one Object to the other's
		 */
		public static const RIGHT:String = "RIGHT";
		
		/**
		 * The LEFT_UP align direction. Combines the Align.LEFT and Align.UP alignments
		 */
		public static const LEFT_UP:String = "LEFT_UP";
		
		/**
		 * The LEFT_DOWN align direction. Combines the Align.LEFT and Align.DOWN alignments
		 */
		public static const LEFT_DOWN:String = "LEFT_DOWN";
		
		/**
		 * The RIGHT_UP align direction. Combines the Align.RIGHT and Align.UP alignments
		 */
		public static const RIGHT_UP:String = "RIGHT_UP";
		
		/**
		 * The RIGHT_DOWN align direction. Combines the Align.RIGHT and Align.DOWN alignments
		 */
		public static const RIGHT_DOWN:String = "RIGHT_DOWN";
		
		/**
		 * The UP_CENTER align direction. Combines the Align.UP and Align.CENTER_Y alignments
		 */
		public static const UP_CENTER:String = "UP_CENTER";
		
		/**
		 * The DOWN_CENTER align direction. Combines the Align.DOWN and ALIGN.CENTER.Y alignments
		 */
		public static const DOWN_CENTER:String = "DOWN_CENTER";
		
		/**
		 * The LEFT_CENTER align direction. Combines the Align.LEFT and Align.CENTER_X alignments
		 */
		public static const LEFT_CENTER:String = "LEFT_CENTER";
		
		/**
		 * The RIGHT_CENTER align direction. Combines the Align.RIGHT and Align.CENTER_X alignments
		 */
		public static const RIGHT_CENTER:String = "RIGHT_CENTER";
		
		/**
		 * The CENTER_X align direction. Centers the Object's length to the other's
		 */
		public static const CENTER_X:String = "CENTER_X";
		
		/**
		 * The CENTER_Y align direction. Centers the Object's height to the other's
		 */
		public static const CENTER_Y:String = "CENTER_Y";
		
		/**
		 * The CENTER align direction. Combines the Align.CENTER_X and Align.CENTER_Y alignments
		 */
		public static const CENTER:String = "CENTER";
		
		private static var customAlignString:Vector.<String> = new Vector.<String>();
		private static var customAlignFunction:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * Registers a custom alignment that gets called when the supplied align String is used in the direction value of the alignTo method. If you supply a String that's already registered or is one of the base Align static constant properties this method does nothing
		 * @param	align The custom alignment String to use on lookup when the alignTo method is used
		 * @param	methodCall The Function to call when a custom alignment is found. The method must take in two values: the movingObject and relationObject
		 */
		public static function registerCustomAlignment(align:String, methodCall:Function):void {
			if (customAlignString.indexOf(align) == -1) {
				customAlignString.push(align);
				customAlignFunction.push(methodCall);
			}
		}
		
		/**
		 * Aligns one DisplayObject to another, with the first object given being the only one that moves in the alignment. This functions allows you to align two objects that are in different parent DisplayObjectContainer fields (it gets the relative x and y locations from the most top-level parent)
		 * @param	movingObject The DisplayObject that's aligning (this is the object that moves, the relationObject does not move)
		 * @param	relationObject The DisplayObject to align to (does not move)
		 * @param	direction The Align direction (use the static constant Align properties)
		 * @param	xOffset The offset in the x direction after alignment
		 * @param	yOffset The offset in the y direction after alignment
		 */
		public static function alignTo(movingObject:DisplayObject, relationObject:DisplayObject, direction:String, xOffset:Number = 0, yOffset:Number = 0):void {
			if (movingObject == null || relationObject == null) return;
			
			var relationWidth:Number = relationObject.width;
			var relationHeight:Number = relationObject.height;
			
			if (relationObject is Stage) {
				relationWidth = Stage(relationObject).stageWidth;
				relationHeight = Stage(relationObject).stageHeight;
			}
			
			if (direction == LEFT) setRelativeX(movingObject, getRelativeX(relationObject));
			else if (direction == RIGHT) setRelativeX(movingObject, getRelativeX(relationObject) + (relationWidth - movingObject.width));
			else if (direction == UP) setRelativeY(movingObject, getRelativeY(relationObject));
			else if (direction == DOWN) setRelativeY(movingObject, getRelativeY(relationObject) + (relationHeight - movingObject.height));
			else if (direction == CENTER_X) setRelativeY(movingObject, getRelativeY(relationObject) + relationHeight / 2 - movingObject.height / 2);
			else if (direction == CENTER_Y) setRelativeX(movingObject, getRelativeX(relationObject) + relationWidth / 2 - movingObject.width / 2);
			else if (direction == LEFT_UP) {
				alignTo(movingObject, relationObject, LEFT);
				alignTo(movingObject, relationObject, UP);
			}
			else if (direction == LEFT_UP) {
				alignTo(movingObject, relationObject, LEFT);
				alignTo(movingObject, relationObject, DOWN);
			}
			else if (direction == RIGHT_UP) {
				alignTo(movingObject, relationObject, RIGHT_UP);
				alignTo(movingObject, relationObject, UP);
			}
			else if (direction == RIGHT_DOWN) {
				alignTo(movingObject, relationObject, RIGHT);
				alignTo(movingObject, relationObject, DOWN);
			}
			else if (direction == LEFT_CENTER) {
				alignTo(movingObject, relationObject, LEFT);
				alignTo(movingObject, relationObject, CENTER_X);
			}
			else if (direction == RIGHT_CENTER) {
				alignTo(movingObject, relationObject, RIGHT);
				alignTo(movingObject, relationObject, CENTER_X);
			}
			else if (direction == UP_CENTER) {
				alignTo(movingObject, relationObject, UP);
				alignTo(movingObject, relationObject, CENTER_Y);
			}
			else if (direction == DOWN_CENTER) {
				alignTo(movingObject, relationObject, DOWN);
				alignTo(movingObject, relationObject, CENTER_Y);
			}
			else if (direction == CENTER) {
				alignTo(movingObject, relationObject, CENTER_X);
				alignTo(movingObject, relationObject, CENTER_Y);
			}
			else {
				var customIndex:int = customAlignString.indexOf(direction);
				
				if (customIndex != -1) customAlignFunction[customIndex].call(null, movingObject, relationObject);
			}
			
			movingObject.x += xOffset;
			movingObject.y += yOffset;
		}
		
		/**
		 * Moves both DisplayObjects to where they are centered on the x axis, each DisplayObject moving the same distance
		 */
		public static function averageCenterX(object1:DisplayObject, object2:DisplayObject):void {
			var center1:Number = object1.x + object1.width / 2;
			var center2:Number = object2.x + object2.width / 2;
			var averageCenter:Number = (center1 + center2) / 2;
			object1.x += averageCenter - center1;
			object2.x += averageCenter - center2;
		}
		
		/**
		 * Moves both DisplayObject to where they are centered on the y axis, each DisplayObject moving the same distance
		 */
		public static function averageCenterY(object1:DisplayObject, object2:DisplayObject):void {
			var center1:Number = object1.y + object1.height / 2;
			var center2:Number = object2.y + object2.height / 2;
			var averageCenter:Number = (center1 + center2) / 2;
			object1.y += averageCenter - center1;
			object2.y += averageCenter - center2;
		}
		
		
		/**
		 * Moves both DisplayObjects to where they are centered on the x and y axes, each DisplayObject moving the same distance
		 */
		public static function averageCenter(object1:DisplayObject, object2:DisplayObject):void {
			averageCenterX(object1, object2);
			averageCenterY(object1, object2);
		}
		
		/**
		 * Gets the x location of a DisplayObject relative to a top-level parent. For example: there's a DisplayObject inside of a Sprite at x location 100, and that Sprite is inside of the Stage, also at x location 100. Relative to the Stage, the DisplayObject is at x location 200, which is what this function returns if given the DisplayObject and the Stage as the topLevelParent
		 * @param	displayObject The DisplayObject to use for the initial x location
		 * @param	topLevelParent The top level parent to use to find the x location relative to the displayObject (leave null to use the Stage)
		 * @return	A Number representing the x location of the DisplayObject relative to the topLevelParent (if the DisplayObject doesn't have a parent that's a child of the topLevelParent, the function returns the Number gathered as far as it could go)
		 */
		public static function getRelativeX(displayObject:DisplayObject, topLevelParent:DisplayObjectContainer = null):Number {
			var totalX:Number = displayObject.x;
			var currentParent:DisplayObjectContainer = displayObject.parent;
			
			while (currentParent != null) {
				if (topLevelParent == null && currentParent is Stage) return totalX;
				if (currentParent == topLevelParent) return totalX;
				
				totalX += currentParent.x;
				currentParent = currentParent.parent;
			}
			
			return totalX;
		}
		
		/**
		 * Gets the y location of a DisplayObject relative to a top-level parent. For example: there's a DisplayObject inside of a Sprite at y location 100, and that Sprite is inside of the Stage, also at y location 100. Relative to the Stage, the DisplayObject is at y location 200, which is what this function returns if given the DisplayObject and the Stage as the topLevelParent
		 * @param	displayObject The DisplayObject to use for the intiial y location
		 * @param	topLevelParent The top level parent to use to find the y location relative to the displayObject (leave null to use the Stage)
		 * @return	A Number representing the y location of the DisplayObject relative to the topLevelParent (if the DisplayObject doesn't have a parent that's a child of the topLevelParent, the function returns the Number gathered as far as it could go)
		 */
		public static function getRelativeY(displayObject:DisplayObject, topLevelParent:DisplayObjectContainer = null):Number {
			var totalY:Number = displayObject.y;
			var currentParent:DisplayObjectContainer = displayObject.parent;
			
			while (currentParent != null) {
				if (topLevelParent == null && currentParent is Stage) return totalY;
				if (currentParent == topLevelParent) return totalY;
				
				totalY += currentParent.y;
				currentParent = currentParent.parent;
			}
			
			return totalY;
		}
		
		/**
		 * Sets the x location of a DisplayObject to the given x relative to a DisplayObjectContainer. For example: There's a DisplayObject inside a Sprite at x location 100, and that Sprite is inside of the Stage, also at x location 100. You want to set the DisplayObject's x location to 150 relative to the Stage, so this function will move the object 50 pixels to the left since it was 200 pixels away relative to the Stage initially.
		 * @param	displayObject The DisplayObject to use for the initial x location
		 * @param	setX The x location to set. This x is relative to the topLevelParent, not the displayObject
		 * @param	topLevelParent The top level parent to use to find the x location relative to the displayObject (leave null to use the Stage)
		 */
		public static function setRelativeX(displayObject:DisplayObject, setX:Number, topLevelParent:DisplayObjectContainer = null):void {
			var currentParent:DisplayObjectContainer = displayObject.parent;
			
			while (currentParent != null) {
				if (topLevelParent == null && currentParent is Stage) break;
				if (currentParent == topLevelParent) break;
				
				setX -= currentParent.x;
				currentParent = currentParent.parent;
			}
			
			displayObject.x = setX;
		}
		
		/**
		 * Sets the y location of a DisplayObject to the given y relative to a DisplayObjectContainer. For example: There's a DisplayObject inside a Sprite at y location 100, and that Sprite is inside of the Stage, also at y location 100. You want to set the DisplayObject's y location to 150 relative to the Stage, so this function will move the object 50 pixels up since it was 200 pixels away relative to the Stage initially.
		 * @param	displayObject The DisplayObject to use for the initial y location
		 * @param	setX The y location to set. This y is relative to the topLevelParent, not the displayObject
		 * @param	topLevelParent The top level parent to use to find the y location relative to the displayObject (leave null to use the Stage)
		 */
		public static function setRelativeY(displayObject:DisplayObject, setY:Number, topLevelParent:DisplayObjectContainer = null):void {
			var currentParent:DisplayObjectContainer = displayObject.parent;
			
			while (currentParent != null) {
				if (topLevelParent == null && currentParent is Stage) break;
				if (currentParent == topLevelParent) break;
				
				setY -= currentParent.y;
				currentParent = currentParent.parent;
			}
			
			displayObject.y = setY;
		}
		
		/**
		 * Ensures that setting the x of a DisplayObject won't make it go outside the bounds of its parent. Use this before setting the x of a DisplayObject if you don't want it to go outside its parent's bounds
		 * @param	displayObject The DisplayObject to check
		 * @param	setX The x amount you want to change the DisplayObject's x by
		 * @return	A Number representing a safe x you can use that ensures the displayObject won't go outside its parent's bounds. This can return the original setX if that change wouldn't have broken the bounds anyway
		 */
		public static function setXBounds(displayObject:DisplayObject, setX:Number):Number {
			if (displayObject.parent == null) return setX;
			
			var parentWidth:Number = displayObject.parent.width;
			
			if (displayObject.parent is Stage) parentWidth = Stage(displayObject.parent).stageWidth;
			
			if (displayObject.x + setX < 0) setX = -displayObject.x;
			else if (displayObject.x + displayObject.width + setX > parentWidth) setX = parentWidth - (displayObject.x + displayObject.width);
			
			return setX;
		}
		
		/**
		 * Ensures that setting the y of a DisplayObject won't make it go outside the bounds of its parent. Use this before setting the y of a DisplayObject if you don't want it to go outside its parent's bounds
		 * @param	displayObject The DisplayObject to check
		 * @param	setY The y amount you want to change the DisplayObject's y by
		 * @return	A Number representing a safe y you can use that ensures the displayObject won't go outside its parent's bounds. This can return the original setY if that change wouldn't have broken the bounds anyway
		 */
		public static function setYBounds(displayObject:DisplayObject, setY:Number):Number {
			if (displayObject.parent == null) return setY;
			
			var parentHeight:Number = displayObject.parent.height;
			
			if (displayObject.parent is Stage) parentHeight = Stage(displayObject.parent).stageHeight;
			
			if (displayObject.y + setY < 0) setY = -displayObject.y;
			else if (displayObject.y + displayObject.height + setY > parentHeight) setY = parentHeight - (displayObject.y + displayObject.height);
			
			return setY;
		}
	}
}