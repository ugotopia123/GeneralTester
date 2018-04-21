package display.fading {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class FadeEvent extends Event {
		/**
		 * An Event called when fading starts
		 */
		public static const FADE_START:String = "display.fading.FadeEvent.fadeStart";
		
		/**
		 * An Event called every frame of the fading process
		 */
		public static const FADE_TICK:String = "display.fading.FadeEvent.fadeTick";
		
		/**
		 * An Event called when fading is stopped by the stopFade method
		 */
		public static const FADE_STOP:String = "display.fading.FadeEvent.fadeStop";
		
		/**
		 * An Event called when fading is ended by the endFade method
		 */
		public static const FADE_END:String = "display.fading.FadeEvent.fadeEnd";
		
		/**
		 * An Event called when fading is reset by the resetFade method
		 */
		public static const FADE_RESET:String = "display.fading.FadeEvent.fadeReset";
		
		/**
		 * An Event called when fading is restarted by the restartFade method
		 */
		public static const FADE_RESTART:String = "display.fading.FadeEvent.fadeRestart";
		
		/**
		 * An Event called when a fade instance is removed by the removeFade method
		 */
		public static const FADE_REMOVE:String = "display.fading.FadeEvent.fadeRemove";
		
		/**
		 * An Event called when fading completes its fading process
		 */
		public static const FADE_COMPLETE:String = "display.fading.FadeEvent.fadeComplete";
		
		/**
		 * An Event called when a fade delay starts its process
		 */
		public static const DELAY_START:String = "display.fading.FadeEvent.delayStart";
		
		/**
		 * An Event called when a fade delay completes its process
		 */
		public static const DELAY_COMPLETE:String = "display.fading.FadeEvent.delayComplete";
		
		public function FadeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new FadeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("FadeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}