package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
#if sys
import sys.io.File;
import sys.FileSystem;
#else
import openfl.utils.Assets;
#end

using StringTools;

class CoolUtil
{
	public static var defaultDifficulties:Array<String> = [
		'Easy',
		'Normal',
		'Hard',
		'Get Real'
	];
	public static var defaultDifficulty:String = 'Normal'; //The chart that has no suffix and starting difficulty on Freeplay/Story Mode

	public static var difficulties:Array<String> = [];

	public static function addSprite(x,y,path:String,scrollFactor:Float=1):FlxSprite{
		var sprite:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image(path));
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		sprite.active = false;
		sprite.antialiasing = true;
		return sprite;
	}
	public static function addAnimPrefix(x,y,path:String,prefix:String,scrollFactor:Float=1,loop:Bool=true,fps:Int=24):FlxSprite{
		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.frames = Paths.getSparrowAtlas(path);
		sprite.animation.addByPrefix(prefix,prefix,fps,loop);
		sprite.animation.play(prefix);
		sprite.antialiasing = true;
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		return sprite;
	}
	public static function addAnimIndices(x,y,path:String,prefix:String,indices:Array<Int>,scrollFactor:Float=1,loop:Bool=true,fps:Int=24):FlxSprite{
		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.frames = Paths.getSparrowAtlas(path);
		sprite.animation.addByIndices(prefix, prefix, indices, "", fps,loop);
		sprite.animation.play(prefix);
		sprite.antialiasing = true;
		sprite.scrollFactor.set(scrollFactor, scrollFactor);
		return sprite;
	}
	
	public static function getDifficultyFilePath(num:Null<Int> = null)
	{
		if(num == null) num = PlayState.storyDifficulty;

		var fileSuffix:String = difficulties[num];
		if(fileSuffix != defaultDifficulty)
		{
			if (fileSuffix == 'Get Real') {
				fileSuffix = '-getreal';
			} else {
				fileSuffix = '-' + fileSuffix;
			}
		}
		else
		{
			fileSuffix = '';
		}
		return Paths.formatToSongPath(fileSuffix);
	}

	public static function difficultyString():String
	{
		return difficulties[PlayState.storyDifficulty].toUpperCase();
	}

	inline public static function boundTo(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = [];
		#if sys
		if(FileSystem.exists(path)) daList = File.getContent(path).trim().split('\n');
		#else
		if(Assets.exists(path)) daList = Assets.getText(path).trim().split('\n');
		#end

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function dominantColor(sprite:flixel.FlxSprite):Int{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth){
			for(row in 0...sprite.frameHeight){
			  var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
			  if(colorOfThisPixel != 0){
				  if(countByColor.exists(colorOfThisPixel)){
				    countByColor[colorOfThisPixel] =  countByColor[colorOfThisPixel] + 1;
				  }else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687)){
					 countByColor[colorOfThisPixel] = 1;
				  }
			  }
			}
		 }
		var maxCount = 0;
		var maxKey:Int = 0;//after the loop this will store the max color
		countByColor[flixel.util.FlxColor.BLACK] = 0;
			for(key in countByColor.keys()){
			if(countByColor[key] >= maxCount){
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		return maxKey;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	//uhhhh does this even work at all? i'm starting to doubt
	public static function precacheSound(sound:String, ?library:String = null):Void {
		var EmbeddedSound = Paths.sound(sound, library);
		if (Assets.exists(EmbeddedSound, SOUND) || Assets.exists(EmbeddedSound, MUSIC))
			Assets.getSound(EmbeddedSound, true);
	}
	
	inline public static function flKeyToFlx(keyCode:Int):FlxKey
		@:privateAccess return FlxKey.toStringMap.get(keyCode);

	public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}
}
