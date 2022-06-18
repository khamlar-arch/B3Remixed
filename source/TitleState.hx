package;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import flixel.addons.display.FlxBackdrop;
import openfl.Assets;
import flixel.math.FlxMath;

using StringTools;
typedef TitleData =
{
	
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var easterEggEnabled:Bool = true; //Disable this to hide the easter egg
	var easterEggKeyCombination:Array<FlxKey> = [FlxKey.B, FlxKey.B]; //bb stands for bbpanzu cuz he wanted this lmao
	var lastKeysPressed:Array<FlxKey> = [];

	var mustUpdate:Bool = false;
	var checkerboard:FlxBackdrop;
	var checkerboard2:FlxBackdrop;
	
	var titleJSON:TitleData;
	
	public static var updateVersion:String = '';

	override public function create():Void
	{
		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();
		
		#if windows
		if (Main.fuckyou) {
			super.create();
			MusicBeatState.switchState(new FuckYouState());
			return;
		}
		#end
		
		#if MODS_ALLOWED
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		if (FileSystem.exists("modsList.txt")){
			
			var list:Array<String> = CoolUtil.listFromString(File.getContent("modsList.txt"));
			var foundTheTop = false;
			for (i in list){
				var dat = i.split("|");
				if (dat[1] == "1" && !foundTheTop){
					foundTheTop = true;
					Paths.currentModDirectory = dat[0];
				}
				
			}
		}
		#end
		
		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/gfDanceTitle.json";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "mods/images/gfDanceTitle.json";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "assets/images/gfDanceTitle.json";
		}
		//trace(path, FileSystem.exists(path));
		titleJSON = Json.parse(File.getContent(path));
		#else
		var path = Paths.getPreloadPath("images/gfDanceTitle.json");
		titleJSON = Json.parse(Assets.getText(path)); 
		#end
		
		#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end
		
		#if CHECK_FOR_UPDATES
		if(!closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");
			
			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}
			
			http.onError = function (error) {
				trace('error: $error');
			}
			
			http.request();
		}
		#end

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 8;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		curWacky = FlxG.random.getObject(getIntroTextShit());

		// DEBUG BULLSHIT
		super.create();
		
		Highscore.load();

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			#if desktop
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
			#end
			
			if (initialized)
				startIntro();
			else {
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var pressEnter:FlxText;

	function startIntro()
	{
		if (!initialized)
		{

			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		checkerboard = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0, 0, true, true);
		checkerboard.alpha = 0.85;
		checkerboard.scale.set(5, 5);
		checkerboard.color = 0xFF582372;
		add(checkerboard);

		checkerboard2 = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0, 0, true, true);
		checkerboard2.alpha = 0.85;
		checkerboard2.scale.set(5, 5);
		checkerboard2.color = 0xFF8D0ECA;
		add(checkerboard2);

		gfDance = new FlxSprite(-200, -90);
		gfDance.frames = Paths.getSparrowAtlas('menus/title/gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.setGraphicSize(Std.int(gfDance.width * 0.75));
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;
		add(gfDance);

		logoBl = new FlxSprite(1400, 0).loadGraphic(Paths.image('menus/title/logo'));
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.75));
		logoBl.screenCenter(Y);
		add(logoBl);

		pressEnter = new FlxText(0, 600, 1280, "Press ENTER to Continue", 40);
		pressEnter.antialiasing = ClientPrefs.globalAntialiasing;
		pressEnter.setFormat(Paths.font('mplus.ttf'), 48, 0xFFFFFFFF, "center");
		pressEnter.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 3, 1);
		add(pressEnter);

		credGroup = new FlxGroup();
		add(credGroup);
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		textGroup = new FlxGroup();
		
		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	
	var newTitle:Bool = true;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (skippedIntro) {
			logoBl.scale.set(FlxMath.lerp(logoBl.scale.x, 0.78, 0.1), FlxMath.lerp(logoBl.scale.y, 0.78, 0.1));

			checkerboard.x += (elapsed / 10) / (1 / 60);
			checkerboard.y += (elapsed / 2) / (1 / 60);

			checkerboard2.x -= (elapsed / 10) / (1 / 60);
			checkerboard2.y -= (elapsed / 2) / (1 / 60);
			if (!transitioning)
			{
				if (newTitle && !pressedEnter)
				{
					var timer:Float = titleTimer;
					if (timer >= 1)
						timer = (-timer) + 2;
					
					timer = FlxEase.quadInOut(timer);
				}
				
				if(pressedEnter)
				{
					pressEnter.color = FlxColor.WHITE;
					FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1, null, true);
					FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

					transitioning = true;
					// FlxG.sound.music.stop();
					FlxTween.tween(pressEnter, {y: 1000}, 0.9, {ease: FlxEase.elasticInOut, type: PINGPONG});

					checkerboard2.color = 0xFFB5439A;
					checkerboard.color = 0xFF87196D;

					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						if (mustUpdate) {
							MusicBeatState.switchState(new OutdatedState());
						} else {
							MusicBeatState.switchState(new MainMenuState());
						}
						closedState = true;
					});
					// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
				}
				else if(easterEggEnabled)
				{
					var finalKey:FlxKey = FlxG.keys.firstJustPressed();
					if(finalKey != FlxKey.NONE) {
						lastKeysPressed.push(finalKey); //Convert int to FlxKey
						if(lastKeysPressed.length > easterEggKeyCombination.length)
						{
							lastKeysPressed.shift();
						}
						
						if(lastKeysPressed.length == easterEggKeyCombination.length)
						{
							var isDifferent:Bool = false;
							for (i in 0...lastKeysPressed.length) {
								if(lastKeysPressed[i] != easterEggKeyCombination[i]) {
									isDifferent = true;
									break;
								}
							}
						}
					}
				}
			}
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickSteps:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.scale.set(0.85, 0.85);

		if(gfDance != null) {
			danceLeft = !danceLeft;

			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}
	}

	override function stepHit()
	{
		super.stepHit();
		
		if(!closedState) {
			sickSteps++;
			switch (sickSteps)
			{
				case 1:
					createCoolText(['STUDIO BREAKBEAT']);
				case 3:
					deleteCoolText();
					addMoreText('present');
				case 5:
					deleteCoolText();
					addMoreText('Created');
				case 6:
					addMoreText('by');
				case 7:
					addMoreText('Biddle3');
					ngSpr.visible = true;
				case 8:
					deleteCoolText();
					ngSpr.visible = false;
				case 9:
					createCoolText([curWacky[0]]);
				case 11:
					addMoreText(curWacky[1]);
				case 12:
					deleteCoolText();
					addMoreText('Friday Night');
				case 13:
					addMoreText('Funkin');
				case 14:
					addMoreText('B3 REMIXED');
				case 15:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
			FlxTween.tween(logoBl, {x: 400, angle: 720}, 1.9, {ease: FlxEase.elasticInOut});
		}
	}
}
