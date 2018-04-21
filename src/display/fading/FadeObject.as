package display.fading {
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name = "display.fading.FadeEvent.fadeStart", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeTick", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeStop", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeEnd", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeReset", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeRestart", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeRemove", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.fadeComplete", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.delayStart", type = "display.fading.FadeEvent")]
	[Event(name = "display.fading.FadeEvent.delayComplete", type = "display.fading.FadeEvent")]
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class FadeObject extends EventDispatcher {
		private static const SHORTEST_FRAME_DURATION:Number = 1 / 60;
		private static var fadeObjectVector:Vector.<FadeObject> = new Vector.<FadeObject>();
		private var _target:DisplayObject;
		private var _duration:Number;
		private var _delay:Number;
		private var _targetAlpha:Number;
		private var _setVisibleBefore:Boolean;
		private var _setVisibleAfter:Boolean;
		private var _fadeID:uint;
		private var removeFinishedFade:Boolean;
		private var originalAlpha:Number;
		private var originalVisible:Boolean;
		private var alphaPerTick:Number;
		private var currentAlpha:Number;
		private var delayTicks:uint;
		private var fadeTimer:Timer;
		private var delayTimer:Timer;
		
		/**
		 * Creates a new FadeObject instance, which handles fading a DisplayObject either in or out with a given duration and delay
		 * @param	target The target DisplayObject to fade. If the target already has a FadeObject associated with it alongside the fadeID, the old instance is removed. An Error is thrown if you provide a null value
		 * @param	duration The duration, in seconds, for the fade to last. If the duration is below 1/60th of a second (the fastest frame rate possible), the duration is set to that value
		 * @param	delay The delay, in seconds, for the fade to use before initializing its fade
		 * @param	targetAlpha The target alpha value the target DisplayObject will have at the end of the fade process
		 * @param	setVisibleBefore The value to set for the DisplayObject's visible property before the fade initializes
		 * @param	setVisibleAfter The value to set for the DisplayObject's visible property after the fade completes
		 * @param	startFade True to immediately start the fade after object initialization, false to manually start the fade at a later time
		 * @param	removeFade True to remove this FadeObject instance from the list when its fade completes, false if you plan on reusing this fade
		 * @param	fadeID An ID used alongside the target to ensure only a set amount of FadeObject instances can be active at once. If you try to create a new FadeObject with the same target and ID as one already existing, the old instance is removed
		 */
		public function FadeObject(target:DisplayObject, duration:Number, delay:Number = 0, targetAlpha:Number = 0, setVisibleBefore:Boolean = true, setVisibleAfter:Boolean = true, startFade:Boolean = true, removeFade:Boolean = false, fadeID:uint = 0) {
			if (!target) throw new Error("Target of FadeObject cannot be null");
			if (duration < SHORTEST_FRAME_DURATION) duration = SHORTEST_FRAME_DURATION;
			if (delay < 0) delay = 0;
			
			if (targetAlpha < 0) targetAlpha = 0;
			else if (targetAlpha > 1) targetAlpha = 1;
			
			_target = target;
			_duration = duration;
			_delay = delay;
			_targetAlpha = targetAlpha;
			_setVisibleBefore = setVisibleBefore;
			_setVisibleAfter = setVisibleAfter;
			_fadeID = fadeID;
			removeFinishedFade = removeFade;
			originalAlpha = target.alpha;
			originalVisible = target.visible;
			handleFade(this);
			fadeObjectVector.push(this);
			fadeTimer = new Timer(1000 / 60, Math.round(duration * 60));
			fadeTimer.addEventListener(TimerEvent.TIMER, fadeHandler);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
			
			if (startFade) this.startFade();
		}
		
		/**
		 * The target DisplayObject being faded. Read-only
		 */
		public function get target():DisplayObject { return _target; }
		
		/**
		 * The ID of this FadeObject, used alongside the target value to ensure only one of each target+ID fading combinations are used. Read-only
		 */
		public function get fadeID():uint { return _fadeID; }
		
		/**
		 * The duration, in seconds, the target will fade
		 */
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void { _duration = value; }
		
		/**
		 * The delay, in seconds, before the target's fade begins
		 */
		public function get delay():Number { return _delay; }
		public function set delay(value:Number):void { _delay += value; }
		
		/**
		 * The alpha value the target DisplayObject is going to end when the fade completes
		 */
		public function get targetAlpha():Number { return _targetAlpha; }
		public function set targetAlpha(value:Number):void { _targetAlpha = value; }
		
		/**
		 * The value the target's visibility will be set to before the fade begins
		 */
		public function get setVisibleBefore():Boolean { return _setVisibleBefore; }
		public function set setVisibleBefore(value:Boolean):void { _setVisibleBefore = value; }
		
		/**
		 * The value the target's visibility will be set to after the fade finishes
		 */
		public function get setVisibleAfter():Boolean { return _setVisibleAfter; }
		public function set setVisibleAfter(value:Boolean):void { _setVisibleAfter = value; }
		
		/**
		 * Initializes the fading process, or continues it if the fading has been stopped (does nothing if the fade has already completed)
		 */
		public function startFade():void {
			if (fadeTimer.currentCount == fadeTimer.repeatCount) return;
			
			alphaPerTick = (_targetAlpha - _target.alpha) / (fadeTimer.repeatCount - fadeTimer.currentCount);
			currentAlpha = _target.alpha;
			
			if (_delay > 0) {
				if (!delayTimer) {
					delayTimer = new Timer(1000 / 60, Math.round(delay * 60));
					delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayComplete);
					delayTimer.start();
					_target.visible = _setVisibleBefore;
					dispatchEvent(new FadeEvent(FadeEvent.FADE_START));
					return;
				}
				
				if (delayTimer.currentCount < delayTimer.repeatCount) {
					delayTimer.start();
					_target.visible = _setVisibleBefore;
					dispatchEvent(new FadeEvent(FadeEvent.DELAY_START));
					return;
				}
			}
			
			if (fadeTimer.currentCount < fadeTimer.repeatCount) {
				fadeTimer.start();
				_target.visible = _setVisibleBefore;
				dispatchEvent(new FadeEvent(FadeEvent.FADE_START));
			}
		}
		
		/**
		 * Immediately stops the fading process, the fade being paused until startFade is called again
		 */
		public function stopFade():void {
			fadeTimer.stop();
			dispatchEvent(new FadeEvent(FadeEvent.FADE_STOP));
		}
		
		/**
		 * Immediately stops the fading process and sets the target's alpha and visibility to its ending fade values
		 */
		public function endFade():void {
			stopFade();
			_target.visible = _setVisibleAfter;
			_target.alpha = _targetAlpha;
			dispatchEvent(new FadeEvent(FadeEvent.FADE_END));
		}
		
		/**
		 * Immediately stops and resets the fade parameters
		 * @param	resetTarget true to reset the target DisplayObject's visible and alpha values to their original values
		 */
		public function resetFade(resetTarget:Boolean):void {
			stopFade();
			
			if (resetTarget) {
				_target.visible = originalVisible;
				_target.alpha = originalAlpha;
			}
			
			fadeTimer.reset();
			
			if (delayTimer) delayTimer.reset();
			
			dispatchEvent(new FadeEvent(FadeEvent.FADE_RESET));
		}
		
		/**
		 * Automatically calls the resetFade and startFade methods, an easier way to restart the fade instead of using both methods yourself
		 * @param	resetTarget true to reset the target DisplayObject's visible and alpha values to their original values
		 */
		public function restartFade(resetTarget:Boolean):void {
			resetFade(resetTarget);
			startFade();
			dispatchEvent(new FadeEvent(FadeEvent.FADE_RESTART));
		}
		
		/**
		 * Immediately stops the fade (if being processed) and removes the fade instance from the instance list
		 * @param	resetTarget true to reset the target DisplayObject's visible and alpha values to their original values (if this is true then the value of completeTarget is ignored, even if it's also true)
		 * @param	completeTarget true to set the target DisplayObject's visible and alpha values to their target values at the end of the fade
		 */
		public function removeFade(resetTarget:Boolean = false, completeTarget:Boolean = true):void {
			fadeTimer.stop();
			fadeTimer.removeEventListener(TimerEvent.TIMER, fadeHandler);
			fadeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fadeComplete);
			
			if (delayTimer) {
				delayTimer.stop();
				delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, delayComplete);
			}
			
			fadeObjectVector.removeAt(fadeObjectVector.indexOf(this));
			
			if (resetTarget) {
				_target.visible = originalVisible;
				_target.alpha = originalAlpha;
			}
			else if (completeTarget) {
				_target.visible = _setVisibleAfter;
				_target.alpha = _targetAlpha;
			}
			
			dispatchEvent(new FadeEvent(FadeEvent.FADE_REMOVE));
		}
		
		private function delayComplete(e:TimerEvent):void {
			fadeTimer.start();
			dispatchEvent(new FadeEvent(FadeEvent.DELAY_COMPLETE));
		}
		
		private function fadeHandler(e:TimerEvent):void {
			currentAlpha += alphaPerTick;
			_target.alpha = currentAlpha;
			dispatchEvent(new FadeEvent(FadeEvent.FADE_TICK));
		}
		
		private function fadeComplete(e:TimerEvent):void {
			if (removeFinishedFade) removeFade();
			else _target.visible = _setVisibleAfter;
			
			dispatchEvent(new FadeEvent(FadeEvent.FADE_COMPLETE));
		}
		
		/**
		 * Attempts to get a FadeObject instance given the DisplayObject target
		 * @param	target The target DisplayObject to check for FadeObject instances
		 * @param	fadeID The ID used alongside the target value to get the specific FadeObject associated with the target
		 * @return	Either a reference to a FadeObject instance handling the target DisplayObject, or null if no instance could be found
		 */
		public static function getFade(target:DisplayObject, fadeID:uint = 0):FadeObject {
			for (var i:uint = 0; i < fadeObjectVector.length; i++) {
				var currentFadeObject:FadeObject = fadeObjectVector[i];
				
				if (currentFadeObject._target == target && currentFadeObject._fadeID == fadeID) return currentFadeObject;
			}
			
			return null;
		}
		
		private static function handleFade(fadeObject:FadeObject):void {
			var foundFade:FadeObject = getFade(fadeObject._target, fadeObject._fadeID);
			
			if (foundFade) foundFade.removeFade(true);
		}
	}
}