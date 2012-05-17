package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;

	/**
	 *  Constructs a body with x,y,xspeed,yspeed
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-04-26
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Body extends MovieClip {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		protected var _xPos:Number;
		protected var _yPos:Number;
		// ^ relative to World, not to screen

		protected var _maxXspeed:Number;
		protected var _maxYspeed:Number;
		protected var _xSpeed:Number;
		protected var _ySpeed:Number;
		
		protected var _inCloud:Cloud;
				
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Body () {
			trace("Body");
			initBody();
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
	
	
		/**
		 * Gets / sets xPos.
		 */

		public function get xPos():Number {
			return _xPos;
		};

		public function set xPos(value:Number):void {
			if(value != _xPos){
				_xPos = value;
				x = _xPos;
			}
		};
	
		/**
		 * Gets / sets yPos.
		 */

		public function get yPos():Number {
			return _yPos;
		};

		public function set yPos(value:Number):void {
			if(value != _yPos){
				_yPos = value;
				y = _yPos;
			}
		};

		/**
		 * Gets / sets xSpeed.
		 */

		public function get xSpeed():Number {
			return _xSpeed;
		};

		public function set xSpeed(value:Number):void {
			_xSpeed = Math.max(-_maxXspeed, Math.min(_maxXspeed, value));
		};
	
		/**
		 * Gets / sets ySpeed.
		 */

		public function get ySpeed():Number {
			return _ySpeed;
		};

		public function set ySpeed(value:Number):void {
			_ySpeed = Math.min(_maxYspeed, value);;
		};
		
		
		/**
		 * Gets / sets inCloud.
		 */

		public function get inCloud():Cloud {
			return _inCloud;
		};

		public function set inCloud(value:Cloud):void {
			_inCloud = value;
		};


	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
	
		private function initBody ():void{
			trace("Body::initBody");
			_xPos = 0;
			_yPos = 0;
			_maxXspeed = 10;
			_maxYspeed = 10;
			_xSpeed = 0;
			_ySpeed = 0;
			_inCloud = null;
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