#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class CreditsTransState extends MusicBeatState
{
	var options:Array<String> = ['B3 Remixed Developers', 'Psych Engine Developers'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	private var descText:FlxText;

	var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0.2, 0.2, true, true);

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'B3 Remixed Developers':
				CreditsState.curArray = 0;
			case 'Psych Engine Developers':
				CreditsState.curArray = 1;
		}
		MusicBeatState.switchState(new CreditsState());
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuBG'));
		bg.color = 0xFFea71fd;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		add(backdrop);
		backdrop.alpha = 0.5;
		backdrop.scale.x = 5;
		backdrop.scale.y = 5;
		backdrop.color = 0xFF00FFF2;
		backdrop.scrollFactor.set(0, 0.07);
		backdrop.updateHitbox();

		var frame2:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/options/fade'));
		frame2.scrollFactor.set();
		frame2.setGraphicSize(Std.int(frame2.width * 1));
		frame2.updateHitbox();
		frame2.screenCenter();
		frame2.antialiasing = ClientPrefs.globalAntialiasing;
		add(frame2);

		var frame:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/options/menuframes'));
		frame.scrollFactor.set();
		frame.setGraphicSize(Std.int(frame.width * 1));
		frame.updateHitbox();
		frame.screenCenter();
		frame.antialiasing = ClientPrefs.globalAntialiasing;
		add(frame);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false);
			optionText.screenCenter();
			optionText.y += (125 * (i - (options.length / 2))) + 68.5;
			grpOptions.add(optionText);
		}

		var topTxt:FlxText = new FlxText(50, 615, 1180, "Choose a set of credits and check out\nall the great people working on the mod,\nor the people on the Psych Engine team!", 40);
		topTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		topTxt.scrollFactor.set();
		topTxt.borderSize = 2.4;
		add(topTxt);

		changeSelection();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		//i feel like this could be done better but i trust peak
		backdrop.x -= 70 * elapsed;
		backdrop.y -= 70 * elapsed;

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {

		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}