import Discord.DiscordClient;
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxTiledSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import lime.utils.Assets;
import meta.data.*;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;

using StringTools;


class FreeplayState extends MusicBeatState {
    	//
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curSongPlaying:Int = -1;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
    var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	var songThread:Thread;
	var threadActive:Bool = true;
	var mutex:Mutex;
	var songToPlay:Sound = null;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	private var mainColor = FlxColor.WHITE;
	private var bg:FlxSprite;
	private var scoreBG:FlxSprite;

	private var existingSongs:Array<String> = [];
	private var existingDifficulties:Array<Array<String>> = [];

	var checkerboard:FlxBackdrop;
	var logobar:FlxTiledSprite;

	var weekList:Array<String>;
	
	override function create()
	{
		mutex = new Mutex();

		Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		weekList = CoolUtil.coolTextFile(Paths.getPreloadPath('weeks/weekList.txt'));
        
        // add songs;
        for (i in 0...WeekData.weeksList.length) {
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}
			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
					colors = [146, 113, 253];
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.setDirectoryFromWeek();

		// LOAD CHARACTERS
		bg = new FlxSprite().loadGraphic(Paths.image('menus/story/menuBG'));
		add(bg);

		checkerboard = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0, 0, true, true);
		checkerboard.alpha = 0.6;
		checkerboard.scale.set(5, 5);
		checkerboard.color = 0xFF042480;
		add(checkerboard);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		logobar = new FlxTiledSprite(Paths.image('menus/freeplay/logo'), 1280, 105, true, false);
		add(logobar);
		logobar.angle = 22.5;
		logobar.antialiasing = true;
		logobar.y += FlxG.height - logobar.height;

		weekGraphic = new FlxSprite();
		weekGraphic.loadGraphic(Paths.image('menus/story/weeks/tutorial'));
		weekGraphic.angle = 22.5/8;	

		for (i in 0...songs.length) {
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.targetY = i;
			songText.disableX = true;
			grpSongs.add(songText);
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			iconArray.push(icon);
			add(icon);
		}

		topBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/top_bar'));
		add(topBar);
		topBar.y -= topBar.height;

		bottomBar = new FlxSprite().loadGraphic(Paths.image('menus/freeplay/bottom_bar'));
		add(bottomBar);
		bottomBar.y += FlxG.height;
		weekGraphic.antialiasing = true;
		add(weekGraphic);

		scoreText = new FlxText(0, -106, 1270, "", 40);
		scoreText.setFormat('assets/fonts/Helvetica-Oblique.ttf', 32, FlxColor.WHITE, RIGHT);
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;
		scoreText.angle = 3.7;

		scoreBG = new FlxSprite(scoreText.x - scoreText.width, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		// add(scoreBG);

		diffText = new FlxText(scoreText.x, -141, 1270, "", 32);
		diffText.setFormat('assets/fonts/Helvetica-Oblique.ttf', 32, FlxColor.WHITE, RIGHT);
		diffText.antialiasing = ClientPrefs.globalAntialiasing;
		diffText.angle = 3.7;
		add(diffText);

		add(scoreText);

		if(lastDifficultyName == '')
			lastDifficultyName = CoolUtil.defaultDifficulty;
	
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeSelection();
		changeDiff();
		changeWeek(0);

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		super.create();
	}

