package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;
	
	import flash.text.*;
	
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	import flash.filters.*
	
	import flash.events.*;

	/**
	 *  Constructs a 
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 9.0.0
	 *
	 *  @author Doug Roussin
	 *  @since  2012-03-22
	 *  @version 0.1
	 *  @copyright (c) 2012 __MyCompanyName__. All rights reserved.
	 */

	public class Icon extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
		private var _source:Sprite;
		
		private var _shadow:Shape;
		private var _reflection:Shape;
		private var _mask:Shape;
		private var _main:Sprite;
		
		private var _hasShadow:Boolean;
		private var _hasReflection:Boolean;
		
		private var _color1:int;
		private var _color2:int;
		
		private var _strokeWidth:Number;
		private var _radius:Number;
		
		private var _iconOnTop:Boolean;
		
		private var _locked:Boolean = false;
		
		private var _isButton:Boolean;
		
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

		public function Icon (incomingVarsObj:Object = null) {
			//trace("Icon");
			
			resolveInitVars(incomingVarsObj);
			createChildren();
			//glossify();
			draw();
			
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * sets locked.
		 */

		public function set locked(value:Boolean):void {
			if(value != _locked){
				_locked = value;
				if(value == false){
					// show in color
					setNormalColor();
				}else{
					// show in grey
					_stateScale = 1;
					draw();
					setGrayScale();
				}
			}
		};
		
		/**
		 * sets isButton.
		 */

		public function set isButton(value:Boolean):void {
			//trace("Icon::isButton("+value+")");
			if(value != _isButton){
				_isButton = value;
				switch(_isButton){
					case true:
						makeButton();
						break;
					default:
					case false:
						removeButton();
						break;	
				}	
			}
		};
		
		
		private function setMouseState(value:String):void {
			if(value != _state && !_locked){
				_state = value;
				switch ( _state ){
					default:
					case "up":
						_stateScale = 1;
						break;
					case "over":
						_stateScale = 1.05;
						break;
					case "down":
						_stateScale = .95;
						break;
				}
				draw();
				switch ( _state ){
					default:
					case "up":
						setNormalColor();
						break;
					case "over":
						setNormalColor();
						//setBrightColor();
						break;
					case "down":
						setDarkColor();
						break;
				}
			}	
		};
	
	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
		
		private function resolveInitVars (newVarsObj:Object):void{
			//trace("Icon::resolveInitVars");
			var defaultVars:Object = {sourceSprite:null, reflection:false, shadow:false, radius:-1, color1:-1, color2:-1, strokeWidth:2, iconOverShine:false, isButton:false, text:""};
			
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
			_color1 = defaultVars.color1;
			_color2 = defaultVars.color2;
			_strokeWidth = defaultVars.strokeWidth;
			_hasShadow = defaultVars.shadow;
			_hasReflection =defaultVars.reflection;
			_iconOnTop = defaultVars.iconOverShine;
			_isButton = defaultVars.isButton;
			_stateScale = 1;
			_state = "up";
			
			// text & format
			_myText = defaultVars.text;
			if(_myText != ""){
				_textFmt = new TextFormat();
				_textFmt.font = new InterstateBoldCond().fontName;
				
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
			//trace("Icon::createChildren");

			_main = new Sprite();
			if(_isButton){
				_isButton = false;
				isButton = true;
			}
		}
		
		private function reflect (){
			//trace("Icon::reflect");
			
			// clear
			if(_reflection){
				_reflection.graphics.clear();
			}else{
				_reflection = new Shape();
			}
			
			if(_mask){
				_mask.graphics.clear();
			}else{
				_mask = new Shape();	
			}

			var bounds:Rectangle = _main.getBounds( _main );
			
			// Icon bitmap
			var bitmap:BitmapData = new BitmapData( bounds.width+1, bounds.height+1, true, 0 );
			var bitMatrix:Matrix = new Matrix();
			bitMatrix.translate(-bounds.x,-bounds.y);
			bitmap.draw( _main, bitMatrix);
			
			var trans:Matrix = new Matrix();
			trans.translate(bounds.x, bounds.y);
			
			// Reflection
	        _reflection.graphics.beginBitmapFill(bitmap, trans, true);
	        _reflection.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			_reflection.graphics.endFill();
			_reflection.scaleY = -1;
			_reflection.y = bounds.height;
			
			// Gradient Mask
			var type:String = GradientType.LINEAR; 
			var colors:Array = [0xFF0000, 0xFF0000, 0xFF0000]; 
			var alphas:Array = [0, .05, .25]; 
			var ratios:Array = [130, 180, 255]; 
			var spreadMethod:String = SpreadMethod.PAD; 
			var interp:String = InterpolationMethod.LINEAR_RGB; 
			var focalPtRatio:Number = 0;

			// matrix
			var edgeMatrix:Matrix = new Matrix();
			var rot:Number = -90 * (Math.PI/180); 
			var tx:Number = bounds.x; 
			var ty:Number = bounds.y;
			edgeMatrix.createGradientBox(bounds.width, bounds.height, rot, tx, ty);

 			// draw mask
 			_mask.y = _reflection.y;
			_mask.graphics.beginGradientFill(type, colors, alphas, ratios, edgeMatrix, spreadMethod, interp, focalPtRatio); 
			_mask.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			_mask.graphics.endFill();
			
			_reflection.cacheAsBitmap=true;
			_mask.cacheAsBitmap=true;
			_reflection.mask = _mask;
		}
		
		private function glossify ():void{
			//trace("Icon::glossify");
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
			alphas = [0.2, .8]; 
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
			//trace("Icon::addText");
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
			_text_txt.y = -_text_txt.height*.45;
			
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
			//trace("Icon::draw");
			
			
			// Glossify
			glossify();
			
			// Build Reflection (and mask)
			if(_hasReflection){
				reflect();
			}
			
			// Build Shadow
			if(_hasShadow){
				// Shadow
				if(_shadow){
					_shadow.graphics.clear();
				}else{
					_shadow = new Shape();
				}
				var bounds:Rectangle = _main.getBounds( _main );
				
		        _shadow.graphics.beginFill(0x000000);
	         	_shadow.graphics.drawCircle(-bounds.x, 0, bounds.width * .4);
	         	_shadow.graphics.endFill();
				_shadow.scaleY = .1;
				_shadow.x = bounds.x;
				_shadow.y = bounds.y+bounds.height;
				_shadow.alpha = .1;
				var myBlur:BlurFilter = new BlurFilter(3,3,3);
				_shadow.filters = [myBlur];
				_shadow.blendMode = BlendMode.MULTIPLY;	
			}
			
			// AddChildren
			if(_hasReflection ){
				if(!contains(_reflection)){
					addChild(_reflection);
				}
				if(contains(_mask)){
					removeChild(_mask);
				}
				addChild(_mask);
			}
			if(_hasShadow && !contains(_shadow)){
				addChild(_shadow);
			}
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
			//trace("Icon::setDarkColor");
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
		
		
		private function makeButton ():void{
			//trace("Icon::makeButton");

			if(!_mouseCatcher){
				_mouseCatcher = new Sprite();
				// Make _mouseCatcher
				_mouseCatcher.graphics.beginFill(0x555555);
				_mouseCatcher.graphics.drawCircle(0,0,_radius);
				_mouseCatcher.graphics.endFill();
				_mouseCatcher.alpha = 0;
			}	
			
			if(!this.contains(_mouseCatcher)){
				addChildAt(_mouseCatcher,0);
			}
			_mouseCatcher.mouseEnabled = true;
			_mouseCatcher.useHandCursor = true;
			_mouseCatcher.buttonMode = true;
			_main.mouseEnabled = false;
			_main.mouseChildren = false;
			if(_text_txt){
				_text_txt.mouseEnabled = false;
			}
			
			_mouseCatcher.addEventListener(MouseEvent.MOUSE_OVER, over_handler, false, 0, true);
			_mouseCatcher.addEventListener(MouseEvent.MOUSE_OUT, up_handler, false, 0, true);
			_mouseCatcher.addEventListener(MouseEvent.MOUSE_DOWN, down_handler, false, 0, true);
			_mouseCatcher.addEventListener(MouseEvent.MOUSE_UP, over_handler, false, 0, true);	
		}
		private function removeButton ():void{
			//trace("Icon::removeButton");
			
			if(_mouseCatcher){
				if( _mouseCatcher.hasEventListener(MouseEvent.MOUSE_OVER) ) {
					_mouseCatcher.removeEventListener(MouseEvent.MOUSE_OVER, over_handler);
				}
				if( _mouseCatcher.hasEventListener(MouseEvent.MOUSE_OUT) ) {
					_mouseCatcher.removeEventListener(MouseEvent.MOUSE_OUT, up_handler);
				}
				if( _mouseCatcher.hasEventListener(MouseEvent.MOUSE_DOWN) ) {
					_mouseCatcher.removeEventListener(MouseEvent.MOUSE_DOWN, down_handler);
				}
				if( _mouseCatcher.hasEventListener(MouseEvent.MOUSE_UP) ) {
					_mouseCatcher.removeEventListener(MouseEvent.MOUSE_UP, over_handler);
				}
				if(contains(_mouseCatcher)){
					removeChild(_mouseCatcher);
				}
			}
		}
	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
		private function over_handler(e:MouseEvent):void{
			//trace("over")
			setMouseState("over");
		}
		
		private function down_handler(e:MouseEvent):void{
			setMouseState("down");
		}
		
		private function up_handler(e:MouseEvent):void{
			setMouseState("up");
		}
	}
}