package com.megadoug.rainbowcloudgame {

	import flash.display.*;
	import flash.utils.*;
	
	import flash.geom.Point;
	import flash.geom.Matrix;

	/**
	 *  Constructs a Rainbow between 2 points
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  2012-04-21
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Rainbow extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
	
		private var _center:Point;
		private var _radius:Number;
		private var _innerRad:Number;
		private var _outerRad:Number;
		private var _startDegree:Number;
		private var _endDegree:Number;
		private var _p1:Point;
		private var _p2:Point;
		private var _innerP1:Point;
		private var _innerP2:Point;
		private var _outerP1:Point;
		private var _outerP2:Point;
		private var _width:Number;
		private var _percentDrawn:Number = .01; // <-- 0 to 1
		private var _leadingPoint:Point;
		private var _points:Array;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Rainbow (p1:Point,p2:Point) {
			//trace("Rainbow");
			_p1 = p1;
			_p2 = p2;
			_leadingPoint = _p2;
			init();
			//draw();
			
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
	
		/**
		 * Gets / sets leadingPoint.
		 */

		public function get leadingPoint():Point {
			return _leadingPoint;
		};
		
		/**
		 * Gets / sets endDegree.
		 */

		public function get endDegree():Number {
			return _endDegree;
		};
		
		/**
		 * Gets / sets center.
		 */

		public function get center():Point {
			return _center;
		};
		
		/**
		 * Gets / sets radius.
		 */

		public function get radius():Number {
			return _radius;
		};

		
		/**
		 * Gets / sets points.
		 */

/*		public function get points():Array {
			return getPoints();
		};*/


	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function init ():void{
			//trace("Rainbow::init");
			// update center
			findCenter();
			updateProperties();
			
			var rad1:Number = Math.atan2(_p1.y - _center.y, _p1.x - _center.x);
			var rad2:Number = Math.atan2(_p2.y - _center.y, _p2.x - _center.x);
			var cos1:Number = Math.cos(rad1);
			var sin1:Number = Math.sin(rad1);
			var cos2:Number = Math.cos(rad2);
			var sin2:Number = Math.sin(rad2);
			
			_innerRad = _radius - _width/2
			var innerP1x:Number = _center.x + cos1 * _innerRad;
			var innerP1y:Number = _center.y + sin1 * _innerRad;
			var innerP2x:Number = _center.x + cos2 * _innerRad;
			var innerP2y:Number = _center.y + sin2 * _innerRad;
			
			_outerRad = _radius + _width/2
			var outerP1x:Number = _center.x + cos1 * _outerRad;
			var outerP1y:Number = _center.y + sin1 * _outerRad;
			var outerP2x:Number = _center.x + cos2 * _outerRad;
			var outerP2y:Number = _center.y + sin2 * _outerRad;
			
			_innerP1 = new Point(innerP1x, innerP1y);
			_innerP2 = new Point(innerP2x, innerP2y);
			_outerP1 = new Point(outerP1x, outerP1y);
			_outerP2 = new Point(outerP2x, outerP2y);
		}
	
		private function findCenter ():void{
			//trace("Rainbow::calcCenter");
			
			var x1 = _p1.x;
			var y1 = _p1.y;
			var x2 = _p2.x;
			var y2 = _p2.y;

			var ychange = y2 - y1;
			var xchange = x2 - x1;

			var length = Math.sqrt(ychange*ychange + xchange*xchange);
			length *= 0.6;
			var slope = ychange/xchange
			// infinite slope is okay, inverse is zero

			var inverseSlope = -1 / slope
			if(inverseSlope == Infinity || inverseSlope == -Infinity){
				//trace("inverseSlope: "+inverseSlope)
				inverseSlope = 1;
			}
			var radian = Math.atan2(inverseSlope,1)
			var cos = Math.cos(radian)

			// Always draw down, so arc is orieneted up
			var xDiff = (inverseSlope < 0)?(-length * cos):length * cos;
			var yDiff = inverseSlope * xDiff;
/*			trace("xDiff: "+xDiff)
			trace("yDiff: "+yDiff)*/
/*			if(yDiff == Infinity){
				yDiff = length
			}*/

			var perpx1 = x1 + (xchange)/2;
			var perpy1 = y1 + (ychange)/2;

			var perpx2 = perpx1 + xDiff;
			var perpy2 = perpy1 + yDiff;
			
			_center = new Point( perpx2, perpy2 );
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
			//trace("Rainbow::drawRainbow");
			
			var endCos:Number = Math.cos(dtor(_endDegree));
			var endSin:Number = Math.sin(dtor(_endDegree));
			var pctInnerP2x:Number = endCos*_innerRad + _center.x;//_p2.x;
			var pctInnerP2y:Number = endSin*_innerRad + _center.y;//_p2.y;//
			
			_leadingPoint.x = _center.x + endCos * _radius;
			_leadingPoint.y = _center.y + endSin * _radius;
			
			var g:Graphics = this.graphics;
			g.clear();
			
/*			g.lineStyle(1,0xFFFF00);
			g.moveTo(_center.x,_center.y);
			g.lineTo(_p1.x,_p1.y);
			g.moveTo(_center.x,_center.y);
			g.lineTo(_p2.x,_p2.y);
			g.lineStyle();*/
	
			var radDiff:Number = _outerRad-_innerRad;
			var radPct:Number = radDiff / _outerRad;
			var pct:Number = (radPct / 100)*255;
			
			var startPct:Number = (_innerRad / _outerRad) * 255;
			
			var mat:Matrix = new Matrix();
			var colors:Array =[0xFFFFFF,0x9933ff,0x9933ff,0x0000FF, 0x33CC33, 0xFFFF00, 0xFF9900, 0xFF0000, 0xFF0000];
			var alphas:Array =[1,0,1,1,1,1,1,1,0];
			
			var ratios:Array =[0, startPct, startPct+pct*10, startPct+pct*25, startPct+pct*50, startPct+pct*65, startPct+pct*80, startPct+pct*90, 255];

			
			//Without the translation parameters, -circRad+25, -circRad-25, the center
			//of the gradient will fall at the point x=circRad, y=circRad relative to
			//the center of the circle. So the center of the gradient will fall in the
			//lower right portion of the perimeter of the circle. -circRad, -circRad
			//move the center of the gradient to the center of the circle; the +25
			//and -25 parts move it a bit up and to the right.
			//mat.createGradientBox(2*circRad,2*circRad,0,-circRad+25,-circRad-25);
			
			mat.createGradientBox(2*_outerRad,2*_outerRad,0,_center.x-_outerRad,_center.y-_outerRad);
			g.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,mat,SpreadMethod.PAD);
		
			
			
			//g.lineStyle(6, 0xFF9900);
			// start Line
			g.moveTo(_innerP1.x,_innerP1.y);
			
			g.lineTo(_outerP1.x,_outerP1.y);
			
			// outer Arc
			//g.lineStyle(2,0x00ff00);
			//var dir:int = (_innerP1.x < pctInnerP2x) ? 1 : -1;
			var dir:int = (_startDegree < _endDegree) ? 1 : -1;
			
			drawArc(g,_startDegree, _endDegree, _outerRad, dir, _outerP1.y);
			
			
			// end Line
			//g.lineStyle(5, 0xff0000);
			
			g.lineTo(pctInnerP2x,pctInnerP2y);
			
			// inner Arc
			//g.lineStyle(2,0x00ffff);
			//g.lineTo(_innerP1.x,_innerP1.y);
			drawArc(g,_endDegree, _startDegree, _innerRad,-dir, pctInnerP2y);

			
			g.endFill();
		}
		
		private function drawArc(g:Graphics,startAngle:Number, endAngle:Number, radius:Number, direction:Number, startY):void
		/* 
		    centerX  -- the center X coordinate of the circle the arc is located on
		    centerY  -- the center Y coordinate of the circle the arc is located on
		    startAngle  -- the starting angle to draw the arc from
		    endAngle    -- the ending angle for the arc
		    radius    -- the radius of the circle the arc is located on
		    direction   -- toggle for going clockwise/counter-clockwise
		*/
		{

						
			startAngle = dtor(startAngle);
			endAngle = dtor(endAngle);
			
		    var difference:Number = Math.abs(endAngle - startAngle);
		    /* How "far" around we actually have to draw */
			//trace("difference: "+Math.round(rtod(difference)))
		    var divisions:Number = Math.floor(difference / (Math.PI / 4))+1;
		    /* The number of arcs we are going to use to simulate our simulated arc */

		    var span:Number    = direction * difference / (2 * divisions);
		//trace("span: "+Math.round(rtod(span))+" * "+divisions)
		    var controlRadius:Number    = radius / Math.cos(span);

		    //g.moveTo(_center.x + Math.cos(startAngle)*radius, _center.y + Math.sin(startAngle)*radius);
		    var controlPoint:Point;
		    var anchorPoint:Point;
 
			//trace("divisions: "+divisions);
			//var divisions_ar:Array = new Array();
		    for(var i:Number=0; i<divisions; ++i)
		    {
			
		        endAngle    = startAngle + span;
		        startAngle  = endAngle + span;

		        controlPoint = new Point(_center.x+Math.cos(endAngle)*controlRadius, _center.y+Math.sin(endAngle)*controlRadius);
		        anchorPoint = new Point(_center.x+Math.cos(startAngle)*radius, _center.y+Math.sin(startAngle)*radius);
				//divisions_ar.push({cp:controlPoint,ap:anchorPoint});
				
		        g.curveTo(
		            controlPoint.x,
		            controlPoint.y,
		            anchorPoint.x,
		            anchorPoint.y
		        );
/*				g.lineTo(controlPoint.x, controlPoint.y);
				g.lineTo(anchorPoint.x, anchorPoint.y);*/
		    }
			//arcEndPointDirs.push(dir);
			//return(divisions_ar);
		}
		
		/*
		 * new abs function, about 25x faster than Math.abs
		 */
		private function abs( value : Number ) : Number {
			//return Math.abs(value);
			return value < 0 ? -value : value;
		}

		/*
		 * new ceil function about 75% faster than Math.ceil. 
		 */
		private function ceil( value : Number) : Number {
			//return Math.ceil(value);
			return (value % 1) ? int( value ) + 1 : value;
		}

		private function rtod(r:Number):Number{
			return (r*180)/Math.PI;
		}
		private function dtor(d:Number):Number{
			return d * Math.PI/180;
		}	
		
		private function updateProperties ():void{
			//trace("Rainbow::updateProperties");
			
			var xDiff:Number = _p1.x-_center.x;
			var yDiff:Number = _p1.y-_center.y;
			
			_radius = Math.sqrt( xDiff*xDiff + yDiff*yDiff );
			
			_startDegree = constrainAngle(rtod(Math.atan2(yDiff,xDiff)));
			var xDiff2:Number = _p2.x-_center.x;
			var yDiff2:Number = _p2.y-_center.y;
			var endD:Number = constrainAngle(rtod(Math.atan2(yDiff2,xDiff2)));
			//trace("Start: "+Math.round(_startDegree));
			//trace("End: "+Math.round(endD));
			//trace("pct: "+Math.round(_percentDrawn*100));
			if(abs(endD-_startDegree) > 180){
				if(endD < _startDegree){
					endD += 360;
					//trace("new endD: "+Math.round(endD))
				}else{
					_startDegree += 360;
					//trace("new Start: "+Math.round(_startDegree))
				}
			}
			
			_endDegree = _startDegree + _percentDrawn * (endD - _startDegree);
			//trace("_endDegree: "+Math.round(_endDegree))
			_width = _radius > 200?120:_radius*.5;

		}
		
		private function constrainAngle (d:Number):Number{
			//trace("Rainbow::constrainAngle");
			d = d <= 0 ? d%-360 + 360 : d % 360;
			return d;
		}
		
		//-----------------------------------------------------
		//
		//   PUBLIC FUNCTIONS
		//
		//-----------------------------------------------------
		
		public function update (p1:Point,p2:Point,percentDrawn:Number):void{
			//trace("Rainbow::update");
			_p1 = p1;
			_p2 = p2;
			_percentDrawn = percentDrawn;
			init();
			draw();
		}
		
		public function getPoints (granularity:Number = 100):Array{
			//trace("Rainbow::getPoints");
			var points_ar:Array = new Array();
			var startAngle:Number = dtor(_startDegree);
			var endAngle:Number = dtor(_endDegree);

		    var difference:Number = Math.abs(endAngle - startAngle);

		    /* How "far" around we actually have to draw */
		    //var divisions:Number = Math.floor(difference / (Math.PI / 4))+1;
			var perimeter:Number = _radius * difference;
			var divisions:Number = Math.ceil(perimeter / granularity);
		    /* The number of arcs we are going to use to simulate our simulated arc */
			//var direction:int = _p2.y < _p1.y ? 1 : -1;
			var direction:int = endAngle > startAngle ? 1 : -1;
			
			//trace("direction: "+direction)
			
		    var span:Number  = direction * difference / (2 * divisions);

		    for(var i:Number=0; i<divisions; ++i)
		    {

		        endAngle    = startAngle + span;
		        startAngle  = endAngle + span;

		        var point:Point = new Point(_center.x+Math.cos(startAngle)*_radius, _center.y+Math.sin(startAngle)*_radius);
				points_ar.push(point);
		    }

			// list points from lowest to highest
			
			if(divisions > 0 && points_ar[divisions-1].y > points_ar[0].y ){
				points_ar.reverse();
			}

			return points_ar;
		}
		
		
		public function getRelativePoint (x:Number, y:Number, dist:Number):Point
		/* dist is the number of pixels we want to move along the perimeter from 
		 * intersection point determined by line from x,y to center
		 */
		{
			//trace("Rainbow::getRelativePoint");
			// Find point where line from center to xy intersects surface:
			// 1.get angle from center to xy
			var startAngle:Number = Math.atan2(y-_center.y, x-_center.x);
			// 2.get cos,sin *radius
			var startPoint:Point = new Point(_center.x + Math.cos(startAngle * _radius), _center.y + Math.sin(startAngle * _radius));
			
			// v Always go UP the rainbow
			var sign:int 
			if(_p2.y < _p1.y ){
				if(_p2.x > _p1.x){
					sign = 1;
				}else{
					sign = -1;
				}
			}else if(_p2.x > _p1.x){
				sign = -1;
			}else{
				sign = 1;
			}

			dist *= sign;
			
			// Find point dist from intersect along surface
			// 1.get angle of dist arc
			var arcSweep:Number = dist / _radius;
			var newAngle:Number = startAngle+arcSweep;
			// 2.get new point
			var newX:Number = _center.x + Math.cos(newAngle) * _radius;
			var newY:Number = _center.y + Math.sin(newAngle) * _radius;
			
			return new Point(newX,newY);
		}
		
		public function checkCollision (x:Number, y:Number, r:Number = 50):Boolean{
			//trace("Rainbow::checkCollision");
			var tempShape:Shape = new Shape();
			addChild(tempShape);
			
			var frequency:Number = _width - 5;
			var startAngle:Number = dtor(_startDegree);
			var endAngle:Number = dtor(_endDegree);
			
		    var difference:Number = Math.abs(endAngle - startAngle);

		    /* How "far" around we actually have to check */
		    //var divisions:Number = Math.floor(difference / (Math.PI / 4))+1;
			var perimeter:Number = _radius * difference;
			var divisions:Number = perimeter / frequency;
		    /* The number of arcs we are going to use to simulate our simulated arc */
			//var direction:int = _p2.y < _p1.y ? 1 : -1;
			var direction:int = endAngle > startAngle ? 1 : -1;
		    var span:Number    = direction * difference / (2 * divisions);
/*			trace("difference: "+rtod(difference))
			trace("perimeter: "+perimeter)
			trace("frequency: "+frequency)
			trace("divisions: "+divisions);
			trace("span: "+rtod(span))*/
			
			
			
			//var p1:Point = new Point( _center.x+Math.cos(startAngle)*_radius, _center.y+Math.sin(startAngle)*_radius );
			var endPoint:Point = new Point( _center.x+Math.cos(endAngle)*_radius, _center.y+Math.sin(endAngle)*_radius );

			var xDiff:Number, yDiff:Number, distSq:Number;
		    for(var i:Number=0; i<divisions-1; ++i)
		    {

		        endAngle    = startAngle + span;
		        startAngle  = endAngle + span;

		        //controlPoint = new Point(_center.x+Math.cos(endAngle)*controlRadius, _center.y+Math.sin(endAngle)*controlRadius);
		        var rp:Point = new Point(_center.x+Math.cos(startAngle)*_radius, _center.y+Math.sin(startAngle)*_radius);
				//divisions_ar.push({cp:controlPoint,ap:anchorPoint});
				
/*				tempShape.graphics.lineStyle(4,0x22FF22);
				tempShape.graphics.drawCircle(rp.x,rp.y,_width/2);
				tempShape.graphics.lineStyle();*/
				
				// check Collision
				xDiff = rp.x - x;
				yDiff = rp.y - y;
				distSq = xDiff*xDiff + yDiff*yDiff;
				if(r*r + _width/2 * _width/2 > distSq){
/*					trace("--HIT")
					trace("distSq: "+Math.sqrt(distSq))
					trace("r: "+r+", _width/2: "+_width/2+" = "+(r + _width/2))
					tempShape.graphics.lineStyle(1,0xFFFF22);
					tempShape.graphics.drawCircle(x,y,r);
					tempShape.graphics.lineStyle();
					
					tempShape.graphics.lineStyle(2,0xFF3322);
					tempShape.graphics.drawCircle(rp.x,rp.y,_width/2);
					tempShape.graphics.lineStyle();*/
					return true;
				}
		    }
		
			// check Collision with endpoint
/*			xDiff = endPoint.x - x;
			yDiff = endPoint.y - y;
			distSq = xDiff*xDiff + yDiff*yDiff;
			if(r*r + _width/2 * _width/2 < distSq){
				return true;
			}*/
			
			return false;
			
		}
				
		
	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}