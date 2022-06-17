package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	public static var curArray:Int = 0;
	var credPrefix:String = "";

	var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0.2, 0.2, true, true);

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		add(backdrop);
		backdrop.alpha = 0.3;
		backdrop.scale.x = 5;
		backdrop.scale.y = 5;
		backdrop.scrollFactor.set(0, 0.07);
		backdrop.updateHitbox();

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		//trace("finding mod shit");
		for (folder in Paths.getModDirectories())
		{
			var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		};
		var folder = "";
			var creditsFile:String = Paths.mods('data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		#end

		var b3pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Directors'],
			['Biddle3',				'biddle',		'Lead Musician and Director',		'https://twitter.com/Biddy312',				'FEFC81'],
			['Degen Dan',			'dan',			'Lead Programmer and Director',		'https://twitter.com/danobot59_',			'8B35C0'],
			['Co-Directors'],
			['Jams3D',				'jams',			'Co-Director and Lead Artist',		'https://twitter.com/jams3d',				'FFFFFF'],
			['paciofd',				'pacio',		'Co-Director and Lead Artist',		'https://twitter.com/paciofdd',				'FFD249'],
			['ItoSaihara',			'ito',			'Co-Director and Artist',			'https://twitter.com/ItoSaihara',			'C5005C'],
			['Artists'],
			['xooplord',			'xoop',			'Portrait Artist',					'https://twitter.com/xooplord', 			'93AE9D'],
			['Faye',				'placeholder',	'Sprite Artist',					'https://twitter.com/JusttFaye', 			'FFFFFF'],
			['NeatoNG',				'placeholder',	'Promotional Artist',				'https://twitter.com/neatochao', 			'FFFFFF'],
			['Yabo',				'yabo',			'Sprite Artist',					'https://twitter.com/yaboigp',	 			'C60011'],
			['Deca',  				'placeholder',	'Sprite Artist',					'https://twitter.com/TheSculpturema1',		'FFFFFF'],
			['Milla209NG',			'placeholder',	'Sprite Artist',					'https://twitter.com/Milla209NG', 			'FFFFFF'],
			['Bizarre_Ethen',		'placeholder',	'Sprite Artist',					'https://twitter.com/BizarreEthen', 		'FFFFFF'],
			['EthanTheDoodler',		'placeholder',	'Sprite Artist',					'https://twitter.com/D00dlerEthan', 		'FFFFFF'],
			['SugarRatio',			'sugar',		'Character Designer',				'https://twitter.com/SugarRatio', 			'CFCFCF'],
			['teethlust',			'teeth',		'Background/UI Artist',				'https://twitter.com/teethlust',			'FFFFFF'],
			['Latte',  				'placeholder',	'Icon + Promotional Artist',		'https://twitter.com/LatteBunss',			'FFFFFF'],
			['Mikefnf',				'mike',			'Background Artist',				'https://twitter.com/MikeFnf',				'F1E2D3'],
			['Little_Geecko',		'placeholder',	'Background Artist',				'https://twitter.com/Little_Geecko',		'FFFFFF'],
			['ShayReyez',  			'shay',			'Sprite Artist',					'https://twitter.com/ShayReyez', 			'FF00AA'],
			['Childish_Manga',		'placeholder',	'Sprite Artist',					'https://twitter.com/VaChildish', 			'FFFFFF'],
			['Shellyn',				'placeholder',	'Background Artist',				'https://twitter.com/sh3llynn', 			'FFFFFF'],
			['Random Inc.',			'rinc',			'Sprite Artist',					'https://twitter.com/RandomIncIsDead', 		'AA70C4'],
			['Hana',				'hana',			'Background Artist',				'https://twitter.com/spacepatrolhana',	 	'FFFFFF'],
			['Composers'],
			['Benlab',				'benlab',		'Composer',							'https://twitter.com/BenlabD',				'A0003A'],
			['Sirfitness',			'sirfitness',	'Composer',							'https://twitter.com/sirfitnessii',			'2F2F2F'],
			['Foodieti',			'foodieti',		'Composer',							'https://twitter.com/Foodieti',				'C27CC2'],
			['Penkaru',				'penkaru',		'Composer',							'https://twitter.com/pex_ton',				'382071'],
			['Programmers'],
			['TKTems',				'tk',			'Programmer',						'https://twitter.com/TKTems',				'40D9BD'],
			['Yoshubs',				'shubs',		'Programmer',						'https://twitter.com/yoshubs',				'279ADC'],
			['Raltyro',				'raltyro',		'Programmer',						'https://gamebanana.com/members/1777465', 	'FFFFFF'],
			['bb-panzu',			'bb-panzu',		'Programmer',						'https://twitter.com/bbsub3',				'389A58'],
			['Former Programmers'],
			['Jackie.exe',			'jackie',		'Former Programmer',				'https://twitter.com/Jack_exe_lol',			'FFF9B3'],
			['BreezyMelee',			'breezy',		'Former Programmer',				'https://twitter.com/BreezyMelee',			'452525'],
			['TSG',					'placeholder',	'Former Programmer',				'https://twitter.com/AyeTSG',				'FFFFFF'],
			['Cval',  				'placeholder',	'Former Programmer',				'https://twitter.com/cval_brown',			'FFFFFF'],
			['Sulayre',				'sulayre',		'Former Programmer',				'https://twitter.com/Sulayre',				'B973CA'],
			['KadeDev',				'kade',			'Former Programmer',				'https://twitter.com/kade0912',				'4B6548'],
			['Charters'],
			['DiscWraith',			'disc',			'Charter',							'https://twitter.com/DiscWraith',			'671FCF'],
			['Vivaderus',			'viva',			'Charter',							'https://twitter.com/Vivaderus',			'163F37'],
			['FoxeruKun',			'fox',			'Charter',							'https://twitter.com/FoxeruKun',			'554650'],
			['Sunny',				'placeholder',	'Charter',							'https://twitter.com/DuckierKarma',			'FFFFFF'],
			['snowy',				'placeholder',	'Charter',							'https://twitter.com/neuroxrd', 			'FFFFFF'],
			['Special Thanks'],
			['BlazeTheWolf55',		'blaze',		'Original B3 Recolors',				'https://twitter.com/BlazeTheWolf10',		'FFAA00'],
			['FruityDaLei',			'placeholder',	'Emotional Support',				'https://twitter.com/FruityDaLei',			'FFFFFF'],
			['VS Sonic.Exe Team',	'sonicexe',		'Letting us do 3x3 <3',				'https://gamebanana.com/mods/316022',		'871B29'],
		];

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',							'https://twitter.com/Shadow_Mario_',	'444444'],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',						'https://twitter.com/RiverOaken',		'C30085'],
			['Yoshubs',				'shubs',			'Additional Programmer of Psych Engine',					'https://twitter.com/yoshubs',			'279ADC'],
			[''],
			['Former Engine Members'],
			['bb-panzu',			'bb-panzu',			'Ex-Programmer of Psych Engine',							'https://twitter.com/bbsub3',			'389A58'],
			[''],
			['Engine Contributors'],
			['iFlicky',				'iflicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',	'https://twitter.com/flicky_i',			'AA32FE'],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',						'https://twitter.com/gedehari',			'FF9300'],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',								'https://twitter.com/polybiusproxy',	'FFEAA6'],
			['Keoiki',				'keoiki',			'Note Splash Animations',									'https://twitter.com/Keoiki_',			'FFFFFF'],
			['Smokey',				'smokey',			'Spritemap Texture Support',								'https://twitter.com/Smokey_5_',		'4D5DBD'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",						'https://twitter.com/ninja_muffin99',	'F73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",							'https://twitter.com/PhantomArcade3K',	'FFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",							'https://twitter.com/evilsk8r',			'53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",							'https://twitter.com/kawaisprite',		'6475F3']
		];
		
		if (curArray == 0) {
			credPrefix = 'b3';
			for(i in b3pisspoop){
				creditsStuff.push(i);
			}
		} else if (curArray == 1) {
			credPrefix = 'psych';
			for(i in pisspoop){
				creditsStuff.push(i);
			}
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			} else {
				optionText.offset.y -= 65;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('icons/credit/' + credPrefix + '/'+ creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

		var frame:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/options/menuframes'));
		frame.scrollFactor.set();
		frame.setGraphicSize(Std.int(frame.width * 1));
		frame.updateHitbox();
		frame.screenCenter();
		frame.antialiasing = ClientPrefs.globalAntialiasing;
		add(frame);

		descText = new FlxText(50, 665, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		//i feel like this could be done better but i trust peak
		backdrop.x -= 70 * elapsed;
		backdrop.y -= 70 * elapsed;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new CreditsTransState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}