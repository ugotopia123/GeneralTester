package display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class DrawSpriteSheet {
		
		/**
		 * Draws a section from a provided sprite sheet onto a Bitmap
		 * @param	displayBitmap The Bitmap to draw the sectioned sprite sheet information on to (creates a new Bitmap if null). Note image might not draw properly if you attempt to draw a sprite with different dimensions than the Bitmap
		 * @param	spriteSheet The sprite sheet Bitmap to draw from
		 * @param	spriteSheetWidth The width each sprite sheet index is, used to calculate x drawing location
		 * @param	spriteSheetHeight The height each sprite sheet index is, used to calculate y drawing location
		 * @param	spriteSheetX The x index location on the sprite sheet to draw from, starting from 0 at the left edge. Note this x is not a pixel location but an index location based on the spriteSheetWidth. For instance if your sprites are 32 pixels wide and you want to get the 3rd sprite index, spriteSheetX will be set to 2 assuming spriteSheetWidth is 32
		 * @param	spriteSheetY The y index location on the sprite sheet to draw from, starting from 0 at the top edge. Note this y is not a pixel location but an index location based on the spriteSheetHeight. For instance if your sprites are 32 pixels tall and you want to get the 3rd sprite index, spriteSheetY will be set to 2 assuming spriteSheetHeight is 32
		 * @param	sectionWidth The width of the sectioned sprite when drawing begins, use this only if the sprite width is different than the spriteSheetWidth in the case of a sprite sheet with different-sized sprites. Otherwise leave 0 to use the spriteSheetWidth
		 * @param	sectionHeight The height of the sectioned sprite when drawing begins, use this only if the sprite height is different than the spriteSheetHeight in the case of a sprite sheet with different-sized sprites. Otherwise leave 0 to use the spriteSheetHeight
		 * @param	displayWidth The width to draw to the provided Bitmap, assuming you haven't provided a displayBitmap. If a Bitmap is provided, its width is used instead. You can set this to a different amount than the sectionWidth if you want to upscale or downscale the drawn image
		 * @param	displayHeight The height to draw to the provided Bitmap, assuming you haven't provided a displayBitmap. If a Bitmap is provided, its height is used instead. You can set this to a different amount than the sectionHeight if you want to upscale or downscale the drawn image
		 * @return	Either the provided displayBitmap or the created one if displayBitmap is null
		 */
		public static function drawSpriteSheetIndex(displayBitmap:Bitmap, spriteSheet:Bitmap, spriteSheetWidth:Number, spriteSheetHeight:Number, spriteSheetX:Number, spriteSheetY:Number, sectionWidth:Number = 0, sectionHeight:Number = 0, displayWidth:Number = 0, displayHeight:Number = 0):Bitmap {
			if (sectionWidth == 0) sectionWidth = spriteSheetWidth;
			if (sectionHeight == 0) sectionHeight = spriteSheetHeight;
			if (displayWidth == 0) displayWidth = sectionWidth;
			if (displayHeight == 0) displayHeight = sectionHeight;
			
			if (!displayBitmap) displayBitmap = new Bitmap(new BitmapData(sectionWidth, sectionHeight));
			
			displayBitmap.bitmapData.copyPixels(spriteSheet.bitmapData, new Rectangle(spriteSheetWidth * spriteSheetX, spriteSheetHeight * spriteSheetY, sectionWidth, sectionHeight), new Point());
			displayBitmap.scaleX = displayWidth / sectionWidth;
			displayBitmap.scaleY = displayHeight / sectionHeight;
			return displayBitmap;
		}
	}
}