	var topBar:FlxSprite;
	var bottomBar:FlxSprite;
	var weekGraphic:FlxSprite;
	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
        songs.push(new SongMetadata(songName, weekNum, songCharacter, color));

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songColor:Array<FlxColor>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songColor == null)
			songColor = [FlxColor.WHITE];

		var num:Array<Int> = [0, 0];
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num[0]], songColor[num[1]]);
			if (songCharacters.length != 1)
				num[0]++;
			if (songColor.length != 1)
				num[1]++;
		}
	}

	public var angleIncrementer:Float = 5;

    var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxTween.color(bg, 0.35, bg.color, mainColor);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

        var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2)  //No decimals, add an empty space
			ratingSplit.push('');
		while(ratingSplit[1].length < 2)  //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';

		topBar.y = FlxMath.lerp(topBar.y, 0, elapsed * 6);
		bottomBar.y = FlxMath.lerp(bottomBar.y, FlxG.height - bottomBar.height, elapsed * 6);
		weekGraphic.y = bottomBar.y + bottomBar.height - (weekGraphic.height + 8);
		weekGraphic.x = bottomBar.x + bottomBar.width/3 - weekGraphic.width/3;

		scoreText.y = topBar.y + 15;
		diffText.y = topBar.y - 20;

		var elapsedTime:Float = elapsed * 6;
		for (i in 0...grpSongs.members.length)
		{
			var scaledY = FlxMath.remapToRange(grpSongs.members[i].targetY, 0, 1, 0, 1.3);
			var item = grpSongs.members[i];
			for (j in 0...item.members.length) {
				item.members[j].angle = FlxMath.lerp(item.members[j].angle, item.angleTo, elapsedTime);
				if (Math.abs(item.members[j].angle) > angleIncrementer*4)
					item.members[j].angle = FlxMath.signOf(item.members[j].angle) * angleIncrementer*4;
				var angle:Float = flixel.math.FlxAngle.asRadians(item.members[j].angle);	
				var yPosition:Float = (scaledY * 120) + (FlxG.height * 0.48);
				var xPosition:Float = item.xTo + item.members[j].posX;

				// item.members[j].y = FlxMath.lerp(item.members[j].y, ((xPosition * Math.sin(angle)) + (yPosition * Math.cos(angle))), elapsedTime);
				item.members[j].y = FlxMath.lerp(item.members[j].y, yPosition + (xPosition * Math.sin(angle)) , elapsedTime);
				// item.members[j].x = FlxMath.lerp(item.members[j].x, ((xPosition * Math.cos(angle)) + (yPosition * Math.sin(angle))), elapsedTime);
				item.members[j].x = FlxMath.lerp(item.members[j].x, (xPosition * Math.cos(angle)), elapsedTime);
			}
			// icon shit
			var icon = iconArray[i];
			icon.angle = FlxMath.lerp(icon.angle, item.angleTo, elapsedTime);
			var myAngle:Float = flixel.math.FlxAngle.asRadians(icon.angle);
			var psuedoX:Float = -(icon.width + 12);
			var psuedoY:Float = -(icon.height/3);
			icon.y = item.members[0].y + (Math.sin(myAngle) * psuedoX) + (Math.cos(myAngle) * psuedoY);
			icon.x = item.members[0].x + (Math.cos(myAngle) * psuedoX) + (Math.sin(myAngle) * psuedoY);
		}

		checkerboard.x += elapsed / (1 / 60);
		checkerboard.y += elapsed / (1 / 60);

		logobar.scrollX += elapsed / (1 / 60);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		if (upP)
			changeSelection(-1);
		else if (downP)
			changeSelection(1);

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			threadActive = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

        if(ctrl)
            openSubState(new GameplayChangersSubstate());
        else if(space) {
            if(instPlaying != curSelected)
                {
                    #if PRELOAD_ALL
                    destroyFreeplayVocals();
                    FlxG.sound.music.volume = 0;
                    Paths.currentModDirectory = songs[curSelected].folder;
                    var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
                    PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
                    if (PlayState.SONG.needsVoices)
                        vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
                    else
                        vocals = new FlxSound();
    
                    FlxG.sound.list.add(vocals);
                    FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
                    vocals.play();
                    vocals.persist = true;
                    vocals.looped = true;
                    vocals.volume = 0.7;
                    instPlaying = curSelected;
                    #end
                }
            }

		if (accepted)
		{
			iconArray[curSelected].animation.curAnim.curFrame = 1;
			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
			var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
			
			if (FlxG.keys.pressed.SHIFT)
				LoadingState.loadAndSwitchState(new ChartingState());
			else
				LoadingState.loadAndSwitchState(new PlayState());
			
			FlxG.sound.music.volume = 0;		
			destroyFreeplayVocals();
		}

		// Adhere the position of all the things (I'm sorry it was just so ugly before I had to fix it Shubs)
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		scoreText.x = FlxG.width - scoreText.width - 5;
		scoreBG.width = scoreText.width + 8;
		scoreBG.x = FlxG.width - scoreBG.width;
		diffText.x = scoreBG.x + (scoreBG.width / 2) - (diffText.width / 2);

		mutex.acquire();
		if (songToPlay != null)
		{
			FlxG.sound.playMusic(songToPlay);

			if (FlxG.sound.music.fadeTween != null)
				FlxG.sound.music.fadeTween.cancel();

			FlxG.sound.music.volume = 0.0;
			FlxG.sound.music.fadeIn(1.0, 0.0, 1.0);

			songToPlay = null;
		}
		mutex.release();
	}

    public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	var lastDifficulty:String;
	function changeDiff(change:Int = 0)
		{
			curDifficulty += change;
	
			if (curDifficulty < 0)
				curDifficulty = CoolUtil.difficulties.length-1;
			if (curDifficulty >= CoolUtil.difficulties.length)
				curDifficulty = 0;
	
			lastDifficultyName = CoolUtil.difficulties[curDifficulty];
	
			#if !switch
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
			intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
			#end
	
			PlayState.storyDifficulty = curDifficulty;
			diffText.text = '< ' + CoolUtil.difficultyString() + ' >';
		}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

        intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		mainColor = songs[curSelected].color;

		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.6;
		iconArray[curSelected].alpha = 1;

		var bullShit:Int = 0;
		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			var increment:Float = (bullShit - curSelected);
			item.xTo = 160 + (Math.abs(increment) * (16 * Math.abs(increment)));
			item.angleTo = -increment * angleIncrementer;

			bullShit++;
			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
		//

		Paths.currentModDirectory = songs[curSelected].folder;
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}
			if(diffs.length > 0 && diffs[0].length > 0)
				CoolUtil.difficulties = diffs;
		}
		
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		if(newPos > -1)
			curDifficulty = newPos;

		trace("curSelected: " + curSelected);

		changeWeek(songs[curSelected].week);
		changeDiff();
		changeSongPlaying();
	}

	static var lastDifficultyName:String = '';

	var oldWeek:Int = 0;
	function changeWeek(newWeek:Int) {
		if (newWeek != oldWeek) {
			bottomBar.y = FlxG.height;
			weekGraphic.loadGraphic(Paths.image('menus/story/weeks/${weekList[newWeek]}'));
			oldWeek = newWeek;
		}
	}

	function changeSongPlaying()
	{
		if (songThread == null)
		{
			songThread = Thread.create(function()
			{
				while (true)
				{
					if (!threadActive)
					{
						trace("Killing thread");
						return;
					}

					var index:Null<Int> = Thread.readMessage(false);
					if (index != null)
					{
						if (index == curSelected && index != curSongPlaying)
						{
							trace("Loading index " + index);

							var inst:Sound = Paths.inst(songs[curSelected].songName);

							if (index == curSelected && threadActive)
							{
								mutex.acquire();
								songToPlay = inst;
								mutex.release();

								curSongPlaying = curSelected;
							}
							else
								trace("Nevermind, skipping " + index);
						}
						else
							trace("Skipping " + index);
					}
				}
			});
		}

		songThread.sendMessage(curSelected);
	}

	var playingSongs:Array<FlxSound> = [];
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) 
            this.folder = '';
	}
}