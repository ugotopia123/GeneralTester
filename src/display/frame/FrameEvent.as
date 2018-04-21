package display.frame {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class FrameEvent extends Event {
		/**
		 * An Event called when the intro delay starts
		 */
		public static const INTRO_DELAY_START:String = "display.frame.FrameEvent.introDelayStart";
		
		/**
		 * An Event called when the intro delay completes
		 */
		public static const INTRO_DELAY_COMPLETE:String = "display.frame.FrameEvent.introDelayComplete";
		
		/**
		 * An Event called when the intro fade starts
		 */
		public static const INTRO_FADE_START:String = "display.frame.FrameEvent.introFadeStart";
		
		/**
		 * An Event called when the intro fade completes
		 */
		public static const INTRO_FADE_COMPLETE:String = "display.frame.FrameEvent.introFadeComplete";
		
		/**
		 * An Event called when the outro delay starts
		 */
		public static const OUTRO_DELAY_START:String = "display.frame.FrameEvent.outroDelayStart";
		
		/**
		 * An Event called when the outro delay completes
		 */
		public static const OUTRO_DELAY_COMPLETE:String = "display.frame.FrameEvent.outroDelayComplete";
		
		/**
		 * An Event called when the outro fade starts
		 */
		public static const OUTRO_FADE_START:String = "display.frame.FrameEvent.outroFadeStart";
		
		/**
		 * An Event called when the outro fade completes
		 */
		public static const OUTRO_FADE_COMPLETE:String = "display.frame.FrameEvent.outroFadeComplete";
		
		/**
		 * An Event called when the Frame is made the currentFrame
		 */
		public static const ENTER_FRAME:String = "display.frame.FrameEvent.enterFrame";
		
		/**
		 * An Event called when the Frame loses currentFrame status
		 */
		public static const EXIT_FRAME:String = "display.frame.FrameEvent.exitFrame";
		
		public function FrameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new FrameEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("FrameEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}