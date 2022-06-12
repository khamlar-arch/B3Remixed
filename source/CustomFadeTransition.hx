package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	public var isTransIn:Bool = false; 
	//what could go wrong making this public?
	var transBlack:FlxSprite; 
	var transGradient:FlxSprite;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 10);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		transBlack = new FlxSprite().makeGraphic(width, height, FlxColor.BLACK);
		transBlack.scrollFactor.set();
		add(transBlack);

		transBlack.x = -width;

		if(isTransIn) {
			transBlack.x = 0;
			FlxTween.tween(transBlack, {x: 1280}, 0.4, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.circInOut});
		} else {
			leTween = FlxTween.tween(transBlack, {x: 0}, 0.4, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.circInOut});
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		// if(isTransIn) {
		// 	transBlack.y = transGradient.y + transGradient.height;
		// } else {
		// 	transBlack.y = transGradient.y - transBlack.height;
		// }
		super.update(elapsed);
		// if(isTransIn) {
		// 	transBlack.y = transGradient.y + transGradient.height;
		// } else {
		// 	transBlack.y = transGradient.y - transBlack.height;
		// }
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}