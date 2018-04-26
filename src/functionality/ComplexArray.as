package functionality {
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public dynamic class ComplexArray extends Array {
		
		/**
		 * A ComplexArray is a subclass of the Array class that grants additional functionality to Arrays that allow you to easier manipulate and work with them. Since Arrays are almost in all cases faster to process than ComplexArray only use this Class when you need its extra functionality
		 * @param	... rest The default items to add to this ComplexArray. This does not have the functionality of the Array where it sets the length if you provide a single number, instead this will add the integer to its list
		 */
		public function ComplexArray(... rest) {
			super();
			
			for (var i:uint = 0; i < rest.length; i++) this[i] = rest[i];
		}
		
		/**
		 * Checks if this ComplexArray contains the given item. This is a shorthand for the 'indexOf(item) != -1' line
		 * @param	item The item to search for
		 * @param	fromIndex Set if you want to start the search from a specific index, otherwise leave 0 to search the entire Array
		 * @return	Whether or not this ComplexArray contains the given item
		 */
		public function contains(item:*, fromIndex:uint = 0):Boolean {
			return indexOf(item, fromIndex) != -1;
		}
		
		/**
		 * Removes the given item from this ComplexArray, filling the index gap after it is removed
		 * @param	item The item to remove
		 * @param	fromIndex Set if you want to start the search from a specific index, otherwise leave 0 to search the entire Array
		 * @return	The index location the item was at before removal
		 */
		public function removeItem(item:*, fromIndex:uint = 0):int {
			var itemIndex:uint = indexOf(item, fromIndex);
			
			if (itemIndex != -1) removeAt(itemIndex);
			
			return itemIndex;
		}
		
		/**
		 * Moves an item to a new index, moving all items in front or behind to fill the gap
		 * @param	itemToMove The item to move
		 * @param	newIndex The new index location to move the item to
		 * @param	fromIndex Set if you want to start the search from a specific index, otherwise leave 0 to search the entire Array
		 */
		public function moveItem(itemToMove:*, newIndex:uint, fromIndex:uint = 0):void {
			var itemIndex:int = indexOf(itemToMove, fromIndex);
			
			if (itemIndex == -1) return;
			
			var difference:int = 1;
			
			if (newIndex > itemIndex) difference = -1;
			
			insertAt(newIndex, itemToMove);
			removeAt(itemIndex + difference);
		}
		
		/**
		 * Condenses this ComplexArray, removing any unwanted values
		 * @param	removeNull True to remove null indices
		 * @param	removeUndefined True to remove undefined indices
		 * @param	removeNaN True to remove NaN indices
		 * @param	... additionalValues Any additional values you want to remove from this ComplexArray
		 * @return	The new length of this ComplexArray
		 */
		public function condense(removeNull:Boolean = true, removeUndefined:Boolean = true, removeNaN:Boolean = true, ... additionalValues):uint {
			var indexVector:Vector.<uint> = new Vector.<uint>();
			
			for (var i:uint = 0; i < length; i++) {
				var value:* = this[i];
				
				if (removeNull && value === null) indexVector.push(i);
				else if (removeUndefined && value === undefined) indexVector.push(i);
				else if (removeNaN && isNaN(value)) indexVector.push(i);
				else if (additionalValues.length > 0) {
					for (var j:uint = 0; j < additionalValues.length; j++) {
						if (value === additionalValues[j]) {
							indexVector.push(i);
							break;
						}
					}
				}
			}
			
			if (indexVector.length == 0) return length;
			for (var k:uint = 0; k < indexVector.length; k++) removeAt(indexVector[k]);
			
			indexVector.length = 0;
			return length;
		}
		
		/**
		 * Creates a new ComplexArray that's a shallow copy of this ComplexArray
		 * @param	startIndex The starting index to copy. By default copying starts at the beginning of the array
		 * @param	endIndex The ending index to copy. By default copying finishes at the end of the array
		 * @return	A new ComplexArray that contains the same values of this ComplexArray
		 */
		public function copy(startIndex:uint = 0, endIndex:uint = 4294967295):ComplexArray {
			var returnArray:ComplexArray = new ComplexArray();
			
			if (length == 0) return returnArray;
			if (startIndex > length - 1) startIndex = length - 1;
			if (endIndex > length) endIndex = length;
			
			for (var i:uint = startIndex; i < endIndex; i++) returnArray.push([i]);
			
			return returnArray;
		}
		
		/**
		 * Combines the given elements into this ComplexArray, combining Array indices if an element is another Array
		 * @param	dense True to make iteration dense for Array copying, meaning if an Array is found that contains other Arrays, those internal Arrays are also iterated through (meaning this ComplexArray will only be one-dimensional). False to only copy Array indices from the main elements Array
		 * @param	... elements The elements to join into this ComplexArray. Each element can be of any type, but if an element is another Array then each index is combined into this ComplexArray
		 * @return	The new length of this ComplexArray
		 */
		public function combine(dense:Boolean = false, ... elements):uint {
			for (var i:uint = 0; i < elements.length; i++) {
				var currentElement:* = elements[i];
				
				if (currentElement is Array) {
					for (var j:uint = 0; j < currentElement.length; j++) {
						var arrayElement:* = currentElement[j];
						
						if (dense && arrayElement is Array) combine(true, arrayElement);
						else push(arrayElement);
					}
				}
				else push(currentElement);
			}
			
			return length;
		}
		
		/**
		 * Finds and returns the index location of the smallest number
		 * @param	randomReturn True to return a random index if multiple contain the same smallest number, false to return the first index that contains the smallest number
		 * @return	Either the first index where the smallest number is contained (if randomReturn is false), or a random index if multiple contain the smallest number (if randomReturn is true). If this ComplexArray or is empty, -1 is returned
		 */
		public function smallest(randomReturn:Boolean = false):int {
			if (length == 0) return -1;
			
			var smallest:Number = this[0];
			var currentIndex:uint = 0;
			var randVector:Vector.<uint> = new Vector.<uint>();
			
			for (var i:uint = 0; i < length; i++) {
				if (this[i] < smallest) {
					smallest = this[i];
					currentIndex = i;
				}
			}
			
			if (randomReturn) {
				for (var j:uint = 0; j < length; j++) {
					if (this[j] == smallest) {
						randVector.push(j);
					}
				}
				
				return randVector[MathFunctions.randomNumber(0, randVector.length - 1)];
			}
			
			return currentIndex;
		}
		
		/**
		 * Finds and returns the index location of the largest number
		 * @param	randomReturn True to return a random index if multiple contain the same largest number, false to return the first index that contains the largest number
		 * @return	Either the first index where the largest number is contained (if randomReturn is false), or a random index if multiple contain the largest number (if randomReturn is true). If this ComplexArray or is empty, -1 is returned
		 */
		public function largest(randomReturn:Boolean = false):int {
			if (length == 0) return -1;
			
			var largest:Number = this[0];
			var currentIndex:uint = 0;
			var randVector:Vector.<uint> = new Vector.<uint>();
			
			for (var i:uint = 0; i < length; i++) {
				if (this[i] > largest) {
					largest = this[i];
					currentIndex = i;
				}
			}
			
			if (randomReturn) {
				for (var j:uint = 0; j < length; j++) {
					if (this[j] == largest) {
						randVector.push(j);
					}
				}
				
				return randVector[MathFunctions.randomNumber(0, randVector.length - 1)];
			}
			
			return currentIndex;
		}
		
		/**
		 * Generates a ComplexArray that contains a randomly chosen percentage of this ComplexArray (this does not choose the same item more than once)
		 * @param	percent The percent of items to randomly choose (for instance, 0.5 will choose a random half of the items in this ComplexArray). Any percent greater than or equal to 1 returns a shallow copy of this ComplexArray
		 * @param	useRound True to round when calculating how many items to return. If false the function uses the useFloorOrCeil value
		 * @param	useFloorOrCeil Only used if useRound is false. True to use Math.floor when calculating how many items to return, false to use Math.ceil
		 * @return	A new ComplexArray containing a randomly chosen amount of items from this ComplexArray
		 */
		public function randomPercent(percent:Number, useRound:Boolean = true, useFloorOrCeil:Boolean = false):ComplexArray {
			if (percent >= 1) return copy();
			
			var copyArray:ComplexArray = copy();
			var returnArray:ComplexArray = new ComplexArray();
			var chooseTotal:Number = length * percent;
			
			if (useRound) chooseTotal = Math.round(chooseTotal);
			else if (useFloorOrCeil) chooseTotal = Math.floor(chooseTotal);
			else chooseTotal = Math.ceil(chooseTotal);
			
			if (chooseTotal > copyArray.length) chooseTotal = copyArray.length;
			
			while (returnArray.length < chooseTotal) {
				var randIndex:uint = MathFunctions.randomNumber(0, copyArray.length - 1);
				returnArray.push(copyArray[randIndex]);
				copyArray.removeAt(randIndex);
			}
			
			return returnArray;
		}
	}
}