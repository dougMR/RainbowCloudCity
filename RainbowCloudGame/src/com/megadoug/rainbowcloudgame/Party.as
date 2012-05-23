package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;

	/**
	 *  Constructs a Party Clip Extension
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-05-07
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Party extends MovieClip {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
	
		private var _guests:Vector.<MovieClip>;
		//private var _guestsAtParty:Vector.<MovieClip>;
		private var _crowdLevel:uint;
		private var _decorationLevel:uint;
		
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Party () {
			trace("Party");
			initGuests();
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Gets / sets guests.
		 */

		public function get guests():Vector.<MovieClip> {
			return _guests;
		};

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function initGuests ():void{
			trace("Party::initGuests");
			_guests = new <MovieClip>[guest01,guest02,guest03,guest04,guest05,guest06];
			for(var i:uint = 0; i < 6; i++){
				_guests[i].visible = false;
			}
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Create / Destroy
	    //
	    //--------------------------------------------------------------------------

	    //--------------------------------------------------------------------------
	    //
	    //  Overridden Methods
	    //
	    //--------------------------------------------------------------------------

	    //--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------
		
		

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}