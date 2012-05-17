package com.megadoug.rainbowcloudgame {

	import flash.display.*;
	import flash.utils.*;
	
	import flash.text.*;
	
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import flash.filters.*
	
	import flash.events.*;

	/**
	 *  Constructs a shiny ball
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Doug Roussin
	 *  @since  2012-03-22
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Prize extends Body {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		private var _source:Sprite;
		
		private var _main:Sprite;
				
		private var _color1:int;
		private var _color2:int;
		
		private var _kind:String;
		
		private var _strokeWidth:Number;
		private var _radius:Number;
		
		private var _iconOnTop:Boolean;
						
		private var _state:String;
		private var _stateScale:Number;
		
		private var _mouseCatcher:Sprite;
		
		private var _textFmt:TextFormat;
		private var _text_txt:TextField;
		private var _myText:String;
		private var _mySize:uint;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function Prize (incomingVarsObj:Object = null) {
			//trace("Prize");
			super();
			resolveInitVars(incomingVarsObj);
			createChildren();
			//glossify();
			draw();
			this.cacheAsBitmap = true;
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
	
		/**
		 * Gets / sets color1.
		 */

		public function get color1():uint {
			return _color1;
		};

		public function set color1(value:uint):void {
			_color1 = value;
		};
		
		/**
		 * Gets / sets color2.
		 */

		public function get color2():uint {
			return _color2;
		};

		public function set color2(value:uint):void {
			_color2 = value;
		};
		
		/**
		 * Gets / sets kind.
		 */

		public function get kind():String {
			return _kind;
		};

/*		public function set kind(value:String):void {
			_kind = value;
		};*/
	
	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function resolveInitVars (newVarsObj:Object):void{
			//trace("Prize::resolveInitVars");
			var defaultVars:Object = {sourceSprite:null, radius:-1, color1:-1, color2:-1, strokeWidth:2, iconOverShine:false, text:"", kind:"Yellow"};
			
			// override default values w/ new values
			for (var i:* in newVarsObj){
				for (var j:* in defaultVars){
					if (i==j) {
						defaultVars[j] = newVarsObj[i];
						break;
					}
				}
			}
			
			// set vars
			_source = defaultVars.sourceSprite;
			if(_source != null){
				_radius = defaultVars.radius==-1 ? _source.height/2+4 : defaultVars.radius;
			}else{
				_radius = defaultVars.radius==-1 ? 17.5 : defaultVars.radius;
			}
			_kind = defaultVars.kind;
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
					_color1 = 0x0033FF;
					_color2 = 0x000099;
					break;	
				case "violet":
					_color1 = 0x6633cc;
					_color2 = 0x660066;
					break;				
			}
/*			_color1 = defaultVars.color1;
			_color2 = defaultVars.color2;*/
			_strokeWidth = defaultVars.strokeWidth;
			_iconOnTop = defaultVars.iconOverShine;
			_stateScale = 1;
			_state = "up";
			
			// text & format
			_myText = defaultVars.text;
			if(_myText != ""){
				_textFmt = new TextFormat();
				_textFmt.font = new ArialBlack().fontName;
				
				var diameter:Number = _radius * 2;
				if( diameter < 10 ){
					_textFmt.size = 9;
				}else if( diameter < 34 ){
					_textFmt.size = 12;
				}else if( diameter < 40 ){
					_textFmt.size = 14;
				}else{
					_textFmt.size = 24;
				}
				_textFmt.color = 0x000000;
				_textFmt.align = "center";
			}	
			this.mouseEnabled = false;
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Create / Destroy
	    //
	    //--------------------------------------------------------------------------
	
		private function createChildren ():void{
			//trace("Prize::createChildren");

			_main = new Sprite();

		}
		
		private function glossify ():void{
			//trace("Prize::glossify");
			var radius:Number = _radius* _stateScale;

			var w:Number = (radius*2)*1.5;
			var h:Number = (radius*2)*1.5;
			
			var color1:uint = ( (_color1==-1)?(0xFF6D00):(_color1));
			var color2:uint = ( (_color2==-1)?(0xFFCB62):(_color2));
			
			// clear
			if(_main){
				while(_main.numChildren > 0){
					_main.removeChildAt(0);
				}
				_main.graphics.clear();
			}else{
				_main = new Sprite();
			}
			
			// base
			
			// gradient
			var type:String = GradientType.RADIAL; 
			var colors:Array = [color1, color2]; 
			var alphas:Array = [1, 1]; 
			var ratios:Array = [160, 255]; 
			var spreadMethod:String = SpreadMethod.PAD; 
			var interp:String = InterpolationMethod.LINEAR_RGB; 
			var focalPtRatio:Number = 0;
			
			// matrix
			var edgeMatrix:Matrix = new Matrix();
			var rot:Number = 90 * (Math.PI/180); 
			var tx:Number = -w*0.5; 
			var ty:Number = -h*0.65;
			edgeMatrix.createGradientBox(w, h, rot, tx, ty);
						
			// outer edge
			_main.graphics.beginGradientFill(type, colors, alphas, ratios, edgeMatrix, spreadMethod, interp, focalPtRatio); 
			_main.graphics.drawCircle(0, 0, radius);
			_main.graphics.endFill();
			
			// add art
			if(_source != null){
				_main.addChild(_source);
			}
			
			// gradient
			var shineW:Number = (radius*2)*0.8;
			var shineH:Number = (radius*2)*0.6;
			
			type = GradientType.LINEAR; 
			colors = [0xffffff, 0xffffff];
			alphas = [0.1, .6]; 
			ratios = [1, 100]; 
			spreadMethod = SpreadMethod.PAD; 
			interp = InterpolationMethod.LINEAR_RGB; 
			focalPtRatio = 0;
			
			// matrix
			var shineMatrix:Matrix = new Matrix();
			rot = 90 * (Math.PI/180); 
			tx = -shineW*0.5; 
			ty = -shineH*0.5;
			shineMatrix.createGradientBox(w, h, rot, tx, ty);
			
			// shine
			var shine:Shape = new Shape();
			shine.graphics.beginGradientFill(type, colors, alphas, ratios, shineMatrix, spreadMethod, interp, focalPtRatio); 
			shine.graphics.drawEllipse(-shineW*0.5, -shineH*0.75, shineW, shineH);
			shine.graphics.endFill();
			shine.blendMode = BlendMode.SCREEN;
			
			// add shine
			if(_iconOnTop && _source != null){
				_main.addChildAt(shine,_main.getChildIndex(_source));
			}else{
				_main.addChild(shine);	
			}
			
			// outline
			var edge:Shape = new Shape();
			edge.graphics.lineStyle(_strokeWidth, color1, 1, true);
			edge.graphics.drawCircle(0, 0, radius-(_strokeWidth*0.5));
			edge.graphics.endFill();

			_main.addChild(edge);

		}
		private function addText ():void{
			//trace("Prize::addText");
			if(!_text_txt){
				_text_txt = new TextField();
			}
			_text_txt.autoSize = TextFieldAutoSize.CENTER; 
			_text_txt.antiAliasType = AntiAliasType.ADVANCED;
			_text_txt.embedFonts = true;
			_text_txt.selectable = false;
			_text_txt.background = false;
			_text_txt.border = false;

			_text_txt.text = _myText;
			_text_txt.setTextFormat(_textFmt);

			_text_txt.x = -_text_txt.width/2;
			_text_txt.y = -_text_txt.height*.45 - _radius;
			
			addChild(_text_txt);	
			
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
			//trace("Prize::draw");
			
			
			// Glossify
			glossify();
			
			
			// AddChildren

			if(!contains(_main)){
				addChild(_main);
			}
			setChildIndex(_main, numChildren-1);
			
			if(_myText != ""){
				addText();
				if(!contains(_text_txt)){
					addChild(_text_txt);
				}
			}
			_main.y = -_radius;
		}
		
		private function setGrayScale(  ) : void
		{
            //spr.transform.colorTransform = new ColorTransform(.5, .5, .5, 1, 0, 0, 0, 0);
			
		    var rLum : Number = 0.2225*.6;
	        var gLum : Number = 0.6169*.6;
   		    var bLum : Number = 0.0606*.6; 

   		    var matrix:Array = [ rLum, gLum, bLum, 0, 0,
   		                         rLum, gLum, bLum, 0, 0,
   		                         rLum, gLum, bLum, 0, 0,
   		                         0,    0,    0,    1, 0 ];

   		    var filter:ColorMatrixFilter = new ColorMatrixFilter( matrix );
   		    this.filters = [filter];
		}
		private function setNormalColor(  ) : void
		{
			//spr.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
   		    this.filters = [];
		}
		private function setBrightColor( ):void{											
			var s:Number = 1.2;
			var b:Number = 10*(255/250);
			
			var m:Array = new Array();
			            m = m.concat([s, 0, 0, 0, b]);  // red
			            m = m.concat([0, s, 0, 0, b]);  // green
			            m = m.concat([0, 0, s, 0, b]);  // blue
			            m = m.concat([0, 0, 0, 1, 0]);  // alpha
			            
			

   		    var filter:ColorMatrixFilter = new ColorMatrixFilter( m );
   		    this.filters = [filter];
		}
		
		private function setDarkColor ():void{
			//trace("Prize::setDarkColor");
			var s:Number = 1.15;
			var b:Number = -40*(255/250);

			var m:Array = new Array();
			            m = m.concat([s, 0, 0, 0, b]);  // red
			            m = m.concat([0, s, 0, 0, b]);  // green
			            m = m.concat([0, 0, s, 0, b]);  // blue
			            m = m.concat([0, 0, 0, 1, 0]);  // alpha



   		    var filter:ColorMatrixFilter = new ColorMatrixFilter( m );
   		    this.filters = [filter];
		}
		
		

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------

	}
}