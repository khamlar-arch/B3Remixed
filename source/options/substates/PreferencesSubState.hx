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
		FlxG.save.data.downScroll = null;
		FlxG.save.data.middleScroll = null;
		FlxG.save.data.hideChars = null;
		FlxG.save.data.judgementCounter = null;
		FlxG.save.data.showFPS = null;
		FlxG.save.data.flashing = null;
		FlxG.save.data.hitsoundVolume = null;
		FlxG.save.data.noteCamera = null;
		FlxG.save.data.specialNoteskin = null;
		FlxG.save.data.globalAntialiasing = null;
		FlxG.save.data.laneUnderlay = null;
		FlxG.save.data.noteSplashes = null;
		FlxG.save.data.lowQuality = null;
		FlxG.save.data.framerate = null;
		FlxG.save.data.camZooms = null;
		FlxG.save.data.hideHud = null;
		FlxG.save.data.noteOffset = null;
		FlxG.save.data.arrowHSV = null;
		FlxG.save.data.ghostTapping = null;
		FlxG.save.data.timeBarType = null;
		FlxG.save.data.scoreZoom = null;
		FlxG.save.data.noReset = null;
		FlxG.save.data.healthBarAlpha = null;
		FlxG.save.data.comboOffset = null;
		FlxG.save.data.ratingOffset = null;
		FlxG.save.data.sickWindow = null;
		FlxG.save.data.goodWindow = null;
		FlxG.save.data.badWindow = null;
		FlxG.save.data.safeFrames = null;
		FlxG.save.data.controllerMode = null;
		FlxG.save.data.gameplaySettings = null;
		FlxG.save.data.guhUnlocked = null;
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