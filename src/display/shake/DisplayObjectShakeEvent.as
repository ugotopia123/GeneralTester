package display.shake {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class DisplayObjectShakeEvent extends Event {
		/**
		 * An Event called when shaking starts
		 */
		public static const SHAKE_START:String = "display.shake.DisplayObjectShake.shakeStart";
		
		/**
		 * An Event called every frame of the shaking process
		 */
		public static const SHAKE_TICK:String = "display.shake.DisplayObjectShake.shakeTick";
		
		/**
		 * An Event called when shaking completes its shaking process
		 */
		public static const SHAKE_COMPLETE:String = "display.shake.DisplayObjectShake.shakeComplete";
		
		public function DisplayObjectShakeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event { 
			return new DisplayObjectShakeEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("DisplayObjectShakeEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}