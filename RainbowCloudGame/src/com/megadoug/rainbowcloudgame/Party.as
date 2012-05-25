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
		private var _crowdLevel:uint = 1;
		private var _decorationLevel:uint = 1;
		private var _lightsLevel:uint = 1;
		private var _musicLevel:uint = 1;
		
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
		
		/**
		 * Gets / sets crowdLevel.
		 */

		public function get crowdLevel():uint {
			return _crowdLevel;
		};

		public function set crowdLevel(value:uint):void {
			_crowdLevel = Math.min(100, value);
			crowd_mc.gotoAndStop(_crowdLevel);
		};
		
		/**
		 * Gets / sets decorationLevel.
		 */

		public function get decorationLevel():uint {
			return _decorationLevel;
		};

		public function set decorationLevel(value:uint):void {
			_decorationLevel =  Math.min(100, value);
		};
		
		/**
		 * Gets / sets lightsLevel.
		 */

		public function get lightsLevel():uint {
			return _lightsLevel;
		};

		public function set lightsLevel(value:uint):void {
			_lightsLevel =  Math.min(100, value);
		};
		/**
		 * Gets / sets musicLevel.
		 */

		public function get musicLevel():uint {
			return _musicLevel;
		};

		public function set musicLevel(value:uint):void {
			_musicLevel =  Math.min(100, value);
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