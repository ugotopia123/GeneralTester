package functionality {
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Seed {
		private static const MAX_RATIO:Number = 1 / uint.MAX_VALUE;
		private static var _seeds:Vector.<Seed> = new Vector.<Seed>();
		protected var _seedName:String;
		protected var _setSeed:uint;
		protected var _currentSeed:uint;
		
		/**
		 * Creates a Seed, which can then be used to create controllable pseudo-random generation. Calling the randomNumber method changes this Seed's currentSeed value by a set amount, which means different Seeds with the same currentSeed value will return the same result
		 * @param	seedName The name of this Seed, used for lookup
		 * @param	initialValue The initial currentSeed value to set. This number can be any number in the uint range except 0
		 * @param	addToVector True to add this Seed to the initial Vector of Seeds
		 */
		public function Seed(seedName:String = "", initialValue:uint = 1, addToVector:Boolean = false) {
			if (addToVector) _seeds.push(this);
			if (initialValue == 0) initialValue = 1;
			
			_seedName = seedName;
			_setSeed = _currentSeed = initialValue;
		}
		
		/**
		 * The name of this Seed, used for lookup
		 */
		public function get seedName():String { return _seedName; }
		public function set seedName(value:String):void { _seedName = value; }
		
		/**
		 * The initial value this Seed was set to on initializing
		 */
		public function get setSeed():uint { return _setSeed; }
		
		/**
		 * The current value of this Seed
		 */
		public function get currentSeed():uint { return _currentSeed; }
		
		/**
		 * The Vector of Seeds currently initialized
		 */
		public static function get seeds():Vector.<Seed> { return _seeds; }
		
		/**
		 * Generates a random number between the two given values. In the process this Seed's currentSeed is automatically changed
		 */
		public function randomNumber(min:Number, max:Number):Number {
			return Math.floor(random() * (1 + max - min)) + min;
		}
		
		private function random():Number {
			if (_currentSeed == 0) _currentSeed = 1;
			
			currentSeed ^= (currentSeed << 21);
			currentSeed ^= (currentSeed >>> 35);
			currentSeed ^= (currentSeed << 4);
			return currentSeed * MAX_RATIO;
		}
		
		/**
		 * Attempts to find a Seed in the initialized Vector of Seeds with the given name
		 * @param	name The seedName value to use for lookup
		 * @return	Either a reference to the found Seed with the same name, or null if no Seed could be found
		 */
		public static function getSeed(name:String):Seed {
			for (var i:uint = 0; i < _seeds.length; i++) {
				if (_seeds[i]._seedName == name) return _seeds[i];
			}
			
			return null;
		}
	}
}