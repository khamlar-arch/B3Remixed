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

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Appearance';
		rpcTitle = 'Appearance Settings Menu'; //for Discord Rich Presence

		addOption(new Option('Notes', '', '', 'filler', null));

		var option:Option = new Option('Custom Noteskin',
			'Change the noteskin between the custom B3 \nnoteskin and the default noteskin. Also affects notesplashes.',
			'specialNoteskin',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Lane Transparency',
			'Changes how transparent the lanes behind the notes should be.',
			'laneUnderlay',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		addOption(new Option('Score and Judgements', '', '', 'filler', null));

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Detailed Score Info',
			"If unchecked, disables the amount of accuracy and the\namount of combo breaks shown in the score text.",
			'scoreDetail',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Judgement Counter',
			"If checked, a counter showing your current amount of\n\"Sick!\"s, \"Good\"s, \"Bad\"s, and \"Shit\"s will be shown.",
			'judgementCounter',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Simple Judgements',
			"If checked, judgements will only be shown one at a time and will not fall apart. (May help with memory usage.)",
			'cleanJudgements',
			'bool',
			true);
		addOption(option);

		addOption(new Option('Other User Interface', '', '', 'filler', null));

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Hitsound Volume',
			'How loud the hitsound is.',
			'hitsoundVolume',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1.5;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Prevent Icon Bop',
			'Stops the icons from bopping, possibly helping with distractions.',
			'mitigateIconBop',
			'bool',
			false);
		addOption(option);

		addOption(new Option('Camera Movement', '', '', 'filler', null));

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Move on Hit',
			'If unchecked, the camera will stay still when\nhitting a note.',
			'noteCamera',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Camera Speed',
			'How fast the camera moves when panning on Boyfriend or another character.',
			'camSpeed',
			'float',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 1.0;
		option.maxValue = 3.0;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		addOption(new Option('Performance Boosters', '', '', 'filler', null));

		var option:Option = new Option('Toggle Shaders',
			'Toggles whether shaders should be added onto a song.\n(This can help with optimization, but makes the experience worse.)',
			'toggleShaders',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'globalAntialiasing',
			'bool',
			true);
		option.showBoyfriend = true;
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);

		super();
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:Dynamic = sprite; //Make it check for FlxSprite instead of FlxBasic
			var sprite:FlxSprite = sprite; //Don't judge me ok
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.globalAntialiasing;
			}
		}
	}
}