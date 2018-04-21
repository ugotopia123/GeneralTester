package display.text {
	import display.GlueableObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Text extends TextField {
		public var bufferDivisor:Number = 3;
		public var bufferMin:Number = 6;
		private var maxWidth:Number;
		private var textFormat:TextFormat;
		private var changingText:Boolean;
		private var _glueObject:GlueableObject;
		
		/**
		 * Creates a new Text instance, which is a friendlier form of a TextField with its default parameters prepared automatically
		 * @param	displayText The String that this text displays
		 * @param	fontName The name of a font to use for this instance (either use the name of a TextFontReference String, or the fontName String of an embedded font)
		 * @param	isEmbedded True if you're using an embedded font, false if you're using a system font from the TextFontReference Class. If this value is not set correctly, your text won't display
		 * @param	parent The parent DisplayObjectContainer to add this instance to, leave null to not set a parent
		 * @param	setX A value to set for the x value if the parent is not null
		 * @param	setY A value to set for the y value if the parent is not null
		 * @param	glueParent Set if you want to automatically glue this Text to another DisplayObject
		 * @param	setVisible The default visibility of this text instance
		 * @param	fontSize The default font size
		 * @param	setColor The default text color
		 * @param	maxWidth The maximum width this text is allowed to be before wrapping, leave 0 to either leave it limitless if no parent is set or have its maximum width be the same as its parent's width
		 * @param	align The default alignment ("center", "left", or "right")
		 * @param	bufferDivisor The default buffer divisor for buffer width, the divisor being divided from the font size, granting larger buffers for larger font sizes. Lower this if you see your text not having enough width by default
		 * @param	bufferMin The default minimum amount of buffer pixels this text has if the bufferDivisor grants 0 additional pixels
		 */
		public function Text(displayText:String, fontName:String, isEmbedded:Boolean, parent:DisplayObjectContainer = null, setX:Number = 0, setY:Number = 0, glueParent:GlueableObject = null, setVisible:Boolean = true, fontSize:uint = 32, setColor:uint = 0xFFFFFF, maxWidth:Number = 0, textAlign:String = "center", bufferDivisor:Number = 3, bufferMin:Number = 6) {
			super();
			_glueObject = new GlueableObject(this);
			textFormat = new TextFormat(fontName, fontSize, setColor, null, null, null, null, null, textAlign);
			defaultTextFormat = textFormat;
			embedFonts = isEmbedded;
			antiAliasType = AntiAliasType.ADVANCED;
			multiline = wordWrap = true;
			selectable = false;
			this.maxWidth = maxWidth;
			this.bufferDivisor = bufferDivisor;
			this.bufferMin = bufferMin;
			
			if (glueParent) glueParent.glueObject(this);
			if (parent) {
				parent.addChild(this);
				x = setX;
				y = setY;
				
				if (this.maxWidth == 0) {
					if (parent is Stage) this.maxWidth = Stage(parent).stageWidth;
					else this.maxWidth = parent.width;
				}
			}
			
			text = displayText;
		}
		
		/**
		 * A string that is the current text in the text field. Lines are separated by the carriage
		 * return character ('\r', ASCII 13). This property contains unformatted text in the text
		 * field, without HTML tags.
		 * 
		 * To get the text in HTML form, use the htmlText property.
		 * 
		 * Note: Changing the text parameter directly acts as if you called the checkResize method
		 */
		override public function set text(value:String):void {
			super.text = value;
			
			if (!changingText) changeText(value);
		}
		
		/**
		 * Indicates the x coordinate of the DisplayObject instance relative to the local coordinates of
		 * the parent DisplayObjectContainer. If the object is inside a DisplayObjectContainer that has
		 * transformations, it is in the local coordinate system of the enclosing DisplayObjectContainer.
		 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the DisplayObjectContainer's
		 * children inherit a coordinate system that is rotated 90° counterclockwise.
		 * The object's coordinates refer to the registration point position.
		 */
		override public function set x(value:Number):void {
			super.x = value;
			_glueObject.updatePositions();
		}
		
		/**
		 * Indicates the y coordinate of the DisplayObject instance relative to the local coordinates of
		 * the parent DisplayObjectContainer. If the object is inside a DisplayObjectContainer that has
		 * transformations, it is in the local coordinate system of the enclosing DisplayObjectContainer.
		 * Thus, for a DisplayObjectContainer rotated 90° counterclockwise, the DisplayObjectContainer's
		 * children inherit a coordinate system that is rotated 90° counterclockwise.
		 * The object's coordinates refer to the registration point position.
		 */
		override public function set y(value:Number):void {
			super.y = value;
			_glueObject.updatePositions();
		}
		
		/**
		 * Gets the GlueableObject instance of this Text, used for gluing other DisplayObjects to this for automatic position updating
		 */
		public function get glueObject():GlueableObject { return _glueObject; }
		
		public function changeText(value:String):void {
			changingText = true;
			text = value;
			checkResize();
			changingText = false;
		}
		
		private function checkResize():void {
			if (!parent) return;
			
			var bufferWidth:uint = Math.floor(Number(defaultTextFormat.size) / bufferDivisor) + bufferMin;
			var maxWidth:Number = this.maxWidth;
			
			if (parent is Stage) {
				var stageParent:Stage = Stage(parent);
				width = stageParent.stageWidth;
				height = stageParent.stageHeight;
				maxWidth = stageParent.stageWidth - x;
			}
			else {
				width = parent.width;
				height = parent.height;
				maxWidth = parent.width - x;
			}
			
			if (textWidth + bufferWidth <= maxWidth) width = textWidth + bufferWidth;
			else width = maxWidth;
			
			height = textHeight + 4;
		}
	}
}