package functionality {
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * ...
	 * @author Alec Spillman
	 */
	public class Serializer {
		private static var definitions:Vector.<String> = new Vector.<String>();
		private static var serializerClassVector:Vector.<Class> = new Vector.<Class>();
		private static var serializerMethodVector:Vector.<Function> = new Vector.<Function>();
		private static var deserializerClassVector:Vector.<Class> = new Vector.<Class>();
		private static var deserializerMethodVector:Vector.<Function> = new Vector.<Function>();
		private static var copyClassVector:Vector.<Class> = new Vector.<Class>();
		private static var copyMethodVector:Vector.<Function> = new Vector.<Function>();
		
		/**
		 * Serializes an item, converting it into a save-friendly Object that can be written to a SharedObject data value. This method is dense, meaning it goes through every variable in the value and serializes any value that cannot be written to the SharedObject. There is risk of recursion if the value has variables that reference each other. This method can only reach public values, any protected or private ones cannot be serialized.
		 * Note if you want to skip any values and not serialize them simply use a [NonSerialized] metadata tag on any value, the serializer will skip that value
		 * @param	value The value to serialize. This can be any type, but if the item is already save-friendly like an int or a String, then that same value is returned. If you want special cases to happen when specific instances of Classes are found, use the addSerializedClass method
		 * @return	Either the given value if it is already save-friendly, like a primitive, or an Object instance with each of its values serialized
		 */
		public static function serialize(value:*):Object {
			if (value === null) return null;
			else if (value === undefined) return undefined;
			else if (value is Number && isNaN(value)) return NaN;
			else if (isPrimitive(value) || value is Class) return value;
			
			var itemClassString:String = getQualifiedClassName(value);
			var returnObject:Object = checkCustomSerializer(value);
			
			if (itemClassString == "Array") {
				returnObject = new Array();
				
				for (var i:uint = 0; i < value.length; i++) returnObject.push(serialize(value[i]));
				
				return returnObject;
			}
			
			if (!returnObject) {
				var willReturn:Boolean = true;
				
				if (itemClassString == "Object") {
					returnObject = serializeObject(value);
				}
				else if (value is Vector.<*> || value is Vector.<Number> || value is Vector.<int> || value is Vector.<uint>) {
					returnObject = serializeVector(value);
				}
				else if (value is Dictionary) {
					returnObject = serializeDictionary(value);
				}
				else if (value is Array) {
					returnObject = serializeArray(value);
					willReturn = false;
				}
				else {
					returnObject = new Object();
					willReturn = false;
				}
				
				returnObject.serializedClassType = itemClassString;
				
				if (willReturn) return returnObject;
				
				var typeDescription:XML = describeType(value);
				var typeProperties:XMLList = typeDescription.variable + typeDescription.accessor;
				
				for each (var property:XML in typeProperties) {
					var propertyName:String = property.@name.toString();
					var propertyAccess:String = property.@access.toString();
					var nonSerializedMetaData:XMLList = property.metadata.(@name == "NonSerialized");
					
					if (propertyAccess != "writeonly" && nonSerializedMetaData.length() == 0) {
						returnObject[propertyName] = serialize(value[propertyName]);
					}
				}
			}
			
			returnObject.serializedClassType = itemClassString;
			return returnObject;
		}
		
		/**
		 * Deserializes an item that was converted using the serialize method. This converts all its values back to their original Class types and sets them to their written values. You can load items from a SharedObject data value using this method. Note that if this method needs to create a new instance of a Class type then the Class requires to either take no parameters in its constructor or have all parameters set to a default value
		 * @param	value The serialized Object to deserialize. If the value is a primitive, like an int or a String, that same value is returned. To have your own custom deserialized methods for specific Class types, use the addDeserializedClass method. If the definition of the instance Class changed (either you renamed it or moved the location), you'll have to update the path using the addChangedDefinition method
		 * @param	strictDeserialization True to have strict deserialization, where the code will throw an Error if any issue is found. Issues could be things such as a variable on a serialized object that no longer exists on the Class (either by renaming or removing it), or a Class constructor requiring parameters with no default values. A value of false attempts to bypass issues since sometimes the issues don't affect the deserialized object (any bypassed issues are traced out to the program log)
		 * @return	A new instance of the serialized item's Class with all its values also deserialized
		 */
		public static function deserialize(value:*, strictDeserialization:Boolean = true):* {
			if (value === null) return null;
			else if (value === undefined) return undefined;
			else if (value is Number && isNaN(value)) return NaN;
			else if (isPrimitive(value) || value is Class) return value;
			else if (value is Array) {
				var returnArray:Array = new Array();
				
				for (var i:uint = 0; i < value.length; i++) returnArray.push(deserialize(value[i]));
				
				return returnArray;
			}
			
			for (var j:uint = 0; j < definitions.length; j += 2) {
				if (value.serializedClassType == definitions[j]) {
					value.serializedClassType = definitions[j + 1];
				}
			}
			
			try { getDefinitionByName(value.serializedClassType); }
			catch (error:Error) {
				if (strictDeserialization) throw new Error("Cannot resolve Class type " + value.serializedClassType + " for deserialization");
				
				trace("Class type " + value.serializedClassType + " is not found. This may be referencing an old class that has been renamed, moved, or no longer exists. Null will be returned for this value");
				return null;
			}
			
			var customValue:* = checkCustomDeserializer(value);
			if (customValue) return customValue;
			
			var ItemClass:Class = Class(getDefinitionByName(value.serializedClassType));
			
			if (ItemClass === Object) {
				return deserializeObject(value);
			}
			else if (getQualifiedSuperclassName(ItemClass) === "Array") {
				return deserializeArray(value);
			}
			else if (value.serializedClassType.indexOf("__AS3__.vec::Vector") == 0) {
				return deserializeVector(value);
			}
			else if (ItemClass === Dictionary) {
				return deserializeDictionary(value);
			}
			
			var returnItem:*;
			
			try { returnItem = new ItemClass(); }
			catch (err:Error) {
				if (strictDeserialization) throw new Error("Cannot create instance of " + value.serializedClassType + ", constructor is either not empty or does not have default values");
				
				trace("Could not create a new instance of type " + value.serializedClassType + ", check that the constructor doesn't require parameters or give all parameters default values. Null will be returned for this variable.");
				return null;
			}
			
			for (var currentVar:String in value) {
				if (currentVar == "serializedClassType") continue;
				
				try { returnItem[currentVar]; }
				catch (err:Error) {
					if (strictDeserialization) throw new Error("Serialized variable '" + currentVar + "' on Class type " + value.serializedClassType + " does not exist");
					
					trace("Serialized variable '" + currentVar + "' on Class " + value.serializedClassType + " does not exist. This variable will be skipped.");
					continue;
				}
				
				var deserializedItem:* = deserialize(value[currentVar], strictDeserialization);
				var valueClass:String = getQualifiedClassName(deserializedItem);
				var returnClass:String = getQualifiedClassName(returnItem[currentVar]);
				
				
				if (valueClass != returnClass) {
					if (strictDeserialization) throw new Error("Variable '" + currentVar + "' on Class " + value.serializedClassType + " is type " + returnClass + ", but serialized value is type " + valueClass);
					
					trace("Variable '" + currentVar + "' on Class " + value.serializedClassType + " is type " + returnClass + ", but serialized value is type " + valueClass + ". This variable will be skipped");
					continue;
				}
				
				returnItem[currentVar] = deserializedItem;
			}
			
			return returnItem;
		}
		
		/**
		 * Creates a dense copy of an item, copying the value itself alongside any variable the value has. Note if you want to skip any values and not copy them simply use a [NonCopyable] metadata tag on any value, the copier will skip that value
		 * @param	value The original value to copy. When copying is complete no value on the returned item has no reference to the given value
		 * @return	A dense copy of the given value
		 */
		public static function copyItem(value:*):* {
			if (value === null) return null;
			else if (value === undefined) return undefined;
			else if (value is Number && isNaN(value)) return NaN;
			else if (isPrimitive(value) || value is Class) return value;
			
			var ItemClass:Class = Class(getDefinitionByName(getQualifiedClassName(value)));
			var returnItem:* = checkCustomCopy(value);
			
			if (!returnItem) {
				if (ItemClass === Object) {
					return copyObject(value);
				}
				else if (ItemClass === Array || getQualifiedSuperclassName(ItemClass) === "Array") {
					returnItem = copyArray(value);
				}
				else if (value is Vector.<*> || value is Vector.<Number> || value is Vector.<int> || value is Vector.<uint>) {
					return copyVector(value);
				}
				else if (ItemClass === Dictionary) {
					return copyDictionary(value);
				}
				else {
					try { returnItem = new ItemClass(); }
					catch (err:Error) { throw new Error("Cannot create instance of " + ItemClass + ", constructor is either not empty or does not have default values"); }
				}
				
				var typeDescription:XML = describeType(value);
				var typeProperties:XMLList = typeDescription.variable + typeDescription.accessor;
				
				for each (var property:XML in typeProperties) {
					var propertyName:String = property.@name.toString();
					var propertyAccess:String = property.@access.toString();
					var nonSerializedMetaData:XMLList = property.metadata.(@name == "NonCopyable");
					
					if (propertyAccess != "writeonly" && nonSerializedMetaData.length() == 0) {
						returnItem[propertyName] = copyItem(value[propertyName]);
					}
				}
			}
			
			return returnItem;
		}
		
		/**
		 * Adds a new definition change if you've either moved the path of a Class or changed its name. Serialization saves the path and Class name when items are serialized, so changing the path will make deserialization unable to resolve. This method will allow old instances to resolve and still be able to be deserialized
		 * @param	originalDefinition The original definition name it its entirety. This will be the same name that's shown in your Class's package location at the top of the file alongside the Class name, such as "foo.bar.FooBarClass"
		 * @param	movedDefinition The new definition location of the Class. This will be the same name that's shown in your Class's package location at the top of the file alongside the Class name, such as "foo.newBar.NewFooBarClass"
		 */
		public static function addChangedDefinition(originalDefinition:String, movedDefinition:String):void {
			definitions.push(originalDefinition, movedDefinition);
		}
		
		/**
		 * Adds a special case for a Class type, skipping serialization if instances of the given Class are found and instead calling the supplied method
		 * @param	type The Class type. This method does nothing if you've already registered the given Class type
		 * @param	methodCall The method to call when instances of the type is found. The method must take one parameter: the value being serialized, and must return an Object
		 */
		public static function addSerializedClass(type:Class, methodCall:Function):void {
			if (serializerClassVector.indexOf(type) != -1) return;
			
			serializerClassVector.push(type);
			serializerMethodVector.push(methodCall);
		}
		
		/**
		 * Adds a special case for a Class type, skipping deserialization if instances of the given Class are found and instead calling the supplied method
		 * @param	type The Class type. This method does nothing if you've already registered the given Class type
		 * @param	methodCall The method to call when instances of the type is found. The method must take one parameter: the serialized item, and must return an instance of the Class type
		 */
		public static function addDeserializedClass(type:Class, methodCall:Function):void {
			if (deserializerClassVector.indexOf(type) != -1) return;
			
			deserializerClassVector.push(type);
			deserializerMethodVector.push(methodCall);
		}
		
		/**
		 * Adds a special case for a Class type, skipping copying if instances of the given Class are found and instead calling the supplied method
		 * @param	type The Class type. This method does nothing if you've already registered the given Class type
		 * @param	methodCall The method to call when an instance of the type is found. The method must take one parameter: the item to copy, and must return a new instance of the Class type
		 */
		public static function addCopyClass(type:Class, methodCall:Function):void {
			if (copyClassVector.indexOf(type) != -1) return;
			
			copyClassVector.push(type);
			copyMethodVector.push(methodCall);
		}
		
		private static function checkCustomSerializer(value:*):Object {
			var valueClass:Class = Class(getDefinitionByName(getQualifiedClassName(value)));
			var classIndex:int = serializerClassVector.indexOf(valueClass);
			
			if (classIndex == -1) return null;
			
			return serializerMethodVector[classIndex].call(null, value);
		}
		
		private static function serializeObject(value:Object):Object {
			var returnObject:Object = new Object();
			
			for (var id:String in value) {
				returnObject[id] = serialize(value[id]);
			}
			
			return returnObject;
		}
		
		private static function serializeArray(array:Array):Object {
			var returnObject:Object = new Object();
			returnObject.toArray = new Array();
			
			for (var arrayIndex:uint = 0; arrayIndex < array.length; arrayIndex++) {
				returnObject.toArray.push(serialize(array[arrayIndex]));
			}
			
			return returnObject;
		}
		
		private static function serializeVector(vector:*):Object {
			var returnObject:Object = new Object();
			returnObject.toArray = new Array();
			
			for (var vectorIndex:uint = 0; vectorIndex < vector.length; vectorIndex++) {
				returnObject.toArray.push(serialize(vector[vectorIndex]));
			}
			
			return returnObject;
		}
		
		private static function serializeDictionary(dictionary:Dictionary):Object {
			var returnObject:Object = new Object();
			returnObject.keyArray = new Array();
			returnObject.valueArray = new Array();
			
			for (var key:Object in dictionary) {
				returnObject.keyArray.push(serialize(key));
				returnObject.valueArray.push(serialize(dictionary[key]));
			}
			
			return returnObject;
		}
		
		private static function checkCustomDeserializer(value:Object):* {
			var valueClass:Class = Class(getDefinitionByName(value.serializedClassType));
			var classIndex:int = deserializerClassVector.indexOf(valueClass);
			
			if (classIndex == -1) return null;
			
			return deserializerMethodVector[classIndex].call(null, value);
		}
		
		private static function deserializeObject(object:Object):Object {
			var returnObject:Object = new Object();
			
			for (var value:String in object) {
				returnObject[value] = deserialize(object[value]);
			}
			
			return returnObject;
		}
		
		private static function deserializeArray(object:Object):* {
			var ArrayClass:Class = Class(getDefinitionByName(object.serializedClassType));
			var returnArray:* = new ArrayClass();
			
			for (var i:uint = 0; i < object.toArray.length; i++) {
				returnArray.push(deserialize(object.toArray[i]));
			}
			
			return returnArray;
		}
		
		private static function deserializeVector(object:Object):* {
			var VectorClass:Class = Class(getDefinitionByName(object.serializedClassType));
			var returnVector:* = new VectorClass();
			
			for (var i:uint = 0; i < object.toArray.length; i++) {
				returnVector.push(deserialize(object.toArray[i]));
			}
			
			return returnVector;
		}
		
		private static function deserializeDictionary(object:Object):Dictionary {
			var returnDictionary:Dictionary = new Dictionary();
			
			for (var i:uint = 0; i < object.keyArray.length; i++) {
				returnDictionary[deserialize(object.keyArray[i])] = deserialize(object.valueArray[i]);
			}
			
			return returnDictionary;
		}
		
		private static function checkCustomCopy(value:*):* {
			var ValueClass:Class = Class(getDefinitionByName(getQualifiedClassName(value)));
			var classIndex:int = copyClassVector.indexOf(ValueClass);
			
			if (classIndex == -1) return null;
			
			return copyMethodVector[classIndex].call(null, value);
		}
		
		private static function copyObject(value:Object):Object {
			var returnObject:Object = new Object();
			
			for (var id:String in value) returnObject[id] = copyItem(value[id]);
			
			return returnObject;
		}
		
		private static function copyArray(value:Array):* {
			var ArrayClass:Class = Class(getDefinitionByName(getQualifiedClassName(value)));
			var returnArray:* = new ArrayClass();
			
			for (var i:uint = 0; i < value.length; i++) returnArray.push(copyItem(value[i]));
			
			return returnArray;
		}
		
		private static function copyVector(value:*):* {
			var VectorClass:Class = Class(getDefinitionByName(getQualifiedClassName(value)));
			var returnVector:* = new VectorClass();
			
			for (var i:uint = 0; i < value.length; i++) returnVector.push(copyItem(value[i]));
			
			return returnVector;
		}
		
		private static function copyDictionary(value:Dictionary):Dictionary {
			var returnDictionary:Dictionary = new Dictionary();
			
			for (var key:Object in value) returnDictionary[key] = copyItem(value[key]);
			
			return returnDictionary;
		}
		
		private static function isPrimitive(value:*):Boolean {
			return (value is Number || value is String || value is Boolean);
		}
	}
}