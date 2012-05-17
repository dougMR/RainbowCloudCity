package com.megadoug.rainbowcloudgame{

	import flash.display.*;
	import flash.utils.*;
	import flash.geom.*;
	
	import fl.motion.Color;
	import flash.geom.ColorTransform;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	import flash.text.*;
	
	/**

	 */

	public class UISimpleButton extends SimpleButton {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		
	    private var _hasUpColor:Boolean = false;
	    private var _upColor:uint = 0xffffff;
		private var _upColor2:int = -1;
		private var _hasUpColor2:Boolean = false;
		
		private var _hasArtColor:Boolean = false;
		private var _artColor:uint = 0;
		
		private var _hasOverColor:Boolean = false;
		private var _overColor:uint;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _hasArt:Boolean = false;
		private var _artClass:Class;
		
		private var _hasLabel:Boolean;
		private var _labelColor:uint;
		private var _labelFormat:TextFormat;
		private var _labelText:String;
		private var _textsize:Number;
		
		private var _edgeWidth:Number;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function UISimpleButton (w:Number = 35, h:Number = 35, artClass:Class = null, label:String = "", edgeWidth:Number = 2) {
			//trace("UISimpleButton");
			
			init();
			_width = w;
			_height = h;
			_edgeWidth = edgeWidth;
			
			_labelText = label;
			_hasLabel = (label != "");

			
			if( artClass ) {
				_artClass = artClass;
				_hasArt = true;
			}
			
/*			downState      = createDownState();
	        overState      = createOverState(_overColor);
	        upState        = createUpState();
	        hitTestState   = createUpState();
	
	        useHandCursor  = true;*/
	
			createStates();
			
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------
		/**
		 * Gets / sets textsize.
		 */

		public function set textsize(value:Number):void {
			if(value != _textsize){
				_textsize = value;
				_labelFormat.size = value;
					update();
			}
		};
	
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			createStates();  // Redraw the states so they show as disabled
		}

		public override function get enabled():Boolean
		{
		 return super.enabled;
		}
		

		public function set artClass(value:Class):void
		{
			if (value != _artClass) {
				_artClass = value;
				_hasArt = true;
				
				// update
				downState      = createDownState();
		        overState      = createOverState(_overColor);
		        upState        = createUpState();
			}
		}

		/**
		 * Sets artColor.
		 */

		public function set artColor(value:uint):void {
			_artColor = value;
			_hasArtColor = true;
			
			// update
			update();
		};

		/**
		 * Sets upColor.
		 */

		public function set upColor(value:uint):void {
			_upColor = value;
			_hasUpColor = true;
			if(!_hasOverColor){
				_overColor = _upColor;
			}
			// update
			update();
		};
		public function set upColor2(value:uint):void {
			_upColor2 = value;
			_hasUpColor2 = true;
			// update
			update();
		};
		

		/**
		 * Sets overColor.
		 */

		public function set overColor(value:uint):void {
			
			if (value != _overColor) {
				_hasOverColor = true;
				_overColor = value;
				
				// update
				downState      = createDownState();
		        overState      = createOverState(_overColor);
		        upState        = createUpState();
			}
			
			
		};
		
		/**
		 * Gets / sets labelColor.
		 */

		public function get labelColor():uint {
			return _labelColor;
		};

		public function set labelColor(value:uint):void {
			if( value!= _labelColor){
				_labelColor = value;
				_labelFormat.color = _labelColor;
				update();
			}
		};

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
	
		private function init ():void{
			//trace("LoginSimpleButton::init");
			//_upColor = 0x666666;
			//_overColor = 0x999999;
			_labelColor = 0xFFFFFF;
			_textsize = 27;
			
			_labelFormat = new TextFormat();
			_labelFormat.font = new ArialBlack().fontName;
			_labelFormat.size = _textsize;
			_labelFormat.color = 0xFFFFFF;
			_labelFormat.align = "left";
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Create / Destroy
	    //
	    //--------------------------------------------------------------------------
	
		private function createStates ():void{
			//trace("ScreensSimpleButton::createStates");
			
			if (enabled) {
			  	
				downState      = createDownState();
		        overState      = createOverState(_overColor);
		        upState        = createUpState();
		        hitTestState   = createUpState();

				useHandCursor  = true;
			 
			} else {
			  
				// Only the upState is going to show in this case, since mouse is ignored
			  	upState        = createDisabledUpState();

			  	// This is what flash test against to see whether to fire a click event; setting the 
			  	// hit test state to null is how we *really* disable a button
			  	hitTestState == null;
			
				useHandCursor  = false;
			 }
			
		}
	
		private function createLabel ():TextField{
			//trace("UISimpleButton::createLabel");
			var labelField = new TextField();
			labelField.autoSize = TextFieldAutoSize.RIGHT; 
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.embedFonts = true;
			labelField.selectable = false;
			labelField.background = false;
			labelField.border = false;
			labelField.width = 0;
			labelField.text = _labelText;
			labelField.setTextFormat(_labelFormat);
			labelField.x = (_width - labelField.width)/2;
			labelField.y = (_height - labelField.height)/2 - labelField.textHeight*.05;
			return labelField;
		}

		private function createBaseState ():Sprite{
			//trace("UISimpleButton::createBaseState");
			
			var sprite:Sprite = new Sprite();
			
			// gradient
			var type:String = GradientType.LINEAR; 
			var colors:Array = [0xFFFFFF, 0xFFFFFF, 0xFFFFFF]; 
			var alphas:Array = [0, .15, 0]; 
			var ratios:Array = [32, 128, 220]; 
			var spreadMethod:String = SpreadMethod.PAD; 
			var interp:String = InterpolationMethod.LINEAR_RGB; 
			var focalPtRatio:Number = 0;
			
			// matrix
			var mat:Matrix = new Matrix();
			var rot:Number = -30 * (Math.PI/180); 
			var tx:Number = 0; 
			var ty:Number = 0;
			mat.createGradientBox(_width, _height, rot, -.15*_width, ty);

			// LIGHT color
			var light:Shape = new Shape();
					
			// outer edge
			light.graphics.beginGradientFill(type, colors, alphas, ratios, mat, spreadMethod, interp, focalPtRatio); 
			light.graphics.drawRoundRect(0, 0, _width, _height, 8);
			
			// Clear middle
			light.graphics.drawRoundRect(_edgeWidth, _edgeWidth, _width-(_edgeWidth*2), _height-(_edgeWidth*2), 6);
			light.graphics.endFill();
			
			// modify matrix
			//mat.rotate(-25*(Math.PI/180));
			mat.createGradientBox(_width, _height, 16*(Math.PI/180), tx, ty);
			// inside
			light.graphics.beginGradientFill(type, colors, alphas, ratios, mat, spreadMethod, interp, focalPtRatio); 
			light.graphics.drawRoundRect(_edgeWidth, _edgeWidth, _width-(_edgeWidth*2), _height-(_edgeWidth*2), 6);
			light.graphics.endFill();
			
			// DARK color
			mat.createGradientBox(_width, _height, rot, -.15*_width, ty);
			
			var darkColor:uint = averageColor(_upColor, 0x000000);
			 colors = [0x000000, 0x000000, 0x000000, 0x000000]; 
			 alphas = [.25, 0, 0, .2]; 
			 ratios = [1, 35, 200, 255];
			
			var dark:Shape = new Shape();
			dark.graphics.beginGradientFill(type, colors, alphas, ratios, mat, spreadMethod, interp, focalPtRatio); 
			dark.graphics.drawRoundRect(_edgeWidth, _edgeWidth, _width-(_edgeWidth*2), _height-(_edgeWidth*2), 6);
			dark.graphics.endFill();
			
			// outer edge
			dark.graphics.beginGradientFill(type, colors, alphas, ratios, mat, spreadMethod, interp, focalPtRatio); 
			dark.graphics.drawRoundRect(0, 0, _width, _height, 8);
			
			// Clear middle
			var edge:Number = 4;
			dark.graphics.drawRoundRect(_edgeWidth, _edgeWidth, _width-(_edgeWidth*2), _height-(_edgeWidth*2), 6);
			dark.graphics.endFill();
			
			mat.createGradientBox(_width, _height, 16*(Math.PI/180), tx, ty);
			// inside
			dark.graphics.beginGradientFill(type, colors, alphas, ratios, mat, spreadMethod, interp, focalPtRatio); 
			dark.graphics.drawRoundRect(_edgeWidth, _edgeWidth, _width-(_edgeWidth*2), _height-(_edgeWidth*2), 6);
			dark.graphics.endFill();
			
			light.blendMode = BlendMode.ADD;
			dark.blendMode = BlendMode.OVERLAY;
									
			//sprite.blendMode = BlendMode.ADD;
			
			//var newSprite:Sprite = new Sprite();
			//newSprite.addChild(sprite);
			
			sprite.addChild(light);
			sprite.addChild(dark);
				

			return sprite;
			
		}
		
		private function createUpState ():Sprite{
			//trace("UISimpleButton::createUpState");
						
			var sprite:Sprite = new Sprite();
			var overlay:Sprite = createBaseState();
			//sprite.x = -(_width * 0.5);
			//sprite.y = -(_height * 0.5);
			
			if(_hasUpColor){
				var shade:Shape = new Shape();
				shade.graphics.beginFill(_upColor, 1); 
				shade.graphics.drawRoundRect(0, 0, _width, _height, 8);
				shade.graphics.endFill();

				sprite.addChild(shade);
			}
			sprite.addChild(overlay);
			
			if (_hasArt) appendArt(sprite);
			
			if(_hasLabel) {
				var label:TextField = createLabel();
				//var textGlow:GlowFilter = new GlowFilter(_upColor);
				//label.filters = [textGlow];
				var filter:BitmapFilter = getBitmapDropShadowFilter();
				var myFilters:Array = new Array();
				myFilters.push(filter);
				label.filters = myFilters;
				sprite.addChild(label);
			}
			
			return sprite;
		}
		
		private function createDisabledUpState ():Sprite{
			//trace("ScreensSimpleButton::createDisabledUpState");
			
			var sprite:Sprite = new Sprite();
			var overlay:Sprite = createBaseState();
		
			var shade:Shape = new Shape();
			shade.graphics.beginFill(0xcccccc, 1); 
			shade.graphics.drawRoundRect(0, 0, _width, _height, 8);
			shade.graphics.endFill();

			sprite.addChild(shade);
			sprite.addChild(overlay);
			
			if (_hasArt) appendArt(sprite);
			
			if(_hasLabel) {
				var label:TextField = createLabel();
				var textGlow:GlowFilter = new GlowFilter(_upColor);
				label.filters = [textGlow];
				sprite.addChild(label);
			}
			
			return sprite;
		}
		
		private function createOverState (color:uint):Sprite{
			//trace("UISimpleButton::createOverState");
						
			var sprite:Sprite = new Sprite();
			var overlay:Sprite = createBaseState();

			var shade:Shape = new Shape();
			shade.graphics.beginFill(_overColor, 1); 
			shade.graphics.drawRoundRect(0, 0, _width, _height, 8);
			shade.graphics.endFill();
			
			sprite.addChild(shade);			
			sprite.addChild(overlay);
			
			var filter:BitmapFilter = getBitmapInnerGlowFilter("over");
			var myFilters:Array = new Array();
			myFilters.push(filter);
			sprite.filters = myFilters;
						
			if (_hasArt) appendArt(sprite);
			
			if(_hasLabel) {
				var label:TextField = createLabel();
				var textGlow:GlowFilter = new GlowFilter(_upColor);
				label.filters = [textGlow];
				sprite.addChild(label);
			}
			
			return sprite;
		}
		
		private function createDownState ():Sprite{

			var sprite:Sprite = createUpState();
			
			// add a darker edge around the shape, for the depth effect.
			var edge:Shape = new Shape();
			edge.graphics.lineStyle(1, 0x000000, 0.3); 
			edge.graphics.drawRoundRect(0, 0, _width, _height, 6);
			edge.graphics.endFill();
			
			sprite.addChild(edge);
		
			var filter:BitmapFilter = getBitmapInnerGlowFilter("down");
			var myFilters:Array = new Array();
			myFilters.push(filter);
			sprite.filters = myFilters;
			var label:TextField = createLabel();
			var textGlow:GlowFilter = new GlowFilter(_upColor);
			label.filters = [textGlow];
			sprite.addChild(label);
			return sprite;
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

		private function appendArt(sprite:Sprite):Sprite{
			//trace("UISimpleButton::appendArt");
			
			var art:Sprite = new _artClass();
			art.x = _width * 0.5;
			art.y = _height * 0.5;
			
			// if we have color, use it
			if (_hasArtColor) {
				
				var myColor:ColorTransform = new ColorTransform();
				myColor.color = _artColor;
				art.transform.colorTransform = myColor;
				
			}
			
			var filter:BitmapFilter = getBitmapDropShadowFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			art.filters = myFilters;
			
			sprite.addChild(art);
					
			return sprite;
		}
		
		public function clearUpColor ():void{
			//trace("UISimpleButton::clearUpColor");
			
			_hasUpColor = false;
			
			// update
			update();
		}
		
		public function clearArtColor ():void{
			//trace("UISimpleButton::clearArtColor");
			
			_hasArtColor = false;
			
			// update
			update();
		}
		
		private function averageColor (c1:uint, c2:uint):uint{
			//trace("UITitlePanel::averageColor");
			
			var averageRed:uint = (((c1 >> 16) & 0xFF) + ((c2 >> 16) & 0xFF)) / 2;
			var averageGreen:uint = (((c1 >> 8) & 0xFF) + ((c2 >> 8) & 0xFF)) / 2;
			var averageBlue:uint = ((c1 & 0xFF) + (c2 & 0xFF)) / 2;
			var hex:uint = averageRed << 16 | averageGreen << 8 | averageBlue;
			return hex;
			
		}
		
		private function update ():void{
			//trace("UISimpleButton::update");
			
			// update
			downState      = createDownState();
	        overState      = createOverState(_overColor);
	        upState        = createUpState();
		}
		
		private function getBitmapDropShadowFilter():BitmapFilter {
			var color:Number = averageColor( 0x000000, _upColor);
			var angle:Number = 0;
			var alpha:Number = 0.9;
			var blurX:Number = 6;
			var blurY:Number = 6;
			var distance:Number = 0;
			var strength:Number = 1;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.HIGH;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}
		
	
		private function getBitmapInnerGlowFilter(state:String = "down"):BitmapFilter {
			var color:Number;
			var alpha:Number;
			var dist:Number;
			if(state == "over"){
				color = 0x000000;
				alpha = 0.8;
				dist = 8;
			}else if( state == "down"){
				color = 0x000000;
				alpha = 1.0;
				dist = 15;
			}
            
            var blurX:Number = dist;
            var blurY:Number = dist;
            var strength:Number = 0.9;
            var inner:Boolean = true;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
        }

	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------
	}
}