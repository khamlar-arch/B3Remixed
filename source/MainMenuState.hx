package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import openfl.Lib;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	var easterEgg:String = 'GUH';
	var menuEgg:String = 'MENYOO';
	var evilEgg:String = 'FOF';
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	
	var optionShit:Array<String> = [
		'story mode',
		'freeplay',
		'options',
		'credits',
		'mods'
	];
	var scrollTxts:Array<String> = [
		'Explore all the weeks in B3 Remixed in any order you want, and watch the story as you go!',
		'Play the songs in any order, without cutscenes, along with bonuses and challenges!',
		'Configure your game options to the way you like it for the best experience!',
		'Check out all the cool people that made this mod that you\'re playing!',
		'Check out the music player and a gallery of images from the development of this mod!'
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var scrollTxt:FlxText;

	var bg:FlxSprite;
	var bg2:FlxSprite;

	var menuBox:FlxSprite;
	var logoBl:FlxSprite;

	var topSec:FlxSprite;
	var bottomSec:FlxSprite;
	var sideSec:FlxSprite;

	var blackbar:FlxSprite;


	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();

		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scrollFactor.set(0, 0);
		bg.color = 0xFF4AC290;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		bg2 = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		bg2.antialiasing = ClientPrefs.globalAntialiasing;
		bg2.scrollFactor.set(0, 0);
		bg2.color = 0xFFB550A2;
		//add(bg2);

		sideSec = new FlxSprite(1203).loadGraphic(Paths.image('menus/main/side'));
		sideSec.scrollFactor.x = 0;
		sideSec.scrollFactor.y = 0;
		sideSec.setGraphicSize(Std.int(sideSec.width * 1));
		sideSec.updateHitbox();
		sideSec.screenCenter(Y);
		sideSec.antialiasing = true;
		add(sideSec);

		topSec = new FlxSprite().loadGraphic(Paths.image('menus/main/top'));
		topSec.scrollFactor.x = 0;
		topSec.scrollFactor.y = 0;
		topSec.setGraphicSize(Std.int(topSec.width * 1));
		topSec.updateHitbox();
		topSec.screenCenter(X);
		topSec.antialiasing = ClientPrefs.globalAntialiasing;
		add(topSec);

		logoBl = new FlxSprite(-140, -150).loadGraphic(Paths.image('menus/title/logo'));
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.updateHitbox();
		logoBl.scrollFactor.set(0, 0);
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.8));
		logoBl.setGraphicSize(Std.int(logoBl.height * 0.8));
		add(logoBl);

		menuBox = new FlxSprite(80, 315).loadGraphic(Paths.image('menus/main/box'));
		menuBox.scrollFactor.x = 0;
		menuBox.scrollFactor.y = 0;
		menuBox.setGraphicSize(Std.int(menuBox.width * 1));
		menuBox.updateHitbox();
		menuBox.antialiasing = true;
		add(menuBox);

		bottomSec = new FlxSprite(-80, FlxG.height - 113).loadGraphic(Paths.image('menus/main/bottom'));
		bottomSec.scrollFactor.x = 0;
		bottomSec.scrollFactor.y = 0;
		bottomSec.setGraphicSize(Std.int(bottomSec.width * 1));
		bottomSec.updateHitbox();
		bottomSec.screenCenter(X);
		bottomSec.antialiasing = true;
		add(bottomSec);

		scrollTxt = new FlxText(12, FlxG.height - 30, 0, "Testing Testing Ring Ring Fuck You ShayReyez", 12);
		scrollTxt.scrollFactor.set();
		scrollTxt.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scrollTxt);

		logoBl.angle = -4;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		var tex = Paths.getSparrowAtlas('menus/main/FNF_main_menu_assets');

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(300, 350 + (i * 55));
			menuItem.frames = tex;
			
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.68));
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.004);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		new FlxTimer().start(0.01, function(tmr:FlxTimer)
		{
			if (logoBl.angle == -4)
				FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
			if (logoBl.angle == 4)
				FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
		}, 0);

		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		scrollTxt.x -= 3 * 60 / Lib.current.stage.frameRate;
		if(scrollTxt.x < 0 - (scrollTxt.text.length * 25)) scrollTxt.x = 1280;

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if(allowedKeys.contains(keyName)) {
					easterEggKeysBuffer += keyName;
					if(easterEggKeysBuffer.length >= 32) 
						easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					var word:String = 'GUH';
					var word2:String = 'MENYOO';
					var word3:String = 'FOF';
					if (easterEggKeysBuffer.contains(word))
					{
						FlxG.save.data.guhUnlocked = true;
						FlxG.save.flush();
						trace('YOU DID IT');

						// Nevermind that's stupid lmao
						var songArray:Array<String> = ['Guh', 'Famine', 'Succ\'d'];

						PlayState.storyPlaylist = songArray;
						PlayState.isStoryMode = true;
						PlayState.isGuhWeek = true;

						var diffic = CoolUtil.getDifficultyFilePath(2);
						if(diffic == null) diffic = '-hard';

						PlayState.storyDifficulty = 2;

						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
						new FlxTimer().start(0.015, function(tmr:FlxTimer)
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
							FreeplayState.destroyFreeplayVocals();
						});

						easterEggKeysBuffer = '';
					} else if (easterEggKeysBuffer.contains(word2)) {
						PlayState.SONG = Song.loadFromJson('menyoo', 'menyoo');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;

						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;		
						FreeplayState.destroyFreeplayVocals();
						easterEggKeysBuffer = '';
					}
				 	if (easterEggKeysBuffer.contains(word3)) {
						PlayState.SONG = Song.loadFromJson('fight-or-flight', 'fight-or-flight');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;

						LoadingState.loadAndSwitchState(new PlayState());
						FlxG.sound.music.volume = 0;		
						FreeplayState.destroyFreeplayVocals();
						easterEggKeysBuffer = '';
					}
				}
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'mods')
				{
					CoolUtil.browserLoad('https://discord.gg/b3-remixed');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					//if(ClientPrefs.flashing) FlxFlicker.flicker(bg2, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
									case 'credits':
										MusicBeatState.switchState(new CreditsTransState());
								}
							});
						}
					});
				}
			}
			#if debug
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
			switch (spr.ID) {
				case 0: spr.x += 105;
				case 1: spr.x += 2;
				case 2: spr.x -= 95;
				case 3: spr.x -= 175;
			}
			spr.x = 105;
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length - 1)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 2;

		/*if (configSelected > 3)
			configSelected = 0;
		if (configSelected < 0)
			configSelected = 3;*/

		scrollTxt.text = scrollTxts[curSelected];

		menuItems.forEach(function(spr:FlxSprite)
		{
			// i dont wanna talk about this code
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.x = 125;
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			} else {
				spr.x = 105;
			}
		});
	}
}
