package com.megadoug.rainbowcloudgame {

	import flash.display.*;
	import flash.utils.*;

	/**
	 *  Constructs a Player Avatar for Rainbow Cloud Game
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-04-14
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Player extends Body {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
/*		private var _xPos:Number;
		private var _yPos:Number;
		// ^ relative to World, not to screen
		
		private var _maxXspeed:Number;
		private var _maxYspeed:Number;
		private var _xSpeed:Number;
		private var _ySpeed:Number;*/
		
		private var _frame:String;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Player () {
			super();
			trace("Player");
			init();
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Gets / sets xPos.
		 */

		override public function set xPos(value:Number):void {
			if(value != _xPos){
				_xPos = value;
				//x = _xPos;
			}
		};
	
		/**
		 * Gets / sets yPos.
		 */

		override public function set yPos(value:Number):void {
			if(value != _yPos){
				_yPos = value;
				//y = _yPos;
			}
		};
		
		/**
		 * Gets / sets frame.
		 */

		public function get frame():String {
			return _frame;
		};

		public function set frame(value:String):void {
			if(	_frame != value){
				_frame = value;
				gotoAndStop(_frame);
			}
		};
		
	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
	
		private function init ():void{
			trace("Player::init");
			_xPos = _yPos = _xSpeed = _ySpeed = 0;
			_maxXspeed = 10;
			_maxYspeed = 20;
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