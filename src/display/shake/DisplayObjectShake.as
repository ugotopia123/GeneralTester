package display.shake {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import functionality.MathFunctions;
	
	[Event(name = "display.shake.DisplayObjectShake.shakeStart", type = "display.shake.DisplayObjectShakeEvent")]
	[Event(name = "display.shake.DisplayObjectShake.shakeTick", type = "display.shake.DisplayObjectShakeEvent")]
	[Event(name = "display.shake.DisplayObjectShake.shakeComplete", type = "display.shake.DisplayObjectShakeEvent")]
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class DisplayObjectShake extends EventDispatcher {
		private static const SHORTEST_FRAME_DURATION:Number = 1 / 60;
		private var _target:DisplayObject;
		private var _duration:Number;
		private var _xIntensity:Number;
		private var _yIntensity:Number;
		private var _startEase:Number;
		private var _midEase:Number;
		private var _endEase:Number;
		private var _shakePercent:Number;
		private var xOrigin:Number;
		private var yOrigin:Number;
		private var range:Rectangle;
		private var currentEase:Number = 0;
		private var shakeTimer:Timer;
		private var delayTimer:Timer;
		private var midCount:uint;
		
		/**
		 * DisplayObjectShake handles a simple shake animation for a DisplayObject
		 * @param	target The target DisplayObject to shake. An Error is thrown if you provide a null value
		 * @param	duration The duration, in seconds, the shaking lasts. If the duration is below 1/60th of a second (the fastest frame rate possible), the duration is set to that value
		 * @param	xIntensity The maximum percent deviation from the origin the target is allowed to move in either x direction. For instance, an xIntensity of 1 allows the target to move 100% its width both positively and negatively from the origin in which the shaking starts
		 * @param	yIntensity The maximum percent deviation from the origin the target is allowed to move in either y direction. For instance, a yIntensity of 1 allows the target to move 100% its height both positively and negatively from the origin in which the shaking starts
		 * @param	startEase The ease percentage the target shakes at the start of the shake, the shake easing into the midEase for the first half of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 * @param	midEase The ease percentage the target shakes at the midpoint of the shake, easing from the startEase at the first half and easing to the endEase for the second half of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 * @param	endEase The ease percentage the target shakes at the end of the shake, easing from the midEase at the midpoint of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 * @param	shakePercent The maximum percentage of the target's width and height it's allowed to move per shake frame
		 * @param	startShake True to automatically start the shake when the DisplayObjectShake is created, otherwise call the startShake method to begin the shake
		 */
		public function DisplayObjectShake(target:DisplayObject, duration:Number, xIntensity:Number = 1, yIntensity:Number = 1, startEase:Number = 0, midEase:Number = 1, endEase:Number = 0, shakePercent:Number = 0.1, startShake:Boolean = false) {
			if (!target) throw new Error("Target of DisplayObjectShake cannot be null");
			if (duration < SHORTEST_FRAME_DURATION) duration = SHORTEST_FRAME_DURATION;
			if (xIntensity < 0) xIntensity = 0;
			if (yIntensity < 0) yIntensity = 0;
			
			if (startEase < 0) startEase = 0;
			else if (startEase > 1) startEase = 1;
			
			if (midEase < 0) midEase = 0;
			else if (midEase > 1) midEase = 1;
			
			if (endEase < 0) endEase = 0;
			else if (endEase > 1) endEase = 1;
			
			_target = target;
			_duration = duration;
			_xIntensity = xIntensity;
			_yIntensity = yIntensity;
			_startEase = startEase;
			_midEase = midEase;
			_endEase = endEase;
			_shakePercent = shakePercent;
			range = new Rectangle(target.x - target.width * xIntensity, target.y - target.height * yIntensity, target.width + target.width * xIntensity * 2, target.height + target.height * yIntensity * 2);
			shakeTimer = new Timer(1000 / 60, duration * 60);
			midCount = Math.round(shakeTimer.repeatCount / 2);
			shakeTimer.addEventListener(TimerEvent.TIMER, shakeTick);
			shakeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, shakeComplete);
			
			if (startShake) this.startShake();
		}
		
		/**
		 * The target DisplayObject that's shaking. Read-only
		 */
		public function get target():DisplayObject { return _target; }
		
		/**
		 * The duration, in seconds, the shaking lasts
		 */
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void { _duration = value; }
		
		/**
		 * The maximum percent deviation from the origin the target is allowed to move in either x direction. For instance, an xIntensity of 1 allows the target to move 100% its width both positively and negatively from the origin in which the shaking starts
		 */
		public function get xIntensity():Number { return _xIntensity; }
		public function set xIntensity(value:Number):void { _xIntensity = value; }
		
		/**
		 * The maximum percent deviation from the origin the target is allowed to move in either y direction. For instance, a yIntensity of 1 allows the target to move 100% its height both positively and negatively from the origin in which the shaking starts
		 */
		public function get yIntensity():Number { return _yIntensity; }
		public function set yIntensity(value:Number):void { _yIntensity = value; }
		
		/**
		 * The ease percentage the target shakes at the start of the shake, the shake easing into the midEase for the first half of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 */
		public function get startEase():Number { return _startEase; }
		public function set startEase(value:Number):void { _startEase = value; }
		
		/**
		 * The ease percentage the target shakes at the midpoint of the shake, easing from the startEase at the first half and easing to the endEase for the second half of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 */
		public function get midEase():Number { return _midEase; }
		public function set midEase(value:Number):void { _midEase = value; }
		
		/**
		 * The ease percentage the target shakes at the end of the shake, easing from the midEase at the midpoint of the shake. An easing of 0 means the object doesn't shake at all, an easing of 1 means the object shakes at its maximum value
		 */
		public function get endEase():Number { return _endEase; }
		public function set endEase(value:Number):void { _endEase = value; }
		
		/**
		 * The maximum percentage of the target's width and height it's allowed to move per shake frame
		 */
		public function get shakePercent():Number { return _shakePercent; }
		public function set shakePercent(value:Number):void { _shakePercent = value; }
		
		private function get rangeLeft():Number { return (range.left - xOrigin) * currentEase + xOrigin; }
		private function get rangeRight():Number { return (range.right - (xOrigin + _target.width)) * currentEase + (xOrigin + _target.width); }
		private function get rangeTop():Number { return (range.top - yOrigin) * currentEase + yOrigin; }
		private function get rangeBottom():Number { return (range.bottom - (yOrigin + _target.height)) * currentEase + (yOrigin + _target.height); }
		
		/**
		 * Resets the shakeTimer, sets the origin parameters, and starts the shaking process
		 */
		public function startShake():void {
			xOrigin = _target.x;
			yOrigin = _target.y;
			shakeTimer.reset();
			shakeTimer.start();
			dispatchEvent(new DisplayObjectShakeEvent(DisplayObjectShakeEvent.SHAKE_START));
		}
		
		private function shakeTick(e:TimerEvent):void {
			var currPercent:Number = shakeTimer.currentCount / midCount;
			var currStartEase:Number = _startEase;
			var currEndEase:Number = _midEase;
			
			if (shakeTimer.currentCount > midCount) {
				currPercent = (shakeTimer.currentCount - midCount) / (shakeTimer.repeatCount - midCount);
				currStartEase = _midEase;
				currEndEase = _endEase;
			}
			
			currentEase = currStartEase + (currEndEase - currStartEase) * currPercent;
			var xMove:Number = Math.abs(_target.width * _shakePercent * currentEase * 1000);
			var yMove:Number = Math.abs(_target.height * _shakePercent * currentEase * 1000);
			var randX:Number = MathFunctions.randomNumber(-xMove, xMove) / 1000;
			var randY:Number = MathFunctions.randomNumber(-yMove, yMove) / 1000;
			
			if (xMove != 0) {
				if (randX < 0 && _target.x + randX < rangeLeft) randX = rangeLeft - _target.x;
				else if (randX > 0 && _target.x + _target.width + randX > rangeRight) randX = rangeRight - (_target.x + _target.width);
				
				_target.x += randX;
			}
			
			if (yMove != 0) {
				if (randY < 0 && _target.y + randY < rangeTop) randY = rangeTop - _target.y;
				else if (randY > 0 && _target.y + _target.height + randY > rangeBottom) randY = rangeBottom - (_target.y + _target.height);
				
				_target.y += randY;
			}
			
			dispatchEvent(new DisplayObjectShakeEvent(DisplayObjectShakeEvent.SHAKE_TICK));
		}
		
		private function shakeComplete(e:TimerEvent):void {
			_target.x = xOrigin;
			_target.y = yOrigin;
			shakeTimer.reset();
			dispatchEvent(new DisplayObjectShakeEvent(DisplayObjectShakeEvent.SHAKE_COMPLETE));
		}
	}
}