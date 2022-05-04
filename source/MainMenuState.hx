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
import Achievements;
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
	private var camAchievement:FlxCamera;
	var easterEgg:String = 'GUH';
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

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var logoBl:FlxSprite;
	var scrollTxt:FlxText;

	var blackbar:FlxSprite;


	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('ui/menu/menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0x03FC73;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('ui/menu/menuBG'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xE84DEB;
		add(magenta);
		// magenta.scrollFactor.set();

		var t1:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('triangles1'));
		t1.scrollFactor.x = 0;
		t1.scrollFactor.y = 0;
		t1.setGraphicSize(Std.int(t1.width * 1));
		t1.updateHitbox();
		t1.screenCenter();
		t1.antialiasing = true;
		add(t1);

		var t2:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('triangles2'));
		t2.scrollFactor.x = 0;
		t2.scrollFactor.y = 0;
		t2.setGraphicSize(Std.int(t2.width * 1));
		t2.updateHitbox();
		t2.screenCenter();
		t2.antialiasing = true;
		add(t2);

		var mf1:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('ui/menu/main/top'));
		mf1.scrollFactor.x = 0;
		mf1.scrollFactor.y = 0;
		mf1.setGraphicSize(Std.int(mf1.width * 1));
		mf1.updateHitbox();
		mf1.screenCenter(X);
		mf1.antialiasing = true;
		add(mf1);

		logoBl = new FlxSprite(-180, -190);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.scrollFactor.set(0, 0);
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.68));
		logoBl.setGraphicSize(Std.int(logoBl.height * 0.68));
		add(logoBl);

		var bt1:FlxSprite = new FlxSprite(80, 315).loadGraphic(Paths.image('ui/menu/main/box'));
		bt1.scrollFactor.x = 0;
		bt1.scrollFactor.y = 0;
		bt1.setGraphicSize(Std.int(bt1.width * 1));
		bt1.updateHitbox();
		bt1.antialiasing = true;
		add(bt1);

		var mf2:FlxSprite = new FlxSprite(-80, FlxG.height - 113).loadGraphic(Paths.image('ui/menu/main/bottom'));
		mf2.scrollFactor.x = 0;
		mf2.scrollFactor.y = 0;
		mf2.setGraphicSize(Std.int(mf2.width * 1));
		mf2.updateHitbox();
		mf2.screenCenter(X);
		mf2.antialiasing = true;
		add(mf2);

		scrollTxt = new FlxText(12, FlxG.height - 30, 0, "Testing Testing Ring Ring Fuck You ShayReyez", 12);
		scrollTxt.scrollFactor.set();
		scrollTxt.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(scrollTxt);

		logoBl.angle = -4;

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		var tex = Paths.getSparrowAtlas('ui/menu/main/FNF_main_menu_assets');
		var texBg = Paths.getSparrowAtlas('b3_select_thingy');
		var texMod = Paths.getSparrowAtlas('FNF_mod_menu_assets');

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

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

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
					if (easterEggKeysBuffer.contains(word))
					{
						FlxG.save.data.guhUnlocked = true;
						FlxG.save.flush();
						trace('YOU DID IT');

						// Nevermind that's stupid lmao
						var songArray:Array<String> = ['Guh', 'Famine', 'Succd'];

						PlayState.storyPlaylist = songArray;
						PlayState.isStoryMode = true;

						var diffic = CoolUtil.getDifficultyFilePath(2);
						if(diffic == null) diffic = '';

						PlayState.storyDifficulty = 2;

						PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
						PlayState.campaignScore = 0;
						PlayState.campaignMisses = 0;
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							LoadingState.loadAndSwitchState(new PlayState(), true);
							FreeplayState.destroyFreeplayVocals();
						});

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

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

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
										MusicBeatState.switchState(new CreditsState());
								}
							});
						}
					});
				}
			}
			#if desktop
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
