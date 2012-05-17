package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;
	
	import flash.geom.Matrix;
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	
	import flash.geom.ColorTransform;
	
	import flash.filters.ColorMatrixFilter;

	/**
	 *  Constructs a Star shape that has states (locked / unlocked, filled / empty)
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Doug Roussin
	 *  @since  2012-04-12
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Star extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		private var _radius:Number;
		private var _color1:uint;
		private var _color2:uint;
		private var _kind:String;
		private var _startDegree:Number;
		
		private var _locked:Boolean;
		private var _filled:Boolean;
		
		private var _slot:Shape;
		private var _star:Shape;
		
		private var _xPos:Number;
		private var _yPos:Number;
				
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Star (r:Number = 28, rot:Number = -90, c1:int = -1, c2:int = -1, kind:String = "none") {
			//trace("UIStarSlot");
			_radius = r;
			_kind = kind;
			if(_kind != "none"){
				switch( _kind ){

					case "yellow":
						_color1 = 0xFFFF66;
						_color2 = 0xFFcc00;
						break;
					case "red":
						_color1 = 0xFF0000;
						_color2 = 0x990000;
						break;
					default:
					case "green":
						_color1 = 0x00FF00;
						_color2 = 0x006600;
						break;
					case "orange":
						_color1 = 0xFF9900;
						_color2 = 0xFF6600;
						break;
					case "blue":
						_color1 = 0x45A7FF;
						_color2 = 0x000099;
						break;	
					case "violet":
						_color1 = 0x9966ff;
						_color2 = 0x660066;
						break;				
				}
			}else{
				if(c1 == -1){
					_color1 = 0xFFcc00;
				}else{
					_color1 = c1;
				}
				if(c2 == -1){
					_color2 = 0xFFFF33;
				}else{
					_color2 = c2;
				}
			}
			_startDegree = rot;
			
			init();
			createChildren();
			//draw();
			this.cacheAsBitmap = true;
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Gets / sets locked.
		 */

		public function get locked():Boolean {
			return _locked;
		};

		public function set locked(value:Boolean):void {
			if(value != _locked){
				_locked = value;
				if(_locked){
					_filled = false;
				}
				draw();
			}
		};
		
		/**
		 * Gets / sets filled.
		 */

		public function get filled():Boolean {
			return _filled;
		};

		public function set filled(value:Boolean):void {
			if(value != _filled){
				_filled = value;	
				draw();
			}
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
		

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function init ():void{
			//trace("UIStarSlot::init");
			_locked = false;
			_filled = false;
			_xPos = 0;
			_yPos = 0;
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Create / Destroy
	    //
	    //--------------------------------------------------------------------------
	
		private function createChildren ():void{
			//trace("UIStarSlot::createChildren");
			var g:Graphics;
			
			// SLOT
			_slot = new Shape();
			g = _slot.graphics;
			
			// stroke
			g.lineStyle( _radius * .19, _color2, 1, false, "normal", null, JointStyle.MITER );	
			drawStar(g, _radius);
			
			// fill
			g.lineStyle();
			g.beginFill(_color1,1);
			drawStar(g, _radius);
			g.endFill();
			addChild(_slot);
			
			
			// STAR
			_star = new Shape();
			g = _star.graphics;
			
			
			// Outer Gradient
 			g.lineStyle( _radius * .015, _color2, 1, false, "normal", null, JointStyle.MITER );
			
			var gradientMatrix:Matrix = new Matrix();
			var colors:Array =[_color2, _color1];
			var alphas:Array =[1,1];
			var ratios:Array =[0,255];

			gradientMatrix.createGradientBox(_radius*2, _radius*2, -90*Math.PI/180, -_radius, -_radius);
			g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);

			drawStar(g, _radius);
			g.endFill();
			
			// Inner Gradient
			var r:Number = _radius * .7;
			g.lineStyle();
			
			 gradientMatrix = new Matrix();
			 colors =[_color1, _color2];
			 alphas =[1,1];
			 ratios =[0,255];

			gradientMatrix.createGradientBox(r*2, r*2, -90*Math.PI/180, -r, -r);
			g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);

			drawStar(g, r);
			g.endFill();
			
			addChild(_star);
			
		}
		
		private function destroy ():void{
			//trace("Star::destroy");
			parent.removeChild(this);
		}

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
			//trace("UIStarSlot::draw");

			if(_locked){
				_filled = false;
				//setGrayScale();		
			}else{
				//setNormalColor();
			}

			_star.visible = _filled;

		}
		
		private function setGrayScale( ) : void
		{			
		    var rLum : Number = 0.2225*.6;
	        var gLum : Number = 0.6169*.6;
   		    var bLum : Number = 0.0606*.6; 

   		    var matrix:Array = [ rLum, gLum, bLum, 0, 100,
   		                         rLum, gLum, bLum, 0, 100,
   		                         rLum, gLum, bLum, 0, 100,
   		                         0,    0,    0,    1, 0 ];

   		    var filter:ColorMatrixFilter = new ColorMatrixFilter( matrix );
   		    this.filters = [filter];
		}
		private function setNormalColor( ) : void
		{
   		    this.filters = [];
		}
	
		private function drawStar (g:Graphics, r:Number):void{
			//trace("UIStarSlot::drawStar");
			var incr:Number = 36;
			g.moveTo(Math.cos(dtor(_startDegree)) * r, Math.sin(dtor(_startDegree))*r );
			var radius:Number;
			for(var i:uint = 0; i<11; i++){
				var radian:Number = dtor(_startDegree + incr * i);
				var cos:Number = Math.cos(radian);
				var sin:Number = Math.sin(radian);
				if(i % 2 == 0){
					radius = r;
				}else{
					radius = r * .57; // <-- inner points
				}
				g.lineTo(cos * radius, sin * radius);
			}
		}
		
		private function dtor (d:Number):Number{
			// Degrees to Radians
			return d * Math.PI / 180;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public Methods
	    //
	    //--------------------------------------------------------------------------
	
		public function startFall ():void{
			//trace("Star::startFall");
			var xDist:Number, yDist:Number,startYtime:Number;
			var completeTween:Function = null;
			var startYease:Function = Cubic.easeIn;
			// pick random xDist
			xDist = 300 - Math.random()*600;
			
			// 50% chance pick random yDist up
			if(Math.random() < .5){
				yDist = Math.random() * - 100;
				completeTween = startSecondYtween;
				startYease = Cubic.easeOut;
				startYtime = 1;
			}else{
				startYtime = 3;
				yDist = 750;
			}
			// set yDist down (past bottom of screen)
			
			// set gtween to x,y values
			
			var myXtween:GTween = new GTween(this, 3, {xPos:xPos+xDist}, { onComplete:destroyMe, ease:Cubic.easeOut});
			var myYtween:GTween = new GTween(this, startYtime, {yPos:yPos+yDist}, { onComplete:completeTween, ease:startYease});
			
			function startSecondYtween(gt:GTween){
				var star:Star = gt.target as Star;
				var targetY:Number = star.yPos + 1000;
				var tween2:GTween = new GTween(star, 2, { y:targetY}, {ease:Cubic.easeIn});
			}
			function destroyMe(gt:GTween){
				var star:Star = gt.target as Star;
				star.destroy();
			}
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}