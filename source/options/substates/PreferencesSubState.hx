package options.substates;

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

class PreferencesSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Preferences';
		rpcTitle = 'Preferences Menu'; //for Discord Rich Presence
		
		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		#if !mobile
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Framerate',
			"Pretty self explanatory, isn't it?",
			'framerate',
			'int',
			60);
		addOption(option);
		option.minValue = 60;
		option.maxValue = 240;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		var option:Option = new Option('Reset Save Data',
			"Resets all save data to default.\nBe careful! [THIS IS NOT REVERSIBLE.]", 
			'thisisntimportantgoodbyesavedata',
			'bool',
			true);
		addOption(option);
		option.onChange = onResetSave;

		super();
	}

	function onResetSave()
	{
		ClientPrefs.downScroll = false;
		ClientPrefs.middleScroll = false;
		ClientPrefs.hideChars = false;
		ClientPrefs.judgementCounter = false;
		ClientPrefs.showFPS = true;
		ClientPrefs.hitsoundVolume = 0;
		ClientPrefs.noteCamera = true;
		ClientPrefs.specialNoteskin = true;
		ClientPrefs.globalAntialiasing = true;
		ClientPrefs.laneUnderlay = 0;
		ClientPrefs.noteSplashes = true;
		ClientPrefs.lowQuality = false;
		ClientPrefs.camZooms = true;
		ClientPrefs.hideHud = false;
		ClientPrefs.noteOffset = 0;
		ClientPrefs.arrowHSV = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
		ClientPrefs.ghostTapping = true;
		ClientPrefs.timeBarType = 'Time Left';
		ClientPrefs.scoreZoom = true;
		ClientPrefs.noReset = false;
		ClientPrefs.healthBarAlpha = 1;
		ClientPrefs.comboOffset = [0, 0, 0, 0];
		ClientPrefs.ratingOffset = 0;
		ClientPrefs.sickWindow = 45;
		ClientPrefs.goodWindow = 90;
		ClientPrefs.badWindow = 135;
		ClientPrefs.safeFrames = 10;
		ClientPrefs.controllerMode = false;
		ClientPrefs.gameplaySettings = [
			'scrollspeed' => 1.0,
			'scrolltype' => 'multiplicative',
			'songspeed' => 1.0,
			'healthgain' => 1.0,
			'healthloss' => 1.0,
			'instakill' => false,
			'practice' => false,
			'botplay' => false,
			'opponentplay' => false
		];
		ClientPrefs.guhUnlocked = false;
		FlxG.save.flush();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end

	function onChangeFramerate()
	{
		if(ClientPrefs.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.framerate;
			FlxG.drawFramerate = ClientPrefs.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.framerate;
			FlxG.updateFramerate = ClientPrefs.framerate;
		}
	}
}