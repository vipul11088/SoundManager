package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class SoundManager extends MovieClip
	{
		private var _loadSound:Sound;
		public var channel:SoundChannel;
		private var _loadSoundArr:Array = new Array();
		private var _soundTransform:SoundTransform;
		public var vol:Number=0;  
		
		/**Construtor*/
		public function SoundManager()
		{
			trace("SoundManager.SoundManager");
			channel    		= new SoundChannel();
		
		}
		
		/**Set the sound  pass as string to push in array.*/
		public function setLoadSounds(soundIDParam:String, soundPathParam:String )
		{
			_loadSoundArr.push( { soundID:soundIDParam, soundPath:soundPathParam } );
			soundLoader();
			
		}
		
		/**Load Sound*/
		private function soundLoader()
		{
			//trace("SoundManager.soundLoader");
			if(_loadSoundArr.length > 0)
			{				
				_loadSound = new Sound();
				_loadSound.load(new URLRequest(_loadSoundArr[0].soundPath));
				_loadSound.addEventListener(Event.COMPLETE, soundCompleteHandler);
				_loadSound.addEventListener(IOErrorEvent.IO_ERROR, showError);
				_loadSound.addEventListener(IOErrorEvent.NETWORK_ERROR, showError);
				_loadSound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, showSecurityError);
				
			}
		}
		
		private function showError(e:IOErrorEvent)
		{
			//trace("SoundManager.showError");
			trace(e);
		}
		private function showSecurityError(e:SecurityErrorEvent)
		{
			//trace("SoundManager.showSecurityError");
			trace(e);
		}
		
		/**Sound complete handler,push sound into array*/
		private function soundCompleteHandler(evt:Event):void
		{
			//trace("SoundManager.soundCompleteHandler");
			// taken [0] due to every time we shifting array, so we will load first value only
			_loadSoundArr.shift();
			soundLoader();
		}
		
		/**Play sound*/
		public function playSound(target_array:Array, soundIDParam:String, startTime:Number, loop:Number):void
		{
			//trace("SoundManager.playSound");
			for (var i = 0; i < target_array.length; i++)
			{
				if (soundIDParam == target_array[i].path)
				{
					var playSound:Sound = new Sound();
					playSound.addEventListener(IOErrorEvent.IO_ERROR, function(evt:IOErrorEvent):void 
					{
						trace("evt >>" + evt) ;
					} );
					
					playSound.load(new URLRequest(target_array[i].path));
					channel = playSound.play(startTime, loop);
					break;
				}
			}
		}
		
		/**Stop sound*/
		public function stopSound(targetArray:Array, soundIDParam:String="")
		{
			//trace("SoundManager.stopSound : " + soundIDParam);
			if(soundIDParam != "")
			{
				for (var i = 0; i < targetArray.length; i++)
				{
					if (soundIDParam == targetArray[i].path)
					{
						if (channel != null)
						{
							channel.stop();
							//SoundMixer.stopAll();
						}
						break;
					}
				}
			}
			else
			{
				if (channel != null)
				{
					channel.stop();
				}
			}
		}
		
		/*public function isPlaying():Boolean
		{
			if (_loadSound.is)
		}*/
		
		/** Do mute or unmute sound*/
		public function soundStateChange():void
		{
			//trace("SoundManager.soundStateChange");
			if(StaticClass.SOUND_MUTE == true)
			{
				muteSound();
			}else
			{
				unMuteSound();
			}
		}
		
		public function volumeController(vLevel:Number):void
		{
			var soundTransform:SoundTransform = new SoundTransform(vLevel);
			channel.soundTransform = soundTransform;
		}
		
		/** Do mute sound*/
		private function muteSound():void 
		{
			//trace("SoundManager.muteSound");
			SoundMixer.soundTransform = new SoundTransform(0);
			//_soundTransform.volume = 0;
			//TweenLite.to(_soundTransform, 2, {volume:0});
			//channel.soundTransform = _soundTransform;	
			//StaticClass.SOUND_MUTE = false;
		}
		
		/** Do unmute sound*/
		private function unMuteSound():void
		{
			//trace("SoundManager.unMuteSound");
			SoundMixer.soundTransform = new SoundTransform(1);
			//_soundTransform = new SoundTransform();
			//_soundTransform.volume = 1
			//TweenLite.to(_soundTransform, 2, { volume:1 } );
			//channel.soundTransform = _soundTransform;	
			//StaticClass.SOUND_MUTE = true;
		}
		
		public function getSoundChannel():SoundChannel
		{
			return channel;	
		}
		
		public function setVol()
		{
		     _soundTransform = channel.soundTransform;
			 _soundTransform.volume =  vol;
			  SoundMixer.soundTransform = _soundTransform;
			
			/*	_soundTransform = channel.soundTransform;
			trace("volume is " + vol);
            _soundTransform.volume = vol;
            channel.soundTransform = _soundTransform;*/
			
		
			/*if ()
			{
				trace("if");
				_soundTransform.volume += .1;
				if(_soundTransform.volume > 1)
				{
					_soundTransform.volume = 1;
				} 
				channel.soundTransform = _soundTransform;
			}
			
			else
			{
				trace("else");
				_soundTransform.volume -= .1;
				if(_soundTransform.volume < 0)
				{
					_soundTransform.volume = 0;
				} 
				channel.soundTransform = _soundTransform;
			}*/
		}
		
	}//Class Ends
}// Package Ends