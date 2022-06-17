// the leaked build was windows so hardcode this shit just for only windows

package;

#if windows
import haxe.io.Path;

import sys.io.File;
import sys.FileSystem;
import sys.thread.Thread;

import lime.system.System;

import openfl.display.BitmapData;
import openfl.net.SharedObject;
import openfl.utils.Assets as FLAssets;
import openfl.utils.AssetType;

import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxG;

import flixel.addons.transition.FlxTransitionableState;
#end

@:access(openfl.net.SharedObject.__getPath)
class FuckYouState extends MusicBeatState {
	#if windows
	private static var sprPath(default, never):String = "assets/piracy.png";
	private static var musicPath(default, never):String = "assets/piracymusic.ogg";
	
	// ClientPrefs.safeBuild, lmao im lazy
	public static function check():Bool {
		if (checkCompiled()) {
			// for yalls who have compiled builds
			if (FileSystem.exists(getPath())) FileSystem.deleteFile(getPath());
			if (FileSystem.exists(getFakePath())) FileSystem.deleteFile(getFakePath());
			return true;
		}
		if (FileSystem.exists(getPath()) || FileSystem.exists(getFakePath())) return false;
		if (FlxG.save.data.hardwareCache == null) {
			@:privateAccess{
				var sharedObject:SharedObject = FlxG.save._sharedObject;
				if (sharedObject == null) return true;
				
				var path:String = SharedObject.__getPath(sharedObject.__localPath, sharedObject.__name);
				
				if (!FileSystem.exists(path)) return true;
				if (Reflect.fields(sharedObject.data).length == 0) return true;
			}
			return false;
		}
		return true;
	}
	
	public static function checkCompiled():Bool
		return FileSystem.exists("../../../../Project.xml");
	
	var spr:FlxSprite;
	
	public function new() {
		super();
		
		FlxTransitionableState.skipNextTransIn = true;
		Main.allowExit = false;
	}
	
	override function create() {
		if (!FLAssets.exists(sprPath, IMAGE)) {
			Thread.create(crazywoah);
			super.create();
			Sys.exit(0);
			return;
		}
		
		if (Main.fpsVar != null) {
			Main.fpsVar.visible = false;
			Main.fpsVar.x = 10000;
		}
		
		Paths.clearStoredMemory();
		Paths.compress(2);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		if (FLAssets.exists(musicPath, MUSIC))
			FlxG.sound.playMusic(FLAssets.getSound(musicPath), 1);
		
		FlxG.mouse.visible = false;
		
		FlxTransitionableState.skipNextTransOut = true;
		
		var bg:FlxSprite = new FlxSprite().makeGraphic(4, 4, 0xFFFFC743, false, "you");
		bg.setGraphicSize(1280, 720);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
		
		spr = new FlxSprite().loadGraphic(graphic(sprPath));
		spr.setGraphicSize(0, 720);
		spr.updateHitbox();
		spr.screenCenter();
		spr.antialiasing = true;
		add(spr);
		
		super.create();
		
		Paths.clearUnusedMemory();
		
		Thread.create(crazywoah);
	}
	
	// fuck it lets jsut use this method, idk how to do regkeys
	private static function getFakePath():String {
		var path:String = SharedObject.__getPath(FlxG.save.path, "B3LOCKED");
		return path.substring(0, path.length - 4) + ".fuckyou";
	}
	
	private static function getPath():String {
		var append:String = Sys.getEnv("ProgramData");
		if (append == null) {
			append = Sys.getEnv("LOCALAPPDATA");
			if (append == null) {
				append = Sys.getEnv("APPDATA");
			}
		}
		if (append == null) {
			var path:String = SharedObject.__getPath("B3LOCKED", "B3LOCKED");
			return path.substring(0, path.length - 4) + ".fuckyou";
		}
		var path:String = append + "/nothingtoseehere";
		if (!FileSystem.exists(path) || !FileSystem.isDirectory(path))
			FileSystem.createDirectory(path);
		
		path = path + "/B3LOCKED.fuckyou";
		return path;
	}
	
	private static function crazywoah() {
		// too evil lmao
		FlxG.fullscreen = true;
		Main.fullscreenKeys = [];
		
		FlxG.updateFramerate = 8;
		FlxG.drawFramerate = 8;
		
		var path:String = getPath();
		var fakepath:String = getFakePath();
		//trace(path, fakepath);
		
		if (!FileSystem.exists(path)) File.saveContent(path, "fuckingL lmao");
		if (!FileSystem.exists(fakepath)) File.saveContent(fakepath, "fuckingL lmao");
		delDir("assets");
		delDir("mods");
	}
	
	private static function delDir(path:String):Bool {
		if (!FileSystem.exists(path) || !FileSystem.isDirectory(path)) return true;
		
		try {
			Fuckfuck.deletePath(FileSystem.absolutePath(path));
		}
		catch(e:haxe.Exception) {
			trace(path);
			trace(e.message, e.stack);
			return false;
		}
		return true;
	}
	
	private static function bitmap(path:String):BitmapData {
		if (FLAssets.exists(path, IMAGE))
			return FLAssets.getBitmapData(path, false, true);
		
		return null;
	}
	
	private static function graphic(path:String):FlxGraphic {
		if (FLAssets.exists(path, IMAGE)) {
			var newGraphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap(path), false, path);
			newGraphic.persist = true;
			return newGraphic;
		}
		return null;
	}
	#end
}

class Fuckfuck {
	public static function deletePath(path:String) {
		remove(Path.normalize(path));
	}
	
	static function remove(path:String) {
		if (FileSystem.isDirectory(path)) {
			var list = FileSystem.readDirectory(path);
			for(it in list) {
				remove(Path.join([path, it]));
			}
			FileSystem.deleteDirectory(path);
		} else {
			FileSystem.deleteFile(path);
		}
	}
}