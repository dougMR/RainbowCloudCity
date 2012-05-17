package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;
	
	import flash.geom.Matrix;
	//import flash.geom.Rectangle;
	//import flash.geom.Point;
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

	public class UIStarSlot extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		private var _radius:Number;
		private var _color1:uint;
		private var _color2:uint;
		private var _startDegree:Number;
		
		private var _locked:Boolean;
		private var _filled:Boolean;
		
		private var _slot:Shape;
		private var _star:Shape;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function UIStarSlot (r:Number = 28, c1:int = -1, c2:int = -1, rot:Number = -90) {
			//trace("UIStarSlot");
			_radius = r;
			if(c1 == -1){
				_color1 = 0xF1E740;
			}else{
				_color1 = c1;
			}
			if(c2 == -1){
				_color2 = 0xE69815;
			}else{
				_color2 = c2;
			}
			_startDegree = rot;
			
			init();
			createChildren();
			draw();
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

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function init ():void{
			//trace("UIStarSlot::init");
			_locked = false;
			_filled = false;
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
			g.lineStyle( _radius * .19, 0x666666, 1, false, "normal", null, JointStyle.MITER );	
			drawStar(g, _radius);
			
			// fill
			g.lineStyle();
			g.beginFill(0x4E4E4E,1);
			drawStar(g, _radius);
			g.endFill();
			addChild(_slot);
			
			
			// STAR
			_star = new Shape();
			g = _star.graphics;
			
			
			// Outer Gradient
 			g.lineStyle( _radius * .015, 0xD77834, 1, false, "normal", null, JointStyle.MITER );
			
			var gradientMatrix:Matrix = new Matrix();
			var colors:Array =[_color2, _color1];
			var alphas:Array =[1,1];
			var ratios:Array =[0,255];

			gradientMatrix.createGradientBox(_radius*2, _radius*2, -90*Math.PI/180, -_radius, -_radius);
			g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,gradientMatrix);

			drawStar(g, _radius);
			g.endFill();
			
			// Inner Gradient
			var r:Number = _radius * .78;
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
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}