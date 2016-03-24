////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import avmplus.DescribeType;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					08.10.2010 2:05:14
	 */
	public final class SerializationHelper {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _HASH:Dictionary = new Dictionary( true );

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function getPropertyNames(o:Object):Array {
			if ( typeof o != 'object' || !o ) Error.throwError( TypeError, 2007, 'o' );
			var c:Object = o is Class ? o as Class : o.constructor;
			var arr:Array = _HASH[ c ];
			if ( !arr ) {
				arr = new Array();

				try {

					o = DescribeType.get( c, DescribeType.INCLUDE_ACCESSORS | DescribeType.INCLUDE_VARIABLES | DescribeType.INCLUDE_TRAITS | DescribeType.USE_ITRAITS );
					if ( o.traits ) {
						var a:Object;
						for each( a in o.accessors ) {
							if ( !a.uri && a.access.charAt( 0 ) == 'r' ) {
								arr.push( a.name );
							}
						}
						if ( a in o.variables ) {
							arr.push( a.name );
						}
					}

				} catch ( e:Error ) {
				
					var n:String;
					var list:XMLList;
					for each ( var x:XML in describeType( c ).factory.* ) {
						n = x.name();
						if (
							(
								(
									n ==  'accessor' &&
									x.@access.charAt( 0 ) == 'r'
								) ||
								n == 'variable' ||
								n == 'constant'
							) &&
							x.@uri.length() <= 0
						) {
							list = x.metadata;
							if ( list.length() <= 0 || list.( @name == 'Transient' ).length() <= 0 ) {
								arr.push( x.@name.toString() );
							}
						}
					}
					
				}

				_HASH[ c ] = arr;

			}
			return arr.slice();
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		public function SerializationHelper() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}