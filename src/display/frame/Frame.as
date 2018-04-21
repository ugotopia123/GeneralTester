package display.frame {
	import display.fading.FadeEvent;
	import display.fading.FadeObject;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	[Event(name = "display.frame.FrameEvent.introDelayStart", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.introDelayComplete", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.introFadeStart", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.introFadeComplete", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.outroDelayStart", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.outroDelayComplete", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.outroFadeStart", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.outroFadeComplete", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.enterFrame", type = "display.frame.FrameEvent")]
	[Event(name = "display.frame.FrameEvent.exitFrame", type = "display.frame.FrameEvent")]
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Frame extends Sprite {
		private static var _initFrames:Vector.<Frame> = new Vector.<Frame>();
		private static var _currentFrame:Frame;
		private var _frameName:String;
		private var _background:Bitmap;
		private var _introFade:FadeObject;
		private var _outroFade:FadeObject;
		
		/**
		 * A Frame is a general DisplayObject that has methods used for handling transitions within a program. Each Frame will contain visual elements, such as slides in a presentation, or rooms and menus in a game
		 * @param	parent The parent DisplayObjectContainer that will hold this Frame. Typically this is the Stage
		 * @param	frameName The name of this Frame, used for lookup
		 * @param	introFadeDuration The duration, in seconds, this Frame fades in when entered (leave 0 to not have a fade in)
		 * @param	introFadeDelay The delay, in seconds, this Frame initiates its fade in if there is one
		 * @param	outroFadeDuration The duration, in seconds, this Frame fades out when exited (leave 0 to not have a fade out)
		 * @param	outroFadeDelay The delay, in seconds, this Frame initiates its fade out if there is one
		 * @param	background The background Bitmap to set for this Frame
		 * @param	backgroundColor Set to a color value (0x000000 to 0xFFFFFF) to assign this Frame a default background color, ignoring the background parameter
		 * @param	backgroundAlpha The alpha value of the background color, if it's being used instead of the background parameter
		 * @param	addToVector True to add this Frame to the Vector of initialized Frames
		 */
		public function Frame(parent:DisplayObjectContainer, frameName:String, introFadeDuration:Number = 0, introFadeDelay:Number = 0, outroFadeDuration:Number = 0, outroFadeDelay:Number = 0, background:Bitmap = null, backgroundColor:uint = 4294967295, backgroundAlpha:Number = 1, addToVector:Boolean = false) {
			parent.addChild(this);
			_frameName = frameName;
			visible = false;
			
			if (backgroundColor <= 0xFFFFFF) {
				var width:Number = parent.width;
				var height:Number = parent.height;
				
				if (parent is Stage) {
					width = Stage(parent).stageWidth;
					height = Stage(parent).stageHeight;
				}
				
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
			else _background = background;
			
			if (background) addChild(background);
			if (addToVector) _initFrames.push(this);
			
			if (introFadeDuration > 0) {
				_introFade = new FadeObject(this, introFadeDuration, introFadeDelay, 1, true, true, false);
				_introFade.addEventListener(FadeEvent.FADE_COMPLETE, introFadeComplete);
				_introFade.addEventListener(FadeEvent.DELAY_START, introDelayStart);
				_introFade.addEventListener(FadeEvent.DELAY_COMPLETE, introDelayComplete);
			}
			
			if (outroFadeDuration > 0) {
				_outroFade = new FadeObject(this, outroFadeDuration, outroFadeDelay, 0, true, true, false, false, 1);
				_outroFade.addEventListener(FadeEvent.FADE_COMPLETE, outroFadeComplete);
				_outroFade.addEventListener(FadeEvent.DELAY_START, outroDelayStart);
				_outroFade.addEventListener(FadeEvent.DELAY_COMPLETE, outroDelayComplete);
			}
		}
		
		/**
		 * The current Frame being displayed
		 */
		public static function get currentFrame():Frame { return _currentFrame; }
		
		/**
		 * The Vector of all initialized Frames
		 */
		public static function get initFrames():Vector.<Frame> { return _initFrames; }
		
		/**
		 * Attempts to get an initialized Frame in the initFrames Vector
		 * @param	frameName The name of the Frame to lookup
		 * @return	Either a reference to the found Frame or null if no Frame could be found
		 */
		public static function getFrame(frameName:String):Frame {
			for each (var frame:Frame in _initFrames) {
				if (frame._frameName == frameName) return frame;
			}
			
			return null;
		}
		
		/**
		 * The background Bitmap of this Frame
		 */
		public function get background():Bitmap { return _background; }
		
		/**
		 * The FadeObject this Frame uses when its enterFrame method is called
		 */
		public function get introFade():FadeObject { return _introFade; }
		
		/**
		 * The FadeObject this Frame uses when its exitFrame method is called
		 */
		public function get outroFade():FadeObject { return _outroFade; }
		
		/**
		 * Enters this Frame, fading in or making it visible while setting the currentFrame property (if there is a current frame with a outro fade then that fade initiates before this frame is entered)
		 */
		public function enterFrame():void {
			var setCurrentFrame:Boolean = true;
			
			if (_currentFrame) {
				if (_currentFrame._outroFade) {
					setCurrentFrame = false;
					_currentFrame._outroFade.addEventListener(FadeEvent.FADE_COMPLETE, delayEnter);
				}
				
				_currentFrame.exitFrame();
			}
			
			if (setCurrentFrame) {
				_currentFrame = this;
				visible = true;
				
				if (_introFade) {
					alpha = 0;
					_introFade.restartFade(false);
					dispatchEvent(new FrameEvent(FrameEvent.INTRO_FADE_START));
				}
				
				dispatchEvent(new FrameEvent(FrameEvent.ENTER_FRAME));
			}
		}
		
		/**
		 * Exits this Frame, fading out or making it invisible
		 */
		public function exitFrame():void {
			if (_currentFrame != this) return;
			if (_introFade) _introFade.resetFade(false);
			
			if (_outroFade) {
				visible = true;
				alpha = 1;
				_outroFade.restartFade(false);
				dispatchEvent(new FrameEvent(FrameEvent.OUTRO_FADE_START));
			}
			else visible = false;
			
			_currentFrame = null;
			dispatchEvent(new FrameEvent(FrameEvent.EXIT_FRAME));
		}
		
		private function delayEnter(e:FadeEvent):void {
			FadeObject(e.target).removeEventListener(FadeEvent.FADE_COMPLETE, delayEnter);
			_currentFrame = this;
			visible = true;
			
			if (_introFade) {
				alpha = 0;
				_introFade.restartFade(false);
				dispatchEvent(new FrameEvent(FrameEvent.INTRO_FADE_START));
			}
			
			dispatchEvent(new FrameEvent(FrameEvent.ENTER_FRAME));
		}
		
		private function introDelayStart(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.INTRO_DELAY_START));
		}
		
		private function introDelayComplete(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.INTRO_DELAY_COMPLETE));
		}
		
		private function introFadeComplete(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.INTRO_FADE_COMPLETE));
		}
		
		private function outroDelayStart(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.OUTRO_DELAY_START));
		}
		
		private function outroDelayComplete(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.OUTRO_DELAY_COMPLETE));
		}
		
		private function outroFadeComplete(e:FadeEvent):void {
			dispatchEvent(new FrameEvent(FrameEvent.OUTRO_FADE_COMPLETE));
		}
	}
}