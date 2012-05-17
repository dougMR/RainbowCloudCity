package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	
	import flash.events.Event;
	

	/**
	 *  Constructs a party Guest for Rainbow Cloud Game
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-05-07
	 *  @version 0.1
	 *  @copyright (c) 2012 megaloMedia. All rights reserved.
	 */

	public class Guest extends Body {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		private var _atParty:Boolean;
		private var _guestType:uint;
		private var _meAtParty:MovieClip;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Guest (type:uint = 1, partyGuest:MovieClip = null) {
			trace("Guest");
			meAtParty = partyGuest;
			_guestType = type;
			init();
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Gets / sets atParty.
		 */

		public function get atParty():Boolean {
			return _atParty;
		};

		public function set atParty(value:Boolean):void {
			_atParty = value;
		};
		
		/**
		 * Gets / sets meAtParty.
		 */

		public function get meAtParty():MovieClip {
			return _meAtParty;
		};

		public function set meAtParty(value:MovieClip):void {
			_meAtParty = value;
		};

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		private function init ():void{
			trace("Guest::init");
			_atParty = false;
			gotoAndStop(_guestType);
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
	
		//
		// PUBLIC METHODS
		//
		public function goToParty (x:Number, y:Number):void{
			trace("Guest::goToParty");
			// set gtween to x,y values
			var xDiff:Number = x-this.xPos;
			var yDiff:Number = y-this.yPos;
			var distSq:Number= xDiff*xDiff + yDiff*yDiff;
			var showDistSq:Number = 1000000;
			if(showDistSq < distSq){
				// traveling offscreen
				var pct:Number = Math.sqrt(showDistSq) / Math.sqrt(distSq);
				x = xPos + xDiff*pct;
				y = yPos + yDiff*pct;
			}
			
			var partyTween:GTween = new GTween(this, 3, {xPos:x,yPos:y}, { onComplete:arriveAtParty, ease:Cubic.easeIn});
			
			function arriveAtParty(gt:GTween){
				dispatchEvent(new Event(Event.COMPLETE));
			}

		}

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}