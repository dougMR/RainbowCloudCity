package com.megadoug.rainbowcloudgame {

	import flash.display.*;
	import flash.utils.*;

	/**
	 *  Constructs a 
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-04-14
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Cloud extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		

		private var _xPos:Number;
		private var _yPos:Number;
		// ^ relative to World, not to screen
		
		private var _width:Number;
		private var _height:Number;
		
		private var _xSpeed:Number;
		private var _ySpeed:Number;
		private var _circRadius:uint;
		
		private var _cloudColor:uint;
		
		private var _rainbowsAttached:uint;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Cloud (w:Number = 300, h:Number = 100, color:uint = 0xFFFFFF) {
			//trace("Cloud");
			_width = w;
			_height = h;
			_cloudColor = color;
			_circRadius = Math.round(_height / 2);
			draw();
			this.cacheAsBitmap = true;
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
	
	
		/**
		 * Gets / sets width.
		 */

		override public function get width():Number {
			return _width;
		};

		override public function set width(value:Number):void {
			_width = value;
		};
		
		/**
		 * Gets / sets height.
		 */

		override public function get height():Number {
			return _height;
		};

		override public function set height(value:Number):void {
			_height = value;
		};
	
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
			_xSpeed = value;
		};
		
		/**
		 * Gets / sets ySpeed.
		 */

		public function get ySpeed():Number {
			return _ySpeed;
		};

		public function set ySpeed(value:Number):void {
			_ySpeed = value;
		};
		
		/**
		 * Gets / sets rainbowsAttached.
		 */

		public function get rainbowsAttached():uint {
			return _rainbowsAttached;
		};

		public function set rainbowsAttached(value:uint):void {
			_rainbowsAttached = value;
		};

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
	
		private function init ():void{
			//trace("Cloud::init");
			_xPos = _yPos = _xSpeed = _ySpeed = 0;
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
	
		private function draw ():void{
			//trace("Cloud::draw");
			
			var g:Graphics = this.graphics;
			
			
			// Cloud Bottom
			var bWidth:Number = _circRadius * 4;
			
			var startX:Number = - Math.max(_circRadius, 0.1 * bWidth);
			var span:Number = _width - startX * 2;
			span = Math.max(span, 100);
			var numPuffs:uint = Math.ceil( span / (bWidth * .7));
			numPuffs = Math.max(2, numPuffs);
			var step:Number = (span-bWidth) / (numPuffs-1);
			//trace("numpuffs-round: "+numPuffs)
			for(var i:uint = 0; i< numPuffs; i++){
				// draw upper puff
				g.beginFill(_cloudColor);
				var x:Number = startX + i*step;
				var y:Number = _height * 0.25;
				var w:Number = bWidth+10 - Math.random()*20;
				var r:Number = _circRadius;// + 5 - Math.random()*10;
				g.drawEllipse(x,y, w, r * 2);
				g.endFill();
/*				if(i > 12){
					trace("BREAKING-oval ["+numPuffs+"]")
					break;
				}*/
			}
			
			
			// Cloud Top
			var fromSides:Number = 0.9 * _circRadius;
			if(fromSides > _width*0.5){
				fromSides = _width*0.48;
			}
			numPuffs = Math.round( (_width-fromSides * 2) / _circRadius);
			numPuffs = Math.max(2, numPuffs);
/*			if(numPuffs > 30){
				trace("\rnumpuffs-round: "+numPuffs)
				
				trace("width: "+_width)
				trace("fromsides: "+fromSides)
				trace("_circRadius: "+_circRadius)
				trace("Math.round( (_width-fromSides * 2) / _circRadius): "+Math.round( (_width-fromSides * 2) / _circRadius))
			}*/
			
			//trace("numPuffs: "+numPuffs);
			step = (_width - fromSides * 2 )/(numPuffs - 1);
			for( i = 0; i< numPuffs; i++){
				// draw upper puff
				g.beginFill(_cloudColor);
				x = fromSides + i*step;
				y = _height * 0.25;
				 r = _circRadius + _circRadius * 0.15 - Math.random()*_circRadius * 0.3;
				g.drawCircle(x, y, r);
				g.endFill();
				if(i > 62){
					trace("BREAKING-round["+numPuffs+"]")
					break;
				}
			}
			
			// Draw Box
/*			g.moveTo(0,0);
			g.lineStyle(1, 0xccccff);
			g.lineTo(_width, 0);
			g.lineTo(_width, _height);
			g.lineTo(0,_height);
			g.lineTo(0,0);*/
			
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}