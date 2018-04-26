package functionality {
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class MathFunctions {
		
		/**
		 * Generates a random number between the two given values (inclusive)
		 * @param	min The minimum Number in the range
		 * @param	max The maximum Number in the range
		 * @return	A random number between the min and max values (inclusive)
		 */
		public static function randomNumber(min:Number, max:Number):Number {
			return Math.floor(Math.random() * (1 + max - min)) + min;
		}
		
		/**
		 * Attempts a random chance between 1 and 99 (this number can include decimals)
		 * @param	chance The random chance to attempt to pass. If the number is less than or equal to 0 it automatically returns false, if it's greater than or equal to 100 it automcatically returns true
		 * @return	Whether the given chance passed its attempt or not
		 */
		public static function tryChance(chance:Number):Boolean {
			if (chance >= 100) return true;
			else if (chance <= 0) return false;
			
			var chanceMult:Number = Math.round(chance * Math.pow(10, 5));
			var maxMult:Number = Math.round(100 * Math.pow(10, 5));
			var randNumber:Number = randomNumber(1, maxMult);
			
			return randNumber <= chanceMult;
		}
		
		/**
		 * Rounds a Number to the nearest given decimal place
		 * @param	initialNumber The starting number, the original value is unchanged
		 * @param	decimalPlace The decimal place to round the Number, the possible range is 0-20
		 * @return	The rounded Number to the given decimal place
		 */
		public static function round(initialNumber:Number, decimalPlace:uint = 0):Number {
			if (decimalPlace > 20) decimalPlace = 20;
			
			var multiplier:Number = Math.pow(10, decimalPlace);
			
			return Math.round(initialNumber * multiplier) / multiplier;
		}
		
		/**
		 * Sums the elements of the given Array and generates the average. Returns NaN if the Array is empty
		 */
		public static function average(numbers:Array):Number {
			if (numbers.length == 0) return NaN;
			
			var sum:Number = 0;
			
			for each (var num:Number in numbers) { sum += num; }
			
			return sum / numbers.length;
		}
		
		/**
		 * Finds the smallest number in the given Array. Returns NaN if the Array is empty
		 */
		public static function smallest(numbers:Array):Number {
			if (numbers.length == 0) return NaN;
			
			var smallest:Number = numbers[0];
			
			for (var i:uint = 0; i < numbers.length; i++) {
				var currentNum:Number = numbers[i];
				
				if (currentNum < smallest) smallest = currentNum;
			}
			
			return smallest;
		}
		
		/**
		 * Finds the largest number in the given Array. Returns NaN if the Array is empty
		 */
		public static function largest(numbers:Array):Number {
			if (numbers.length == 0) return NaN;
			
			var largest:Number = numbers[0];
			
			for (var i:uint = 0; i < numbers.length; i++) {
				var currentNum:Number = numbers[i];
				
				if (currentNum > largest) largest = currentNum;
			}
			
			return largest;
		}
		
		/**
		 * Checks if the given value is an even number. Note that a value of false doesn't necessarily mean the number is odd, but that the value wasn't determined to be even. Decimal numbers can neither be even nor odd, so providing one will return false
		 */
		public static function isEven(value:Number):Boolean {
			return value % 2 == 0;
		}
		
		/**
		 * Checks if the given value is a whole number (doesn't contain decimals)
		 */
		public static function isWhole(value:Number):Boolean {
			return value == Math.floor(value);
		}
		
		/**
		 * Checks if the given value is a positive number
		 */
		public static function isPositive(value:Number):Boolean {
			return value > 0;
		}
		
		/**
		 * Generates a ComplexArray of a linear, interpolated series of numbers based on the beginning and ending numbers. For instance, if the beginning number is 0, the ending number is 100, and there's 5 series total the function returns a ComplexArray containing 0,25,50,75,100.
		 * @param	begin The starting Number
		 * @param	end The ending Number
		 * @param	series The total number of series for interpolation. The series is inclusive to the begin and end numbers
		 * @return	A ComplexArray containing all interpolated numbers for every series from the beginning to the end numbers
		 */
		public static function interpolate(begin:Number, end:Number, series:uint):Array {
			var returnArray:Array = new Array();
			var seriesIncrement:Number = (end - begin) / (series - 1);
			var currentNumber:Number = begin;
			returnArray.push(begin);
			
			for (var i:uint = 0; i < series - 1; i++) returnArray.push(currentNumber += seriesIncrement);
			
			return returnArray;
		}
	}
}