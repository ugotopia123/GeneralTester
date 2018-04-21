package {
	import flash.display.Sprite;
	import flash.events.Event;
	import functionality.ComplexArray;
	import functionality.MathFunctions;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Tester extends Sprite {
		
		public function Tester() {
			if (stage) initialize();
			else addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(e:Event = null):void {
			if (e != null) e.target.removeEventListener(Event.ADDED_TO_STAGE, initialize);
		}
	}
}