package {

	import flash.display.*;
	import com.megadoug.rainbowcloudgame.*;
	import net.hires.debug.Stats;
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flash.events.MouseEvent;
	
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import flash.text.*;
	//import flash.filters.GlowFilter;
	import fl.motion.Color;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	

	/**
	 *  Constructs a Document Class for Rainbow Cloud Game
	 *  
	 *  @langversion ActionScript 3
	 *  @playerversion Flash 10.0.0
	 *
	 *  @author Douglas Roussin
	 *  @since  14.04.2012
	 *  @version 0.1
	 *  @copyright (c) 2012 megaloMedia. All rights reserved.
	 */

	public class RainbowCloudGame extends Sprite {

	    //--------------------------------------------------------------------------
	    //
	    //  Variables, Constants & Bindings
	    //
	    //--------------------------------------------------------------------------
		private var _splashScreen:Sprite;
		private var _endScreen:Sprite;
	
		private var _player:Player;
		
		private var _party:Party;
		private var _partyHolder:Sprite;
		private var _guestsToSpawn:Vector.<Guest>;
		private var _guests:Vector.<Guest>;
		private var _guestTimer:Timer;
		
		//private var _playerOnCloud:Boolean = false;
		//private var _playerInCloud:Boolean = false;
		//private var _inCloud:Cloud = null;
		private var _rainbowMeter:RainbowMeter;
		private var _redPct:Number = 0;
		private var _orangePct:Number = 0;
		private var _yellowPct:Number = 0;
		private var _greenPct:Number = 0;
		private var _bluePct:Number = 0;
		private var _violetPct:Number = 0;
		
		
		private var _playerInRainbow:Boolean = false;
		private var _inRainbowObject:Object = null;
		private var _playerJumping:Boolean = false;
		
		private var _worldHeight:Number;
		private var _worldWidth:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _worldYgap:Number;
		
//		private var _playerWorldX:Number;
//		private var _playerWorldY:Number;
		
		private var _xSpeedIncr:Number;
		private var _speedPct:Number; // <-- 0to1
		private var _levelsNum:uint;
		private var _currentLevel:uint;
		
		private var _gravity:Number = .12;
		private var _drag:Number = .95;
		private var _jumpSpeed:Number = -7;
		
	//	private var _onscreenClouds:Vector.<Cloud>;
		private var _levels:Vector.< Vector.<Cloud> >;
		//private var _clouds:Vector.<Cloud>;
		private var _cloudsHolder:Sprite;
		private var _partyCloud:Cloud;
		
		private var _rainbows:Vector.<Object>;
		private var _rainbowsHolder:Sprite;
		private var _rainbowTimer:Timer;
		
		private var _timeoutTimer:Timer;
		private var _noKeysPressed:Boolean;
		
		private var _worldFG:Sprite;
		private var _worldFGcopy:Bitmap;
		private var _worldBG:Sprite;
		
		private var _starsHolder:Sprite;
		
		private var _prizesHolder:Sprite;
		private var _prizes:Vector.<Prize>;
		private var _prizeX:Number = 0;
		private var _prizeTimer:Timer;
		
		private var rightCombo:KeyCombo;
		private var downCombo:KeyCombo;
		private var leftCombo:KeyCombo;
		private var upCombo:KeyCombo;
		private var spaceCombo:KeyCombo;
		private var pauseCombo:KeyCombo;
		private var resetCombo:KeyCombo;
		
		private var _paused:Boolean = false;
		

		private var _jumpSound:Object;
		private var _landSound:Object;
		private var _windSound:Object;
		private var _harpSound:Object;
		private var _bellSound:Object;
		private var _fluteSound:Object;
		private var _enchantSound:Object
		private var _musicBoxSound:Object;
		
		private var output_txt:TextField;
		private var outputFmt:TextFormat;
		
		public static var STAGE:Stage;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------

		public function RainbowCloudGame () {
			trace("RainbowCloudGame");
			
			STAGE = this.stage;
			init();

			createChildren();

			
			//startGame();
/*			stage.displayState = StageDisplayState.FULL_SCREEN;		
			stage.scaleMode = StageScaleMode.SHOW_ALL;*/
			
		};

		//--------------------------------------------------------------------------
	    //
	    //  Accessors
	    //
	    //--------------------------------------------------------------------------

	    //--------------------------------------------------------------------------
	    //
	    //  Init Methods
	    //
	    //--------------------------------------------------------------------------
	
		private function init ():void{
			trace("RainbowCloudGame::init");
			
			_speedPct = .2;
			_xSpeedIncr = 1;
			
			_worldWidth = stage.stageWidth * 8;
			_worldHeight = stage.stageHeight * 5;
			
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			
			_worldYgap = 2 * _stageHeight;
			
			//_playerWorldX = 0;
			//_playerWorldY = _worldHeight * .9;
			
			_levelsNum = 18;
			_currentLevel = 3;
			//_clouds = new Vector.<Cloud>();
			_levels = new Vector.< Vector.<Cloud> >();
			
			_partyHolder = new Sprite();
			_guests = new Vector.<Guest>();
			_guestsToSpawn = new Vector.<Guest>();
			
			for(var i:uint = 1; i <= 6; i++){
				_guestsToSpawn.push(new Guest(i));
			}
			_guestTimer = new Timer(10000, 0);
			
			_rainbowsHolder = new Sprite();
			_rainbows = new Vector.<Object>();
			_rainbowTimer = new Timer(4000,0);
			
			_timeoutTimer = new Timer(50000,0);
			
			_prizesHolder = new Sprite();
			_prizes = new Vector.<Prize>;
			_prizeTimer = new Timer(3000, 0);
			
			setKeys();
			
			_worldFG = new Sprite();
			_worldBG = new Sprite();
			var bd1:BitmapData = new BitmapData(_stageWidth, _stageHeight, true, 0xFF00FFFF);
			_worldFGcopy = new Bitmap(bd1);
			_worldFGcopy.smoothing = true;
			_cloudsHolder = new Sprite();
			buildClouds();
			
			_rainbowMeter = new RainbowMeter();
			_rainbowMeter.colors = new Vector.<Object>();
			_rainbowMeter.colors.push({
				name:"red",
				mc:_rainbowMeter.red,
				percent:0,
				emoticon:": )"
			});
			_rainbowMeter.colors.push({
				name:"orange",
				mc:_rainbowMeter.orange,
				percent:0,
				emoticon:"8 P"
			});
			_rainbowMeter.colors.push({
				name:"yellow",
				mc:_rainbowMeter.yellow,
				percent:0,
				emoticon:"=)"
			});
			_rainbowMeter.colors.push({
				name:"green",
				mc:_rainbowMeter.green,
				percent:0,
				emoticon:"S; |"
			});
			_rainbowMeter.colors.push({
				name:"blue",
				mc:_rainbowMeter.blue,
				percent:0,
				emoticon:": D"
			});
			_rainbowMeter.colors.push({
				name:"violet",
				mc:_rainbowMeter.violet,
				percent:0,
				emoticon:"|: ?"
			});
			
			
			_jumpSound = makeSound(Jump);
			_landSound = makeSound(Land);
			_windSound = makeSound(Wind);
			_harpSound = makeSound(Harp);
			_bellSound = makeSound(Bell);
			_fluteSound = makeSound(Flute);
			_enchantSound = makeSound(Enchant);
			_musicBoxSound = makeSound(MusicBox);
		}
		
		private function buildClouds ():void{
			trace("RainbowCloudGame::makeClouds");
			
			
			
			var shadow1:BitmapFilter =  new DropShadowFilter(18,
				-70,
				0xFF9966,
				.5,
				22,
				22,
				1,
				BitmapFilterQuality.LOW,
				true,
				false);
			var hilite:DropShadowFilter =  new DropShadowFilter(12,
				110,
				0x99ffff,
				.5,
				8,
				8,
				1,
				BitmapFilterQuality.LOW,
				true,
				false);

			//_cloudsHolder.filters = [shadow1,hilite];
			//_cloudsHolder.filters = [shadow1];
			//trace("_cloudsHolder.filters: "+_cloudsHolder.filters);
			
			// use same cloud vector vor all cloud layers? 
			// just use diferent xPos so it's not noticeable?
			
			
			var numClouds:uint = Math.round( _worldWidth / 800 );
			var slotWidth:Number = _worldWidth / numClouds;
			
			var maxCloudW:Number = slotWidth *.9;
			//trace("maxCloudW: "+maxCloudW)
			var minCloudW:Number = 200;
			//var maxGap:Number = 1400;//(_worldWidth - (minCloudW * numClouds)) / numClouds;
			//var minGap:Number = 400;//(_worldWidth - (maxCloudW * numClouds)) / numClouds;
			var yStep:Number = _worldHeight / (_levelsNum-1);
			var nextX:Number;
			
			_cloudsHolder.graphics.beginFill(0x00ffFF,1);
			_cloudsHolder.graphics.drawRect(0,0,10,_worldHeight);
			_cloudsHolder.graphics.endFill();
			_cloudsHolder.graphics.beginFill(0xffff88,1);
			_cloudsHolder.graphics.drawRect(_worldWidth-10,0,10,_worldHeight);
			_cloudsHolder.graphics.endFill();
			
			_cloudsHolder.graphics.beginFill(0xffff66,1);
			_cloudsHolder.graphics.drawRect(0,- _worldYgap/2,_worldWidth,5);
			_cloudsHolder.graphics.endFill();
			_cloudsHolder.graphics.beginFill(0x66ffff,1);
			_cloudsHolder.graphics.drawRect(0,_worldHeight + _worldYgap/2,_worldWidth,5);
			_cloudsHolder.graphics.endFill();
			
			
			
			
			for(var i:uint = 0; i < _levelsNum; i++ ){
				var pct:Number = (i + 1) / _levelsNum;
				var maxSpan:Number = (maxCloudW - minCloudW)* pct;
				 
				var maxW:Number = minCloudW + pct * maxSpan;
				var minW:Number = minCloudW + maxSpan * .5 * pct;
/*				trace("maxSpan"+maxSpan)
				trace("pct: "+pct)
				trace("minW, maxW: "+minW+", "+maxW);*/
				var ncv:Vector.<Cloud> = new Vector.<Cloud>();
				_levels[i] = ncv;
				var levelXspeed:Number = Math.random() * 10 - 5;
				//_levels[i]["xspeed"] = levelXspeed;
				var levely:Number = yStep * i;
				
				for(var c:uint = 0; c < numClouds; c++){
/*					var maxW:Number = (_worldWidth - nextX) / (numClouds - c) - 20;
					var minW:Number = 100;*/
					
					nextX = c * slotWidth;//minGap;
					var w:Number = Math.round(minW + Math.random()*(maxW - minW));
					var h:Number = Math.round(Math.random()*40 + 40);
					var xadd:Number = Math.random()*(slotWidth - w - 100);
					var newCloud:Cloud = new Cloud(w,h);
					newCloud.yPos = newCloud.y = levely;
					newCloud.xPos = newCloud.x = nextX + xadd;
					newCloud.xSpeed = levelXspeed;
					_levels[i].push(newCloud);
					_cloudsHolder.addChild(newCloud);
					hilite.blurX = hilite.blurY = Math.ceil(h * .1);
					newCloud.filters = [shadow1,hilite];
					
					_worldBG.addChild(new Cloud(w,h));
					_worldBG.getChildAt(_worldBG.numChildren-1).x = nextX + xadd;
					_worldBG.getChildAt(_worldBG.numChildren-1).y = levely;
					
					//nextX += w + minGap + Math.random()*(maxGap - minGap);
				}
			}	
			
			// Add Party Cloud
		 	ncv = new Vector.<Cloud>();
			_levels[i] = ncv;
			
			_partyCloud = new Cloud(650,100,0xffccff);
			_partyCloud.filters = [shadow1,hilite];
			_partyCloud.yPos = _partyCloud.y = -400;
			_partyCloud.xPos = _partyCloud.x = _worldWidth/2 - 325;
			_partyCloud.xSpeed = 0;
			_levels[i].push(_partyCloud);
			_cloudsHolder.addChild(_partyCloud);
			// draw duplicate at bottom of world
			var partyCopy:Cloud = new Cloud(650,100,0xffccff);
			partyCopy.y = _worldHeight + _worldYgap -400;
			partyCopy.x = _worldWidth/2 - 325;
			partyCopy.filters = [shadow1,hilite];
			_cloudsHolder.addChild(partyCopy);
			
			
			_worldBG.graphics.lineStyle(1,0xffffff);
			_worldBG.graphics.lineTo(0,_worldBG.height);
			_worldBG.graphics.moveTo(_worldBG.width,0);
			_worldBG.graphics.lineTo(_worldBG.width,_worldBG.height);
			
			_worldBG.scaleX = _worldBG.scaleY = .5;	
			
			
			
			var co:Color = new Color();
			co.setTint(0x0066CC,.90);
			_worldBG.transform.colorTransform = co;
		}
	
		private function setKeys():void{
			//downCombo = new KeyCombo([83,40,101],goDown);
			rightCombo = new KeyCombo([68,39,102],goRight);
			upCombo = new KeyCombo([87,38,104],goUp);
			leftCombo = new KeyCombo([65,37,100],goLeft);
			spaceCombo = new KeyCombo([32],spacePressed,popRainbows);
			//popCombo = new KeyCombo([32],popRainbow,true);
			
			pauseCombo = new KeyCombo([16], null, togglePause);
			resetCombo = new KeyCombo([82], null, endGame);
		}
		private function togglePause ():void{
			trace("RainbowCloudGame::togglePause");
			if(hasEventListener(Event.ENTER_FRAME)){
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_paused = true;
				stopSounds();
			}else{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
				_paused = false;
				_windSound.playMe(0,999);
			}
		}
		
		private function resetGame ():void{
			trace("RainbowCloudGame::reset");
			
				_endScreen.visible = false;
				
				_speedPct = .2;
				_xSpeedIncr = 1;

				_currentLevel = 3;
				//_clouds = new Vector.<Cloud>();

/*				while(_rainbowsHolder.numChildren > 0){
					_rainbowsHolder.removeChildAt(0);
				}*/
				for(var i:int = _rainbows.length-1; i >= 0; i --){
					destroyRainbow(_rainbows[i]);
				}
				for( i = _prizes.length-1; i >= 0; i --){
					destroyPrize(_prizes[i]);
				}

				_rainbowMeter.red.rotation =
				_rainbowMeter.orange.rotation =
				_rainbowMeter.yellow.rotation =
				_rainbowMeter.green.rotation =
				_rainbowMeter.blue.rotation =
				_rainbowMeter.violet.rotation = 0;
				
				_levels.length = 0;
				while(_cloudsHolder.numChildren > 0){
					_cloudsHolder.removeChildAt(0);
				}
				while(_worldBG.numChildren > 0){
					_worldBG.removeChildAt(0);
				}
				buildClouds();
				
				_worldFG.y = -_levels[0][0].yPos + _player.y;
/*				_player.yPos = _levels[0][0].yPos;
				_player.xPos = _player.x;*/
				_player.yPos = _partyCloud.yPos - 100;
				_player.xPos = _partyCloud.xPos + 100;


				_splashScreen.visible = true;
				_enchantSound.playMe();

				for( i = 0; i < 30; i ++){
					var s:Star = new Star(8+Math.random()*7, Math.random()*144-72);
					_splashScreen.addChild(s);
					s.xPos = Math.random()*(_stageWidth - 200) + 100;
					s.yPos = Math.random()*100;
					s.startFall();
				}
				
		}

	    //--------------------------------------------------------------------------
	    //
	    //  Create / Destroy
	    //
	    //--------------------------------------------------------------------------
		
		private function createChildren ():void{
			trace("RainbowCloudGame::createChildren");
			_worldBG.y = 300
			addChild(_worldBG);
			addChild(_rainbowsHolder);
			
			_party = new Party();
			_party.x = _partyCloud.x + _partyCloud.width/2;
			_party.y = _partyCloud.y;
			_partyHolder.addChild(_party);
			addChild(_partyHolder);
			
			_player = new Player();
			_player.x = stage.stageWidth/2;
			_player.y = stage.stageHeight/2;
			
			addChild(_worldFGcopy);
			addChild(_player);
			_worldFG.addChild(_prizesHolder);
			_worldFG.addChild(_cloudsHolder);
			_starsHolder = new Sprite();
			_worldFG.addChild(_starsHolder);
			addChild(_worldFG);
			
			_worldFG.y = -_levels[0][0].yPos + _player.y;
			_player.yPos = _partyCloud.yPos - 100;
			_player.xPos = _partyCloud.xPos + 100;
			

			// STATS
			var stats:Stats = new Stats();
			stats.x = stage.stageWidth - 90;
			stats.y = stage.stageHeight - 105;
			addChild( stats );
			createOutputField();
			
			_endScreen = new Sprite();
			_endScreen.addChild(new EndScreen());
			var restartButton:UISimpleButton = new UISimpleButton(140, 60, null, "RESET", 6);
			restartButton.upColor = 0x00CC33;
			restartButton.overColor = 0xFF6600;
			restartButton.addEventListener(MouseEvent.CLICK, restartButtonHandler);
			restartButton.x = 700;
			restartButton.y = 515;
			_endScreen.addChild(restartButton);
			addChild(_endScreen);
			_endScreen.visible = false;
			
			// SHOW SPLASH SCREEN
			
			_splashScreen = new Sprite();
			_splashScreen.addChild(new Splash());
			var playButton:UISimpleButton = new UISimpleButton(120, 60, null, "PLAY", 6);
			playButton.upColor = 0x00CC33;
			playButton.overColor = 0xFF6600;
			playButton.addEventListener(MouseEvent.CLICK, playButtonHandler);
			playButton.x = 820;
			playButton.y = 420;
			_splashScreen.addChild(playButton);
			addChild(_splashScreen);
			_enchantSound.playMe();
			for(var i:uint = 0; i < 30; i ++){
				var s:Star = new Star(8+Math.random()*7, Math.random()*144-72);
				_splashScreen.addChild(s);
				s.xPos = Math.random()*(_stageWidth - 200) + 100;
				s.yPos = Math.random()*100;
				s.startFall();
			}			
		}
		
		private function createClouds ():void{
			trace("RainbowCloudGame::createClouds");
			
		}
		
		private function createOutputField ():void{
			trace("RainbowCloudGame::createOutputField");
			
			outputFmt = new TextFormat();
			outputFmt.font = new ArialRoundedBold().fontName;			
			outputFmt.size = 12;
			outputFmt.color = 0x3333FF;
			outputFmt.align = "right";
			
			output_txt = new TextField();
			output_txt.border = false;
			output_txt.background = true;
			//output_txt.autoSize = TextFieldAutoSize.RIGHT; 
			output_txt.antiAliasType = AntiAliasType.ADVANCED;
			output_txt.embedFonts = true;
			output_txt.selectable = false;
			output_txt.defaultTextFormat = outputFmt;
			output_txt.text = "Today";
			
			output_txt.x = 10;
			output_txt.y = 450;
			output_txt.width = 100;
			output_txt.height = 160;
			addChild(output_txt);
		}
		
		private function createRainbow (c1:Cloud, c2:Cloud):void{
			trace("RainbowCloudGame::createRainbow");
			// Make sure same clouds don't already have a rainbow
			for(var i:uint = 0; i < _rainbows.length; i++){
				var k1:Cloud = _rainbows[i].cloud1;
				var k2:Cloud = _rainbows[i].cloud2;
				if((c1 == k1 && c2 == k2) || (c1 == k2 && c2 == k1)){
					// don't do it
					return;
				}
			}
			var p1:Point = new Point(c1.xPos + c1.width/2, c1.yPos + c1.height / 2);
			var p2:Point = new Point(c2.xPos + c2.width/2, c2.yPos + c2.height / 2);
			var r:Rainbow = new Rainbow(p1,p2);
			var s:Starburst = new Starburst();
			
			_rainbows.push({cloud1:c1, cloud2:c2, percentDrawn:0, rainbow:r, starburst:s});
			_rainbowsHolder.addChild(r);
			_rainbowsHolder.addChild(s);
			
		}	
		private function destroyRainbow (o:Object):void{
				trace("RainbowCloudGame::destroyRainbow");

				// Make Star shower
				o.cloud1.rainbowsAttached --;
				o.cloud2.rainbowsAttached --;
				//var myKind:String;

				var points_ar:Array = o.rainbow.getPoints(100);
				for(var i:uint = 0; i<points_ar.length; i++){
					//myKind = randomColor();
					var s:Star = new Star(4+Math.random()*15, Math.random()*144-72,-1,-1);//,myKind);
					_starsHolder.addChild(s);
					s.xPos = points_ar[i].x;
					s.yPos = points_ar[i].y;
					s.startFall();
				}


				if(_inRainbowObject == o){
					_fluteSound.stop();
					_playerInRainbow = false;
					_inRainbowObject = null;
				}
				_rainbowsHolder.removeChild(o.rainbow);
				if(_rainbowsHolder.contains(o.starburst)){
					_rainbowsHolder.removeChild(o.starburst);
				}
				_rainbows.splice(_rainbows.indexOf(o),1);
			}
		
		private function createPrize ():void{
			trace("RainbowCloudGame::createPrize");
			//{sourceSprite:null, radius:-1, color1:-1, color2:-1, strokeWidth:2, iconOverShine:false, text:""}
			//var kind_vec:Vector.<String> = new Vector.<String>();
			
			var myKind:String;
			var color:Object;
			do{
				var index:uint = Math.floor(Math.random()*6);
				color = _rainbowMeter.colors[index];
				myKind = color.name;				
			}while(color.percent == 1);
			
			var p:Prize = new Prize({radius:30, kind:myKind, text:color.emoticon});
			_prizeX = (_prizeX + 300) % _worldWidth;
			p.xPos = _prizeX;
			p.yPos = _player.yPos - _stageHeight;
			
			_prizesHolder.addChild(p);
			_prizes.push(p);
		}
		
		private function createGuest ():void{
			trace("RainbowCloudGame::createGuest");
			// Should be called spawnGuest, since guests are already created
			var i:uint = Math.floor(Math.random()*_guestsToSpawn.length);
			var g:Guest = _guestsToSpawn[i];
			
			g.xPos = Math.random() * _worldWidth;
			g.yPos =  _worldHeight - Math.random()*_worldHeight*0.6;
			_partyHolder.addChild(g);
			_guests.push(g);
			_guestsToSpawn.splice(i,1);
		}
		
		private function destroyPrize (p:Prize):void{
			trace("RainbowCloudGame::destroyPrize");
			_prizes.splice(_prizes.indexOf(p),1);
			_prizesHolder.removeChild(p);
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
	
		private function update ():void{
			//trace("RainbowCloudGame::update");
			// GAME FRAME
			updateOutput();
			
			checkKeys();
			if(_player.inCloud != null){
				moveInCloud(_player);
			}else if(!_playerInRainbow){//} && !_playerJumping){
				checkCloudsCollisions(_player);
			}
			
			if(!_playerJumping){
				
				
			}else if(_player.ySpeed > 0){
				_playerJumping = false;
			}
			if(!_player.inCloud){
				checkRainbowCollisions();
			}

			// Apply Gravity
			if(_player.inCloud == null && !_playerInRainbow){
				_player.ySpeed = _player.ySpeed + _gravity;
				// "+(_player.ySpeed + _gravity));
			}
			_player.yPos += _player.ySpeed;
			_player.xPos += _player.xSpeed;
			
			// Set player avatar frame
			
			var left:Boolean = _player.xSpeed < 0;
			var up:Boolean = _player.ySpeed < 0;
			if( left ){
				if(up){
					_player.frame = ("leftup");
				}else{
					_player.frame = ("leftdown");
				}
			}else{
				if(up){
					_player.frame = ("rightup");
				}else{
					_player.frame = ("rightdown");
				}
			}
			
			// Time to Wrap?
			if(_player.xPos < 0){
				_player.xPos += _worldWidth;
			}else if(_player.xPos > _worldWidth){
				_player.xPos -= _worldWidth;
			}
			if(_player.yPos < -_worldYgap/2){
				_player.yPos += _worldHeight+_worldYgap;
 			}else if(_player.yPos > _worldHeight + _worldYgap/2){
				_player.yPos -= _worldHeight+_worldYgap;
				
			}
			
			// Move World
					
			checkPrizeCollisions();
			
			_rainbowsHolder.x = _worldFG.x = _partyHolder.x = - _player.xPos + _player.x; //+= xVel;
			_rainbowsHolder.y = _worldFG.y = _partyHolder.y = - _player.yPos + _player.y;//+= yVel;
			
			moveClouds();
			moveRainbows();
			movePrizes();
			moveGuests();
			// Show 2nd screen?
			if(_player.xPos < _stageWidth/2 || _player.xPos > _worldWidth - _stageWidth/2){
				//_worldFGcopy.bitmapData.lock();
				_worldFGcopy.visible = true;
				var tx:Number, ty:Number;
				var tx2:Number;
				var drawBG:Boolean = false;
				var rectW:Number;
				var rx:Number, ry:Number;
				if(_player.xPos < _stageWidth){
					
					// show 2nd world to left
					rx = 0;//_worldFG.x;// - _worldWidth;
					tx = -(_worldWidth - _worldFG.x);
					rectW = _worldFG.x;
				}else if(_player.xPos > _worldWidth - _stageWidth){
					
					// show 2nd world to right
					rectW = _stageWidth - (_worldFG.x + _worldWidth);
					
					rx = _stageWidth - rectW;
					tx = rx//-(_stageWidth - (_worldFG.x + _worldWidth));//_worldWidth//_worldFG.x;
				}
				
				ry = 0//- _worldFG.y;
				ty =  _worldFG.y
				// draw 2nd bg clouds?
/*				if(_worldBG.x > 0){
					tx2 = _worldBG.x - _worldBG.width * _worldBG.scaleX;
					drawBG = true;
				} else if(_worldBG.x < - (_worldBG.width * _worldBG.scaleX - _stageWidth)){
					tx2 = _worldBG.x + _worldBG.width * _worldBG.scaleX;
					drawBG = true;
				}*/
				
				var mat:Matrix = new Matrix();
				mat.translate(tx, ty);
				var clipRect:Rectangle = new Rectangle(rx, ry, rectW, _stageHeight);
			
				_worldFGcopy.bitmapData.lock()
				_worldFGcopy.bitmapData.fillRect(_worldFGcopy.bitmapData.rect, 0x0000FFFF);
/*				if(drawBG){
					var mat2:Matrix = new Matrix();
					mat2.translate(tx2, _worldBG.y);
					_worldFGcopy.bitmapData.draw(_worldBG,mat2);
				}*/
				//draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:flash.geom:ColorTransform = null, blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false):void
				_worldFGcopy.bitmapData.draw(_worldFG,mat,null, null, clipRect);
				_worldFGcopy.bitmapData.unlock();
			} else {
				_worldFGcopy.visible = false;
			}
			//trace("CP5")
			// Move BG
			_worldBG.x = _worldFG.x * _worldBG.scaleX;
			_worldBG.y = _worldFG.y * _worldBG.scaleY;
			


	
			
		}
		
		//---------------------------
		// 	v KEYS v
		//---------------------------
		private function goRight():void{
			//trace("goRight()");
			//var mod:Number = _player.inCloud ? .7 : _speedPct;
			_player.xSpeed += _xSpeedIncr * _speedPct;
			
		}
		private function goLeft():void{
			//trace("goLeft()");
			//var mod:Number = _player.inCloud ? .7 : _speedPct;
			_player.xSpeed -= _xSpeedIncr * _speedPct;
		}
		private function goUp():void{
			//trace("goUp()");
			_player.yPos -= .1;
			_player.ySpeed -= .5;
			_player.ySpeed = Math.max(-5, _player.ySpeed);
			
		}
		/*
		private function goDown():void{
			//trace("goDown()");
			_surfer.yspeed += _ySpeedIncr * _speedPct;
			_surfer.yspeed = Math.min(_maxYspeed, _surfer.yspeed);		
		}*/
		private function spacePressed ():void{
			// Jump
			
			//var onCloud:Boolean = _player.inCloud != null; // (_player.inCloud && _player.yPos < _player.inCloud.yPos + 10);
			
			if(_player.inCloud){
				var pDepth:Number = _player.yPos - _player.inCloud.yPos;
				var depthPct:Number = pDepth / _player.inCloud.height;
				
			//}
			
			//trace("onCloud: "+onCloud)
			//if(onCloud){
				// Jump
				_player.ySpeed = _jumpSpeed + _jumpSpeed * 0.5 * depthPct;
				_player.xSpeed += _player.inCloud.xSpeed;
				_playerJumping = true;
 				_player.yPos = _player.inCloud.yPos;
				_player.inCloud = null;
				_jumpSound.playMe(0,1,0.3);
/*				_playerInRainbow = false;
				_inRainbowObject = null;*/
			}
		}
		private function popRainbows ():void{
			trace("RainbowCloudGame::popRainbows");
			if(_playerInRainbow && ! _player.inCloud){
				destroyRainbow(_inRainbowObject);
				_player.ySpeed = _jumpSpeed*2;
				growMeter("all",4);
				_harpSound.playMe();
			}
		}

		private function checkKeys():void{
			var l,r:Boolean;
			l = leftCombo.anyDown;
			r = rightCombo.anyDown;
			if(r && !l){
				rightCombo.myFunction();
			}else if(l && !r){
				leftCombo.myFunction();
			}else{
				//slowDown("x");
				if(_player.inCloud ){
					_player.xSpeed *= .95;//drag;
				}else{
					_player.xSpeed *= .99;
				}
				
			}
			var u:Boolean = upCombo.anyDown;
			if(u ){
				upCombo.myFunction();
			}
			
			if(spaceCombo.allDown){
				//trace("space.allDown")
				spaceCombo.myFunction();
			}
			if(l || r || spaceCombo.allDown){
				_noKeysPressed = false;
			}
		}
		//----------------------------------
		//   ^ KEYS ^
		//----------------------------------
		//--------------------
		// SOUND FUNCTIONS v
		//--------------------
		private function makeSound(sclass:Class):Object{
			trace("makeSound("+sclass+")");
			var newSound:Object = new Object();
			newSound.mySound = new sclass();
			//var newChannel:SoundChannel;
			newSound.myChannel = new SoundChannel();
			newSound.myTransform = new SoundTransform();
			//newSound.myTransform.volume = svol;
			newSound.myPos = 0;
			newSound.playMe = function(pos:Number = 0,loops:uint = 0,vol:Number = 1):void{
				trace("sound.playMe("+pos+", "+loops+", "+vol+")");
				newSound.myChannel = newSound.mySound.play(pos,loops);
				newSound.myTransform.volume = vol;
				newSound.myChannel.soundTransform = newSound.myTransform;
				//newSound.myChannel.soundTransform.volume = vol;
			}
			newSound.stop = function():void{
				newSound.myChannel.stop();
				newSound.myPos = newSound.myChannel.position;
			}
			return newSound;
		}
		private function stopSounds():void{
			_windSound.stop();
			_fluteSound.stop();
		}
		//--------------------
		// SOUND FUNCTIONS ^
		//--------------------
		
		private function startGame ():void{
			trace("RainbowCloudGame::startGame");
			if(!contains(_rainbowMeter)){
				addChild(_rainbowMeter);
				_rainbowMeter.x = _rainbowMeter.y = 15;
			}
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_rainbowTimer.addEventListener(TimerEvent.TIMER, rainbowTimerHandler);
			_prizeTimer.addEventListener(TimerEvent.TIMER, prizeTimerHandler);
			_guestTimer.addEventListener(TimerEvent.TIMER, guestTimerHandler);
			_timeoutTimer.addEventListener(TimerEvent.TIMER, timeoutHandler);
			_rainbowTimer.start();
			_prizeTimer.start();
			_guestTimer.start();
			_noKeysPressed = true;
			_timeoutTimer.start();
			//_bellSound.playMe();
			_windSound.playMe(0,999);
		}
		
		private function checkRainbowCollisions ():void{
			//trace("RainbowCloudGame::checkRainbowCollisions");

			var r:Rainbow;
			//_playerInRainbow = false;
			//_inRainbowObject = null;
			if(!_playerInRainbow){
				//trace("Not in Rainbow")
				
				for(var i:uint = 0; i < _rainbows.length; i++){
					var o:Object = _rainbows[i];
					r = o.rainbow;
					// Above end cloud?
					var topCloud:Cloud = o.cloud1.yPos < o.cloud2.yPos ? o.cloud1 : o.cloud2;
					if(_player.yPos > topCloud.yPos+topCloud.height || _player.xPos < topCloud.xPos || _player.xPos > topCloud.xPos + topCloud.width){
					var playerRadius:Number = (_player.width+_player.height) / 4;
						if(r.checkCollision (_player.xPos, _player.yPos, playerRadius)){
							_playerInRainbow = true;
							_inRainbowObject = o;
							trace("Hit Rainbow!")
/*							removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
							_paused = true;*/
							_player.xSpeed = _player.ySpeed = 0;
							_fluteSound.playMe(0,10,.2);
							break;
						
						}
					}
				}
			} 
			 if(_playerInRainbow){
				r = _inRainbowObject.rainbow;
				// Move up the Rainbow
				var nextPoint:Point = r.getRelativePoint(_player.xPos, _player.yPos, 12);
				_player.xPos = nextPoint.x;//-_player.xPos;
				_player.yPos = nextPoint.y;// - _player.yPos;
				
				growMeter("all",.05);
				var starColor:String = randomColor();
				var s:Star = new Star(4+Math.random()*7, Math.random()*144-72,-1,-1,starColor);
				_starsHolder.addChild(s);
				s.xPos = _player.xPos;
				s.yPos = _player.yPos;
				s.startFall();
				//trace("PlayerInRainbow")
				// If leaving rainbow...
				if(!_inRainbowObject.rainbow.checkCollision(_player.xPos, _player.yPos, 10)){ //_player.inCloud != null || 
					// Leaving Rainbow
					_harpSound.playMe();
					_playerInRainbow = false;
					destroyRainbow(_inRainbowObject);
					_inRainbowObject = null;
					_player.xSpeed = (nextPoint.x-_player.xPos)/2;
					_player.ySpeed = (nextPoint.y - _player.yPos)/2;
					
				}
			}
		}
		
		private function checkPrizeCollisions ():void{
			//trace("RainbowCloudGame::checkPrizeCollision");
			
			var hitPrize:Prize = null;
			
			var y1:Number = _player.yPos;
			var y2:Number = y1 + _player.ySpeed;
			var x1:Number = _player.xPos;
			var x2:Number = x1 + _player.xSpeed;
			var pl:Number,pr:Number,pt:Number,pb:Number;
			if(x1<x2){
				pl = x1-_player.width/2;
				pr = x2 + _player.width/2;
			}else{
				pl = x2-_player.width/2;
				pr = x1 + _player.width/2;
			}
			if(y1<y2){
				pt = y1 - _player.height/2;
				pb = y2;
			}else{
				pt = y2 - _player.height/2;
				pb = y1;
			}
			
			for (var i:uint = 0; i < _prizes.length; i++){
				var p:Prize = _prizes[i];
				var l:Number = p.x - p.width/2;
				var r:Number = p.x + p.width/2;
				var t:Number = p.y - p.height/2;
				var b:Number = p.y;
				// check collision
				if( (pl < l && pr > l) || (pl < r && pl > l) || (pr > r && pl < r) || (pr < r && pr > l) ){
					// Horizontally aligned for collision
					if( (pt < t && pb > t) || (pt > t && pt < b) || (pb > b && pt < b) || (pb < b && pb > t) ){
						// Vertically alligned.  Collision.
						hitPrize = p;
						break;
					}
				}
			}
			if(hitPrize != null){
				playerHitPrize(hitPrize);
			}
			
		}
		
		private function checkCloudsCollisions (who:Body):void{
			//trace("RainbowCloudGame::checkCloudsCollisions");
			
			var isPlayer:Boolean = who == _player;
			var p1:Number = who.yPos;
			var p2:Number = p1 + who.ySpeed;
			
			for(var i:uint = 0; i < _levels.length; i++){
				var l:Vector.<Cloud> = _levels[i];
				var enterFromTop:Boolean = (p1 < l[0].yPos && p2 > l[0].yPos);
				var enterFromBottom:Boolean = (p1 > l[0].yPos + l[0].height && p2 < l[0].yPos + l[0].height);
				var startInside:Boolean =  (p1 > l[0].yPos && p1 < l[0].yPos + l[0].height);
				if( startInside || enterFromBottom || enterFromTop ){
					// In Y range
					for(var j:uint = 0; j < l.length; j++){
						var c:Cloud = l[j];
						if(who.xPos + who.xSpeed > c.xPos && who.xPos + who.xSpeed < c.xPos + c.width){
							var xStartOutside:Boolean = who.xPos < c.xPos || who.xPos > c.xPos + c.width;
						//	if(!startInside || xStartOutside){

									
									// In X range, INSIDE CLOUD
									if(isPlayer){
										_playerInRainbow = false;
										_inRainbowObject = null;
										trace("entering Cloud")
										_landSound.playMe(0,1,.4);
								
									}
									who.inCloud = c;
								
						//	}
						}
					}
				}
			}
			
		}
		private function moveInCloud (who:Body):void{
			//trace("RainbowCloudGame::moveInCloud");
			
			// MOVE IN CLOUD
			var p1:Number = who.yPos;
			var p2:Number = p1 + who.ySpeed;
			
			var c:Cloud = who.inCloud;
			
			if(who.xPos > c.xPos + c.width || who.xPos < c.xPos){
				// Leaving Cloud
				
				trace("leaving cloud from the side")
				who.xSpeed *= 1.1;
				// if moving same direction as cloud, get cloud's speed boost to clear edge
/*				if(c.xSpeed > 0 && who.xSpeed > 0 || c.xSpeed < 0 && who.xSpeed < 0){
					 who.xSpeed += c.xSpeed;
				}*/

				who.inCloud = null;
			}else{
				// Still In Cloud
				
				var top:Number = c.yPos;
				var bottom:Number = top + c.height;
			
				if( p2 > p1 ){
				
					// down
					if( p2 > bottom ){
						who.ySpeed = bottom - p1 - 1;
					}else if(who.ySpeed < .5){
						who.ySpeed *= -1;
					}
					who.ySpeed *= .9;
				
				}else{ // if( p2 < p1 ){
			
					// up

					if( (p1 - top < 2 && p2-p1 < 2) || p2 < top){
						// at the top
						who.ySpeed = top - p1;
					}
				
					if( p2 < top ){
						// out
						who.ySpeed *= .5;

					}
					who.ySpeed -= .15;
					
				}
				who.xPos += c.xSpeed;
				
				// increase drag with depth
				
/*				var depthPct:Number = Math.min(1,  (p1-top)/c.height);
				var modifier:Number = 1 - .05 * depthPct
				who.xSpeed *= modifier;*/
				who.xSpeed *= .99;
			}
		}
		
		private function movePrizes ():void{
			//trace("RainbowCloudGame::movePrizes");
			for(var i:uint = 0; i < _prizes.length; i++){
				var p:Prize = _prizes[i];
				
				if(p.inCloud != null){
					moveInCloud(p);
				}else{
					p.xPos += p.xSpeed;
					checkCloudsCollisions(p);
					p.ySpeed += _gravity;
					p.ySpeed = 10;
					//trace("p.ySpeed: "+p.ySpeed)
				}
				if(p.xSpeed != 0){
					p.xSpeed *= _drag;
					if(Math.abs(p.xSpeed) < 1){
						p.xSpeed = 0;
					}
				}
				p.yPos += p.ySpeed;
				if(p.yPos > _worldHeight){
					p.yPos -= _worldHeight;
				}
			}
		}
		
		private function moveGuests ():void{
			//trace("RainbowCloudGame::moveGuests");
			for(var i:uint = 0; i < _guests.length; i++){
				var g:Guest = _guests[i];
				
				if(g.inCloud != null){
					moveInCloud(g);
				}else{
					g.xPos += g.xSpeed;
					checkCloudsCollisions(g);
					g.ySpeed += _gravity;
					g.ySpeed = 10;
					//trace("g.ySpeed: "+g.ySpeed)
				}
				if(g.xSpeed != 0){
					g.xSpeed *= _drag;
					if(Math.abs(g.xSpeed) < 1){
						g.xSpeed = 0;
					}
				}
				g.yPos += g.ySpeed;
				if(g.yPos > _worldHeight){
					g.yPos -= _worldHeight;
				}
			}
		}
		
		private function moveClouds ():void{
			//trace("RainbowCloudGame::moveClouds");
			// world edge on screen?
			var assumedMaxCloudWidth:Number = 800;
			var showingEdge:String = "none";
			
			if(_worldFG.x + assumedMaxCloudWidth > _stageWidth/2 ){
				showingEdge = "left";
			}else if(_worldFG.x + _worldWidth - assumedMaxCloudWidth <  _stageWidth/2 ){
				showingEdge = "right";
			}
			
			for(var i:uint = 0; i<_levels.length; i++){
				var l:Vector.<Cloud> = _levels[i];
				for(var c:uint = 0; c < l.length;c++){
					var cloud:Cloud = l[c];
					cloud.xPos += cloud.xSpeed;
					// check world edge
					// Time to Wrap?
					if(cloud.xPos < 0){
						if(showingEdge == "right" || showingEdge =="none" && cloud.xPos < cloud.width){
							// Move to right edge
							cloud.xPos += _worldWidth;
							
						} 
					}else if(cloud.xPos > _worldWidth - cloud.width){
						if(showingEdge == "left" || showingEdge == "none" && cloud.xPos > _worldWidth){

							cloud.xPos -= _worldWidth;
						}
					}
				}
			}
			
			// Show party cloud at top or bottom?
			if(_player.yPos > _worldHeight - _stageHeight){
				_partyCloud.y = _partyCloud.yPos - _worldHeight;
			}else{
				_partyCloud.y = _partyCloud.yPos
			}
			
		}
		
		private function isOnscreen (x:Number, y:Number, buffer:Number = 0):void{
			trace("RainbowCloudGame::isOnscreen");
/*			l = -_worldFG.x;
			r = l + _stageWidth;
			t = -_worldFG.y;
			b = t+_stageHeight;*/
		}
		
		private function moveRainbows ():void{
			//trace("RainbowCloudGame::moveRainbows");
			if(_rainbows.length > 0){
				var l:Number,r:Number,t:Number,b:Number;
				l = -_worldFG.x - 800;
				r = l + _stageWidth + 800;
				t = -_worldFG.y - 600;
				b = t+_stageHeight + 600;
				
/*				_worldFG.graphics.clear();
				_worldFG.graphics.lineStyle(8,0xFF0000);
				_worldFG.graphics.drawRect(l,t,r-l,b-t);
				_worldFG.graphics.lineStyle();*/
				
				for(var i:int = _rainbows.length-1; i >= 0 ; i--){
					var o:Object = _rainbows[i];
					// If Onscreen, redraw rainbow
					var rl:Number , rr:Number, rt:Number, rb:Number;
					var p1:Point = new Point(o.cloud1.xPos + o.cloud1.width/2, o.cloud1.yPos + o.cloud1.height/2);
					var p2:Point = new Point(o.cloud2.xPos + o.cloud2.width/2, o.cloud2.yPos + o.cloud2.height/2);
					rl = Math.min(p1.x,p2.x);
					rr = Math.max(p1.x,p2.x);
					rt = Math.min(p1.y,p2.y,o.rainbow.center.y - o.rainbow.radius);
					rb = Math.max(p1.y,p2.y);
/*					if(p1.x < p2.x) 
					{
						rl = p1.x;
						rr = p2.x;
					}else{
						rl = p2.x;
						rr = p1.x;
					}
					if(p1.y < p2.y){
						rt = p1.y;
						rb = p2.y;
					}else{
						rt = p2.y;
						rb = p1.y;
					}*/

					
					
					if( ((rl < l && rr > l ) || (rr > r && rl < r) || (rl > l && rl < r) || (rr > l && rr < r)) && ((rt>t && rt<b) || (rb>t && rb<b) || (rt < t && rb > t) || (rb > b && rt < b))){
						
						
						//Math.abs(rl-rr) < 3000 &&
						// Rainbow's box intersects screen
						if(o.percentDrawn < 1){
							o.percentDrawn += .008;
							var lp:Point = o.rainbow.leadingPoint;
							
							if(o.percentDrawn > 1){
								o.percentDrawn = 1;
								_rainbowsHolder.removeChild(o.starburst);
								
							}else{// if(lp.x > l - 50 && lp.x < r+50 && lp.y > t-50 && lp.y < b+50 ){
								var s:Starburst = o.starburst;
								s.x = lp.x;
								s.y = lp.y;
								s.rotation = o.rainbow.endDegree;
							}
						}
						o.rainbow.update(p1,p2,o.percentDrawn);
						//_rainbowsHolder.graphics.clear();
/*						_worldFG.graphics.lineStyle(2,0x00ff00);
						_worldFG.graphics.drawRect(rl,rt,rr-rl,rb-rt);
						_worldFG.graphics.lineStyle();*/
					} else {
						// Get rid of rainbow
						destroyRainbow(o);
					}
				
				
				}
			}
		}
		
		
		private function playerHitPrize (p:Prize):void{
			trace("RainbowCloudGame::playerHitPrize");
			// Get Points - grow bar of prize's color
			growMeter(p.kind,10);
			// Burst
			var c1:uint = p.color1;
			var c2:uint = p.color2;
			for(var i:uint = 0; i<10; i++){
				var s:Star = new Star(5+Math.random()*5, Math.random()*144-72, c1, c2);
				_starsHolder.addChild(s);
				s.xPos = p.xPos;
				s.yPos = p.yPos;
				s.startFall();
			}
			// Destroy Prize
			destroyPrize(p);
			_enchantSound.playMe(0,1,0.5);
		}
		
		private function updateOutput ():void{
			//trace("RainbowCloudGame::updateOutput");
			var showingEdge:String = "none";
			
			var msg:String = "in cloud: "+_player.inCloud;
			msg+="\rjumping: "+_playerJumping;
			
			if(_worldFG.x + 800 > _stageWidth/2 ){
				showingEdge = "left";
				//msg+="\r_worldFG.x + 800: "+(_worldFG.x + 800);
			}else if(_worldFG.x + _worldWidth - 800 <  _stageWidth/2 ){
				showingEdge = "right";
				//msg+="\r_worldFG.x + _worldWidth - 800: "+(_worldFG.x + _worldWidth - 800);
			}
			
			
			msg+="\redge: "+showingEdge;
			msg+="\rySpeed: "+Math.round(_player.ySpeed);
			msg+="\ry: "+Math.round(_player.yPos);
			msg+="\rinRainbow: "+_playerInRainbow+"\r#rainbows: "+_rainbows.length;
			msg+="\r_gravity: "+_gravity;
			msg+="\r_noKey: "+_noKeysPressed;
			msg+="\r#prizes: "+_prizes.length;
			output_txt.text = msg;
		}
		
		private function growMeter (color:String, pct:Number):void{
			trace("RainbowCloudGame::growMeter");
			switch(color){
				default:
				case "all":
					_rainbowMeter.red.rotation = Math.min(180, _rainbowMeter.red.rotation + pct/100 * 180);
					_rainbowMeter.orange.rotation = Math.min(180, _rainbowMeter.orange.rotation + pct/100 * 180);
					_rainbowMeter.yellow.rotation = Math.min(180, _rainbowMeter.yellow.rotation + pct/100 * 180);
					_rainbowMeter.green.rotation = Math.min(180, _rainbowMeter.green.rotation + pct/100 * 180);
					_rainbowMeter.blue.rotation = Math.min(180, _rainbowMeter.blue.rotation + pct/100 * 180);
					_rainbowMeter.violet.rotation = Math.min(180, _rainbowMeter.violet.rotation + pct/100 * 180);
					break;
				case "red":
					_rainbowMeter.red.rotation = Math.min(180, _rainbowMeter.red.rotation + pct/100 * 180);
					
					break;
				case "orange":
					_rainbowMeter.orange.rotation = Math.min(180, _rainbowMeter.orange.rotation + pct/100 * 180);
				
					break;
				case "yellow":
				 	_rainbowMeter.yellow.rotation = Math.min(180, _rainbowMeter.yellow.rotation + pct/100 * 180);
					
					break;
				case "green":
					_rainbowMeter.green.rotation = Math.min(180, _rainbowMeter.green.rotation + pct/100 * 180);
				
					break;
				case "blue":
					_rainbowMeter.blue.rotation = Math.min(180, _rainbowMeter.blue.rotation + pct/100 * 180);
				
					break;
				case "violet":
					_rainbowMeter.violet.rotation = Math.min(180, _rainbowMeter.violet.rotation + pct/100 * 180);
				
					break;
			}
			// if all full,
			if(
				_rainbowMeter.red.rotation == 180 &&
				_rainbowMeter.orange.rotation == 180 &&
				_rainbowMeter.yellow.rotation == 180 &&
				_rainbowMeter.green.rotation == 180 &&
				_rainbowMeter.blue.rotation == 180 &&
				_rainbowMeter.violet.rotation == 180
				)
				{
					endGame();
				}
			// _musicBoxSound.playMe();
		}
		
		private function endGame ():void{
			trace("RainbowCloudGame::endGame");
			// STOP
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_rainbowTimer.reset();
			_prizeTimer.reset();
			_timeoutTimer.reset();
			_rainbowTimer.removeEventListener(TimerEvent.TIMER, rainbowTimerHandler);
			_prizeTimer.removeEventListener(TimerEvent.TIMER, prizeTimerHandler);	
			_timeoutTimer.removeEventListener(TimerEvent.TIMER, timeoutHandler);		
			stopSounds();
			showEndScreen();			
		}
		
		private function showEndScreen ():void{
			trace("RainbowCloudGame::showEndScreen");
			_musicBoxSound.playMe();
			
			// ADD END SCREEN
			_endScreen.y = _stageHeight + 20;
			_endScreen.visible = true;
			// bounce in!
			var myYtween:GTween = new GTween(_endScreen, 2, {y:0}, { ease:Bounce.easeOut});
		}
	
		
		private function randomColor ():String{
			//trace("RainbowCloudGame::randomColor");
			var rc:String;
			switch( Math.floor(Math.random() * 6)){

				case 0:
					rc = "red";
					break;
				case 1:
					rc = "orange";
					break;
				case 2:
					rc = "yellow";
					break;
				case 3:
					rc = "green";
					break;	
				case 4:
					rc = "blue";
					break;		
				case 5:
					rc = "violet";
					break;
			}
			return rc;
		}
		
		/*
		 * new abs function, about 25x faster than Math.abs
		 */
		private static function abs( value : Number ) : Number {
			return value < 0 ? -value : value;
		}

		/*
		 * new ceil function about 75% faster than Math.ceil. 
		 */
		private static function ceil( value : Number) : Number {
			return (value % 1) ? int( value ) + 1 : value;
		}
		
	    //--------------------------------------------------------------------------
	    //
	    //  Event Handlers
	    //
	    //--------------------------------------------------------------------------

		private function enterFrameHandler (e:Event):void{
		//	trace("RainbowCloudGame::enterFrameHandler");
			update();
		}
		private function rainbowTimerHandler (e:TimerEvent):void{
			trace("RainbowCloudGame::rainbowTimerHandler");
			
			// Make onscreen Rainbow
			if(!_paused){
				if(_rainbows.length < 6){
					
					var madeRainbow:Boolean = false;
					var l:Number,r:Number,t:Number,b:Number;
					l = -_worldFG.x;
					r = l + _stageWidth;
					t = -_worldFG.y;
					b = t+_stageHeight;
				
					for(var i:uint = 0; i < _levels.length; i++){
						var lvl:Vector.<Cloud> = _levels[i];
						if(lvl[0].yPos > t && lvl[0].yPos < b){
							// In Y range

							for(var j:uint = 0; j < lvl.length; j++){
								var c:Cloud = lvl[j];
								var midc:Number = c.xPos + c.width/2;
								if(midc > l && midc < r){
									// In X range
									// pick 2nd cloud

									var l2:uint;
									var x:uint = 0;
									do{
										x++;
										if(x > 10){
											break;
										}
										l2 = Math.max(0, Math.min( _levels.length-1, i + Math.floor( Math.random()*6 )-3));
									
									}while(abs(l2-i) > 2 || l2 == i || l2 < 0 || l2 > _levels.length - 1);

									for(var c2:uint = 0; c2 < _levels[l2].length; c2++){
										var cloud2:Cloud = _levels[l2][c2];

										if(abs(cloud2.xPos - c.xPos) < 1000){
											// Make a new RAINBOW!
											if(cloud2.rainbowsAttached < 2){
												createRainbow (c, cloud2);
												madeRainbow = true;
												break;
											}
										}
									}
								}
								if(madeRainbow){
									break;
								}
							}
						} 
						if(madeRainbow){
							break;
						}
					}
				}
			}
		}
		
		private function prizeTimerHandler (e:TimerEvent):void{
			trace("RainbowCloudGame::prizeTimerHandler");
			if(_prizes.length < 40){
				createPrize();
			}
		}
		
		private function guestTimerHandler (e:TimerEvent):void{
			trace("RainbowCloudGame::guestTimerHandler");
			if(_guests.length < 2){
				// Make Guest
				createGuest();
				// All Guests spawned?
				if(_guestsToSpawn.length == 0){
					_guestTimer.reset();
					_guestTimer.removeEventListener(TimerEvent.TIMER, guestTimerHandler);
				}
			}
		}
		
		private function timeoutHandler (e:TimerEvent):void{
			trace("RainbowCloudGame::timeoutHandler");
			if(_noKeysPressed == true){
				endGame();
				
				resetGame();
			}else{
				_noKeysPressed = true;
			}
		}
		
		private function playButtonHandler (e:MouseEvent):void{
			trace("RainbowCloudGame::playButtonHandler");
			_splashScreen.visible = false;
			startGame();
		}
		
		private function restartButtonHandler (e:MouseEvent):void{
			trace("RainbowCloudGame::restartButtonHandler");
			
			stopSounds();
			resetGame();
		}
		
	};
};