package options;

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

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Controls', 'Gameplay', 'Offset', 'Appearance', 'Preferences'];
	var descs:Array<String> = ['Change your keybinds for both in\ngame play and HUD movement here.', 'Adjust how the gameplay feels\nto fit your perfect match!', 'Edit the song\'s offset to match up with your headphones, or\nadjust your combo sprites and where they show up!', 'Change how your game looks and make\nit look perfect to your standards.', 'Play with the options to edit your\ngame for the best experience.'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	private var descBox:FlxSprite;
	private var descText:FlxText;

	var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image('menus/menuCheckerboard'), 0.2, 0.2, true, true);

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Controls':
				openSubState(new options.substates.ControlsSubState());
			case 'Appearance':
				openSubState(new options.substates.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.substates.GameplaySettingsSubState());
			case 'Offset':
				LoadingState.loadAndSwitchState(new options.substates.NoteOffsetState());
			case 'Preferences':
				openSubState(new options.substates.PreferencesSubState());
		}
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

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 200 * i, options[i], true, false);
			optionText.isMenuItem = true;
			optionText.isOptionBase = true;
			/*optionText.forceX = 300;
			optionText.yMult = 90;*/
			optionText.targetY = i;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(100, 250, '>', true, false);
		selectorLeft.angle = -90;
		selectorLeft.screenCenter(X);
		add(selectorLeft);
		selectorRight = new Alphabet(100, 420, '<', true, false);
		selectorRight.angle = -90;
		selectorRight.screenCenter(X);
		add(selectorRight);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		add(descBox);

		var topBox:FlxSprite = new FlxSprite(50, 50).makeGraphic(1180, 125, FlxColor.BLACK);
		topBox.alpha = 0.6;
		add(topBox);

		var menuItem:FlxSprite = new FlxSprite(0, 55);
		menuItem.frames = Paths.getSparrowAtlas('menus/main/FNF_main_menu_assets');	
		menuItem.animation.addByPrefix('idle', "options basic", 24);
		menuItem.setGraphicSize(Std.int(menuItem.width * 1.5));
		menuItem.screenCenter(X);
		menuItem.animation.play('idle');
		add(menuItem);
		menuItem.scrollFactor.set();
		menuItem.antialiasing = true;

		descText = new FlxText(50, 600, 1180, "2 Lines\nYeah", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);


		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		descText.text = descs[curSelected];

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
		descText.screenCenter(Y);
		descText.y += 270;

		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}
}