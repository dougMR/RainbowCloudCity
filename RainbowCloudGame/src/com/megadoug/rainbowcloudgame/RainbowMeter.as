package com.megadoug.rainbowcloudgame
{
	import flash.display.MovieClip;
	import flash.events.Event;

	public class RainbowMeter extends MovieClip
	{
		// VARIABLES
		private var _colors:Vector.<Object>;
		// CONSTRUCTOR
		public function RainbowMeter()
		{
			super();
			init();
		}
		
		private function init ():void{
			trace("RainbowMeter::Init");
			_colors = new Vector.<Object>();
			_colors.push({
				name:"red",
				mc:red,
				percent:0,
				emoticon:": )"
			});
			//red.rotation = .9 * 180,
			_colors.push({
				name:"orange",
				mc:orange,
				percent:0,
				emoticon:"8 P"
			});
			_colors.push({
				name:"yellow",
				mc:yellow,
				percent:0,
				emoticon:"=)"
			});
			_colors.push({
				name:"green",
				mc:green,
				percent:0,
				emoticon:"S; |"
			});
			_colors.push({
				name:"blue",
				mc:blue,
				percent:0,
				emoticon:": D"
			});
			_colors.push({
				name:"violet",
				mc:violet,
				percent:0,
				emoticon:"|: ?"
			});
		}
		
		// ACCESSORS
		
		/**
		 * Gets colors.
		 */
		public function get colors():Vector.<Object> {
			return _colors;
		};
		
		// PRIVATE FUNCTIONS
		
		// PUBLIC FUNCTIONS
		
		public function reset ():void{
			trace("RainbowMeter::reset");
			red.rotation =
			orange.rotation =
			yellow.rotation =
			green.rotation =
			blue.rotation =
			violet.rotation = 0;
		}
		
		public function growMeter (color:String, pct:Number):void{
			//trace("RainbowCloudGame::growMeter");
			switch(color){
				default:
				case "all":
					red.rotation = Math.min(180, red.rotation + pct/100 * 180);
					orange.rotation = Math.min(180, orange.rotation + pct/100 * 180);
					yellow.rotation = Math.min(180, yellow.rotation + pct/100 * 180);
					green.rotation = Math.min(180, green.rotation + pct/100 * 180);
					blue.rotation = Math.min(180, blue.rotation + pct/100 * 180);
					violet.rotation = Math.min(180, violet.rotation + pct/100 * 180);
					break;
				case "red":
					red.rotation = Math.min(180, red.rotation + pct/100 * 180);
					break;
				case "orange":
					orange.rotation = Math.min(180, orange.rotation + pct/100 * 180);
				
					break;
				case "yellow":
				 	yellow.rotation = Math.min(180, yellow.rotation + pct/100 * 180);
					
					break;
				case "green":
					green.rotation = Math.min(180, green.rotation + pct/100 * 180);
				
					break;
				case "blue":
					blue.rotation = Math.min(180, blue.rotation + pct/100 * 180);
				
					break;
				case "violet":
					violet.rotation = Math.min(180, violet.rotation + pct/100 * 180);
				
					break;
			}
			for(var i:uint = 0; i < colors.length; i++){
				colors[i].percent = colors[i].mc.rotation*100 / 180;
			}
			// if all full,
			if(
				red.rotation == 180 &&
				orange.rotation == 180 &&
				yellow.rotation == 180 &&
				green.rotation == 180 &&
				blue.rotation == 180 &&
				violet.rotation == 180
				)
				{
					dispatchEvent(new Event(Event.COMPLETE, true));
					//endGame();
				}
			// _musicBoxSound.playMe();
		}
	
	}

}

